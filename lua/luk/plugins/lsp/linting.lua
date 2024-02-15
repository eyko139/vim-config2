return {
	"mfussenegger/nvim-lint",
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
		local lint = require("lint")
		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			go = { "golangcilint" },
			golang = { "golangcilint" },
		}
	end,
}
