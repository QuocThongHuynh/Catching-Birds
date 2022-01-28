Jobs = {}
Job = {}
Job.__index = Job
ESX = nil

local u = 0 -- don't delete

--[[ local function random(x, y)
    u = u + 1
    if x ~= nil and y ~= nil then
        return math.floor(x +(math.random(math.randomseed(GetGameTimer()+u))*999999 %y))
    else
        return math.floor((math.random(math.randomseed(GetGameTimer()+u))*100))
    end
end ]]

function Job:Init(jobName)
    local o = Config.Jobs[jobName]
    setmetatable(o, Job)
    o.name = jobName
    o.curAction = nil
    o.curMarker = nil
    o.isInJob = false
    o.blips = {}
    o.curHelpMarker = nil
    o.blipRoute = nil
    o.objSpawn = {}
    o.objSpawnCount = {}
    o.pedApply = nil
    o.pedDealer = nil
    o.isBusy = false
    o.startAt = 0
    return o
end

function Job:CheckMainPos()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    for k, v in pairs(self['main-pos']) do 
        local distance = GetDistanceBetweenCoords(pedCoords.x, pedCoords.y, pedCoords.z, v.x, v.y, v.z, true)
        if distance <= 2.0 then 
            self.curMarker = k
            return
        end
    end
    self.curMarker = nil
    return
end

function Job:DrawMarker()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    if self.isInJob then
        for k, v in pairs(self['main-pos']) do 
            local distance = GetDistanceBetweenCoords(pedCoords.x, pedCoords.y, pedCoords.z, v.x, v.y, v.z, true)
            if distance <= 20 then 
                if k == "dealer" then
                    if self.pedDealer == nil then 
                        RequestModel(GetHashKey('u_m_y_burgerdrug_01'))
                        while not HasModelLoaded(`u_m_y_burgerdrug_01`) do 
                            Wait(0)
                        end
                        self.pedDealer = CreatePed(4, `u_m_y_burgerdrug_01`, v.x, v.y, v.z-0.9, v.h, false, false)
                        FreezeEntityPosition(self.pedDealer, true)
                        SetEntityCanBeDamaged(self.pedDealer, false)
                        SetPedCanBeTargetted(self.pedDealer, false)
                    end
                else
                    DrawMarker(6, v.x, v.y, v.z - 0.99, 0.0, 0.0, 0.0, 270.0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 0, 0, 150, false, false, 2, nil, nil, false)
                end
            end
        end
            for i = 1, #self['step'], 1 do
                local distance = GetDistanceBetweenCoords(pedCoords.x, pedCoords.y, pedCoords.z, self['step'][i].coords.x, self['step'][i].coords.y, self['step'][i].coords.z, true)
                if self['step'][i].work.type ~= "gather" and distance <= 20 then 
                    DrawMarker(6, self['step'][i].coords.x, self['step'][i].coords.y, self['step'][i].coords.z - 0.99, 0.0, 0.0, 0.0, 270.0, 0.0, 0.0, self['step'][i].work.radius or 2.0, self['step'][i].work.radius or 2.0, self['step'][i].work.radius or 2.0, 255, 0, 0, 150, false, false, 2, nil, nil, false)
                end
            end
    end
end

function Job:RefreshBlip()
    for k, v in pairs(self.blips) do 
        RemoveBlip(v)
    end
    if self.isInJob then 
        for k, v in pairs(self['main-pos']) do 
            local blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(blip, self['blip'].sprite)
            SetBlipScale(blip, 1.0)
            SetBlipColour(blip, self['blip'].color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(self['job-label']..' : '..Config.BlipName[k])
            EndTextCommandSetBlipName(blip)
            table.insert(self.blips, blip)
        end
        for k, v in pairs(self['step']) do 
            local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
            SetBlipSprite(blip, 501 + k)
            SetBlipScale(blip, 0.6)
            SetBlipColour(blip, self['blip'].color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(self['job-label']..' : '..v['blip'].label)
            EndTextCommandSetBlipName(blip)
            table.insert(self.blips, blip)
        end
    end
end

function Job:HelpMarker()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    if self.curHelpMarker ~= nil then 
        DrawMarker(2, self.curHelpMarker.x, self.curHelpMarker.y, self.curHelpMarker.z + 3, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 2.0, 2.0, 2.0, 255, 0, 0, 90, true, true, 2, nil, nil, false)
        if self.blipRoute == nil then 
            self.blipRoute = AddBlipForCoord(self.curHelpMarker.x, self.curHelpMarker.y, self.curHelpMarker.z)
            SetBlipRoute(self.blipRoute, true)
            SetBlipRouteColour(self.blipRoute, 5)
        end
        if GetDistanceBetweenCoords(self.curHelpMarker.x, self.curHelpMarker.y, self.curHelpMarker.z, pedCoords.x, pedCoords.y, pedCoords.z, false) <= 2.0 then 
            self.curHelpMarker = nil
            if self.blipRoute ~= nil then 
                RemoveBlip(self.blipRoute)
                self.blipRoute = nil
            end
        end
    end
end

function Job:MissionText(text, time, immediately)
    --ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(time or 1, immediately or 1)
end

function Job:CheckJobPos()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    for k, v in pairs(self['step']) do 
        local distance = GetDistanceBetweenCoords(pedCoords.x, pedCoords.y, pedCoords.z, v.coords.x, v.coords.y, v.coords.z)
        if v.work.radius == nil then 
            if distance <= 2.0 then 
                self.curAction = k
                return
            end
        else
            if v.work.type == "gather" then
                if distance <= v.work.radius + 50.0 then 
                    self.curAction = k
                    return
                end
            else
                if distance <= v.work.radius + 10.0 then 
                    self.curAction = k
                    return
                end
            end
        end
    end
    self.curAction = nil 
    return
end

function Job:JobThread()
    if self.curAction ~= nil then 
        local curStep = self['step'][self.curAction]
        if curStep.work.type == "freeze" then 
            local ped = PlayerPedId()
            ESX.ShowHelpNotification(curStep.helpMessage)
            if IsControlJustReleased(0, 38) and not self.isBusy then
                self.startAt = self['step'][self.curAction].progressBar.duration + GetGameTimer()
                self.isBusy = true 
                if self['step'][self.curAction].work.scenario then 
                    TaskStartScenarioInPlace(ped, self['step'][self.curAction].work.scenario, 0, true)
                end
                TriggerEvent("mythic_progbar:client:progress",{
                    name = "get_item",
                    duration = self['step'][self.curAction].progressBar.duration,
                    label = self['step'][self.curAction].progressBar.label,
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true
                    },
                    --[[ animation = {
                        animDict = "amb@world_human_const_drill@male@drill@base",
                        anim = "base",
                    }, ]]
                    --[[ prop = {
                        model = "hei_prop_heist_drill",
                    } ]]
                },function(status)
                    if not status then
                        ClearPedTasks(ped)
                        self.isBusy = false
                        --[[ if GetGameTimer() - self.startAt < -1500 then 
                            TriggerServerEvent("LRPT:server:clientIllegal", GetCurrentResourceName().." Mythic_progressbar")
                            return 
                        end ]]
                        TriggerServerEvent("job_framework:server:reward:"..self.name, self.curAction)
                    end
                end)
            end
            self:RemoveAllObject()
        elseif curStep.work.type == "gather" then 
            self:SpawnObject()
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            for k, v in pairs(self.objSpawn[self.curAction]) do 
                local objCoords = GetEntityCoords(v)
                local distance = GetDistanceBetweenCoords(pedCoords.x, pedCoords.y, pedCoords.z, objCoords.x, objCoords.y, objCoords.z, false)
                if distance < 2.0 then 
                    ESX.ShowHelpNotification(curStep.helpMessage)
                    if IsControlJustReleased(0, 38) then 
                        if not self.isBusy then 
                            self.startAt = self['step'][self.curAction].progressBar.duration + GetGameTimer()
                            self.isBusy = true
                            TaskStartScenarioInPlace(ped, self['step'][self.curAction].work.scenario, 0, true)
                            TriggerEvent("mythic_progbar:client:progress",{
                                name = "get_item",
                                duration = self['step'][self.curAction].progressBar.duration,
                                label = self['step'][self.curAction].progressBar.label,
                                useWhileDead = false,
                                canCancel = false,
                                controlDisables = {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true
                                },
                                --[[ animation = {
                                    animDict = "amb@world_human_const_drill@male@drill@base",
                                    anim = "base",
                                }, ]]
                                --[[ prop = {
                                    model = "hei_prop_heist_drill",
                                } ]]
                            },function(status)
                                if not status then
                                    ClearPedTasks(ped)
                                    ESX.Game.DeleteObject(v)
                                    DeleteJackhammer()
                                    DeletePed(v)
                                    table.remove(self.objSpawn[self.curAction], k)
                                    self.objSpawnCount[self.curAction] = self.objSpawnCount[self.curAction] - 1
                                    local drill = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 2.0, 1360563376, false, 1, 1)
                                    ESX.Game.DeleteObject(drill)
                                    print(GetGameTimer() - self.startAt)
                                    print(GetGameTimer(), self.startAt)
                                    --[[ if GetGameTimer() - self.startAt < -1500 then 
                                        TriggerServerEvent("LRPT:server:clientIllegal", GetCurrentResourceName().." Mythic_progressbar")
                                        return 
                                    end ]]
                                    TriggerServerEvent("job_framework:server:reward:"..self.name, self.curAction)
                                    Wait(1000)
                                    self.isBusy = false
                                end
                            end)
                        end
                    end
                    break
                end
            end
        end
    else
        self:RemoveAllObject()
    end
end

--[[ Citizen.CreateThread(function()
    while true do 
        Wait(0)
        print(GetGameTimer())
    end
end) ]]

function Job:SpawnObject()
    if self.objSpawn[self.curAction] == nil then 
        self.objSpawn[self.curAction] = {}
    end
    if self.objSpawnCount[self.curAction] == nil then 
        self.objSpawnCount[self.curAction] = 0
    end
    while self.objSpawnCount[self.curAction] < self['step'][self.curAction].work['max-spawn'] do 
        Wait(0)
        local objCoords = self:GenerateObjCoords()
        local objHash = self:GetRandomObject()
        if self['step'][self.curAction].work['objType'] then 
            RequestModel(objHash)
            while not HasModelLoaded(objHash) do
                Citizen.Wait(1)
            end
            local obj = CreatePed(28, objHash, objCoords, 10.0, false, true)
            table.insert(self.objSpawn[self.curAction], obj)
            self.objSpawnCount[self.curAction] = self.objSpawnCount[self.curAction] + 1
        else
            ESX.Game.SpawnLocalObject(objHash, objCoords, function(obj)
                PlaceObjectOnGroundProperly(obj)
                --FreezeEntityPosition(obj, true)
    
                table.insert(self.objSpawn[self.curAction], obj)
                self.objSpawnCount[self.curAction] = self.objSpawnCount[self.curAction] + 1
            end)
        end
    end
end

function Job:GenerateObjCoords()
    while true do 
        Wait(1)
        local x, y, z
        math.randomseed(GetGameTimer())
        local mX = math.random(0 - self['step'][self.curAction].work.radius/2, 0 + self['step'][self.curAction].work.radius/2)
        Wait(100)
        math.randomseed(GetGameTimer())
        local mY = math.random(0 - self['step'][self.curAction].work.radius/2, 0 + self['step'][self.curAction].work.radius/2)
        x = self['step'][self.curAction].coords.x + mX
        y = self['step'][self.curAction].coords.y + mY
        z = self:GetZ(x, y)
        local coords = vector3(x, y, z)
        if self:ValidateObjCoords(coords) then
            return coords
        end
    end
end

function Job:ValidateObjCoords(coords)
    local canSpawn = true
    for k, v in pairs(self.objSpawn[self.curAction]) do 
        if GetDistanceBetweenCoords(coords, GetEntityCoords(v), true) < 0 then 
            canSpawn = false
        end
    end
    return canSpawn
end

function Job:GetZ(x, y)
    for i = math.floor(self['step'][self.curAction].coords.z - 30), math.floor(self['step'][self.curAction].coords.z + 30), 1 do 
        local foundGround, z = GetGroundZFor_3dCoord(x, y, i+0.0, 0)
        if foundGround then
			return z
		end
    end
    return 0
end

function Job:GetRandomObject()
    local objList = self['step'][self.curAction].work.obj
    math.randomseed(GetGameTimer())
    local rd = math.random(1, #objList)
    if type(objList[rd]) == "string" then 
        return GetHashKey(objList[rd])
    elseif type(objList[rd]) == "number" then 
        return objList[rd]
    end
end

function Job:RemoveAllObject()
    for k, v in pairs(self.objSpawnCount) do 
        self.objSpawnCount[k] = 0
    end
    for k, v in pairs(self.objSpawn) do 
        for i = 1, #v, 1 do 
            DeleteObject(v[i])
            DeletePed(v[i])
        end
        self.objSpawn[k] = {}
    end
end

function Job:OpenDealerMenu()
    self.isBusy = true 
    local elements = {}
    for k, v in pairs(ESX.GetPlayerData().inventory) do 
        local price = self['items'][v.name]
        if price and v.count > 0 then 
            table.insert(elements, {
                label = ('%s - <span style="color:green;">%s</span>'):format(v.label, price),
                name = v.name,
                type = 'slider',
                value = 1,
                min = 1,
                max = v.count
            })
        end
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), self.name..'_shop', {
        title = ("[%s] Thương Nhân"):format(self.name),
        align = 'right',
        elements = elements
    }, function(data, menu)
        TriggerServerEvent("job_framework:server:sell:"..self.name, data.current.name, data.current.value)
        menu.close()
        self:OpenDealerMenu()
    end, function(data, menu)
        menu.close()
    end, nil, function(data, menu)
        self.isBusy = false
    end)
end

function Job:Main()
    Citizen.CreateThread(function()
        while true do 
            coroutine.yield(0)
            self:DrawMarker()
            self:CheckMainPos()
            self:HelpMarker()
            if self.curMarker == 'dealer' and self.isInJob then 
                ESX.ShowHelpNotification(("Nhấn [E] để bán vật phẩm ~y~[%s]~w~"):format(self['job-label']))
                if IsControlJustReleased(0, 38) and not self.isBusy then 
                    self:OpenDealerMenu()
                end
            end
            if self.isInJob then 
                self:CheckJobPos()
                self:JobThread()
            end
        end
    end)
end

Citizen.CreateThread(function()
    while ESX == nil do 
        Citizen.Wait(0)
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end
    Citizen.Wait(2000)
    for k, v in pairs(Config.Jobs) do 
        Jobs[k] = Job:Init(k)
        Jobs[k]:RefreshBlip()
        Jobs[k]:Main()
    end
    for i, j in pairs(Config.Jobs) do 
        if ESX.GetPlayerData().job.name == i then
            Jobs[i].isInJob = true
            Jobs[i]:RefreshBlip()
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
	for k, v in pairs(Jobs) do 
        Jobs[k]:RemoveAllObject()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    for k, v in pairs(Config.Jobs) do 
        if xPlayer.job.name == k then
            Jobs[k].isInJob = true
            Jobs[k]:RefreshBlip()
        end
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    for k, v in pairs(Config.Jobs) do 
        if job.name == k then
            Jobs[k].isInJob = true
        else
            Jobs[k].isInJob = false
        end
        Jobs[k]:RefreshBlip()
    end
end)

RegisterCommand("testdaomo", function()
    print(ESX.DumpTable(Jobs))
end)

--[[ RegisterCommand("ga", function()
    local pedCoords = GetEntityCoords(PlayerPedId())
    RequestModel(1706635382)
    while not HasModelLoaded(1706635382) do
        Citizen.Wait(1)
    end
    thisPed = CreatePed(26, 1706635382, pedCoords.x, pedCoords.y, pedCoords.z, 0.0, false, true)
end) ]]
local sc = 0
local scL = {
    "PROP_HUMAN_ATM",
    "PROP_HUMAN_BBQ",
    "PROP_HUMAN_BUM_BIN",
    "PROP_HUMAN_BUM_SHOPPING_CART",
    "PROP_HUMAN_MUSCLE_CHIN_UPS",
    "PROP_HUMAN_MUSCLE_CHIN_UPS_ARMY",
    "PROP_HUMAN_MUSCLE_CHIN_UPS_PRISON",
    "PROP_HUMAN_PARKING_METER",
    "PROP_HUMAN_SEAT_ARMCHAIR",
    "PROP_HUMAN_SEAT_BAR",
    "PROP_HUMAN_SEAT_BENCH",
    "PROP_HUMAN_SEAT_BENCH_FACILITY",
    "PROP_HUMAN_SEAT_BENCH_DRINK",
    "PROP_HUMAN_SEAT_BENCH_DRINK_FACILITY",
    "PROP_HUMAN_SEAT_BENCH_DRINK_BEER",
    "PROP_HUMAN_SEAT_BENCH_FOOD",
    "PROP_HUMAN_SEAT_BENCH_FOOD_FACILITY",
    "PROP_HUMAN_SEAT_BUS_STOP_WAIT",
    "PROP_HUMAN_SEAT_CHAIR",
    "PROP_HUMAN_SEAT_CHAIR_DRINK",
    "PROP_HUMAN_SEAT_CHAIR_DRINK_BEER",
    "PROP_HUMAN_SEAT_CHAIR_FOOD",
    "PROP_HUMAN_SEAT_CHAIR_UPRIGHT",
    "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER",
    "PROP_HUMAN_SEAT_COMPUTER",
    "PROP_HUMAN_SEAT_COMPUTER_LOW",
    "PROP_HUMAN_SEAT_DECKCHAIR",
    "PROP_HUMAN_SEAT_DECKCHAIR_DRINK",
    "PROP_HUMAN_SEAT_MUSCLE_BENCH_PRESS",
    "PROP_HUMAN_SEAT_MUSCLE_BENCH_PRESS_PRISON",
    "PROP_HUMAN_SEAT_SEWING",
    "PROP_HUMAN_SEAT_STRIP_WATCH",
    "PROP_HUMAN_SEAT_SUNLOUNGER",
    "PROP_HUMAN_STAND_IMPATIENT",
    "CODE_HUMAN_COWER",
    "CODE_HUMAN_CROSS_ROAD_WAIT",
    "CODE_HUMAN_PARK_CAR",
    "PROP_HUMAN_MOVIE_BULB",
    "PROP_HUMAN_MOVIE_STUDIO_LIGHT",
    "CODE_HUMAN_MEDIC_KNEEL",
    "CODE_HUMAN_MEDIC_TEND_TO_DEAD",
    "CODE_HUMAN_MEDIC_TIME_OF_DEATH",
    "CODE_HUMAN_POLICE_CROWD_CONTROL",
    "CODE_HUMAN_POLICE_INVESTIGATE",
    "CHAINING_ENTRY",
    "CHAINING_EXIT",
    "CODE_HUMAN_STAND_COWER",
    "EAR_TO_TEXT",
    "EAR_TO_TEXT_FAT",
    "WORLD_LOOKAT_POINT",
}
-- RegisterCommand("scene", function()
--     ClearPedTasksImmediately(PlayerPedId())
--     sc = sc + 1
--     TaskStartScenarioInPlace(PlayerPedId(), scL[sc], 0, true)
--     print(scL[sc])
-- end)

function DeleteJackhammer()
	local position = GetEntityCoords(PlayerPedId(), false)
	local object = GetClosestObjectOfType(position.x, position.y, position.z, 15.0, GetHashKey("prop_tool_jackham"), false, false, false)
	if object ~= 0 then
		DeleteObject(object)
	end
end