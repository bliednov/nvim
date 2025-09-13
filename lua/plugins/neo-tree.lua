return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('neo-tree').setup()
      vim.keymap.set('n', '<C-n>', ':NeoTreeRevealToggle<CR>', { desc = 'Toggle Neo-tree (reveal current file)' })
    end,
  },
}
