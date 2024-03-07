require("luk")

local function findSubstringInPath(path)
	local match = string.match(path, "modules/([^/]+)")
	if match then
        return match
	else
		return nil
	end
end

local function test()
	print("Hello")
	local buff = vim.api.nvim_buf_get_name(0)
	local module = findSubstringInPath(buff)
    if module ~= nil then
        local tmuxCommand = string.format("tmux new-window -n %s", module)
        local bashCommand = string.format("./gradlew deploy -p modules/%s", module)
        os.execute(tmuxCommand)
        local gradlewCommand = "tmux send-keys -t " .. module .. " '" .. bashCommand .. "' Enter"
        print(gradlewCommand)
        os.execute(gradlewCommand)
        os.execute("tmux select-window -t main")
    else
        print("Module not found")
    end
end

vim.api.nvim_create_user_command("SayHello", test, {})
