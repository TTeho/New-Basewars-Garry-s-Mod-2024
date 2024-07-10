### 1.3.0 Fixes

### New Features
+ Added new 'Help/Info' tab to the F3 menu
+ Added the defuse kit to defuse twice as fast
+ Added 'Raid' field for raid only items
+ Added lasergun, not on the menu due to lack of testing so far
+ Added Health, AlwaysRaidable and Raid (Only during raids) as flags for the spawnmenu
+ Weapons will now despawn after a configurable period of time
+ Added a basewars medkit to the spawnmenu under "Medical". (bw_medkit)
+ Added a new LANG line OnItemCoolDown, formatting required.
+ Added a discord command.
+ Added option for manual turret shooting speed.

### Fixes
+ Fixed long standing bug with money distribution in raids.
+ Fixed very rare errors in shared.lua
+ Fixed a bug in raid.lua which caused an error but didn't break anything
+ Made MySQL attempt to reconnect if the database object becomes invalid for some reason
+ Fixed password length when joining factions
+ Fixed the spawnmenu icons not having their outlines
+ Fixed being unable to use the medkit after using it and dying
+ Fixed turrets sometimes bugging out and never shooting.

### Config
+ BaseWars.Config.AllTalk
+ BaseWars.Config.SpawnRadius
+ BaseWars.Config.WeaponDespawn
+ BaseWars.Config.NonOwnedTakeDamage
+ BaseWars.Config.Discord

### Changes
+ Cleaned up some files, removing whitespace and excessive code spacing
+ Changed default max /pay to 50k rather than 10k
+ Made the nuke and bigbomb raid only
+ Moved the default PlayerIsRaidable code to a gamemode hook
