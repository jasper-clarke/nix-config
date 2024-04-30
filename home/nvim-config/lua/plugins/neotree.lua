return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ action = "focus" })
      end,
      desc = "Toggle NeoTree Focus",
    },
    {
      "<C-n>",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
      end,
      desc = "Toggle NeoTree",
    },
  },
}
