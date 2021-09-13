1. Drop SQL file into your database.
2. server.cfg --> ensure esegovic_advacnedDrugs
3. PROFIT!!


[Errors]
Check Config File for your ESX Library most common is "esx:getSharedObject"
Check Config File for mythic progress bar folder name as default is: "mythic_progbar"
Mythic Progbar can be found here: https://github.com/HalCroves/mythic_progbar
Coke & Weed Labs are from bob74_ipl that can be founded here: https://github.com/Bob74/bob74_ipl
Amfetamin Map is also free and can be found here: https://forum.cfx.re/t/drug-processing-facility-ymap-for-fivem/1076307
[NOTIFICATIONS_ERROR]
If you are getting Server side error for showNotification then you are using very old version of es_extended so just follow this steps if you want to use it if not, you need to replace it with your own
notifications system.

1. Open es_extended
2. Head to /server
3. Head to /classes
4. Open player.lua

And then at very bottom BEFORE this: ```return self``` add this:
    self.showNotification = function(msg)
    	self.triggerEvent('esx:showNotification', msg)
    end

So you will have something like this:
https://i.imgur.com/ncstWOJ.png


For any other questions feel free to contact me on my discord server: https://discord.gg/2PnMkZy2Uc