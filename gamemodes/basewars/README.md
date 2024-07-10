# BaseWars
BaseWars is a gamemode all about printing and raiding. Build your own base to print tons of money while fighting off enemies trying to raid you!

## Features

* Easy to setup!
* Easy to configure!
* Crashes recover lost player money!
* Progression via a configurable leveling system!
* Automated anti-spawnkill!
* Automated raiding, no more 'random raids'!
* Custom chatbox!
* Built-in textscreens!
* Custom language support!
* Easy to use entity bases!
* Developer support!


## Installation

The gamemode's default config uses Customizable Weaponry 2.0, you can install the needed packs from here:

[part 1](https://steamcommunity.com/sharedfiles/filedetails/?id=349050451)

[part 2](https://steamcommunity.com/sharedfiles/filedetails/?id=358608166)

[part 3](https://steamcommunity.com/sharedfiles/filedetails/?id=359830105)

Or, if you want, just edit the config to use other weapons!

### Prerequisites
* A CPPI compliant prop-protection addon.
* A fading door addon.
* Easylua, which can be downloaded [here](https://github.com/Noiwex/luadev/blob/master/lua/autorun/easylua.lua)!

### Installing the gamemode
* Drag the folder into ```garrysmod/gamemodes```.
* Make sure easylua is installed in ```lua/autorun```.
* Edit ```garrysmod/gamemodes/basewars/gamemode/config.lua``` to your own liking.

## Screenshots

### Help Menu
![ScreenShot](http://puu.sh/mALs7/ad13259bff.jpg)
### Main Menu
![ScreenShot](http://puu.sh/mALv7/eefc81fe95.jpg)
### Entities
![ScreenShot](http://puu.sh/mALDK/b199a75830.jpg)
### Chatbox
![ScreenShot](http://puu.sh/mANRz/5577d91aa3.jpg)
### Textscreens
![ScreenShot](http://puu.sh/mAOmT/370b971f4f.jpg)

## Authors

### Hexahedronic

  **Main Developer:** [Callum J. Slaney](mailto:q2f2@hexahedron.pw)

  **Developer:** [Andrew Austin](mailto:ghosty.hexahedronic@gmail.com)

  **Developer:** [Stepan Fedotov](mailto:admin@futuretechs.eu)

  **Developer:** [Ling](mailto:ling@hexahedron.pw)
  
### Others

  Credited in the author field of the gamemode.
  
# Git stuff

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

## Usage for developers

```
-- Manipulating players money
	ply:GiveMoney(amt)
	ply:SetMoney(amt)
	ply:TakeMoney(amt)

-- Manipulating players level
	ply:AddLevel(amt)
	ply:SetLevel(amt)

	ply:SetXP(amt)
	ply:AddXP(amt)

-- Manipulating players karma
	ply:AddKarma(amt)
	ply:SetKarma(amt)

-- Utility global functions
	BaseWars.Raid:IsOnGoing()

	BaseWars.UTIL.Log(...)
	BaseWars.UTIL.RefundAll(ply, returnAsTable) -- Call with no arg to do full server refund, with arg to refund only them, call with second arg to REFUND NO-ONE but get a 'UID = Money' table

	BaseWars.NumberFormat(number) -- Converts to scale suffixed, eg 8,100,000 -> 8.1 Million


-- Utility metamethods
	ply:InFaction(name, leader) -- args optional, ply:InFaction() for ANY faction, ply:InFaction(nil, true) if LEADER of ANY faction, ect

	ply:InRaid()
	ply:Raidable(ignoreCooldown)

	ply:Notify(string, color) -- For strings try and keep them localised using BaseWars.LANG, and there are some global color enums, BASEWARS_NOTIFCATION_*


-- Available hooks
	hook.Add("BaseWars_PlayerEmptyPrinter", "name", function(ply, ent, money) end)

	hook.Add("BaseWars_PlayerBuyEntity", "name", function(ply, ent) end)
	hook.Add("BaseWars_PlayerBuyGun",    "name", function(ply, ent) end)
	hook.Add("BaseWars_PlayerBuyDrug",   "name", function(ply, ent) end)
	hook.Add("BaseWars_PlayerBuyProp",   "name", function(ply, ent) end)

-- 'CanBuy' hooks can be returned as false to block buying, with the second arg being an error message
	hook.Add("BaseWars_PlayerCanBuyEntity", "name", function(ply, class) end)
	hook.Add("BaseWars_PlayerCanBuyGun",    "name", function(ply, class) end)
	hook.Add("BaseWars_PlayerCanBuyDrug",   "name", function(ply, class) end)
	hook.Add("BaseWars_PlayerCanBuyProp",   "name", function(ply, class) end)

-- Similar to the 'CanBuy', you can return false with an error message.
	hook.Add("CanCreateFaction", "name", function(ply, name, password) end)
	hook.Add("CanJoinFaction",   "name", function(ply, name, password) end)
	hook.Add("CanLeaveFaction",  "name", function(ply, disband) end)

-- Same as above, false to make them unraidable, followed by a reason why.
	hook.Add("PlayerIsRaidable", "name", function(ply) end)
	
-- Called when certain drug events happen to a player
	hook.Add("PlayerRemoveDrug", "name", function(ply, effect) end)
	hook.Add("PlayerApplyDrug", "name", function(ply, effect) end)

-- Deriving entities
	ENT.Base = "bw_base"                -- Generic electronic
	ENT.Base = "bw_base_electronics"    -- Power CONSUMING electronic
	ENT.Base = "bw_base_generator"      -- Power GENERATING electronic
	ENT.Base = "bw_base_moneyprinter"   -- Template moneyprinter
	ENT.Base = "bw_base_turret"         -- Automated turrets!
	ENT.Base = "bw_base_explosive"      -- Explosive base, with support for cluster bombs
	ENT.Base = "bw_explosive_mine"      -- Explosive base with code for proximity detonation
-- You can also base off of a lot of entities if you want to inherit their behaviours
-- For example, the vending machine contains a lot of code that allows its behaviour to be modified
```
