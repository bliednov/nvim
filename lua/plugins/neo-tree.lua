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
      vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>')
      vim.keymap.set('n', '<leader>ne', ':Neotree filesystem reveal position=left toggle<CR>', { desc = 'Toggle Neo-tree (reveal current file)' })
    end,
  },
}
