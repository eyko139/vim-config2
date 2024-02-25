function _G.tbl_length(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end
function _G.get_visual_selection()
	-- this will exit visual mode
	-- use 'gv' to reselect the text
	local _, csrow, cscol, cerow, cecol
	local mode = vim.fn.mode()
	if mode == "v" or mode == "V" or mode == "" then
		-- if we are in visual mode use the live position
		_, csrow, cscol, _ = unpack(vim.fn.getpos("."))
		_, cerow, cecol, _ = unpack(vim.fn.getpos("v"))
		if mode == "V" then
			-- visual line doesn't provide columns
			cscol, cecol = 0, 999
		end
		-- exit visual mode
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
	else
		-- otherwise, use the last known visual position
		_, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
		_, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
	end
	-- swap vars if needed
	if cerow < csrow then
		csrow, cerow = cerow, csrow
	end
	if cecol < cscol then
		cscol, cecol = cecol, cscol
	end
	local lines = vim.fn.getline(csrow, cerow)
	-- local n = cerow-csrow+1
	local n = tbl_length(lines)
	if n <= 0 then
		return ""
	end
	lines[n] = string.sub(lines[n], 1, cecol)
	lines[1] = string.sub(lines[1], cscol)
	return table.concat(lines, "\n")
end

vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
vim.keymap.set("i", "jk", "<Esc>", options)

vim.o.clipboard = "unnamedplus"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.updatetime = 50

-- move multiple lines at once
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set(
	"n",
	"gd",
	"<cmd>lua require('telescope.builtin').lsp_definitions({ exclude = '/react/index.d.ts' })<CR>"
)

vim.keymap.set({ "v", "n" }, "gm", "<cmd>Telescope marks<CR>", {})
-- vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")

-- jump while keeping cursor in middle of screen
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- paste without filling buffer
vim.keymap.set("x", "<S-p>", '"_dP')
vim.api.nvim_set_keymap("n", "<F8>", [[:lua require"dap".toggle_breakpoint()<CR>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<F9>", [[:lua require"dap".continue()<CR>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<F10>", [[:lua require"dap".step_over()<CR>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<S-F10>", [[:lua require"dap".step_into()<CR>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<F12>", [[:lua require"dap.ui.widgets".hover()<CR>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<F5>", [[:lua require"osv".launch({port = 8086})<CR>]], { noremap = true })

-- dap ui
-- vim.keymap.set("v", "<M-k>", "<Cmd>lua require('dapui').eval(call :lua get_visual_selection())<CR>")
vim.keymap.set("v", "<M-k>", "<Cmd>lua require('dapui').eval('call' get_visual_selection())<CR>")
