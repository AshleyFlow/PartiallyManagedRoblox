local roblox = require("@lune/roblox")
local fs = require("@lune/fs")

local cookie = roblox.getAuthCookie()
assert(cookie, "Failed to get roblox auth cookie")

local RunContextEnum = (roblox :: any).Enum.RunContext :: typeof(Enum.RunContext)

--- Only supports scripts/localscripts and modulescripts
local function syncFile(parent: roblox.Instance, fileName: string, filePath: string)
	local kind: "Client" | "Server" | "Module"

	if fileName:match(".server.luau$") then
		kind = "Server"
	elseif fileName:match(".client.luau$") then
		kind = "Client"
	elseif fileName:match(".luau$") then
		kind = "Module"
	end

	if kind == "Module" then
		local module: ModuleScript = roblox.Instance.new("ModuleScript")
		module.Name = fileName:gsub(".luau", "")
		module.Source = fs.readFile(filePath)
		module.Parent = parent :: any
		print("Synced Module:", module:GetFullName())
	else
		local script: Script = roblox.Instance.new("Script")
		script.RunContext = if kind == "Server" then RunContextEnum.Server else RunContextEnum.Client
		script.Name = fileName:gsub(".server.luau" :: any, ""):gsub(".client.luau" :: any, "")
		script.Source = fs.readFile(filePath)
		script.Parent = parent :: any
		print("Synced Script:", script:GetFullName())
	end
end

return {
	universe = "6448521988",
	place = "87807834966824",
	key = "awlYpWXs10iyrfrwLfvtUBAIBS4uRgMtJJIEbKyXYm2GUbQbZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkluTnBaeTB5TURJeExUQTNMVEV6VkRFNE9qVXhPalE1V2lJc0luUjVjQ0k2SWtwWFZDSXNJbU4wZVNJNklrcFhWQ0o5LmV5SmlZWE5sUVhCcFMyVjVJam9pWVhkc1dYQlhXSE14TUdsNWNtWnlkMHhtZG5SVlFrRkpRbE0wZFZKblRYUktTa2xGWWt0NVdGbHRNa2RWWWxGaUlpd2liM2R1WlhKSlpDSTZJalkwTkRneU9USXpOaUlzSW1GMVpDSTZJbEp2WW14dmVFbHVkR1Z5Ym1Gc0lpd2lhWE56SWpvaVEyeHZkV1JCZFhSb1pXNTBhV05oZEdsdmJsTmxjblpwWTJVaUxDSmxlSEFpT2pFM01qUXlORFU1T0Rjc0ltbGhkQ0k2TVRjeU5ESTBNak00Tnl3aWJtSm1Jam94TnpJME1qUXlNemczZlEuSkVKOVVLem1rY0RobTM0bXBEU0lOSEhzS3RiaG83ektxYXcwbjZXR0l3UkpLc3B6RTNpNGpiVGZ1MDI4MmpfVVRKczNPZXFIZ2ZCVUg5eGtNOWV1d2ZKY1RJMFJLMGpJWlRQcHdyem5ENTlEeGIyQTZjS3E3X0pXUUl6dTFZaDNXWVdnRjFPVXNJWHpDUzhJUUlFT2NPRG9aVEdyOEoxV2VrRDJXbWE5c3NURnZPd0FPTTBZVE9lQTZtMWZJWjM2eUhaZGVWZU5YZC1BWHEzUGxPVDVEZWZJUmF2UmdOUEpQR3ZDd2tubUx2WDR6aUxudVdaWVI2RFJpd3lmOVk0ZTZUVE8zWHNZR2Z5ZzVFcVJWVkNhV3NsMHZVbGpVa3htWV9md09zN3pQVmdGSkNidTJ2elJIa0w3TG4zUTV1akdxTzRqZUNHbTJqNFdZYnpFM3ZjTnB3",
	cookie = cookie,
	modify = function(place: roblox.DataModel)
		local ReplicatedStorage = place:GetService("ReplicatedStorage")
		local ServerScriptService = place:GetService("ServerScriptService")

		ReplicatedStorage:ClearAllChildren()
		ServerScriptService:ClearAllChildren()

		for _, fileName in fs.readDir("src/client") do
			syncFile(ReplicatedStorage, fileName, `src/client/{fileName}`)
		end

		for _, fileName in fs.readDir("src/server") do
			syncFile(ServerScriptService, fileName, `src/server/{fileName}`)
		end
	end,
}
