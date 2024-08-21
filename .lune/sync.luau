local cli = require("./lib/cli")
local util = require("./lib/util")

local cli_cache = table.find(cli.flags, "use-cache") and true
local cli_publish = table.find(cli.flags, "publish") and true

local place = util.getPlace(cli_cache)

if cli_publish then
	-- ...
	-- modifiy the place

	util.publishPlace(place)
end
