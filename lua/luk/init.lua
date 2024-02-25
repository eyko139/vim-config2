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

require("telescope").setup({
	defaults = {
		cache_picker = {
			num_pickers = 1000,
			limit_entries = 1000,
		},
	},
})
require("telescope").load_extension("dap")

require("gitsigns").setup({
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns
		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		map("n", "[c", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		-- Actions
		map("n", "<leader>hs", gs.stage_hunk)
		map("n", "<leader>hr", gs.reset_hunk)
		map("v", "<leader>hs", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)
		map("v", "<leader>hr", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)
		map("n", "<leader>hS", gs.stage_buffer)
		map("n", "<leader>hu", gs.undo_stage_hunk)
		map("n", "<leader>hR", gs.reset_buffer)
		map("n", "<leader>hp", gs.preview_hunk)
		map("n", "<leader>hb", function()
			gs.blame_line({ full = true })
		end)
		map("n", "<leader>tb", gs.toggle_current_line_blame)
		map("n", "<leader>hd", gs.diffthis)
		map("n", "<leader>hD", function()
			gs.diffthis("~")
		end)
		map("n", "<leader>td", gs.toggle_deleted)

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,
})

-- local dap = require("dap")
-- dap.adapters["local-lua"] = {
-- 	type = "executable",
-- 	command = "node",
-- 	args = {
-- 		"/home/luk/projects/priv/local-lua-debugger-vscode/extension/debugAdapter.js",
-- 	},
-- 	enrich_config = function(config, on_config)
-- 		if not config["extensionPath"] then
-- 			local c = vim.deepcopy(config)
-- 			-- 💀 If this is missing or wrong you'll see
-- 			-- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
-- 			c.extensionPath = "/home/luk/projects/priv/local-lua-debugger-vscode"
-- 			on_config(c)
-- 		else
-- 			on_config(config)
-- 		end
-- 	end,
-- }
local dap = require("dap")
dap.configurations.lua = {
	{
		type = "nlua",
		request = "attach",
		name = "Attach to running Neovim instance",
	},
}

dap.adapters.nlua = function(callback, config)
	callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end

dap.adapters.delve = {
	type = "server",
	port = "${port}",
	executable = {
		command = "dlv",
		args = { "dap", "-l", "127.0.0.1:${port}" },
	},
}

dap.configurations.go = {
	{
		type = "go",
		name = "Debug ENV",
		request = "launch",
		program = "${env:DEBUG_GO_PACKAGE}",
	},
	{
		type = "go",
		name = "Debug",
		request = "launch",
		program = "${file}",
	},
	{
		type = "delve",
		name = "Debug test", -- configuration for debugging test files
		request = "launch",
		mode = "test",
		program = "${file}",
	},
	-- works with go.mod packages and sub packages
	{
		type = "delve",
		name = "Debug test (go.mod)",
		request = "launch",
		mode = "test",
		program = "./${relativeFileDirname}",
	},
}
local args = { "dap", "-l", "127.0.0.1:" .. "33078" }
dap.adapters.go = {
	type = "server",
	port = "33078",
	executable = {
		command = "dlv",
		args = args,
	},
}

-- require("dap-go").setup()
require("dapui").setup()
