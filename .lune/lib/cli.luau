local process = require("@lune/process")

local flags = {}

for _, arg in process.args do
	if arg:match("^--") then
		table.insert(flags, arg:sub(3))
	end
end

return {
	flags = flags,
}
