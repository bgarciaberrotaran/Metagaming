--[[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]]
--[[ VLE Light 1.02                                                          ]]
--[[ Created by Mex                                                          ]]
--[[                                                                         ]]
--[[ Works with files created by VLE 1.06                                    ]]
--[[                                                                         ]]
--[[ Website    http://vle.vicecityonline.com/light/                         ]]
--[[ Need help? http://vle.vicecityonline.com/lighthelp/                     ]]
--[[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]]


--[[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]]
--[[ Stage 1/2                                               ]]
--[[ Load Settings                                           ]]
--[[ Choose which files you wish to load into your server    ]]
--[[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]]

SpawnClasses = false
SpawnClassMembers = false
Vehicles = false
Objects = true
Pickups = false
Markers = false
Actors = false
Icons = false
Maps = true

--[[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]]
--[[ Stage 2/2                                               ]]
--[[ File Path Settings                                      ]]
--[[ Choose the paths to the files (relative to Server.exe)  ]]
--[[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]]

SpawnClassesPath = ""
SpawnClassMembersPath = ""
VehiclesPath = ""
ObjectsPath = "MG/Objects.txt"
PickupsPath = ""
MarkersPath = ""
ActorsPath = ""
IconsPath = ""
MapsPath = "VLE/Maps.txt"
MapsDirPath = "VLE/Maps/"

function VLELightLoadFeatures()
	outputConsole("VLE Light 1.02 is loading.. (VLE 1.06 files)")
	local a,d=string.sub(MapsDirPath,-1)
	if a~="/" and a~="\\" then MapsDirPath = MapsDirPath.."/" end
	local Features = { "SpawnClasses", "SpawnClassMembers", "Vehicles", "Objects", "Pickups", "Markers", "Actors", "Icons", "Maps" }
	local FeatureAmounts = {}
	for i,v in ipairs(Features) do
		if _G[v] then
			if _G[v.."Path"] == "" then outputConsole("\n\n     @@@@@@@@@@@@@@ ERROR @@@@@@@@@@@@@@\n\n     You chose to load feature '"..v.."',\n     but you did not specify the path to this file.\n\n"); return end
			if not vexists(_G[v.."Path"]) then outputConsole("  FILE NOT FOUND FOR '"..v.."'")
			else
				local a, b, SpacePos, NextSpacePos
				for v1,v2 in vfile(_G[v.."Path"]) do
					a = vexplode(v2, " ")
					for j,w in ipairs(a) do
						if (v~="SpawnClasses" or j<12) and (v~="Pickups" or j~=1) and (v~="Markers" or j~=1) and (v~="Actors" or j<6) and (v~="Icons" or j<6) then a[j] = tonumber(a[j]) end
					end
					if v=="SpawnClasses" then addSpawnClass(table.concat(a," ",12),a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8],a[9],a[10],a[11])
					elseif v=="SpawnClassMembers" then addClassMember(tonumber(string.sub(v1,1,string.find(v1,"_",1,true)-1)),a[1],a[2],a[3],a[4],a[5],a[7],a[8],a[9],a[10],a[11],a[12])
					elseif v=="Vehicles" then createVehicle(a[1],a[2],a[3],a[4],a[5],a[6],a[7])
					elseif v=="Objects" then b=createGlobalObject(a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8])
					elseif v=="Pickups" then
						if a[1]=="generic" then createGlobalGenericPickup(a[2],a[3],a[4],a[5],a[6])
						elseif a[1]=="weapon" then createGlobalWeaponPickup(a[2],a[3],a[4],a[5],a[6])
						elseif a[1]=="cash" then createGlobalCashPickup(a[2],a[3],a[4],a[5])
						end
					elseif v=="Markers" then
						if a[1]=="checkpoint" then createGlobalCheckpoint(a[3],a[4],a[5],a[2])
						elseif a[1]=="corona" then createGlobalCorona(a[5],a[6],a[7],a[2],a[3],a[4])
						end
					elseif v=="Actors" then
						b=createStaticActor(a[1],a[2],a[3],a[4],a[5],((a[6]=="true") and true or false))
						setStaticActorAnimation(b,((a[7]=="none") and 0 or tonumber(a[7])))
						if a[8] then setStaticActorName(b,table.concat(a," ",8)) end
					elseif v=="Icons" then
						b=createGlobalIcon(a[1],a[2],a[3],a[4],a[5],((a[6]=="false") and false or true))
						toggleGlobalIconFlashing(b,((a[7]=="off") and 0 or 1))
					elseif v=="Maps" then
						if v2 == "0" then FeatureAmounts[v] = (FeatureAmounts[v] or 0) - 1
						else
							for b,c in vfile(MapsDirPath..v1..".txt") do
								a = vexplode(c, " ", true)
								b=createGlobalObject(unpack(a))
								FeatureAmounts["MapObjects"] = (FeatureAmounts["MapObjects"] or 0) + 1
							end
						end
					end
					FeatureAmounts[v] = (FeatureAmounts[v] or 0) + 1
				end
				outputConsole("  Loaded "..v..". ("..(FeatureAmounts[v] or 0)..")"..((v == "Maps") and " ("..(FeatureAmounts["MapObjects"] or 0).." object"..((FeatureAmounts["MapObjects"] ~= 1) and "s" or "")..")" or ""))
			end
		end
	end
	
	-- #4# Clean up global variables
	SpawnClases,SpawnClassMembers,Vehicles,Objects,Pickups,Markers,Actors,Icons = nil
	SpawnClasesPath,SpawnClassMembersPath,VehiclesPath,ObjectsPath,PickupsPath,MarkersPath,ActorsPath,IconsPath = nil
	outputConsole("VLE Light 1.02 has loaded. (VLE 1.06 files)")
end
function vexplode(String, Sep, ToNumber)
	local Table, SepPos, NextSepPos, Token = {}, string.find(String, Sep, 1, true)
	if SepPos then
		Token = string.sub(String, 1, SepPos - 1)
		if ToNumber then Token = tonumber(Token) end
		table.insert(Table, Token)
	end
	while SepPos do
		NextSepPos = string.find(String, Sep, SepPos + 1, true)
		Token = string.sub(String, SepPos + 1, ((NextSepPos) and NextSepPos - 1 or nil))
		if ToNumber then Token = tonumber(Token) end
		table.insert(Table, Token)
		SepPos = NextSepPos
	end
	return Table
end
function vexists(Path)
	if not Path then return end
	
	local Handle = io.open(Path, "r")
	if not Handle then return false end
	io.close(Handle)
	
	return true
end
VLELightLoadFeatures()