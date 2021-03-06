local poslao = 0
parts = {
    ['RFoot'] = 52301,
    ['LFoot'] = 14201,
    ['RHand'] = 57005,
    ['LHand'] = 18905,
    ['RKnee'] = 36864,
    ['LKnee'] = 63931,
    ['Head'] = 31086,
    ['Neck'] = 39317,
    ['RArm'] = 28252,
    ['LArn'] = 61163,
    ['Chest'] = 24818,
    ['Pelvis'] = 11816,
    ['RShoulder'] = 40269,
    ['LShoulder'] = 45509,
    ['RWrist'] = 28422,
    ['LWrist'] = 60309,
    ['Tounge'] = 47495,
    ['UpperLip'] = 20178,
    ['LowerLip'] = 17188,
    ['RThigh'] = 51826,
    ['LThigh'] = 58217,
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local FoundLastDamagedBone, LastDamagedBone = GetPedLastDamageBone(PlayerPedId())
        if FoundLastDamagedBone then
            local DamagedBone = GetKeyOfValue(parts, LastDamagedBone)
            if LastDamagedBone == 31086 and poslao == 0 then
                TriggerEvent("esx_hitna:umrisine")
				TriggerEvent('chat:addMessage', { args = { '[HITNA]', 'Pogođeni ste u glavu i nije vam bilo spasa!' } })
				poslao = 1
				Wait(1000)
				poslao = 0
            else
                print('Error: Missing ID:' .. LastDamagedBone)
            end
        end
    end
end)

function GetKeyOfValue(Table, SearchedFor)
    for Key, Value in pairs(Table) do
        if SearchedFor == Value then
            return Key
        end
    end
    return nil
end