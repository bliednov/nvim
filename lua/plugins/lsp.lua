return {
  'neovim/nvim-lspconfig',
  branch = 'master',
  dependencies = {
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'hrsh7th/cmp-nvim-lsp',
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('bliednov-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        map('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation', { 'i' })
        map('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic message')
        map(']d', vim.diagnostic.goto_next, 'Go to next diagnostic message')
        map('<leader>e', vim.diagnostic.open_float, 'Open floating diagnostic message')
        map('<leader>q', vim.diagnostic.setloclist, 'Open diagnostics list')

        local function client_supports_method(client, method, bufnr)
          if vim.fn.has 'nvim-0.11' == 1 then
            return client:supports_method(method, bufnr)
          else
            return client.supports_method(method, { bufnr = bufnr })
          end
        end

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('bliednov-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('bliednov-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'bliednov-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
          local diagnostic_message = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return diagnostic_message[diagnostic.severity]
        end,
      },
    }

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Servers configured via vim.lsp.config (no on_new_config needed)
    local servers = {
      html = {},
      pylsp = {},
      rust_analyzer = {},
      astro = {},
      tailwindcss = {},
      eslint = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
          },
        },
      },

      gopls = {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              nilness = true,
              shadow = true,
              unusedwrite = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      },
    }

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua',
      'prettierd',
      'prettier',

      -- LSPs configured via lspconfig.setup() (need on_new_config)
      'biome', -- Global fallback when not in node_modules
      'ts_ls', -- TypeScript LSP

      'gopls',
      'goimports',
      'golines',
    })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      ensure_installed = {},
      automatic_installation = false,
      automatic_enable = true,
    }

    -- Configure servers using vim.lsp.config (Neovim 0.11+ API)
    for server_name, server_opts in pairs(servers) do
      local config = vim.tbl_deep_extend('force', {}, { capabilities = capabilities }, server_opts)
      vim.lsp.config(server_name, config)
    end

    -- Servers with local binary detection (use before_init since on_new_config not supported)
    vim.lsp.config('biome', {
      capabilities = capabilities,
      before_init = function(params, config)
        local root = params.rootPath or vim.fn.getcwd()
        local local_biome = root .. '/node_modules/.bin/biome'
        if vim.fn.executable(local_biome) == 1 then
          config.cmd = { local_biome, 'lsp-proxy' }
        end
      end,
    })

    vim.lsp.config('ts_ls', {
      capabilities = capabilities,
      before_init = function(params, config)
        local root = params.rootPath or vim.fn.getcwd()
        config.init_options = config.init_options or {}
        config.init_options.plugins = config.init_options.plugins or {}
        local local_ts = root .. '/node_modules/typescript/lib/tsserver.js'
        if vim.fn.filereadable(local_ts) == 1 then
          config.init_options.tsserver = { path = local_ts }
          vim.notify('ts_ls: using local TypeScript at ' .. local_ts, vim.log.levels.INFO)
        else
          vim.notify('ts_ls: local TypeScript not found, using global', vim.log.levels.WARN)
        end
      end,
    })
  end,
}
