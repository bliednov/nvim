local function has_biome_config(bufnr)
  local root = vim.fs.root(bufnr, { 'biome.json', 'biome.jsonc' })
  return root ~= nil
end

local function js_formatters(bufnr)
  if has_biome_config(bufnr) then
    return { 'biome' }
  end
  return { 'prettierd', 'prettier', stop_after_first = true }
end

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      local disable_filetypes = { c = true, cpp = true }
      local lsp_format_opt
      if disable_filetypes[vim.bo[bufnr].filetype] then
        lsp_format_opt = 'never'
      else
        lsp_format_opt = 'fallback'
      end
      return {
        timeout_ms = 500,
        lsp_format = lsp_format_opt,
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'autopep8' },
      rust = { 'rustfmt' },
      go = { 'gopls', 'goimports', 'golines' },
      javascript = js_formatters,
      javascriptreact = js_formatters,
      typescript = js_formatters,
      typescriptreact = js_formatters,
      json = js_formatters,
      jsonc = js_formatters,
      yaml = { 'prettierd', 'prettier', stop_after_first = true },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      css = { 'prettierd', 'prettier', stop_after_first = true },
    },
    formatters = {
      biome = {
        require_cwd = true,
      },
      prettier = {
        require_cwd = true,
      },
      prettierd = {
        require_cwd = true,
      },
    },
  },
}
