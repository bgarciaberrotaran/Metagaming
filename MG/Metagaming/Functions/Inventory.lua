function PrintMyInventory(PlayerID, LineStart)
	LineStart = (LineStart) and tonumber(LineStart) or 1
	local Nickname = getPlayerName(PlayerID)
	local Amount, a = getPlayerItemsAmount(PlayerID), 1
	
	if Amount < 4 then
		outputChatBox(PlayerID,"You have this in your inventory:",0,206,209,255)
		for i,v in pairs(PlayerInv[PlayerID]) do
			if a >= LineStart then
				outputChatBox(PlayerID,a..") "..v .. " " .. getItemName(i) .. "(s)",0,206,209,255)
			end
			a = a + 1
		end
	else
		local ItemsEcho = {}
		for i,v in pairs(PlayerInv[PlayerID]) do
			if a >= LineStart then
				table.insert(ItemsEcho, v.." "..getItemName(i))
			end
			a = a + 1
		end
		outputChatBox(PlayerID, "Inventory) "..table.concat(ItemsEcho, " ; "), 0, 206, 209, 255)
	end
	
	outputChatBox(PlayerID,"[Optional] Use /inventory <Line number> to limit your inventory on the chat",0,206,209,255)
end

function BuyCommand(PlayerID, ...)
	local ItemName = string.lower(table.concat(arg, " "))
	local ItemID = (arg[1]) and getItemID(ItemName)
	local ItemPrice, ItemAreas, ItemMaxAmount
	if ItemID then
		ItemPrice = GetItemPrice(ItemID)
		ItemAreas = GetItemAreas(ItemID)
		ItemMaxAmount = GetItemMaxAmount(ItemID)
	end
	
	local PlayerCash = mgGetPlayerCash(PlayerID)
	local PlayerArea = getPlayerArea(PlayerID)
	local PlayerItemAmount = InventoryGetItem(PlayerID, ItemID)
	
	if not ItemName then
		outputChatBox(PlayerID,"Syntax: /buy <Food name>. Use /foodname for more information",255,69,0,255)
	elseif not ItemID then
		outputChatBox(PlayerID,"Syntax: /buy <Food name>. Use /foodname for more information",255,69,0,255)
	elseif PlayerCash < ItemPrice then
		outputChatBox(PlayerID,"You dont enough cash to buy " .. ItemName,255,69,0,255)
	elseif isPlayerSpawned(PlayerID) == 0 or not vinTable(ItemAreas, PlayerArea) then
		outputChatBox(PlayerID,"You need to be in any of the places that sell food. Use /foodarea for more information",255,69,0,255)
	elseif PlayerItemAmount == ItemMaxAmount then
		outputChatBox(PlayerID,"Your inventory is full for " .. ItemName,255,69,0,255)
	else
		outputChatBox(PlayerID,"You bought one " .. ItemName .. " for $" .. ItemPrice .. " and it has been stored in your inventory",30,144,255,255)
		outputChatBox(PlayerID,"To eat use : /eat <Food name>, for example : /eat " .. ItemName,30,144,255,255)
		InventoryAddItem(PlayerID,ItemID)
		mgTakeCash(PlayerID,ItemPrice)
	end
end

function UseFoodFromInventory(PlayerID, ...)
	local ItemNameMatch = string.lower(table.concat(arg," ") )
	local ItemID = getItemID(ItemNameMatch)
	local ItemName = (ItemID) and getItemName(ItemID) or nil
	local Amount = (ItemID) and InventoryGetItem(PlayerID, ItemID) or 0
	
	local Nickname = getPlayerName(PlayerID)
	local Health = getPlayerHealth(PlayerID)
	local Timestamp = os.time()
	local FoodTime = PlayerInfo[PlayerID].foodtime
	local EatTime = (Timestamp - FoodTime)/60
	
	if ItemNameMatch == "" then
		outputChatBox(PlayerID,"Syntax: /eat <Food name here> || Use /inventory to check your food",255,69,0,255)
	elseif not ItemID then
		outputChatBox(PlayerID,"That food doesnt exist.",255,69,0,255)
	elseif Amount == 0 then
		outputChatBox(PlayerID,"You dont have that food.",255,69,0,255)
	elseif Amount < 1 then
		outputChatBox(PlayerID,"You dont have enought " .. ItemName .. " to eat",255,69,0,255)	
	elseif EatTime > 2 then
		if Health < 100 then
			if vinTable(FoodNames,ItemNameMatch) then
				if Health + FoodHeal[ItemID] >= 100 then
					outputChatBox(PlayerID,FoodMessage[ItemID] .. ". Your health has been restored",255,185,015,255)
					TakeOneFoodFromInventory(PlayerID,ItemID)
					setPlayerHealth(PlayerID,100)
				elseif Health + FoodHeal[ItemID] < 100 then
					outputChatBox(PlayerID,FoodMessage[ItemID] .. ". You gain " .. FoodHeal[ItemID] .. " Hp",255,185,015,255)
					TakeOneFoodFromInventory(PlayerID,ItemID)
					setPlayerHealth(PlayerID,100)		
				end
			end			
		else
			outputChatBox(PlayerID,"Your health is at 100, you cant eat anything now",255,69,0,255)
		end
	else
		outputChatBox(PlayerID,"Wait some time before eating another food",255,69,0,255)
	end		
end

--[[ Print Loading results ]]
outputConsole("		Inventory Functions Loaded")