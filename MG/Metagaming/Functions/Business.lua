function saveBusinessPoint(PlayerID)	
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)
	
	if Level < 5 then
		outputChatBox(PlayerID,"Your level is " .. Level .. ", you need to be at least lvl 5 to store a point",255,69,0,255)
	else
		local Pos = { getPlayerPos(PlayerID) }
		table.insert(Points[PlayerID],Pos)
		outputChatBox(Nickname .. " has stored a point for a new business",100,149,237,255)
	end
end

function createBusiness(PlayerID,Income,Price, ...)
	local Nickname = getPlayerName(PlayerID)
	local Level = GetAccountLevel(PlayerID)
	local Income = tonumber(Income)
	local Price = tonumber(Price)
	local Name = GetParams(arg)
	
	if Level < 5 then
		outputChatBox(PlayerID,"Your level is " .. Level .. ", you need to be at least lvl 4 to create a business",255,69,0,255)	
	elseif not Income then
		outputChatBox(PlayerID,"Syntax: /createbusiness <Incomes Per Hour> <Price> <Name>",255,69,0,255)
	elseif not Price then
		outputChatBox(PlayerID,"Syntax: /createbusiness <Incomes Per Hour> <Price> <Name>",255,69,0,255)
	elseif not Name then
		outputChatBox(PlayerID,"Syntax: /createbusiness <Incomes Per Hour> <Price> <Name>",255,69,0,255)
	elseif not Points[PlayerID][1] then
		outputChatBox(PlayerID,"You havent stored any point to create a business",255,69,0,255)
		outputChatBox(PlayerID,"Use /storepoint to create a new business",255,69,0,255)
	elseif isFloat(Income) or isFloat(Price) then
		outputChatBox(PlayerID,"Syntax: /createbusiness <Incomes Per Hour> <Price> <Name>",255,69,0,255)
	else
		local PlayerPoints, PointZ, MinZ, MaxZ = Points[PlayerID]
		local PointsXY = {}
		
		
		for i,v in ipairs(PlayerPoints) do
			
			PointZ = v[3]
			-- check if this point's Z, is higher than MaxZ, or less than MinZ
			
			
			if not MinZ or PointZ < MinZ then MinZ = PointZ end
			if not MaxZ or PointZ > MaxZ then MaxZ = PointZ end
			
			
			-- push this point's XY onto the PointsXY table
			
			table.insert(PointsXY, v[1])
			table.insert(PointsXY, v[2])
			
			
			MinZ = MinZ  - 10
			MaxZ = MaxZ + 10
			Points[PlayerID] = {}
			
			-- add business		
		end
		addBusiness(PointsXY, MinZ, MaxZ, Income, Price, Name)
		outputChatBox(Nickname .. " has added a new business",100,149,237,255)
	end
end

function checkBusiness(PlayerID)
	local BusinessID = getPlayerBusinessArea(PlayerID)
	if BusinessID then
		if getBusinessOwner(BusinessID) then
			local MgBussinessOwner = getBusinessOwner(BusinessID)
			local MgBusinessPrice = getBusinessPrice(BusinessID)
			local BusinessName = getBusinessName(BusinessID)
			local BusinessIncomes = getBusinessIncomes(BusinessID)
			
			outputChatBox(PlayerID,"Business: " .. BusinessName .. " | Incomes: $" .. BusinessIncomes .. " p/h | Owned by: " .. MgBussinessOwner,255,127,80,255)
		elseif not getBusinessOwner(BusinessID) then			
			local MgBusinessPrice = getBusinessPrice(BusinessID)
			local BusinessName = getBusinessName(BusinessID)
			local BusinessIncomes = getBusinessIncomes(BusinessID)
			
			outputChatBox(PlayerID,"Business: " .. BusinessName .. " | Incomes: $" .. BusinessIncomes .. "  p/h | Not Owned | Price: $" .. MgBusinessPrice,255,127,80,255)
		end
	else
		outputChatBox(PlayerID,"You are not standing on any Business",255,69,0,255)
	end		
end

function BuyBusiness(PlayerID)
	local BusinessID = getPlayerBusinessArea(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local Cash = mgGetPlayerCash(PlayerID)
	
	if not BusinessID then
		outputChatBox(PlayerID,"You are not at any business",255,69,0,255)
	elseif isBusinessOwned(BusinessID) then		
		if getBusinessOwner(BusinessID) ~= Nickname then
			outputChatBox(PlayerID,"This business is owned by " .. getBusinessOwner(BusinessID),255,69,0,255)
		end
	elseif Cash < getBusinessPrice(BusinessID) then
		outputChatBox(PlayerID,"You dont have enough money to buy this business",255,69,0,255)
	elseif vinTable(BusinessOwner,Nickname) then
		outputChatBox(PlayerID,"You already own a business",255,69,0,255)
	else
		local BusinessName = getBusinessName(BusinessID)		
		local MgBusinessPrice = getBusinessPrice(BusinessID)
		
		mgTakeCash(PlayerID,MgBusinessPrice)
		BusinessOwner[BusinessID] = Nickname
        BusinessTime[BusinessID] = os.time()
		vwrite("Business/Owner.txt",BusinessID,Nickname)
        vwrite("Business/Time.txt",BusinessID,os.time())
		outputChatBox(PlayerID,"You bought Business: " .. BusinessName .. " | for $" .. MgBusinessPrice,255,127,80,255)
		outputChatBox(PlayerID,"For more help of businesses type /help business",255,127,80,255)
		PlayerBusinessTime[PlayerID] = 0
	end
end

function SellBusiness(PlayerID)
	local BusinessID = getPlayerBusinessArea(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local Cash = mgGetPlayerCash(PlayerID)
	
	if not BusinessID then
		outputChatBox(PlayerID,"You are not at any business",255,69,0,255)
	elseif not isBusinessOwned(BusinessID) then
		outputChatBox(PlayerID,"This business is not owned",255,69,0,255)		
	elseif getBusinessOwner(BusinessID) ~= Nickname then		
		outputChatBox(PlayerID,"This business is owned by " .. getBusinessOwner(BusinessID),255,69,0,255)
	else
		local BusinessName = getBusinessName(BusinessID)		
		local MgBusinessPrice = getBusinessPrice(BusinessID)
		
		mgAddCash(PlayerID,round(MgBusinessPrice * 0.4))
		PlayerBusinessTime[PlayerID] = nil
		BusinessOwner[BusinessID] = nil
        BusinessTime[BusinessID] = nil
		vremove("Business/Owner.txt",BusinessID)
		outputChatBox(PlayerID,"You sold Business: " .. BusinessName .. " | for $" .. round(MgBusinessPrice * 0.4),255,127,80,255)		
		vremove("Business/Active.txt", Nickname)
        vremove("Business/Time.txt",BusinessID)       
	end
end

function CheckoutBusiness(PlayerID)
	local BusinessID = getPlayerBusinessArea(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	
	if not BusinessID then
		outputChatBox(PlayerID,"You are not at any business",255,69,0,255)
	elseif not isBusinessOwned(BusinessID) then
		outputChatBox(PlayerID,"This business is not owned",255,69,0,255)		
	elseif getBusinessOwner(BusinessID) ~= Nickname then		
		outputChatBox(PlayerID,"This business is owned by " .. getBusinessOwner(BusinessID),255,69,0,255)
	else
		local BusinessIncomes = getBusinessIncomes(BusinessID)		
		local Amount = math.floor(getPlayerBusinessTime(PlayerID) * (BusinessIncomes / 3600))
		if Amount < 5 then
			outputChatBox(PlayerID,"You should wait untill your business reaches a minimum of $5 to checkout incomes",255,69,0,255)
			local BusinessIncomes = getBusinessIncomes(BusinessID)
			local BusinessIncomePerSec = BusinessIncomes / 3600
			local PlayerBusinessTimeLeft = (5 - (getPlayerBusinessTime(PlayerID) * BusinessIncomePerSec)) / BusinessIncomePerSec
			local PlayerBusinessTimeLeftString = vgetTimeString(PlayerBusinessTimeLeft)
			outputChatBox(PlayerID,PlayerBusinessTimeLeftString .. " left",255,69,0,255)
		else
			outputChatBox(PlayerID,"You have earned $" .. Amount .. " from your business's earnings",255,127,80,255)
			mgAddCash(PlayerID,Amount)
			resetPlayerBusinessTime(PlayerID)
		end
	end
end



function MyBusiness(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	
	if vinTable(BusinessOwner,Nickname) then
		local BusinessID = getTableKey(BusinessOwner,Nickname)
		local BusinessName = getBusinessName(BusinessID)
		local BusinessIncomes = getBusinessIncomes(BusinessID)
		local Amount = math.floor(getPlayerBusinessTime(PlayerID) * (BusinessIncomes / 3600))
		
		outputChatBox(PlayerID,"You own business: " .. BusinessName .. " | Incomes: $" .. BusinessIncomes .. " p/h",255,127,80,255)
		outputChatBox(PlayerID,"You can checkout $" .. Amount .. " from your business",255,127,80,255)
	else
		outputChatBox(PlayerID,"You dont own any business",255,69,0,255)
	end
end

--[[ Print Loading results ]]
outputConsole("		Business Functions Loaded")