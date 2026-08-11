local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- ===== CRUCIFIX SYSTEM =====
local RepentanceUrl = "https://github.com/RegularVynixu/DOORS-Entity-Spawner-V2/raw/main/Assets/Repentance.rbxm"

local function getgithubmodeL(url)
	if not (writefile and getcustomasset and request) then return nil end
	local fileName = string.match(url, "([^/]+)$") or "temp_model.rbxm"
	local response = request({Url = url, Method = "GET"})
	if response.StatusCode ~= 200 then return nil end
	writefile(fileName, response.Body)
	local assetId = getcustomasset(fileName)
	local success, result = pcall(function() return game:GetObjects(assetId)[1] end)
	return success and result or nil
end

local function resetLightingSmoothly(duration)
	duration = duration or 3
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(Lighting, tweenInfo, {
		FogEnd = 60,
		FogStart = 0,
		FogColor = Color3.new(0, 0, 0)
	}):Play()
end

local function executeCrucifixion(entityModel, targetPart, crucifixTool, onComplete)
	if crucifixTool then crucifixTool:Destroy() end
	local repentanceAsset = getgithubmodeL(RepentanceUrl)
	if not repentanceAsset then
		if entityModel then entityModel:Destroy() end
		if onComplete then onComplete() end
		return
	end

	local player = Players.LocalPlayer
	local char = player.Character
	local rootPart = char and char:FindFirstChild("HumanoidRootPart")
	local camera = Workspace.CurrentCamera
	if not rootPart then
		if entityModel then entityModel:Destroy() end
		repentanceAsset:Destroy()
		if onComplete then onComplete() end
		return
	end

	-- Tìm sound "Scream" và "Repent" trong targetPart (FogMonster) hoặc entityModel
	local screamSound = targetPart:FindFirstChild("Scream", true) or (entityModel and entityModel:FindFirstChild("Scream", true))
	local repentSound = targetPart:FindFirstChild("Repent", true) or (entityModel and entityModel:FindFirstChild("Repent", true))

	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = {char, entityModel, repentanceAsset}
	local rayResult = workspace:Raycast(targetPart.Position, Vector3.new(0, -1000, 0), rayParams)
	local groundPos = rayResult and rayResult.Position or (targetPart.Position - Vector3.new(0, 3, 0))

	repentanceAsset:PivotTo(CFrame.new(groundPos))
	repentanceAsset.Parent = workspace

	local crucifixPart = repentanceAsset:FindFirstChild("Crucifix")
	local entityPart = repentanceAsset:FindFirstChild("Entity") or targetPart

	local sound = crucifixPart and (crucifixPart:FindFirstChild("Sound") or crucifixPart:FindFirstChildWhichIsA("Sound"))
	if sound then sound:Play() end

	-- Phát tiếng Scream khi bắt đầu dính Crucifix
	if screamSound then 
		screamSound:Play() 
	end

	if crucifixPart then
		crucifixPart.CFrame = camera.CFrame * CFrame.new(0, 0, -3)
		local bodyPos = crucifixPart:FindFirstChild("BodyPosition")
		if bodyPos then bodyPos.Position = (rootPart.CFrame * CFrame.new(0.5, 2, -5)).Position end

		local bodyAngular = crucifixPart:FindFirstChild("BodyAngularVelocity")
		if bodyAngular then
			TweenService:Create(bodyAngular, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.In), { AngularVelocity = Vector3.new(0, 30, 0) }):Play()
		end
	end

	if targetPart and entityPart then
		TweenService:Create(targetPart, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { CFrame = entityPart.CFrame }):Play()
	end

	task.wait(2)

	-- Phát tiếng Repent khi bắt đầu bị dìm xuống đất
	if repentSound then 
		repentSound:Play() 
	end

	if targetPart then
		TweenService:Create(targetPart, TweenInfo.new(2.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), { CFrame = targetPart.CFrame - Vector3.new(0, 25, 0) }):Play()
	end

	task.wait(2.5)
	if crucifixPart then
		TweenService:Create(crucifixPart, TweenInfo.new(1), { Size = crucifixPart.Size * 2, Transparency = 1 }):Play()
	end

	task.wait(1)
	if entityModel then entityModel:Destroy() end
	if repentanceAsset then repentanceAsset:Destroy() end

	-- Reset Lighting mượt mà sau khi Crucifix hoàn tất
	resetLightingSmoothly(3)

	if onComplete then onComplete() end
end
-- ============================

local gameData = ReplicatedStorage:WaitForChild("GameData")
local latestRoom = gameData:WaitForChild("LatestRoom")
local floor = gameData:WaitForChild("Floor")

latestRoom.Changed:Connect(function(roomValue)
	if floor.Value == "Hotel" and roomValue == 50 then
		local entityModel = nil
		local isCrucified = false

		local cofingae = {
			Name = "Fog",
			HeightOffset = 2
		}

		local function EntityMoveTo(targetCFrame)
			if isCrucified or not entityModel or not entityModel.Parent then return end
			local reached = false
			local connection

			connection = RunService.Stepped:Connect(function(_, step)
				if isCrucified or not entityModel or not entityModel.Parent then 
					if connection then connection:Disconnect() end
					reached = true 
					return 
				end

				local pivot = entityModel:GetPivot()
				local difference = (targetCFrame.Position - pivot.Position)

				if difference.Magnitude > 0.8 then
					local unit = difference.Unit
					entityModel:PivotTo(pivot + unit * math.min(step * 20, difference.Magnitude))
				else
					if connection then connection:Disconnect() end
					reached = true
				end
			end)

			local start = os.clock()
			repeat RunService.Stepped:Wait() until reached or isCrucified or (os.clock() - start > 12)
			if connection then connection:Disconnect() end
		end

		-- Hàm Lol() được tối ưu hóa để lấy CFrame chuẩn xác của phòng 50
		local function Lol()
			local rooms = Workspace:FindFirstChild("CurrentRooms")
			if rooms then
				local room50 = rooms:FindFirstChild("50") or rooms:FindFirstChild("Room50") or rooms:FindFirstChild(tostring(roomValue))
				if room50 then
					local startPart = room50:FindFirstChild("RoomStart") 
						or room50:FindFirstChild("RoomExit") 
						or room50.PrimaryPart 
						or room50:FindFirstChildWhichIsA("BasePart")
					if startPart then
						return startPart.CFrame
					end
				end
			end

			-- Fallback: Lấy vị trí của Player nếu phòng không khả dụng (tránh bị quăng về gốc tọa độ 0,5,0 ở xa)
			local char = Players.LocalPlayer.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				return char.HumanoidRootPart.CFrame
			end

			return CFrame.new(0, 5, 0)
		end

		local function Fastest()
			local pathFolder = Workspace:FindFirstChild("FigureNodes", true)
			if not pathFolder then 
				task.wait(1)
				return false
			end

			local nodes = pathFolder:GetChildren()
			table.sort(nodes, function(a, b)
				local numA = tonumber(a.Name:match("%d+")) or 0
				local numB = tonumber(b.Name:match("%d+")) or 0
				return numA < numB
			end)

			for _, node in ipairs(nodes) do
				if isCrucified or not entityModel or not entityModel.Parent then return false end
				if node:IsA("BasePart") then
					EntityMoveTo(node.CFrame + Vector3.new(0, cofingae.HeightOffset, 0))
				end
			end

			if isCrucified or not entityModel or not entityModel.Parent then return false end
			EntityMoveTo(Lol())
			return true
		end

		-- Kiểm tra va chạm & kích hoạt Crucifix
		local function Gex(model)
			task.spawn(function()
				while task.wait(0.1) do
					if isCrucified or not model or not model.Parent then break end

					local part = model:FindFirstChild("FogMonster") or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")

					local rushNew = model:FindFirstChild("RushNew")
					if rushNew and rushNew:IsA("BasePart") then
						rushNew.CanCollide = false
					end

					local player = Players.LocalPlayer
					local char = player.Character
					local hum = char and char:FindFirstChildOfClass("Humanoid")
					local hrp = char and char:FindFirstChild("HumanoidRootPart")

					if part and hum and hrp and hum.Health > 0 then
						if (hrp.Position - part.Position).Magnitude <= 9 then
							local equippedTool = char:FindFirstChildOfClass("Tool")
							if equippedTool and equippedTool.Name == "Crucifix" then
								isCrucified = true
								executeCrucifixion(model, part, equippedTool)
								---====== Load achievement giver ======---
								local achievementGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))()

								---====== Display achievement ======---
								achievementGiver({
									Title = "Emotinal Damage",
									Desc = "You Are Safe",
									Reason = "Crucifix Fog",
									Image = "rbxassetid://"
								})
								break
							else
								local cue2 = Instance.new("Sound")
								cue2.Parent = game.Workspace
								cue2.Name = "Spawn"
								cue2.SoundId = "rbxassetid://71300535805250"
								cue2.Volume = 10
								cue2.TimePosition = 0
								cue2.PlaybackSpeed = 1
								cue2:Play()

								local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
								local screenGui = Instance.new("ScreenGui")
								screenGui.Name = "FlashOverlay"
								screenGui.IgnoreGuiInset = true 
								screenGui.Parent = playerGui

								-- Create the Frame
								local frame = Instance.new("Frame")
								frame.Size = UDim2.new(1, 0, 1, 0)
								frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
								frame.BackgroundTransparency = 0 
								frame.BorderSizePixel = 0
								frame.Parent = screenGui
								wait(0.59)


								local Smiler = Instance.new("ImageLabel")
								Smiler.Image = "rbxassetid://12706593968"
								Smiler.Size = UDim2.new(0, 800, 0, 800)
								Smiler.Position = UDim2.new(0.5, 0,0.5, 0)
								Smiler.ImageColor3 = Color3.fromRGB(255, 255, 255)
								Smiler.AnchorPoint = Vector2.new(0.5, 0.5)
								Smiler.Parent = screenGui
								Smiler.BackgroundTransparency = 1
								Smiler.ResampleMode = Enum.ResamplerMode.Pixelated
								Smiler.ImageTransparency = 0.9
								Smiler.ZIndex = 1000
								Smiler.Rotation = 0


								local a = task.spawn(function()
									while true do
										frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
										wait(0)
										frame.BackgroundColor3 = Color3.fromRGB(81, 81, 81)
										wait(0)
									end
								end)

								local rng = Random.new()
								local origin = Smiler.Position

								local b = task.spawn(function()
									while true do
										Smiler.Rotation = math.random(-8, 8)
										Smiler.Position = origin + UDim2.new(0, math.random(-40, 40), 0, math.random(-40, 40))
										task.wait(0)
									end
								end)

								local TweenService = game:GetService("TweenService")
								local rng = Random.new() 
								local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

								wait(0.97)
								screenGui:Destroy()		
								cue2:Destroy()
								hum.Health = 0
							end
						end
					end
				end
			end)
		end

		-- Hiệu ứng sương mù khi xuất hiện
		local function eventfog()
			local t1 = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			TweenService:Create(Lighting, t1, {FogEnd = 150, FogStart = 0, FogColor = Color3.new(1, 1, 1)}):Play()

			task.wait(15)
			if isCrucified then return end

			Lighting.FogEnd = 50
			task.wait(1)

			Lighting.FogEnd = 150
			task.wait(1)

			Lighting.FogEnd = 50
			task.wait(1)
		end

		local function initEntity()
			local objects = game:GetObjects("rbxassetid://12802386940")
			if not objects or #objects == 0 then return end

			entityModel = objects[1]
			entityModel.Name = cofingae.Name
			entityModel.Parent = Workspace

			for _, part in ipairs(entityModel:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
					part.Massless = true
				end
			end

			-- Spawn phía trước 60 stud so với vị trí RoomStart
			local entranceCFrame = Lol()
			local hiddenSpawnCFrame = entranceCFrame * CFrame.new(0, 2, -60)
			entityModel:PivotTo(hiddenSpawnCFrame)

			Gex(entityModel)

			task.spawn(eventfog)

			task.wait(3)

			for i = 1, 100000 do
				if isCrucified then break end
				print("Starting patrol loop count: " .. i)
				local success = Fastest()
				if not success or isCrucified then break end
			end

			print("Entity is despawning")
			if not isCrucified and entityModel then
				entityModel:Destroy()
				entityModel = nil
				resetLightingSmoothly(2)
			end
		end

		initEntity()
		latestRoom.Changed:Wait()
			resetLightingSmoothly()
			entityModel:Destroy()
			---====== Load achievement giver ======---
			local achievementGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))()

			---====== Display achievement ======---
			achievementGiver({
				Title = "few fog",
				Desc = "Don't Think That Safe",
				Reason = "Survive Fog",
				Image = "rbxassetid://"
			})
	end
end)
