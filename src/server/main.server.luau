--!strict
type Base = {
	walkSpeed: number,
	health: number,
}

type NPC = Base & {
	behaviourTree: {},
}

type Player = Base & {
	inputManager: {},
	inventory: {},
}

type Character = {
	kind: "Base",
	value: Base,
} | {
	kind: "NPC",
	value: NPC,
} | {
	kind: "Player",
	value: Player,
}

local function takeCharacter(char: Character)
	print(char.kind)

	if char.kind == "Base" then
		print(char.value.walkSpeed, char.value.health)
	elseif char.kind == "NPC" then
		print(char.value.walkSpeed, char.value.health, char.value.behaviourTree)
	elseif char.kind == "Player" then
		print(char.value.walkSpeed, char.value.health, char.value.inputManager, char.value.inventory)
	end
end

do
	takeCharacter({
		kind = "Base",
		value = {
			walkSpeed = 16,
			health = 100,
		},
	})
end

do
	local v: NPC = {
		behaviourTree = {},
		walkSpeed = 16,
		health = 100,
	}

	takeCharacter({
		kind = "NPC",
		value = v,
	})
end

do
	local v: Player = {
		inputManager = {},
		inventory = {},
		walkSpeed = 16,
		health = 100,
	}

	takeCharacter({
		kind = "Player",
		value = v,
	})
end
