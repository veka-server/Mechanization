#Add to rate, then check for control rode
scoreboard players add @s[tag=mech_uranium] mech_y 3
scoreboard players add @s[tag=mech_plutonium] mech_y 2
execute if entity @s[tag=mech_uranium] if block ~ ~-1 ~ dropper[triggered=true] run scoreboard players remove @s mech_y 7
execute if entity @s[tag=mech_plutonium] if block ~ ~-1 ~ dropper[triggered=true] run scoreboard players remove @s mech_y 6
execute if score @s mech_y matches ..-16 run scoreboard players set @s mech_y -16
execute if score @s mech_y matches 64.. run scoreboard players set @s mech_y 64

#Get Fuel grade, add rate multiplier, add to current heat
execute store result score temp_0 mech_data run data get entity @s HandItems[0].tag.FuelGrade
scoreboard players set temp_1 mech_data 16
scoreboard players operation temp_0 mech_data *= temp_1 mech_data
scoreboard players operation temp_0 mech_data *= @s mech_y
scoreboard players operation @s mech_x += temp_0 mech_data

#Process Cooling
scoreboard players set temp_2 mech_data 0
execute if score @s mech_x matches 100000.. run function mechanization:nuclear/machines/fission_reactor/cooling/start
execute if score temp_2 mech_data matches 1.. run playsound mechanization:nuclear.steam_boil block @a[distance=..16] ~ ~1 ~ 1.5

#Add Power to Turbine
scoreboard players set temp_0 mech_data 400
scoreboard players operation heat_0 mech_data /= temp_0 mech_data

execute if score heat_0 mech_data matches 10.. store result score temp_0 mech_data if entity @e[tag=mech_turbine,scores={mech_power=..2000},distance=..5]
execute if score heat_0 mech_data matches 10.. if score temp_0 mech_data matches 1.. run scoreboard players operation heat_0 mech_data /= temp_0 mech_data
execute if score heat_0 mech_data matches 10.. if score temp_0 mech_data matches 1.. run tag @e[tag=mech_turbine,scores={mech_power=..2000},distance=..5] add mech_active

execute if score heat_0 mech_data matches 250.. run scoreboard players set heat_0 mech_data 250
execute if score heat_0 mech_data matches 10.. if score temp_0 mech_data matches 1.. run scoreboard players operation @e[tag=mech_turbine,scores={mech_power=..2000},distance=..5] mech_power += heat_0 mech_data
execute if score heat_0 mech_data matches 10.. if score temp_0 mech_data matches 1.. run playsound mechanization:nuclear.steam_turbine_active block @a[distance=..16] ~ ~2 ~ 2

#reduce fuel durability
execute store result score temp_0 mech_data run data get entity @s HandItems[0].tag.FuelGrade
execute store result score temp_1 mech_data run data get entity @s HandItems[0].tag.FuelSpent
execute if score temp_0 mech_data < temp_1 mech_data run replaceitem entity @s weapon.mainhand diamond_shovel{du_nerf:1b, mech_itemid: 3102, Unbreakable:1, OreDict:["cellSpentFuel"], Damage:97, HideFlags:6, display: {Name: "{\"translate\":\"mech.item.spent_fuel_cell\",\"color\":\"gray\",\"italic\":false}"}}
scoreboard players add temp_1 mech_data 1
execute store result entity @s HandItems[0].tag.FuelSpent int 1 run scoreboard players get temp_1 mech_data

#Cleanup
scoreboard players set @s[scores={mech_x=..20000}] mech_x 20000
execute if score @s mech_x matches 2000000.. run function mechanization:nuclear/machines/fission_reactor/explode
playsound mechanization:nuclear.fission_reactor_active block @a[distance=..16] ~ ~1 ~ 0.5
