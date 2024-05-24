return {
  {
    "stevearc/conform.nvim",
    opts = function()
      local opts = {
        formatters_by_ft = {
          nix = { "alejandra" },
        },
      }

      return opts
    end,
  },
}
