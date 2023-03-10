local Players = game:GetService("Players")
local Functions = {}

function Functions.ParseArguments(Player, CommandArguments, ExpectedArguments)
    local ArgumentTable = {}
    for Index, ExpectedArgument in next, ExpectedArguments do
        local Argument = CommandArguments[Index]
        if not Argument then
            if ExpectedArgument:match("?$") ~= nil then
                break
            end

            return false
        end

        ExpectedArgument = ExpectedArgument:gsub("?$", "")

        if ExpectedArgument == "players" then
            if Argument == "all" then
                table.insert(ArgumentTable, Players:GetPlayers())
                continue
            elseif Argument == "others" then
                local PlayerTable = Players:GetPlayers()
                local MyIndex = table.find(PlayerTable, Player)
                if MyIndex then
                    table.remove(PlayerTable, MyIndex)
                end

                table.insert(ArgumentTable, PlayerTable)
                continue
            elseif Argument == "me" then
                table.insert(ArgumentTable, {Player})
                continue
            end

            local PlayerTable = {}
            local PlayerNames = Argument:split(",")
            for _, PlayerName in next, PlayerNames do
                PlayerName = PlayerName:gsub("%W", ""):lower()
                for _, TPlayer in next, Players:GetPlayers() do
                    if TPlayer.Name:lower():sub(1, #PlayerName) ~= PlayerName then continue end
                    table.insert(PlayerTable, TPlayer)
                end
            end

            if #PlayerTable == 0 then
                return false
            end

            table.insert(ArgumentTable, PlayerTable)
        elseif ExpectedArgument == "string" then
            table.insert(ArgumentTable, Argument)
            continue
        elseif ExpectedArgument == "fullstring" then
            table.insert(ArgumentTable, table.concat(CommandArguments, " ", Index))
            break
        elseif ExpectedArgument == "boolean" then
            table.insert(ArgumentTable, Argument == "true" or Argument == "on" or Argument == "yes")
            continue
        elseif ExpectedArgument == "number" then
            local Number = tonumber(Argument)
            if not Number then
                return false
            end

            table.insert(ArgumentTable, Number)
            continue
        end
    end

    return true, ArgumentTable
end

function Functions.MatchStringFromStart(String, Matched)
    if String:lower():sub(1, #Matched) == Matched:lower() then
        return (" "):rep(#Matched) .. String:sub(#Matched + 1)
    end
end

function Functions.IsCharacter(Inst)
    local Humanoid = Inst:FindFirstChildOfClass("Humanoid")
    local HumanoidRootPart = Inst:FindFirstChild("HumanoidRootPart")
    return Humanoid ~= nil and HumanoidRootPart ~= nil
end

function Functions.ToggleCharCollisions(Character, CanCollide)
    for _, Inst in next, Character:GetDescendants() do
        if not Inst:IsA("BasePart") then continue end
        Inst.CanCollide = CanCollide
    end
end

return Functions