require("luk.remap")
require("luk.config")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ { import = "luk.plugins" }, { import = "luk.plugins.lsp" } }, {})
require("nvim-treesitter.configs").setup({
	highlight = {
		enabled = true,
	},
})
