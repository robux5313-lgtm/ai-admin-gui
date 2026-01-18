local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local AdminEvent = Instance.new("RemoteEvent")
AdminEvent.Name = "AdminAction"
AdminEvent.Parent = ReplicatedStorage

local AllowedAdmins = {
	["takipakipayer"] = true
}

local function findTargetPlayer(partialName)
	for _, player in ipairs(Players:GetPlayers()) do
		if string.sub(string.lower(player.Name), 1, string.len(partialName)) == string.lower(partialName) then
			return player
		end
	end
	return nil
end

AdminEvent.OnServerEvent:Connect(function(player, action, targetName)
	if not AllowedAdmins[player.Name] then return end
	
	local target = findTargetPlayer(targetName)
	
	if target and target.Character then
		local humanoid = target.Character:FindFirstChild("Humanoid")
		local rootPart = target.Character:FindFirstChild("HumanoidRootPart")
		
		if action == "Kill" and humanoid then
			humanoid.Health = 0
		elseif action == "Freeze" and rootPart then
			rootPart.Anchored = true
		elseif action == "Kick" then
			target:Kick("You have been kicked by an administrator.")
		end
	end
end)