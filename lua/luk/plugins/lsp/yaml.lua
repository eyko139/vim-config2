return {
	"someone-stole-my-name/yaml-companion.nvim",
	requires = {
		{ "neovim/nvim-lspconfig" },
		{ "nvim-lua/plenary.nvim" },
		{ "eyko139/telescope.nvim" },
	},
	config = function()
		require("telescope").load_extension("yaml_schema")
	end,
}
