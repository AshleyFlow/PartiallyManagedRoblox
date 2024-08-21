--!strict
local fs = require("@lune/fs")
local net = require("@lune/net")
local roblox = require("@lune/roblox")

local secrets = require("../../secrets")
local links = require("./urls")

local function downloadPlace(): {
	raw: string,
	game: roblox.DataModel,
}
	print("Downloading place")

	local response = net.request({
		url = links.asset,
		headers = {
			Cookie = secrets.cookie,
		},
		query = {
			id = secrets.place,
		},
	})

	assert(response.ok, "Failed to download place")

	print("Downloaded place")

	return {
		raw = response.body,
		game = roblox.deserializePlace(response.body),
	}
end

local function cache(name: string, content: string)
	local path = `./cache/{name}`

	if not fs.isDir("cache") then
		fs.writeDir("cache")
	end

	if fs.isFile(path) then
		fs.removeFile(path)
	end

	fs.writeFile(path, content)

	print("Cached", name)
end

local function getPlace(useCache: boolean): roblox.DataModel
	if useCache then
		print("Using the stored cache instead of downloading the Roblox place")

		return roblox.deserializePlace(fs.readFile("cache/place.rbxm"))
	else
		local place = downloadPlace()
		cache("place.rbxm", place.raw)
		return place.game
	end
end

local function publishPlace(place: roblox.DataModel)
	print("Publishing place")

	local response = net.request({
		method = "POST",
		body = roblox.serializePlace(place, false),
		url = links.cloud.publish,
		headers = {
			["x-api-key"] = secrets.key,
			["Content-Type"] = "application/octet-stream",
		},
	})

	assert(response.ok, `Failed to publish place\n{response.statusMessage}`)

	print("Published place")
end

return {
	downloadPlace = downloadPlace,
	getPlace = getPlace,
	publishPlace = publishPlace,
}
