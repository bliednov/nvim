return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  lazy = false,
  version = false,
  opts = {
    -- add any opts here
    provider = 'claude',
    mode = 'legacy',
    mappings = {
      sidebar = {
        -- impossible mapping to disable it
        switch_windows = '<S-Tab>',
        reverse_switch_windows = '<F24><C-F24>',
      },
    },
    windows = {
      edit = {
        start_insert = false,
      },
      ask = {
        start_insert = false,
      },
    },
    providers = {
      openai = {
        disable_tools = true,
        model = 'gpt-4o-mini',
      },
      claude = {
        disable_tools = true,
      },
      gemini = {
        disable_tools = true,
        model = 'gemini-2.5-pro',
      },
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = 'make',
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    -- 'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
}
