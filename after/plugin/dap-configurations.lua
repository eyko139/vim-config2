local dap = require("dap")
local dapui = require("dapui")
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

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end
