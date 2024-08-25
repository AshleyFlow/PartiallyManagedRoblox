--!strict
local roblox = require("@lune/roblox")
local serde = require("@lune/serde")
local fs = require("@lune/fs")

local Enum: typeof(Enum) = (roblox :: any).Enum

export type SourceObject = {
	name: string,
	className: string,
	filePaths: { string },
	children: { SourceObject }?,
}

local function scriptSourceToInstance(scriptSource: SourceObject): roblox.Instance
	assert(
		scriptSource.className == "Script" or scriptSource.className == "ModuleScript",
		"only Scripts and ModuleScripts are currently supported"
	)

	local scriptName: string = scriptSource.name
	local scriptPath: string = scriptSource.filePaths[1]
	local scriptContent = fs.readFile(scriptPath)
	local scriptInstance: ModuleScript

	if scriptSource.className == "ModuleScript" then
		local obj: ModuleScript = roblox.Instance.new("ModuleScript")

		scriptInstance = obj
	elseif scriptPath:match(".client.luau") then
		local obj: Script = roblox.Instance.new("Script")
		obj.RunContext = Enum.RunContext.Client

		scriptInstance = obj :: any
	elseif scriptPath:match(".server.luau") then
		local obj: Script = roblox.Instance.new("Script")
		obj.RunContext = Enum.RunContext.Server

		scriptInstance = obj :: any
	else
		error("only .client.luau and .server.luau is supported on scripts")
	end

	scriptInstance.Name = scriptName
	scriptInstance.Source = scriptContent

	return scriptInstance :: any
end

local function sourceToInstance(sourceObject: SourceObject): roblox.Instance
	local sourceInstance: roblox.Instance? = nil

	if sourceObject.className == "Folder" then
		local folder = roblox.Instance.new("Folder")
		folder.Name = sourceObject.name

		sourceInstance = folder
	elseif sourceObject.className == "Script" or sourceObject.className == "ModuleScript" then
		sourceInstance = scriptSourceToInstance(sourceObject)
	end

	assert(sourceInstance, `{sourceObject.className} is not supported`)

	if sourceObject.children then
		for _, childSource in sourceObject.children do
			local childInstance = sourceToInstance(childSource)
			childInstance.Parent = sourceInstance

			print("Synced Child", childInstance:GetFullName())
		end
	end

	return sourceInstance
end

local function sourceToPlace(place: roblox.DataModel)
	if not fs.isFile("sourcemap.json") then
		error("Failed to find sourcemap.json in cwd")
	end

	local datamodelSource: SourceObject = serde.decode("json", fs.readFile("sourcemap.json"))

	assert(datamodelSource.children, "Sourcemap is empty")

	for _, serviceSource in datamodelSource.children do
		local serviceName: string = serviceSource.name
		local serviceInstance = place:GetService(serviceName)

		if serviceSource.children == nil then
			continue
		end

		serviceInstance:ClearAllChildren()

		for _, scriptSource in serviceSource.children do
			local scriptInstance = sourceToInstance(scriptSource)
			scriptInstance.Parent = serviceInstance

			print("Synced", scriptInstance:GetFullName())
		end
	end
end

return {
	sourceToInstance = sourceToInstance,
	sourceToPlace = sourceToPlace,
}
