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
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
}
