scoreboard players remove temp_0 mech_data 2
scoreboard players remove temp_1 mech_data 1
scoreboard players remove temp_2 mech_data 2

execute if block ~ ~ ~ dropper{Items:[{Slot:7b,tag:{OreDict:["ingotTitaniumSteel"]}}]} run scoreboard players add temp_3 mech_data 1
execute if score temp_3 mech_data matches 0 run replaceitem block ~ ~ ~ container.7 firework_star{mech_itemid: 2109, Explosion: {Colors: [I; 8876682]}, HideFlags: 32, display: {Name: "{\"translate\":\"mech.item.titanium_steel\",\"color\":\"light_purple\",\"italic\":false}"}, OreDict: ["ingotTitaniumSteel"]} 1