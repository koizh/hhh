local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tomatotxt/code/refs/heads/main/kavomobile.luau"))()
task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/koizh/hhh/refs/heads/main/loadthing.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/koizh/hhh/refs/heads/main/fjf.lua"))()
end)
local Window = Library.CreateLib("WinIt x1000", "Ocean")
local Tab = Window:NewTab("Auto")
local Section = Tab:NewSection("Main")
Section:NewToggle("Auto-Farm", "Wins for your noob self!", function(state)
    getgenv().TomatoAutoFarm = state
end)
Section:NewToggle("Auto Voting", "Vote automatically for maps", function(state)
    getgenv().AutoVote = state
end)
Section:NewToggle("Auto Challenges", "Auto-complete daily challenges", function(state)
    getgenv().AutoChallengesEnabled = state
end)
