return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig")
    end,
  },

  {
  	"williamboman/mason.nvim",
  	opts = {
  		ensure_installed = {
  			"lua-language-server", "rust-analyzer"
  		},
  	},
  },

  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function ()
      vim.g.rustfmt_autosave = 1
    end
  },
  
  {
    "mistricky/codesnap.nvim",
    build = "make",
    config = function()
      require("codesnap").setup({
        bg_theme = "grape",
        watermark = "Jasper@Windswept",
        mac_window_bar = false,
        code_font_family = "JetBrains Mono",
      })
    end
  }
  -- {
    -- "simrat39/rust-tools.nvim",
    -- ft = "rust",
    -- dependencies = "neovim/nvim-lspconfig",
    -- opts = function ()
      -- return require "rust-tools"
    -- end,
    -- config = function (_, opts)
      -- require('rust-tools').setup(opts)
    -- end
  -- }
  --
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
