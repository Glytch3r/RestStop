
require 'NPCs/ZombiesZoneDefinition'
ZombiesZoneDefinition = ZombiesZoneDefinition or {}
table.insert(ZombiesZoneDefinition.Default,{name = "BunkerStaff", chance=0, });
--oldarmy
--[[ 

Events.OnPostDistributionMerge.Add(function()
	table.insert(ZombiesZoneDefinition.Default,{name = "BunkerStaff", chance=0.000000001, });
	ItemPickerJava.Parse()
end)
 ]]