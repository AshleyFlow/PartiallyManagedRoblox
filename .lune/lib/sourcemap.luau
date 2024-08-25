local roblox = require("@lune/roblox")
local serde = require("@lune/serde")
local fs = require("@lune/fs")

local Enum: typeof(Enum) = (roblox :: any).Enum

return {
	syncToPlace = function(place: roblox.DataModel)
		if not fs.isFile("sourcemap.json") then
			error("Failed to find sourcemap.json in cwd")
		end

		local datamodelSource = serde.decode("json", fs.readFile("sourcemap.json"))

		for _, serviceSource in datamodelSource.children do
			local serviceName: string = serviceSource.name
			local serviceInstance = place:GetService(serviceName)

			serviceInstance:ClearAllChildren()

			for _, scriptSource in serviceSource.children do
				assert(
					scriptSource.className == "Script" or scriptSource.className == "ModuleScript",
					"only scripts are supported"
				)

				local scriptName: string = scriptSource.name
				local scriptPath: string = scriptSource.filePaths[1]
				local scriptContent = fs.readFile(scriptPath)
				local scriptInstance

				if scriptSource.className == "ModuleScript" then
					local obj: ModuleScript = roblox.Instance.new("ModuleScript")

					scriptInstance = obj
				elseif scriptPath:match(".client.luau") then
					local obj: Script = roblox.Instance.new("Script")
					obj.RunContext = Enum.RunContext.Client

					scriptInstance = obj
				elseif scriptPath:match(".server.luau") then
					local obj: Script = roblox.Instance.new("Script")
					obj.RunContext = Enum.RunContext.Server

					scriptInstance = obj
				else
					error(".client.luau or .server.luau wasnt found in script name (?)")
				end

				scriptInstance.Name = scriptName
				scriptInstance.Source = scriptContent
				scriptInstance.Parent = serviceInstance

				print("Synced", scriptInstance:GetFullName())
			end
		end
	end,
}
