local stdio = require("@lune/stdio")

local sourcemap = require("./lib/sourcemap")
local config = require("../sync.config")
local util = require("./lib/util")

print("Make sure your sourcemap.json is updated before using this script!!!")

local action = stdio.prompt("select", "Select an action", {
	"Download, Modify & Publish",
})

if action == 1 then
	local place = util.getPlace(false)

	config.modify(place)
	sourcemap.syncToPlace(place)

	util.publishPlace(place)
else
	print("No action selected")
end
