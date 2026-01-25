local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ServerListGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "Toggle"
toggleButton.Size = UDim2.new(0, 120, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0.1, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 20
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Text = "Servers"
toggleButton.BorderSizePixel = 0
toggleButton.Parent = screenGui

local uiCornerToggle = Instance.new("UICorner")
uiCornerToggle.CornerRadius = UDim.new(0, 12)
uiCornerToggle.Parent = toggleButton

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local uiCornerMain = Instance.new("UICorner")
uiCornerMain.CornerRadius = UDim.new(0, 10)
uiCornerMain.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Server List"
titleLabel.Parent = mainFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "Container"
scrollFrame.Size = UDim2.new(1, -20, 1, -60)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = scrollFrame
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

local function createServerEntry(serverName, playerCount, ping, placeId, jobId)
	local entryFrame = Instance.new("Frame")
	entryFrame.Size = UDim2.new(1, -10, 0, 80)
	entryFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	entryFrame.Parent = scrollFrame
	
	local entryCorner = Instance.new("UICorner")
	entryCorner.CornerRadius = UDim.new(0, 8)
	entryCorner.Parent = entryFrame
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.6, 0, 0, 30)
	nameLabel.Position = UDim2.new(0, 10, 0, 5)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 16
	nameLabel.Text = serverName
	nameLabel.Parent = entryFrame
	
	local infoLabel = Instance.new("TextLabel")
	infoLabel.Size = UDim2.new(0.6, 0, 0, 40)
	infoLabel.Position = UDim2.new(0, 10, 0, 35)
	infoLabel.BackgroundTransparency = 1
	infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	infoLabel.TextXAlignment = Enum.TextXAlignment.Left
	infoLabel.Font = Enum.Font.Gotham
	infoLabel.TextSize = 14
	infoLabel.Text = "Players: " .. playerCount .. "/20 | Ping: " .. ping .. "ms"
	infoLabel.Parent = entryFrame
	
	local joinButton = Instance.new("TextButton")
	joinButton.Size = UDim2.new(0.3, 0, 0.6, 0)
	joinButton.Position = UDim2.new(0.65, 0, 0.2, 0)
	joinButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	joinButton.Font = Enum.Font.GothamBold
	joinButton.TextSize = 16
	joinButton.Text = "JOIN"
	joinButton.Parent = entryFrame
	
	local joinCorner = Instance.new("UICorner")
	joinCorner.CornerRadius = UDim.new(0, 6)
	joinCorner.Parent = joinButton
	
	joinButton.MouseButton1Click:Connect(function()
		if jobId then
			TeleportService:TeleportToPlaceInstance(placeId, jobId, LocalPlayer)
		else
			print("Simulated Join: " .. serverName)
		end
	end)
end

for i = 1, 10 do
	createServerEntry("Server " .. i, math.random(1, 19), math.random(50, 150), game.PlaceId, nil)
end

scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
end)