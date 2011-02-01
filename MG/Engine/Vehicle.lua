function getVehicleOwner(VehicleID)
	return Vehicle[VehicleID] or nil
end

function getVehiclePrice(VehicleModel)
	return VehiclePrice[VehicleModel] or nil
end

function mgCreateVehicle(VehicleID,ModelID,XPos,YPos,ZPos,ZAngle,Colour1,Colour2)
	local VehicleID = createVehicle(ModelID, XPos, YPos, ZPos, ZAngle, Colour1, Colour2)
	local Data = { ModelID, XPos, YPos, ZPos, ZAngle, Colour1, Colour2 }
 
	VehicleData[VehicleID] = Data
	vwrite("Vehicle/Vehicles.txt", VehicleID, table.concat(Data, " "))
 
	return VehicleID
end