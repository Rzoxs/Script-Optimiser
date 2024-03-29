local RZS = {
    HandsUp = false,
}

RegisterKeyMapping("handsup", "Mettre les mains en l'air", "keyboard", "X")
RegisterCommand('handsup', function()
    local dict = "missminuteman_1ig_2"

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    if IsPedInAnyVehicle(PlayerPedId()) then
        ShowNotification('~r~Vous ne pouvez pas levez les mains dans un véhicule')
    else
        if RZS.HandsUp then
            RZS.HandsUp = false
            ClearPedTasks(GetPlayerPed(-1))
        else
            RZS.HandsUp = true
            TaskPlayAnim(GetPlayerPed(-1), "missminuteman_1ig_2", "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
        end
    end
end)

ShowNotification = function(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(msg)
	DrawNotification(false, true)
end
