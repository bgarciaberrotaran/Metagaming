function getXYInFrontOfPlayer(PlayerID,Radius)
    -- thanks to ReGeX for this function
    local X,Y,Z = getPlayerPos(PlayerID)
    local a = getPlayerAngle(PlayerID)
    X = X + ((math.cos(math.rad(a) + (math.pi/ 2)))*(Radius))
    Y = Y + ((math.sin(math.rad(a) + (math.pi/ 2)))*(Radius))
    return X,Y,Z,a
end

function getXYInFrontOfVehicle(VehicleID,Radius)
    -- thanks to ReGeX for this function
    local X,Y,Z = getVehiclePos(VehicleID)
    local a = getVehicleAngle(VehicleID)
    X = X + ((math.cos(math.rad(a) + (math.pi/ 2)))*(Radius))
    Y = Y + ((math.sin(math.rad(a) + (math.pi/ 2)))*(Radius))
    return X,Y,Z,a
end
function getXYBehindPlayer(PlayerID,Radius)
    local X,Y,Z = getPlayerPos(PlayerID)
    local a = getPlayerAngle(PlayerID)
    X = X - ((math.cos(math.rad(a) + (math.pi/ 2)))*(Radius))
    Y = Y - ((math.sin(math.rad(a) + (math.pi/ 2)))*(Radius))
    return X,Y,Z,a
end
function getXYBehindVehicle(VehicleID,Radius)
    local X,Y,Z = getVehiclePos(VehicleID)
    local a = getVehicleAngle(VehicleID)
    X = X - ((math.cos(math.rad(a) + (math.pi/ 2)))*(Radius))
    Y = Y - ((math.sin(math.rad(a) + (math.pi/ 2)))*(Radius))
    return X,Y,Z,a
end
function getXYInFrontOfPos(X, Y, ZAngle, Radius)
    X = X + ((math.cos(math.rad(ZAngle) + (math.pi/ 2)))*(Radius))
    Y = Y + ((math.sin(math.rad(ZAngle) + (math.pi/ 2)))*(Radius))
    return X,Y
end

function isFloat(Value)
	return (string.find(Value, ".", 1, true)) and true or false
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

--[[ Print Loading results ]]
outputConsole("		Engine Formulas Functions Loaded")
