return {

  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = { style = "night" },
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  -- {
  --   "loctvl842/monokai-pro.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     transparent_background = false,
  --     devicons = true,
  --     filter = "ristretto", -- classic | octagon | pro | machine | ristretto | spectrum
  --     -- day_night = {
  --     --   enable = true,
  --     --   day_filter = "pro",
  --     --   night_filter = "spectrum",
  --     -- },
  --     inc_search = "background", -- underline | background
  --     background_clear = {
  --       "nvim-tree",
  --       "neo-tree",
  --       "bufferline",
  --       -- "telescope",
  --       "toggleterm",
  --     },
  --     plugins = {
  --       bufferline = {
  --         underline_selected = true,
  --         underline_visible = false,
  --         underline_fill = true,
  --         bold = false,
  --       },
  --       indent_blankline = {
  --         context_highlight = "pro", -- default | pro
  --         context_start_underline = true,
  --       },
  --     },
  --   },
  --   config = function(_, opts)
  --     local monokai = require("monokai-pro")
  --     monokai.setup(opts)
  --     monokai.load()
  --   end,
  -- },
}
