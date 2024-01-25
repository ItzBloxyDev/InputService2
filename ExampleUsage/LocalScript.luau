--This script uses 2 buttons, one to make the character move forward, and one to swtich between left hand and right hand keys.

--Local script in starter player scripts

local InputService2 = require(game.ReplicatedStorage.InputService2)

local PlayerGui = game.Players.LocalPlayer.PlayerGui

local ScreenGui = PlayerGui:WaitForChild("ScreenGui")

local LeftHand = ScreenGui.LeftHand
local MoveForward = ScreenGui.MoveForward

local usingLeftHand = false

local leftHandKeys = {
	Enum.KeyCode.Space,
	Enum.KeyCode.I,
	Enum.KeyCode.J,
	Enum.KeyCode.K,
	Enum.KeyCode.L
} -- Table of left hand controls

InputService2.BindMovement() -- begin setting up the module, Keys are WASD by default

LeftHand.MouseButton1Click:Connect(function()
	usingLeftHand = not usingLeftHand
	InputService2.BindMovement(usingLeftHand and leftHandKeys or nil) -- Rebind the movement with the corresponding keys
end)

MoveForward.MouseButton1Down:Connect(function()
	local key = usingLeftHand and "I" or "W"
	InputService2.SimulateInputBegan(key) -- Simulate the input beggining for the key
end)

MoveForward.MouseButton1Up:Connect(function()
	local key = usingLeftHand and "I" or "W"
	InputService2.SimulateInputEnded(key) -- Simulate the input ending for the key
end)