local Player = game.Players.LocalPlayer
local CL_MAIN_GameScript = Player.PlayerScripts:WaitForChild("CL_MAIN_GameScript")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFolder = ReplicatedStorage.Remote
local DataRemote = CL_MAIN_GameScript.GetPlayerData
--local AutoChallengesEnabled = true
getgenv().AutoChallengesEnabled = false
local WinStreak = 0
local NoProgressStreak = 0
local CurrentMap

local CurrentChallengeData = {
	standard = {},
	master = {}
}
local ChallengeData = {
	{
		Name = "Press # Normal Buttons",
		ID = 1,
		CanBeMaster = true,
		AmountRequired = 0 -- set to value when script is being made
	},
	{
		Name = "Press # Group Buttons",
		ID = 2,
		CanBeMaster = true,
		AmountRequired = 0 -- set to value when script is being made
	},
	{
		Name = "Escape # Insane+ Map",
		ID = 4,
		CanBeMaster = false,
		AmountRequired = 1
	},
	{
		Name = "Escape # Maps In A Row",
		ID = 5,
		CanBeMaster = true,
		AmountRequired = 0 -- set to value when script is being made
	},
	{
		Name = "Perform # Rescue",
		ID = 6,
		CanBeMaster = false,
		AmountRequired = 1
	},
	{
		Name = "Find # Lost Page(s)",
		ID = 7,
		CanBeMaster = true,
		AmountRequired = 1 -- 2 when its master
	},
	{
		Name = "Survive # 'Chaotic Buttons' Event(s)",
		ID = 8,
		CanBeMaster = true,
		AmountRequired = 1 -- 2 when its master
	},
	{
		Name = "Perform # Rescue On An Insane+ Map",
		ID = 9,
		CanBeMaster = true,
		AmountRequired = 1
	},
	{
		Name = "Escape # Maps",
		ID = 10,
		CanBeMaster = false,
		AmountRequired = 0 -- set to value when script is being made
	},
	{
		Name = "Ride # Ziplines",
		ID = 13,
		CanBeMaster = true,
		AmountRequired = 0 -- set to value when script is being made
	},
	{
		Name = "Escape 1st Starting With 6+ Players",
		ID = 14,
		CanBeMaster = true,
		AmountRequired = 1 -- 2 when its master
	},
	{
		Name = "Boost The Game Intensity",
		ID = 15,
		CanBeMaster = false,
		AmountRequired = 1
	},
	{
		Name = "Earn #XP",
		ID = 16,
		CanBeMaster = true,
		AmountRequired = 1000 -- 3000 when its master
	},
	{
		Name = "Play With A Friend",
		ID = 17,
		CanBeMaster = false,
		AmountRequired = 1
	},
	{
		Name = "Play For # Minutes",
		ID = 18,
		CanBeMaster = true,
		AmountRequired = 0 -- set to value when script is being made
	},
	{
		Name = "Vote Multiple Times For 1 Map",
		ID = 19,
		CanBeMaster = false,
		AmountRequired = 1
	},
	{
		Name = "Press All Buttons & Escape Starting With 4+ Players",
		ID = 20,
		CanBeMaster = true,
		AmountRequired = 1
	},
	{
		Name = "Get # Air Bubbles",
		ID = 21,
		CanBeMaster = true,
		AmountRequired = 2 -- 4 when its master
	},
	{
		Name = "Escape # Map(s) Without Pressing Any Buttons",
		ID = 23,
		CanBeMaster = true,
		AmountRequired = 1 -- 2 when its master
	},
	{
		Name = "Escape # Map(s) In Under 60 Seconds",
		ID = 24,
		CanBeMaster = false,
		AmountRequired = 0 -- set to value when script is being made
	},
	{
		Name = "Complete # Standard Challenges",
		ID = 25,
		CanBeMaster = false,
		AmountRequired = 2
	},
	{
		Name = "Walljump From # Walls",
		ID = 26,
		CanBeMaster = true,
		AmountRequired = 0 -- set to value when script is being made
	},
	{
		Name = "Slide Under # Barriers",
		ID = 27,
		CanBeMaster = true,
		AmountRequired = 0 -- set to value when script is being made
	},
	{
		Name = "Regenerate # Air",
		ID = 28,
		CanBeMaster = true,
		AmountRequired = 500 -- 1500 when its master
	},
	{
		Name = "Survive # 'Mirrored Map' Event(s)",
		ID = 29,
		CanBeMaster = true,
		AmountRequired = 1 -- 2 when its master
	},
	{
		Name = "Press # Exploding Buttons",
		ID = 31,
		CanBeMaster = true,
		AmountRequired = 2 -- 4 when its master
	},
	{
		Name = "Survive # 'Thick Fog' Event(s)",
		ID = 32,
		CanBeMaster = true,
		AmountRequired = 1 -- 2 when its master
	},
	{
		Name = "Escape # Highlighted Map(s)",
		ID = 33,
		CanBeMaster = true,
		AmountRequired = 1 -- 2 when its master
	},
	{
		Name = "Survive # 'Speed Up' Event(s)",
		ID = 35,
		CanBeMaster = true,
		AmountRequired = 1 -- 2 when its master
	},
	{
		Name = "Survive # 'Slow Down' Event(s)",
		ID = 36,
		CanBeMaster = true,
		AmountRequired = 1 -- 2 when its master
	},
	{
		Name = "Survive # 'Tectonic Shift' Event(s)",
		ID = 37,
		CanBeMaster = true,
		AmountRequired = 1 -- 2 when its master
	},
	{
		Name = "Survive # 'Iced Up' Event(s)",
		ID = 38,
		CanBeMaster = false,
		AmountRequired = 1
	},
}

function CreateCurrentChallengeData()
	local CurrData = DataRemote:Invoke().dailyChallenges
	for _, CurrChallenge in pairs(CurrData.standard) do
		for _, Challenge in pairs(ChallengeData) do
			if CurrChallenge.ID == Challenge.ID and CurrChallenge.amtCurrent ~= Challenge.amtRequired then -- checks if same id and if its not completed
				table.insert(CurrentChallengeData.standard, {
					ID = CurrChallenge.ID,
					AmountCurrent = CurrChallenge.amtCurrent,
					AmountRequired = CurrChallenge.amtRequired
				})
			end
		end
	end
	for _, CurrChallenge in pairs(CurrData.master) do
		for _, Challenge in pairs(ChallengeData) do
			if CurrChallenge.ID == Challenge.ID and CurrChallenge.amtCurrent ~= Challenge.amtRequired then -- checks if same id and if its not completed
				table.insert(CurrentChallengeData.master, {
					ID = CurrChallenge.ID,
					AmountCurrent = CurrChallenge.amtCurrent,
					AmountRequired = CurrChallenge.amtRequired
				})
			end
		end
	end
end

function RemoveCompletedChallenges()
	if #CurrentChallengeData.standard ~= 0 then
		for ChallengeIndex = 1, #CurrentChallengeData.standard do
			if CurrentChallengeData.standard[ChallengeIndex].AmountCurrent >= CurrentChallengeData.standard[ChallengeIndex].AmountRequired then
				table.remove(CurrentChallengeData.standard, ChallengeIndex)
			end
		end
	end
	if #CurrentChallengeData.master ~= 0 then
		for ChallengeIndex = 1, #CurrentChallengeData.master do
			if CurrentChallengeData.master[ChallengeIndex].AmountCurrent >= CurrentChallengeData.master[ChallengeIndex].AmountRequired then
				table.remove(CurrentChallengeData.master, ChallengeIndex)
			end
		end
	end
end

RemoteFolder.Alert.OnClientEvent:Connect(function(Text : string)
	if string.find(Text, "Escaped") then
		WinStreak += 1
	end
end)

RemoteFolder.StartClientMapTimer.OnClientEvent:Connect(function()
	local AmountProgressed = 0
	CurrentMap = game.Workspace.Multiplayer:FindFirstChild("Map") -- important instances names are not encoded dw
	if not CurrentMap then
		CL_MAIN_GameScript.Notify:Fire("Couldn't update map variable!", "Fatal Error")
		return
	end
	if getgenv().AutoChallengesEnabled == true then
		local MapDifficulty = math.floor(CurrentMap.Settings:GetAttribute("Difficulty"))
		for _, ChallengeInfo in pairs(CurrentChallengeData.standard) do
			local ID = ChallengeInfo.ID
			if ID == 13 then -- ride ziplines (1 per map)
				for _, Inst in pairs(CurrentMap:GetDescendants()) do
					if Inst.Name == "RopeStart" then
						task.wait(0.02)
						Player.Character.HumanoidRootPart.CFrame = Inst.CFrame -- only way to get this one to work is by teleporting player to zipline, cant fake pos like sliding one :(
						AmountProgressed += 1
						break
					end
				end
			end
			if ID == 15 then -- boost the game intensity
				RemoteFolder.BoostIntensity:FireServer()
			end
			if ID == 19 then -- vote multiple times for 1 map
				local VotePublicID = ReplicatedStorage:FindFirstChild("AutoVotePublicID")
				if VotePublicID then
					task.delay(0.1, function() -- delay just in case
						CL_MAIN_GameScript.DoMapVote:Fire(VotePublicID.Value, 10) -- i think 10 because first vote is free and second one costs 10 coins
						AmountProgressed += 1
					end)
				end
			end
			if ID == 21 then -- get airbubbles (1 per map if has it)
				for _, Inst in pairs(CurrentMap:GetDescendants()) do
					if Inst.Name == "AirTank" then
						task.wait(0.03)
						Player.Character.HumanoidRootPart.CFrame = Inst.Hitbox.CFrame
						AmountProgressed += 1
						break
					end
				end
			end
			if ID == 26 then -- walljumps (1 per map if has it)
				for _, Inst in pairs(CurrentMap:GetDescendants()) do
					if Inst:FindFirstChild("_Wall") then
						RemoteFolder.Challenges.Walljumped:FireServer(Inst)
						AmountProgressed += 1
						break
					end
				end
			end
			if ID == 27 then -- slide under barriers (1 per map)
				for _, Inst in pairs(CurrentMap:GetDescendants()) do
					if Inst.Name == "SlideBeam" then
						local FakeRootPart = Instance.new("Part", game.Workspace)
						FakeRootPart.Name = "FakeRootPart"
						FakeRootPart.Anchored = true
						FakeRootPart.CanCollide = false
						FakeRootPart.Position = Vector3.new(Inst.Position.X, Inst.Position.Y - 1, Inst.Position.Z) -- fakes root part position so it thinks its under actual slide barrier
						RemoteFolder.Challenges.SlideCheck:FireServer(Vector3.new(Inst.Position.X, Inst.Position.Y, Inst.Position.Z + 1), Vector3.new(Inst.Position.X, Inst.Position.Y, Inst.Position.Z - 1)) -- first before slide, later is after slide
						task.delay(1, function()
							FakeRootPart:Destroy()
						end)
						AmountProgressed += 1
						break
					end
				end
			end
			if ID == 28 then
				RemoteFolder.Challenges.RegeneratedAir:FireServer(tonumber(ChallengeInfo.AmountRequired)) -- tonumber just in case it breaks somehow
				AmountProgressed += 1
			end
		end
		if #CurrentChallengeData.standard == 0 then -- if standard challenges are completed, master challenges go here
			for _, ChallengeInfo in pairs(CurrentChallengeData.master) do
				local ID = ChallengeInfo.ID
				if ID == 13 then -- ride ziplines (1 per map)
					for _, Inst in pairs(CurrentMap:GetDescendants()) do
						if Inst.Name == "RopeStart" then
							task.wait(0.02)
							Player.Character.HumanoidRootPart.CFrame = Inst.CFrame -- only way to get this one to work is by teleporting player to zipline, cant fake pos like sliding one :(
							AmountProgressed += 1
							break
						end
					end
				end
				if ID == 21 then -- get airbubbles (1 per map if has it)
					for _, Inst in pairs(CurrentMap:GetDescendants()) do
						if Inst.Name == "AirTank" then
							task.wait(0.03)
							Player.Character.HumanoidRootPart.CFrame = Inst.Hitbox.CFrame
							AmountProgressed += 1
							break
						end
					end
				end
				if ID == 26 then -- walljumps (1 per map if has it)
					for _, Inst in pairs(CurrentMap:GetDescendants()) do
						if Inst:FindFirstChild("_Wall") then
							RemoteFolder.Challenges.Walljumped:FireServer(Inst)
							AmountProgressed += 1
							break
						end
					end
				end
				if ID == 27 then -- slide under barriers (1 per map)
					for _, Inst in pairs(CurrentMap:GetDescendants()) do
						if Inst.Name == "SlideBeam" then
							local FakeRootPart = Instance.new("Part", game.Workspace)
							FakeRootPart.Name = "FakeRootPart"
							FakeRootPart.Anchored = true
							FakeRootPart.CanCollide = false
							FakeRootPart.Position = Vector3.new(Inst.Position.X, Inst.Position.Y - 1, Inst.Position.Z) -- fakes root part position so it thinks its under actual slide barrier
							RemoteFolder.Challenges.SlideCheck:FireServer(Vector3.new(Inst.Position.X, Inst.Position.Y, Inst.Position.Z + 1), Vector3.new(Inst.Position.X, Inst.Position.Y, Inst.Position.Z - 1)) -- first before slide, later is after slide
							task.delay(1, function()
								FakeRootPart:Destroy()
							end)
							AmountProgressed += 1
							break
						end
					end
				end
				if ID == 28 then
					RemoteFolder.Challenges.RegeneratedAir:FireServer(tonumber(ChallengeInfo.AmountRequired)) -- tonumber just in case it breaks somehow
					AmountProgressed += 1
				end
			end
		end
		RemoveCompletedChallenges()
		NoProgressStreak = AmountProgressed > 0 and 0 or NoProgressStreak + 1
		if NoProgressStreak == 10 then -- change it as you prefer, i'd recommend the amount to be 8 or above
			RemoteFolder.CycleNewChallenges:FireServer()
			NoProgressStreak = 0
		end
	end
end)

RemoteFolder.UpdPlayerData.OnClientEvent:Connect(CreateCurrentChallengeData)

CreateCurrentChallengeData()