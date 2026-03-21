--There are two functions that will install mods, ServerModSetup and ServerModCollectionSetup. Put the calls to the functions in this file and they will be executed on boot.

--ServerModSetup takes a string of a specific mod's Workshop id. It will download and install the mod to your mod directory on boot.
        --The Workshop id can be found at the end of the url to the mod's Workshop page.
        --Example: http://steamcommunity.com/sharedfiles/filedetails/?id=350811795
        --ServerModSetup("350811795")

--ServerModCollectionSetup takes a string of a specific mod's Workshop id. It will download all the mods in the collection and install them to the mod directory on boot.
        --The Workshop id can be found at the end of the url to the collection's Workshop page.
        --Example: http://steamcommunity.com/sharedfiles/filedetails/?id=379114180
        --ServerModCollectionSetup("379114180")

ServerModSetup("1852257480") -- Beefalo Widget
ServerModSetup("569043634") -- Campfire Respawn
-- ServerModSetup("347079953") -- Display Food Values
ServerModSetup("1185229307") -- Epic Healthbar
ServerModSetup("2798599672") -- Extra Equip Slots+3
ServerModSetup("378160973") -- Global Positions
ServerModSetup("374550642") -- Increased Stack size
ServerModSetup("2921270365") -- Quick Pick
ServerModSetup("1111658995") -- Show Bundle
ServerModSetup("3571706033") -- Wormhole Marks [DST]
-- ServerModSetup("2078243581") -- Display Attack Range
