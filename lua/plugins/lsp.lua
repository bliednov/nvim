return {
  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig',            branch = "master" }, -- Required
      -- Necessary due to config
      'nvim-telescope/telescope.nvim',
      {
        -- Optional,
        'williamboman/mason.nvim',
        build = function()
          local f = function()
            vim.cmd('MasonUpdate')
          end
          pcall(f)
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },     -- Required
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
      { 'L3MON4D3/LuaSnip' },     -- Required
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',                tag = 'legacy',   opts = {} },
      -- Additional lua configuration, makes nvim stuff amazing!
      { 'folke/neodev.nvim',                opts = {} },
      'github/copilot.vim',
    },
    config = function()
      local lsp = require("lsp-zero")

      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',
          'pylsp',
          'html',
          'ts_ls',
          'jqls',
          'astro',
          'tailwindcss',
          'eslint',
          -- 'rust_analyzer',
        },
        automatic_installation = false,
        handlers = {
          lsp.default_setup,
          lua_ls = function()
            local lua_opts = lsp.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
          end,
        }
      })

      lsp.configure('rust_analyzer', {
        cmd = { 'rust-analyzer' },
      })

      local cmp = require('cmp')
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      cmp.setup({
        sources = {
          { name = 'path' },
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'luasnip', keyword_length = 2 },
          { name = 'buffer',  keyword_length = 3 },
        },
        -- formatting = lsp.cmp_format(),
        mapping = cmp.mapping.preset.insert({
          ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
          ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
          ['<CR>'] = cmp.mapping.confirm({
            select = true,
          }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ['<Tab>'] = nil,
          ['<S-Tab>'] = nil,
        }),
      })

      -- lsp.set_preferences({
      --   suggest_lsp_servers = false,
      --   sign_icons = {
      --     error = 'E',
      --     warn = 'W',
      --     hint = 'H',
      --     info = 'I'
      --   }
      -- })

      lsp.format_on_save({
        servers = {
          ['lua_ls'] = { 'lua' },
          ['rust_analyzer'] = { 'rust' },
          ['pylsp'] = { 'python' },
          ['ts_ls'] = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
        }
      })

      lsp.on_attach(function(_, bufnr)
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        local imap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('i', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        -- nmap("gr", vim.lsp.buf.references, '[G]oto [R]eferences')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        -- nmap("<leader>ws", vim.lsp.buf.workspace_symbol, '[W]orkspace [S]ymbols')
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- See `:help K` for why this keymap
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        imap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

        -- Lesser used LSP functionality
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })

        -- Diagnostic keymaps
        nmap('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic message')
        nmap(']d', vim.diagnostic.goto_next, 'Go to next diagnostic message')
        nmap('<leader>e', vim.diagnostic.open_float, 'Open floating diagnostic message')
        nmap('<leader>q', vim.diagnostic.setloclist, 'Open diagnostics list')
      end)

      lsp.setup()

      vim.diagnostic.config({
        virtual_text = true
      })
    end,
  },
}
