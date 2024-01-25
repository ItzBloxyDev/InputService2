local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local InputService2 = {}

local currentKeyboard

local player = game.Players.LocalPlayer

local reMaps = {}

function InputService2.BindMovement(keys)	
	local newModule = script.Keyboard:Clone()
	local controller = player.PlayerScripts.PlayerModule.ControlModule
	
	InputService2.StoredKeyboardController = controller.Keyboard:Clone()
	
	local playerModule = player.PlayerScripts.PlayerModule:Clone()
	playerModule.ControlModule.Keyboard:Destroy()
	newModule.Parent = playerModule.ControlModule
	
	player.PlayerScripts.PlayerModule:Destroy()
	playerModule.Parent = player.PlayerScripts
	
	local keyboardModule = require(newModule)
	local keyboard = keyboardModule.new(2000)
	
	if keys then
		keyboardModule.MovementKeys = keys
	end

	keyboard:Enable(false)
	keyboard:Enable(true)
	
	currentKeyboard = keyboardModule
	
	require(playerModule)

end

function InputService2.MapKey(bind : Enum.KeyCode, replace : Enum.KeyCode)
	if not currentKeyboard then
		warn("Movement hasn't been binded")
	end
	reMaps[bind] = replace
end

function InputService2.BindMovementKey(bind : Enum.KeyCode, replace : Enum.KeyCode)
	if not currentKeyboard then
		warn("Movement hasn't been binded")
	end
	local controller = player.PlayerScripts.PlayerModule.ControlModule
	local keyboardModule = require(controller.Keyboard)
	
	for i,v in pairs(keyboardModule.MovementKeys) do
		if v == replace then
			keyboardModule.ReplaceKey(keyboardModule.labels[i],bind)
			return
		end
	end
	warn("Given argument is not a movement keybind")
end

local function registerMovement(keyCode : Enum.KeyCode, state: Enum.UserInputState)
	local controller = player.PlayerScripts.PlayerModule.ControlModule
	local keyboardModule = require(controller.Keyboard)
	
	if keyboardModule.PressKey then
		keyboardModule.PressKey(keyCode,state)
	end
	
end

function InputService2.Click(Name : string, holdDuration : number)
	InputService2.SimulateInputBegan(Name)
	if holdDuration then
		task.wait(holdDuration)
	else
		task.wait()
	end
	InputService2.SimulateInputEnded(Name)
end

local function newBindable(Name : string, state : Enum.UserInputState)
	local inputEvent = Instance.new("BindableEvent")
	InputService2[Name] = inputEvent.Event
	
	InputService2["Simulate"..Name] = function(input : string, gameProcessed : boolean)
		local key = Enum.KeyCode[input]
		if reMaps[key] then
			key = reMaps[key]
		end
		local simulatedInput = {
			KeyCode = key,
			UserInputType = state
		}
		if currentKeyboard and table.find(currentKeyboard.MovementKeys,key) then
			registerMovement(key, state)
		end
		
		inputEvent:Fire(simulatedInput, gameProcessed)
	end
	
	UserInputService[Name]:Connect(function(input, gameProcessed)
		local key = input.KeyCode
		if reMaps[input.KeyCode] then
			registerMovement(reMaps[input.KeyCode], state)
		end
		if currentKeyboard and table.find(currentKeyboard.MovementKeys,key) then
			registerMovement(key, state)
		end
		inputEvent:Fire(input, gameProcessed)
	end)
end

newBindable("InputBegan",Enum.UserInputState.Begin)
newBindable("InputEnded",Enum.UserInputState.End)

return InputService2 -- no way
