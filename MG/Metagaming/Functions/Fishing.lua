function BuyFishingRod(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local Cash = mgGetPlayerCash(PlayerID)
	local Area = getPlayerArea(PlayerID)
	local RodID = getItemID('fishing rod')
	local Rod = InventoryGetItem(PlayerID, RodID)	
	
	
	if Area ~= Boat then
		outputChatBox(PlayerID,"You need to be in the boat at the docks to buy a fishing rod",255,69,0,255)
	elseif Cash < 10 then
		outputChatBox(PlayerID,"You need at least $10 to buy a fishing rod",255,69,0,255)
	elseif Rod == 1 then
		outputChatBox(PlayerID,"You already have a Fishing Rod in your inventory",255,69,0,255)
	else
		outputChatBox(PlayerID,"You bought a fishing rod, it costed you $10 and it has been stored in your inventory",50,200,80,255)
		InventoryAddItem(PlayerID,9)
		mgTakeCash(PlayerID,10)
	end
end

function BuyBait(PlayerID,Amount)
	local Amount = tonumber(Amount)
	local Cash = mgGetPlayerCash(PlayerID)
	local Area = getPlayerArea(PlayerID)
	local BaitID = getItemID('bait')
	local Bait = InventoryGetItem(PlayerID, BaitID)
	
	if Area ~= Boat then
		outputChatBox(PlayerID,"You need to be in the boat at the docks to buy bait",255,69,0,255)
	elseif Cash < 5 then
		outputChatBox(PlayerID,"You need at least $5 to buy bait",255,69,0,255)
	elseif not Amount then
		outputChatBox(PlayerID,"Syntax: /buybait <Amount>",255,69,0,255)
	elseif Bait + Amount > 15 then
		outputChatBox(PlayerID,"You cant buy that much, try a smaller number",255,69,0,255)
	elseif Bait >= 15 then
		outputChatBox(PlayerID,"Your slot for bait is currently full",255,69,0,255)
	elseif Amount <= 0 then
		outputChatBox(PlayerID,"You cant buy that much, try a bigger number",255,69,0,255)
	elseif Amount > 15 then
		outputChatBox(PlayerID,"You cant buy more than 15 baits",255,69,0,255)
	elseif Amount * 5 > Cash then
		outputChatBox(PlayerID,"You dont have enough cash to buy bait",255,69,0,255)
	else
		outputChatBox(PlayerID,"You bought " .. Amount .. " bait, it costed you $" .. Amount * 5 .. " and it has been stored in your inventory",50,200,80,255)
		InventoryAddMore(PlayerID,10,Amount)
		mgTakeCash(PlayerID,Amount * 5)
	end
end

function FishingLine(PlayerID,Option)
	local BaitID = getItemID('bait')
	local Bait = InventoryGetItem(PlayerID, BaitID)
	local RodID = getItemID('fishing rod')
	local Rod = InventoryGetItem(PlayerID, RodID)
	local Area = getPlayerArea(PlayerID)	
	
	if Option == "bait" then
		if Area ~= FishingDocks then
			outputChatBox(PlayerID,"You need to be at the fishing dock to bait your line",255,69,0,255)
		elseif Rod ~= 1 then		
			outputChatBox(PlayerID,"You need to buy a fishing rod before you can bait your line",255,69,0,255)
			outputChatBox(PlayerID,"You can buy a fishing rod for $10 in the boat at the docks",255,69,0,255)
		elseif Bait < 1 then
			outputChatBox(PlayerID,"You dont have enough bait to bait your line",255,69,0,255)
			outputChatBox(PlayerID,"You can buy bait for $5 each in the boat at the docks",255,69,0,255)
		elseif Fishing[PlayerID].baited == 1 then
			outputChatBox(PlayerID,"Your line is already baited, use /line throw to throw your line",255,69,0,255)	
		else
			outputChatBox(PlayerID,"You have baited your line. You can use /line throw to throw your line",50,200,80,255)
			Fishing[PlayerID].baited = 1
			TakeOneFoodFromInventory(PlayerID,10)
		end	
	elseif Option == "throw" then
		if Area ~= FishingDocks then
			outputChatBox(PlayerID,"You need to be at the fishing dock to throw your line",255,69,0,255)
		elseif Rod ~= 1 then		
			outputChatBox(PlayerID,"You need to buy a fishing rod before you can throw your line",255,69,0,255)
			outputChatBox(PlayerID,"You can buy a fishing rod for $10 in the boat at the docks",255,69,0,255)
		elseif Fishing[PlayerID].baited == 0 then
			outputChatBox(PlayerID,"You need to bait your line before you throw it",255,69,0,255)
		else
			outputChatBox(PlayerID,"You have thrown your line,wait a few seconds and use /line check to check if got a bite",50,200,80,255)
			vtimer("BiteLine",1,math.random(10000,20000),"BiteLine",PlayerID)
			Fishing[PlayerID].throw = 1
		end
	elseif Option == "check" then
		if Area ~= FishingDocks then
			outputChatBox(PlayerID,"You need to be at the fishing dock to check your line",255,69,0,255)
		elseif Rod ~= 1 then		
			outputChatBox(PlayerID,"You need to buy a fishing rod before you can check your line",255,69,0,255)
			outputChatBox(PlayerID,"You can buy a fishing rod for $10 in the boat at the docks",255,69,0,255)
		elseif Fishing[PlayerID].baited == 0 then
			outputChatBox(PlayerID,"You need to bait your line before you check it",255,69,0,255)
		elseif Fishing[PlayerID].throw == 0 then
			outputChatBox(PlayerID,"You need to throw your line before you check it",255,69,0,255)
		elseif Fishing[PlayerID].bited == 0 then
			outputChatBox(PlayerID,"Your bait is still on the line, you dont have a bite yet",255,69,0,255)
		elseif Fishing[PlayerID].bited == 1 or Fishing[PlayerID].bited == 2 then
			local a = math.random(11,19)
			local Fishname = getItemName(a)
			local FishID = getItemID(Fishname)
			local Fish = InventoryGetItem(PlayerID, FishID)
			if Fish >= 15 then
				outputChatBox(PlayerID,"You cought a " .. Fishname .. "! but your inventory is full, sell some fish to empty it",50,200,80,255)
			else
				outputChatBox(PlayerID,"You cought a " .. Fishname .. "! It has been stored in your inventory",50,200,80,255)
				InventoryAddItem(PlayerID,a)
				Fishing[PlayerID].throw = 0
				Fishing[PlayerID].baited = 0
				Fishing[PlayerID].bited = 0
			end
		else
			outputChatBox(PlayerID,"A fish has eaten your bait and got away, try again!",50,200,80,255)
		end
	else
		outputChatBox(PlayerID,"Syntax: /line <bait,throw,check>",255,69,0,255)
	end
end

function BiteLine(PlayerID)	
	local a = math.random(1,9)
	if a == 1 or a == 2 then
		Fishing[PlayerID].bited = 1
	else
		Fishing[PlayerID].bited = 2
	end
end


function SellFish(PlayerID,Amount,Fishname)	
	local FishID = getItemID(Fishname)
	local Fish = InventoryGetItem(PlayerID, FishID)
	local Amount = tonumber(Amount)
	local Area = getPlayerArea(PlayerID)
	
	if Area ~= Boat then
		outputChatBox(PlayerID,"You have to inside the Boat at the Docks to sell fish",255,69,0,255)
	elseif not Amount then
		outputChatBox(PlayerID,"Syntax: /sellfish <Amount> <Fish Name>",255,69,0,255)
	elseif not Fishname then
		outputChatBox(PlayerID,"Syntax: /sellfish <Amount> <Fish Name>",255,69,0,255)
	elseif Fish == 0 or Fish == nil or FishID == nil then
		outputChatBox(PlayerID,"You dont have that fish to sell or it doesnt exist",255,69,0,255)	
	elseif Fish < 0 then
		outputChatBox(PlayerID,"You cant sell that amount of fish, it has to be over 0",255,69,0,255)
	elseif vinTable(FishesNames,Fishname) then
		if Amount > Fish or Amount <= 0 then
			outputChatBox(PlayerID,"You dont have that much " .. Fishname .. " to sell",255,69,0,255)
		elseif isFloat(Amount) then
			outputChatBox(PlayerID,"You cant sell that amount of fish, it has to be rounded",255,69,0,255)
		else
			local FishPrice = GetItemPrice(FishID)
			outputChatBox(PlayerID,"You have sold " .. Amount .. " " .. Fishname .. " for $" .. (Amount * FishPrice),50,200,80,255)
			mgAddCash(PlayerID,Amount * FishPrice)
			InventoryMoreRemoveItem(PlayerID,FishID,Amount)
		end
	else
		outputChatBox(PlayerID,"You cant sell that item in your inventory",255,69,0,255)
	end
end

--[[ Print Loading results ]]
outputConsole("		Fishing Functions Loaded")