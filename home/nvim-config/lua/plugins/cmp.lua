return {
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      require("cmp").setup({
        window = {
          completion = {
            border = "rounded",
            scrollbar = false,
          },
          documentation = {
            border = "rounded",
          },
        },
      })
    end,
  },
}
