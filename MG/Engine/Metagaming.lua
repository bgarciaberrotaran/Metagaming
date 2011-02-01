--[[ - - - - - - - - - - - ]]
--[[ 	Engine functions   ]]
--[[ - - - - - - - - - - - ]]
--[[ Metagaming functions  ]]
--[[ - - - - - - - - - - - ]]

function mgAddCash(PlayerID,Amount)
	local Amount = tonumber(Amount)
	local Nickname = getPlayerName(PlayerID)
	local Add = PlayerInfo[PlayerID].cash
	local CurrentAmount = mgGetPlayerCash(PlayerID)
	local AddAmount = Add + Amount
	vwrite("Files/Account/Money.txt",Nickname,AddAmount)
	setPlayerCash(PlayerID,Amount + CurrentAmount)
	PlayerInfo[PlayerID].cash = AddAmount
end

function mgTakeCash(PlayerID,Amount)
	local Amount = tonumber(Amount)
	local Nickname = getPlayerName(PlayerID)
	local Take = PlayerInfo[PlayerID].cash
	local CurrentAmount = mgGetPlayerCash(PlayerID)
	local TakeAmount = Take - Amount
	vwrite("Files/Account/Money.txt",Nickname,TakeAmount)
	setPlayerCash(PlayerID,CurrentAmount - Amount)
	PlayerInfo[PlayerID].cash = TakeAmount
end

function mgGetPlayerID(PlayerID, Text)
    if not Text then return PlayerID end
    local b = getMaxPlayers() - 1
    local TextNumber = tonumber(Text)
    if TextNumber and TextNumber >= 0 and TextNumber <= b and not string.find(TextNumber, ".", 1, true) then
        -- Text is a number between 0 and maxplayers (could be player ID)
        if isPlayerConnected(TextNumber) == 1 then return TextNumber end
    end
    -- Text is not a number, check for exact nick match (not case sensitive)
    local c
    local d = string.lower(Text)
    local e = {}
    for a=0, b do
        if isPlayerConnected(a) == 1 then
            c = string.lower(getPlayerName(a))
            e[a] = c
            if c == d then return a end
        end
    end
    -- check for wild nick match
    for i,v in pairs(e) do
        if string.find(v, d, 1, true) then return i end
    end
    -- no match found
    return
end

function PayNSpray(PlayerID)
	local VehicleID = getPlayerVehicleID(PlayerID)	
	outputChatBox(PlayerID,"Your vehicle has been repaired",050,205,050,255)
	setVehicleSpeed(VehicleID,-10)
	togglePlayerControllable(PlayerID,1)
	repairVehicle(VehicleID)
end

function InventoryAddItem(PlayerID, ItemID)
	local NewAmount = (PlayerInv[PlayerID][ItemID] or 0) + 1
	local Nickname = getPlayerName(PlayerID)
	
	PlayerInv[PlayerID][ItemID] = NewAmount
	vwrite("Inventory/"..Nickname..".txt", ItemID, NewAmount)
end

function InventoryAddMore(PlayerID, ItemID, Amount)
	local NewAmount = (PlayerInv[PlayerID][ItemID] or 0) + Amount
	local Nickname = getPlayerName(PlayerID)
	
	PlayerInv[PlayerID][ItemID] = NewAmount
	vwrite("Inventory/"..Nickname..".txt", ItemID, NewAmount)
end

function InventoryGetItem(PlayerID, ItemID)
	return PlayerInv[PlayerID][ItemID] or 0
end

function InventoryRemoveItem(PlayerID, ItemID)
	local NewAmount = (PlayerInv[PlayerID][ItemID] or 0) - 1
	local Nickname = getPlayerName(PlayerID)
	
	if NewAmount > 0 then
		PlayerInv[PlayerID][ItemID] = NewAmount
		vwrite("Inventory/"..Nickname..".txt", ItemID, NewAmount)
	else
		PlayerInv[PlayerID][ItemID] = nil
		vremove("Inventory/"..Nickname..".txt", ItemID)
	end
end

function InventoryMoreRemoveItem(PlayerID, ItemID, Amount)
	local Amount = tonumber(Amount)
	local NewAmount = (PlayerInv[PlayerID][ItemID] or 0) - Amount
	local Nickname = getPlayerName(PlayerID)
	
	if NewAmount > 0 then
		PlayerInv[PlayerID][ItemID] = NewAmount
		vwrite("Inventory/"..Nickname..".txt", ItemID, NewAmount)
	else
		PlayerInv[PlayerID][ItemID] = nil
		vremove("Inventory/"..Nickname..".txt", ItemID)
	end
end

function getPlayerItemsAmount(PlayerID)
	local a = 0
	for i,v in pairs(PlayerInv[PlayerID]) do a = a + 1 end
	return a
end

function TakeOneFoodFromInventory(PlayerID, ItemID)
	InventoryRemoveItem(PlayerID, ItemID)
	
	local Nickname = getPlayerName(PlayerID)
	local Timestamp = os.time()
	vwrite("Files/Account/FoodTime.txt",Nickname,Timestamp)
	PlayerInfo[PlayerID].foodtime = Timestamp
end

function EndDrunkCam(PlayerID)
	togglePlayerDrunk(PlayerID,0)	
end


function mgGetPlayerCash(PlayerID)
	return PlayerInfo[PlayerID].cash or 0
end

function GetAccountLevel(PlayerID)
	return PlayerInfo[PlayerID].level or 0
end

function getItemID(ItemNameMatch)
	if not ItemNameMatch then return end
	ItemNameMatch = string.lower(ItemNameMatch)
	
	-- check for exact item name match
	for i,v in pairs(Items) do
		if string.lower(v) == ItemNameMatch then return i end
	end
	
	-- check for part item name match
	for i,v in pairs(Items) do
		if string.find(string.lower(v), ItemNameMatch, 1, true) then return i end
	end
	
	return
end

function getItemName(ItemID)	
	return Items[ItemID]
end

function GetItemPrice(ItemID)
	return ItemPrices[ItemID]
end

function GetItemAreas(ItemID)
	return ItemAreas[ItemID]
end

function GetItemMaxAmount(ItemID)
	return ItemMaxAmount[ItemID]
end

function isNicknameBlocked(Name)
	if vinTable(BlockedNames,Name) then
		return true
	else
		return false
	end
end

function NicknameBlocker(...)
	local BlockedName = GetParams(arg)
	for i,v in vfile("Files/Admin/BlockedNames.txt",i) do
		if v == BlockedName then
			return i
		end
	end
end



function merror(PlayerID,...)
	local Message = arg[1]
	local PostMessage = arg[2]
	local Level = GetAccountLevel(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	
	if Message == NotEnoughLevel then Message = "Your level is " .. Level .. ", you need to be at least lvl "
		outputChatBox(PlayerID,Message .. (arg[2] or ""),255,69,0,255)
	else
		outputChatBox(PlayerID,Message,255,69,0,255)
	end
end

--[[ Print Loading results ]]
outputConsole("		Engine Metagaming Functions Loaded")
