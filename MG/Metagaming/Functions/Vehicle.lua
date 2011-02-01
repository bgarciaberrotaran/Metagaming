function BuyCar(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local Cash = mgGetPlayerCash(PlayerID)
	local Area = getPlayerArea(PlayerID)
	local VehicleID = getPlayerVehicleID(PlayerID)
	local VehicleModel = getVehicleModel(VehicleID)
	local VehicleName = getVehicleNameFromModelID(VehicleModel)
	local VehicleOwner = getVehicleOwner(VehicleID)
	local VehiclePrice = getVehiclePrice(VehicleModel)
	local WordPrefix = vgetWordPrefix(VehicleName)
	
	
	if Area ~= SunshineAutos then
		outputChatBox(PlayerID,"You need to be in Sunshine Autos to buy a vehicle",255,69,0,255)
	elseif not isPlayerInAnyVehicle(PlayerID) then
		outputChatBox(PlayerID,"You need to be in a vehicle to buy it",255,69,0,255)
	elseif vinTable(Vehicle,Nickname) then
		outputChatBox(PlayerID,"You already own a vehicle, you cant own more than one",255,69,0,255)
	elseif Vehicle[VehicleID] then
		outputChatBox(PlayerID,"This vehicle is already owned by " .. Vehicle[VehicleID],255,69,0,255)
	elseif tonumber(VehiclePrice) > Cash then
		outputChatBox(PlayerID,"You dont have enough cash to buy " .. WordPrefix .. " " .. VehicleName,255,69,0,255)
	else
		outputChatBox(PlayerID,"Congratulations! You bought " .. WordPrefix .. " " .. VehicleName .. " for $" .. VehiclePrice,0,178,238,255)
		outputChatBox(PlayerID,"Use /help vehicle to learn more about vehicles",0,178,238,255)
		vwrite("Vehicle/Owner.txt",VehicleID,Nickname)
		Vehicle[VehicleID] = Nickname
		mgTakeCash(PlayerID,VehiclePrice)
	end
end

function SellCar(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	local Cash = mgGetPlayerCash(PlayerID)
	local Area = getPlayerArea(PlayerID)
	local VehicleID = getPlayerVehicleID(PlayerID)
	local VehicleModel = getVehicleModel(VehicleID)
	local VehicleName = getVehicleNameFromModelID(VehicleModel)
	local VehicleOwner = getVehicleOwner(VehicleID)
	local VehiclePrice = getVehiclePrice(VehicleModel)
	local WordPrefix = vgetWordPrefix(VehicleName)
	
	if Area ~= SunshineAutos then
		outputChatBox(PlayerID,"You need to be in Sunshine Autos to sell a vehicle",255,69,0,255)
	elseif not isPlayerInAnyVehicle(PlayerID) then
		outputChatBox(PlayerID,"You need to be in a vehicle to sell it",255,69,0,255)
	elseif VehicleOwner == nil then
		outputChatBox(PlayerID,"You dont own this vehicle, you cant sell one that you dont own",255,69,0,255)
	elseif VehicleOwner ~= Nickname then
		outputChatBox(PlayerID,"This vehicle is already owned by " .. VehicleOwner,255,69,0,255)
	else
		outputChatBox(PlayerID,"Congratulations! You sold your " .. VehicleName .. " for $" .. round(VehiclePrice * 0.3) ,0,178,238,255)
		vremove("Vehicle/Owner.txt",VehicleID)
		mgAddCash(PlayerID,round(VehiclePrice*0.3))
		Vehicle[VehicleID] = nil
	end
end

function MyCar(PlayerID)	
	if vinTable(Vehicle,Nickname) then		
		local Nickname = getPlayerName(PlayerID)
		local VehicleID = getTableKey(Vehicle, Nickname)
		local VehicleModel = getVehicleModel(VehicleID)
		local VehicleName = getVehicleNameFromModelID(VehicleModel)
		local WordPrefix = vgetWordPrefix(VehicleName)
		local VehiclePrice = getVehiclePrice(VehicleModel)
		
		outputChatBox(PlayerID,"| Your Vehicle |",085,221,0,255)
		outputChatBox(PlayerID,"[ID: " .. VehicleID .. "] " .. VehicleName .. ". Price: $" .. VehiclePrice,085,221,0,255)
	else
		outputChatBox(PlayerID,"You dont own any vehicle",085,221,0,255)
	end
end

function PrintCarDriving(PlayerID)
	if isPlayerInAnyVehicle(PlayerID) == 0 then
		outputChatBox(PlayerID,"You are not driving any vehicle",255,69,0,255)
	else
		local VehicleID = getPlayerVehicleID(PlayerID)
		local VehicleModel = getVehicleModel(VehicleID)
		local VehicleName = getVehicleNameFromModelID(VehicleModel)
		local WordPrefix = vgetWordPrefix(VehicleName)
		local SeatID = getPlayerSeatID(PlayerID)
		if SeatID == 0 then
			if Vehicle[VehicleID] then
				outputChatBox(PlayerID,"You are driving " .. WordPrefix .. " " .. VehicleName .. " (ID " .. VehicleID .. ") owned by " .. Vehicle[VehicleID] .. " as the driver ",085,221,0,255)
			else
				outputChatBox(PlayerID,"You are driving " .. WordPrefix .. " " .. VehicleName .. " (ID " .. VehicleID .. ") as the driver",085,221,0,255)
			end
		elseif SeatID > 0 then
			if Vehicle[VehicleID] then
				outputChatBox(PlayerID,"You are on " .. WordPrefix .. " " .. VehicleName .. " (ID " .. VehicleID .. ") owned by " .. Vehicle[VehicleID] .. " as a passanger",085,221,0,255)
			else
				outputChatBox(PlayerID,"You are on " .. WordPrefix .. " " .. VehicleName .. " (ID " .. VehicleID .. ") as a passanger",085,221,0,255)
			end
		end		
	end
end

--[[ Print Loading results ]]
outputConsole("		Vehicle Functions Loaded")