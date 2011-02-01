--[[ - - - - - - - - - - - ]]
--[[ 	Engine functions   ]]
--[[ - - - - - - - - - - - ]]
--[[  Business functions   ]]
--[[ - - - - - - - - - - - ]]

function isPointInPolygon(X, Y, ...)
	-- bool = isPointInPolygon(PointX,PointY, X1,Y1, X2,Y2, X3,Y3, [X4,Y4], [...])
	-- http://alienryderflex.com/polygon/
	for i=1, 2 do table.insert(arg, arg[i]) end
	local Points, PointsX, PointsY = #arg/2, {}, {}
	for i=1, Points do
		PointsX[i] = arg[((i-1)*2)+1]
		PointsY[i] = arg[i*2]
	end
	local Corners, OddNodes = Points-1, false
	j = Corners
	for i=1, Corners do
		if (PointsY[i] < Y and PointsY[j] >= Y) or (PointsY[j] < Y and PointsY[i] >= Y) then
			if PointsX[i] + (Y - PointsY[i]) / (PointsY[j] - PointsY[i]) * (PointsX[j] - PointsX[i]) < X then
				OddNodes = not OddNodes
			end
		end
		j = i
	end
	return OddNodes
end

function isPlayerInPolygon(PlayerID, ...)
	-- bool = isPlayerInPolygon(PlayerID, X1,Y1, [X2,Y2], [...], Z1,Z2)
	local X, Y, Z = getPlayerPos(PlayerID)
	local Args = #arg
	local MinZ, MaxZ = arg[Args-1], arg[Args]
	return (Z >= MinZ and Z <= MaxZ and isPointInPolygon(X, Y, unpack(arg, 1, Args-2))) and true or false
end

function addBusiness(Pos, MinZ, MaxZ, Income, Price, ...)
	local BusinessID = #Business + 1
	local Income = tonumber(Income)
	local Price = tonumber(Price)
	local Name = GetParams(arg)
	Business[BusinessID] = Income
	BusinessPositions[BusinessID] = { Pos, MinZ, MaxZ }
	BusinessPrice[BusinessID] = Price
	BusinessName[BusinessID] = Name
	vwrite("Business/Incomes.txt",BusinessID,Income)
	vwrite("Business/Position.txt",BusinessID,table.concat(Pos,",") .. "," .. MinZ .. "," .. MaxZ)
	vwrite("Business/Name.txt",BusinessID,Name)
	vwrite("Business/Price.txt",BusinessID,Price)
	return BusinessID
end

function getPlayerBusinessArea(PlayerID)
	local PlayerX, PlayerY, PlayerZ = getPlayerPos(PlayerID)
	for i,v in pairs(BusinessPositions) do
		if PlayerZ >= v[2] and PlayerZ <= v[3] and isPointInPolygon(PlayerX, PlayerY, unpack(v[1])) then
			return i
		end
	end
	return
end

function getBusinessPrice(BusinessID)
	local a = tonumber(BusinessPrice[BusinessID])
	if a then
		return a
	else
		return
	end
end

function getBusinessOwner(BusinessID)
	local a = BusinessOwner[BusinessID]
	if a then
		return a
	else
		return
	end
end

function isBusinessOwned(BusinessID)
	local a = BusinessOwner[BusinessID]
	if a then
		return true
	else
		return false
	end
end

function getBusinessName(BusinessID)
	return BusinessName[BusinessID] or "Un-Named Business"
end

function getBusinessIncomes(BusinessID)
	return Business[BusinessID] or 0
end

function getPlayerBusinessTime(PlayerID)
	local SecondsConnected = os.time() - PlayerConnected[PlayerID]
	return PlayerBusinessTime[PlayerID] + SecondsConnected
end

function resetPlayerBusinessTime(PlayerID)
	local Nickname = getPlayerName(PlayerID)
	PlayerBusinessTime[PlayerID] = 0
	PlayerConnected[PlayerID] = os.time()
	vremove("Business/Active.txt", Nickname)
end

--[[ Print Loading results ]]
outputConsole("		Engine Business Functions Loaded")