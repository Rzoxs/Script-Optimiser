AddEventHandler('gameEventTriggered', function (name, args)
    if name == "CEventNetworkPlayerEnteredVehicle" then
        Citizen.CreateThread(function()
            while true do
                Wait(0)
                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                    DisablePlayerVehicleRewards(-1)
                else
                    break
                end
            end
        end)
    end
end)
