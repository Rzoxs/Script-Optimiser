local mp_pointing = false
local once = true
local oldval = false
local oldvalped = false

RegisterKeyMapping('pointing', 'Pointer du doigt', 'keyboard', 'b')
RegisterCommand("pointing", function(source, args)
    if mp_pointing then
        mp_pointing = false
        stopPointing()
    else
        if IsPedOnFoot(PlayerPedId()) then
            mp_pointing = true
            startPointing()

            CreateThread(function()
                while mp_pointing do
                    if IsTaskMoveNetworkActive(PlayerPedId()) then
                        if not IsPedOnFoot(PlayerPedId()) then
                            stopPointing()
                        else
                            local ped = GetPlayerPed(-1)
                            local camPitch = GetGameplayCamRelativePitch()
                            if camPitch < -70.0 then
                                camPitch = -70.0
                            elseif camPitch > 42.0 then
                                camPitch = 42.0
                            end
                            camPitch = (camPitch + 70.0) / 112.0
            
                            local camHeading = GetGameplayCamRelativeHeading()
                            local cosCamHeading = Cos(camHeading)
                            local sinCamHeading = Sin(camHeading)
                            if camHeading < -180.0 then
                                camHeading = -180.0
                            elseif camHeading > 180.0 then
                                camHeading = 180.0
                            end
                            camHeading = (camHeading + 180.0) / 360.0
            
                            local blocked = 0
                            local nn = 0
            
                            local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                            local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                            nn,blocked,coords,coords = GetRaycastResult(ray)
            
                            SetTaskMoveNetworkSignalFloat(ped, "Pitch", camPitch)
                            SetTaskMoveNetworkSignalFloat(ped, "Heading", camHeading * -1.0 + 1.0)
                            SetTaskMoveNetworkSignalBool(ped, "isBlocked", blocked)
                            SetTaskMoveNetworkSignalBool(ped, "isFirstPerson", GetCamViewModeForContext(GetCamActiveViewModeContext()) == 4)
                        end
                    end
                    Wait(0)
                end
            end)
        end
    end
end)

startPointing = function()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

stopPointing = function()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end
