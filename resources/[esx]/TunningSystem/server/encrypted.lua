function SendUsed(id,type)
                                Config.TunningLocations[id].used = type
                                TriggerClientEvent("Bennys:Used",-1,id, type)
                        end
                        RegisterServerEvent('ApplymodSync')
                        AddEventHandler('ApplymodSync', function(modindex,index)
                                local _source = source
                                TriggerClientEvent("ApplymodSync",_source,modindex,index)
                        end)