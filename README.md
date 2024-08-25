# Partially Managed Roblox Template

This template uses Lune to do the following:

* download the place
* insert scripts into the place
* publish the place back to roblox

By default this repo uses `rokit` to install tools and `argon` to sync with studio, feel free to change them to `aftman` and `rojo`, nothing will break if you do so.

The lune script in this template is very limited (only supports Script and ModuleScript instances)
you can change this behavior by editing `.lune/lib/sourcemap.luau`

## Usage

create a file with the name of `sync.config.luau` and fill it with the following content:

```luau
local roblox = require("@lune/roblox")

local cookie = roblox.getAuthCookie()
assert(cookie, "Failed to get roblox auth cookie")

return {
    -- universe id
    universe = "x",

    -- place id
    place = "x",

    -- roblox opencloud api key (must have universe-places:write access permission)
    key = "x",

    cookie = cookie,
    modify = function(place: roblox.DataModel)
        -- if you'd like you can modify the place here before it gets published.
    end,
}
```

now to publish your game, update your `sourcemap.json` file if needed and then run this in your terminal `lune run sync`
