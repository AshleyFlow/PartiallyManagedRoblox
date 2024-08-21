local secrets = require("../../secrets")

local links = {
	cloud = {},
	asset = "https://assetdelivery.roblox.com/v1/asset/",
}

links.cloud.universe_v1 = `https://apis.roblox.com/universes/v1/{secrets.universe}`
links.cloud.universe = `https://apis.roblox.com/cloud/v2/universes/{secrets.universe}`

links.cloud.place_v1 = `{links.cloud.universe_v1}/places/{secrets.place}`
links.cloud.place = `{links.cloud.universe}/places/{secrets.place}`

links.cloud.game = `{links.cloud.place}/instances/game`
links.cloud.publish = `{links.cloud.place_v1}/versions?versionType=Published`

return links
