local stdio = require("@lune/stdio")

local config = require("../sync.config")
local util = require("./lib/util")
local action = stdio.prompt("select", "Select an action", {
	"Download, Modify & Publish",
})

if action == 1 then
	local place = util.getPlace(false)

	config.modify(place)

	util.publishPlace(place)
else
	print("No action selected")
end
