AddEventHandler('gameEventTriggered', function (name, args)
    if name == "CEventNetworkPlayerEnteredVehicle" then
        Citizen.CreateThread(function()
            while true do
                Wait(0)
                DisablePlayerVehicleRewards(-1)
                if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                    break
                end
            end
        end)
    end
end)
