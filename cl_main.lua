if not lib then
    print("ox_lib is not loaded! Please ensure ox_lib is started before this resource.")
    return
end

local createdDryVolumes = {}
local dryVolumeHandles = {}

local function CreateDryVolumeIfNotExists(xMin, yMin, zMin, xMax, yMax, zMax)
    local key = string.format("%.2f_%.2f_%.2f_%.2f_%.2f_%.2f", xMin, yMin, zMin, xMax, yMax, zMax)
    if createdDryVolumes[key] then
        if Config.debug then
            print("Dry volume already created for key: " .. key)
        end
        return createdDryVolumes[key]
    end
    local retVal = Citizen.InvokeNative(0xEB1C6DD, xMin, yMin, zMin, xMax, yMax, zMax)
    createdDryVolumes[key] = retVal
    table.insert(dryVolumeHandles, retVal)
    return retVal
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for _, handle in ipairs(dryVolumeHandles) do
            Citizen.InvokeNative(0x7BCAA6E7, handle) -- REMOVE_DRY_VOLUME
        end
        if Config.debug then
            print("All dry volumes removed")
        end
    end
end)

for _, zone in ipairs(Config.zones) do
    local polyZone = lib.zones.poly({
        points = zone.points,
        thickness = zone.thickness,
        debug = Config.debug,
        onEnter = function(self)
            if Config.debug then
                print("Entered dry volume zone: " .. (zone.id or "unknown"))
            end
        end,
        onExit = function(self)
            if Config.debug then
                print("Exited dry volume zone: " .. (zone.id or "unknown"))
            end
        end,
    })

    Citizen.CreateThread(function()
        local xValues = {}
        local yValues = {}
        for _, point in ipairs(zone.points) do
            table.insert(xValues, point.x)
            table.insert(yValues, point.y)
        end

        local xMin = math.min(table.unpack(xValues))
        local xMax = math.max(table.unpack(xValues))
        local yMin = math.min(table.unpack(yValues))
        local yMax = math.max(table.unpack(yValues))
        local zMin = zone.points[1].z - zone.thickness / 2
        local zMax = zone.points[1].z + zone.thickness / 2
        local dryVolumeId = CreateDryVolumeIfNotExists(xMin, yMin, zMin, xMax, yMax, zMax)
        if Config.debug then
            print("Permanent dry volume created for " .. (zone.id or "unknown") .. "! ID: " .. tostring(dryVolumeId))
            print(string.format("Dry volume AABB for %s: xMin=%.2f, yMin=%.2f, zMin=%.2f, xMax=%.2f, yMax=%.2f, zMax=%.2f", 
                zone.id or "unknown", xMin, yMin, zMin, xMax, yMax, zMax))
        end
    end)
end