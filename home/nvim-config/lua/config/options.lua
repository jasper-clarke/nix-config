-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

vim.filetype.add({
  pattern = { [".*/hyprwm/.*%.conf"] = "hyprlang" },
})

opt.relativenumber = false
opt.wrap = true
opt.number = true
opt.clipboard = "unnamedplus"
opt.autochdir = true
