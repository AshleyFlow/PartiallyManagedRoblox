local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local hello = require(ReplicatedStorage.shared.hello)
hello(Players.LocalPlayer.Name)
