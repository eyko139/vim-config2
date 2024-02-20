return {
	"eyko139/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	name = "telescope.nvim",
	config = function()
		local actions = require("telescope.actions")
		local config = require("telescope.config")
		require("telescope").setup({
			defaults = {
				mappings = {
					i = {
						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,
						["<C-f>"] = actions.preview_scrolling_left,
						["<C-k>"] = actions.preview_scrolling_right,
					},
				},
				cache_picker = {
					num_pickers = 100,
					limit_entries = 1000,
				},
			},
		})
	end,
}
