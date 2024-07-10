-- CURRENCY: The currency used for the gamemode
local CURRENCY = "£"

-- category: The name of the spawnmenu category
-- This is done with language.Add since it's already handled by gmod
if CLIENT then
	language.Add("spawnmenu.category.basewars", "BaseWars")
end

-- GO NO FURTHER IF YOU ARE NOT AT LEAST SEMI-EXPERIENCED WITH LUA

-- To create a new language, copy the english language lookup, and paste a second copy
-- below it. Change _LANGUAGELOOK.ENGLISH to _LANGUAGELOOK.YOURLANGUAGE then translate any strings.
-- When done go back to the config and change the selected language

-- If you create a language table which we dont have already, or notice any spelling or grammar mistakes
-- in the existing ones, open a support ticket or mail @ q2f2@hexahedron.pw and we will add it to the gamemode and you to the credits.

-- Korean: Unfinished

BaseWars.LANG = {}
BaseWars.LANG.__LANGUAGELOOK = {}

BaseWars.LANG.__LANGUAGELOOK.ENGLISH = {
    Numbers = {
        [20] = {10^6, "Million"},
        [19] = {10^9, "Billion"},
        [18] = {10^12, "Trillion"},
        [17] = {10^15, "Quadrillion"},
        [16] = {10^18, "Quintillion"},
        [15] = {10^21, "Sextillion"},
        [14] = {10^24, "Septillion"},
        [13] = {10^27, "Octillion"},
        [12] = {10^30, "Nonillion"},
        [11] = {10^33, "Decillion"},
        [10] = {10^36, "Undecillion"},
        [9] = {10^39, "Duodecillion"},
        [8] = {10^42, "Tredecillion"},
        [7] = {10^45, "Quattuordecillion"},
        [6] = {10^48, "Quindecillion"},
        [5] = {10^51, "Sexdecillion"},
        [4] = {10^54, "Septendecillion"},
        [3] = {10^57, "Octodecillion"},
        [2] = {10^60, "Novemdecillion"},
        [1] = {10^63, "Vigintillion"},
    },

	CURFORMER								= CURRENCY .. "%s",
	CURRENCY								= CURRENCY,

	Yes											= "Yes",
	No											= "No",
	Level										= "Level",
	Remaining								= "Remaining",
	Seconds									= "Seconds",
	Mins										= "Mins",
	You											= "You",

	NaNResult								= "Can't break the system mate",
	MaximumPay							= "Maximum amount is " .. CURRENCY .. "%s. Please don't break our economy.",
	MinimumPay							= "Minimum amount is " .. CURRENCY .. "1",
	PayRateLimit						= "YOU JUST GOT RATE LIMITED! %s Seconds Left",

	FactionNameTaken				= "This faction name is already in use!",
	FactionNotExist					= "That faction does not exist!",
	FactionCantDisband			= "Only the faction leader can disband the faction!",
	FactionWrongPass				= "That is not the correct password!",
	FactionCantLeaveLeader	= "You cannot leave the faction as its leader, you must disband it!",
	FactionCantPassword			= "Only the faction leader can re-password the faction!",

	PayDay									= "PayDay! You received " .. CURRENCY .. "%s!",

	DontBuildSpawn					= "Do not build props around spawn.",
	SpawnKill								= "Do not attempt to spawnkill.",
	SpawnCamp								= "Do not attempt to camp in spawn.",

	RaidOngoing							= "There is already a raid ongoing!",
	RaidSelfUnraidable			= "You are not raidable yourself! (%s)",
	RaidTargetUnraidable		= "Your target is not raidable! (%s)",
	RaidOver								= "The raid between %s and %s has ENDED!",
	RaidStart								= "A raid started between %s and %s!",
	RaidTargNoFac						= "You cannot raid a factionless player as a faction!",
	RaidSelfNoFac						= "You cannot raid a faction as a factionless player!",
	RaidNoFaction						= "You cannot use faction functions during a raid!",
	CantRaidSelf						= "You can't raid yourself or your faction!",

	CannotPurchaseRaid			= "You cannot purchase that in a raid!",

	NoPrinters							= "Not enough raidable printers!",
	OnCoolDown							= "Currently on CoolDown from being raided!",
	OnItemCoolDown						= "Currently on CoolDown from using %s!",

	PayOutOwner							= "You got " .. CURRENCY .. "%s for the destruction of your %s!",
	PayOut									= "You got " .. CURRENCY .. "%s for destroying a %s!",

	SteroidEffect						= "You feel full of energy...",
	SteroidRemove						= "Your energy passes...",
	RegenEffect							= "You feel your wounds healing by themselves...",
	RegenRemove							= "Your flesh ceases to heal...",
	PainKillerEffect				= "You feel no pain...",
	PainKillerRemove				= "You once again feel pain...",
	AntidoteEffect					= "You feel very healthy, and less afflicted by poison...",
	AntidoteRemove					= "You no longer feel very healthy...",
	AdrenalineEffect				= "YOU FEEL REALLY PUMPED...",
	AdrenalineRemove				= "You no longer feel pumped...",
	DoubleJumpEffect				= "You feel very light...",
	DoubleJumpRemove				= "You suddenly feel like lead...",
	ShieldEffect						= "You feel energy gathering around you...",
	ShieldRemove						= "The energy that previously protected you dissipates...",
	ShieldSave							= "The person you attacked was saved by an energy shield.",
	RageEffect							= "KIIIIIIILLLLLLLLLLLL!!!",
	RageRemove							= "Whoa, that was a bit much wasn't it...",

	PowerFailure						= "NO POWER!",
	HealthFailure						= "CRITICAL DAMAGE!",

	NewSpawnPoint						= "Your new Spawnpoint has been set!",

	UseSpawnMenu						= "Use the BaseWars spawnlist!",
	SpawnMenuMoney					= "You don't have enough money for that.",
	SpawnMenuBuy						= "You bought a(n) \"%s\" for " .. CURRENCY .. "%s.",
	SpawnMenuBuyConfirm			= "Are you sure you want to buy a(n) \"%s\" for " .. CURRENCY .. "%s?",
	SpawnMenuConf						= "Purchase Confirmation",
	DeadBuy									= "Dead people buy nothing.",
	EntLimitReached					= "You have reached the limit of \"%s\"s.",

	StuckText								= "You are stuck inside a wall, prop, or player! Remain calm and press [%s], if it does not work press [%s].",

	MainMenuControl					= "F3 - Open Main Menu (Rules, Factions, Raids)",
	SpawnMenuControl				= " - Open Buy Menu (Entities, Weapons)", -- Key is detected automatically, do not add one.
	KarmaText								= "Your Karma is currently %s",
	LevelText               = "Level: %s",
	XPText                  = "%s/%s XP",

	AFKFor									= "You have been away for",
	RespawnIn								= "You can respawn in",

	UpgradeNoMoney					= "You don't have enough money to upgrade!",
	UpgradeMaxLevel					= "You can't upgrade this printer any more!",

	WelcomeBackCrash				= "Welcome back, the last time you played we crashed.",
	Refunded								= "You have been refunded " .. CURRENCY .. "%s.",

	GivenMoney							= "%s gave you " .. CURRENCY .. "%s.",
	GaveMoney								= "You gave %s " .. CURRENCY .. "%s.",

	BountyNotEnoughMoney		= "You don't have enough money to place a bounty.",
	BountyInFaction				= "You can't put a bounty on a faction member.",
	BountyIsFriend				= "You can't put a bounty on friends.",
	BountyOnSelf				= "You can't put a bounty on yourself.",

	InvalidPlayer						= "Invalid Player!",
	InvalidAmount						= "Invalid Amount!",
	TooPoor									= "You're too poor for this transaction!",

	BaseWarsMenu						= "BaseWars Menu",
	Factions								= "Factions",
	Faction									= "Faction",
	Player									= "Player",
	Raids										= "Raids",
	Rules										= "Rules",
	NoFaction								= "<NONE>",

	ConfirmLeave						= [[
Are you sure you want to leave this faction?
If you are the leader of it, it will be disbanded!]],
	JoinWarning							= [[
Note: if you're the leader of a faction, joining another faction will disband your old one.]],
	CreateNotice						= [[
Warning: Creating a faction has a few caveats:
- You cannot create factions during a raid.
- If you are a leader of an existing faction, that faction will be disbanded.
Please proceed with caution.]],

	CreateFaction						= "Create Faction",
	FactionName							= "Faction name",
	FactionPassword					= "Password (optional)",

	Create									= "CREATE",
	Nevermind								= "NEVERMIND",

	JoinFaction							= "Join Faction",
	Join										= "JOIN",

	LeaveFaction						= "Leave Faction",
	Leave										= "LEAVE",

	YouNotFaction						= "You're not currently in a faction.",
	YourFaction							= "Your faction: ",

	StartRaid								= "Start Raid",
	ConceedRaid							= "Concede Raid",

	Use											= "Use",
	Collect									= "Collect",
	Activate								= "Activate",
	LookAt									= "Look At",
	Drink										= "Drink",
	TalkTo									= "Talk to",

	Door										= "Door",
	Money										= "Money",
	Drug										= "Drug",
	Soda										= "Soda",
	HelpNPC									= "Help NPC",
	Spawnpoint							= "Spawnpoint",
	Defusing								= "Defusing...",
	Plant										= "Plant",
	Defuse									= "Defuse",

	Entities								= "Entities",
	Loadout									= "Loadout",
	BaseWarsSpawnlist				= "BaseWars Spawnlist",
	CategoryLeft						= "Click on a category to the left.",

	PrinterBeen							= "This printer has been",
	Disabled								= "DISABLED",
	Cash										= "CASH",
	MaxLevel								= "!Max Level!",
	Paper										= "Paper: %s sheets",
	UntilFull								= "%s until full",
	Full										= "FULL",
	NextUpgrade							= "NEXT UPGRADE: %s",

	HoursShort							= "h",
	MinutesShort						= "m",
	SecondsShort						= "s",

	VS											= " vs ",
}

BaseWars.LANG.__LANGUAGELOOK.GERMAN = {
	Numbers = {
        [20] = {10^6, "Million"},
        [19] = {10^9, "Milliarde"},
        [18] = {10^12, "Billion"},
        [17] = {10^15, "Billiarde"},
        [16] = {10^18, "Trillion"},
        [15] = {10^21, "Trilliarde"},
        [14] = {10^24, "Quadrillion"},
        [13] = {10^27, "Quadrilliarde"},
        [12] = {10^30, "Quintillion"},
        [11] = {10^33, "Quintilliarde"},
        [10] = {10^36, "Sextillion"},
        [9] = {10^39, "Sextilliarde"},
        [8] = {10^42, "Septillion"},
        [7] = {10^45, "Septilliarde"},
        [6] = {10^48, "Oktillion"},
        [5] = {10^51, "Oktilliarde"},
        [4] = {10^54, "Nonillion"},
        [3] = {10^57, "Nonilliarde"},
        [2] = {10^60, "Dezillion"},
        [1] = {10^63, "Dezilliarde"},
	},

	CURFORMER								= CURRENCY .. "%s",
	CURRENCY								= CURRENCY,

	Yes											= "Ja",
	No											= "Nein",
	Level										= "Level",
	Remaining								= "Verbleibend",
	Seconds									= "Sekunden",
	Mins										= "Minuten",
	You											= "Du",

	NaNResult								= "Breche das system nicht, mate",
	MaximumPay							= "Maximale Menge ist " .. CURRENCY .. "%s. Bitte zerstör unser Währungsystem nicht.",
	MinimumPay							= "Minimale Menge ist " .. CURRENCY .. "1",
	PayRateLimit						= "Du wurdest limitiert! %s Seconds Left",

	FactionNameTaken				= "Dieser Fraktions Name ist bereits in benutzung!",
	FactionNotExist					= "Diese Fraktion existiert nicht!",
	FactionCantDisband			= "Nur der Fraktionsleiter kann die Fraktion auflösen!",
	FactionWrongPass				= "Das Password ist nicht korrekt!",
	FactionCantLeaveLeader	= "Du kannst nicht die Fraktion verlassen! Du musst sie auflösen!",
	FactionCantPassword			= "Nur der Fraktionsleiter kann das Password ändern!",

	PayDay									= "Zahltag! Du hast " .. CURRENCY .. "%s bekommen!",

	DontBuildSpawn					= "Baue keine Props am Spawn.",
	SpawnKill								= "Versuche keine Spawnkills zumachen.",
	SpawnCamp								= "Versuche nicht zu Spawncampen.",

	RaidOngoing							= "Es wird bereits ein Raid ausgeführt!",
	RaidSelfUnraidable			= "Du kannst dich nicht selbst raiden! (%s)",
	RaidTargetUnraidable		= "Dein Ziel ist nicht raidbar! (%s)",
	RaidOver								= "Der Raid zwischen %s und %s ist beendet!",
	RaidStart								= "Ein Raid zwischen %s and %s wurde gestartet!",
	RaidTargNoFac						= "Du kannst als Fraktion nicht einen Fraktionslosen Spieler raiden!",
	RaidSelfNoFac						= "Du kannst als Spieler keine Fraktion raiden!",
	RaidNoFaction						= "Du kannst keine Fraktion Funktionen nutzen wärend eines Raids!",
	CantRaidSelf						= "Du kannst nicht dich selbst oder deine Faktion raiden!",

	CannotPurchaseRaid			= "Du kannst nichts während eines Raids kaufen!",

	NoPrinters							= "Es sind nicht genügend raidbare Printer verfügbar!",
	OnCoolDown							= "Momentan läuft ein cooldown vom letzten raid!",

	PayOutOwner							= "Du hast " .. CURRENCY .. "%s für die Zerstörung deiner Struktur %s erhalten!",
	PayOut									= "Du hast " .. CURRENCY .. "%s bekommen für die Zerstörung von %s bekommen!",

	SteroidEffect						= "Du fühlst dich voller Kraft...",
	SteroidRemove						= "Deine Kraft verlässt dich...",
	RegenEffect							= "Du fühlst eine Kraft die dich heilt...",
	RegenRemove							= "Die selbstheilende Kraft ist verschwunden...",
	PainKillerEffect				= "Du fühlst keine Schmerzen...",
	PainKillerRemove				= "Du fühlst wieder Schmerzen...",
	AntidoteEffect					= "Du fühlst dich sehr Gesund und weniger von Gift vergiftet...",
	AntidoteRemove					= "Du fühlst dich nicht mehr so Gesund ...",
	AdrenalineEffect				= "Du fühlst dich aufgepumpt...",
	AdrenalineRemove				= "Du fühlst dich nicht mehr länger aufgepumpt...",
	DoubleJumpEffect				= "Du fühlst dich sehr leicht...",
	DoubleJumpRemove				= "Du fühlst dich wieder schwer...",
	ShieldEffect						= "Du spürst, wie sich Energie um dich sammelt...",
	ShieldRemove						= "Du spürst, wie sich die Energie wieder verschwinded...",
	ShieldSave							= "Die Person die du angreifts hat einen Schild.",
	RageEffect							= "KIIIIIIILLLLLLLLLLLL!!!", -- I think it's in german the same xD
	RageRemove							= "Du fühlst dich nicht mehr so agressiv...",

	PowerFailure						= "Keine Energie!",
	HealthFailure						= "Kritischer Schaden!",

	NewSpawnPoint						= "Dein neuer Spawnpoint wurde gesetzt!",

	UseSpawnMenu						= "Benutze die BaseWars Spawnliste!",
	SpawnMenuMoney					= "Du hast nicht genung Geld dafür.",
	SpawnMenuBuy						= "Du hast \"%s\" für " .. CURRENCY .. "%s gekauft,",
	SpawnMenuBuyConfirm			= "Bist du sicher dass du \"%s\" für " .. CURRENCY .. "%s kaufen möchtest?",
	SpawnMenuConf						= "Kauf bestätigen",
	DeadBuy									= "Töte Personen können nichts kaufen.",
	EntLimitReached					= "Du hast dass Limit von \"%s\"s ist erreicht.",

	StuckText								= "You are stuck inside a wall, prop, or player! Remain calm and press [%s], if it does not work press [%s].",

	MainMenuControl					= "F3 - Öffnet das Hauptmenü (Regeln, Fraktion, Raids)",
	SpawnMenuControl				= " - Öffnet das Kaufmenü (Entities, Weapons)", -- Key is detected automatically, do not add one.
	KarmaText								= "Dein Karma beträgt %s",
	LevelText               = "Level: %s",
	XPText                  = "%s/%s XP",

	AFKFor									= "You have been away for",
	RespawnIn								= "You can respawn in",

	UpgradeNoMoney					= "Du hast nicht genung Geld für das Upgrade!",
	UpgradeMaxLevel					= "Du kannst diesen Printer nicht mehr Upgraden!",

	WelcomeBackCrash				= "Wilkommen zurück, hier bekommst du deine erstattung für den Crash.",
	Refunded								= "Du wurde " .. CURRENCY .. "%s.",

	GivenMoney							= "Du hast von %s " .. CURRENCY .. "%s geschenkt bekommen.",
	GaveMoney								= "Du hast %s " .. CURRENCY .. "%s geschenkt.",

	BountyNotEnoughMoney		= "Du hast nicht genung Geld .",

	InvalidPlayer						= "Dieser Spieler existiert nicht!",
	InvalidAmount						= "Nicht verfügbare Summe!",
	TooPoor									= "Du bist zu Arm für diese Transaktion!",

	BaseWarsMenu						= "BaseWars Menü",
	Factions								= "Fraktionen",
	Faction									= "Faktion",
	Player									= "Spieler",
	Raids										= "Raids",
	Rules										= "Regeln",
	NoFaction								= "<NONE>",

	ConfirmLeave						= [[
Willst du wirklich die Fraktion verlassen?
Wenn du der Leiter bist wird die Fraktion aufgelöst!]],
	JoinWarning							= [[
Note: Wenn du ein Leiter einer Fraktion bist wird deine alte aufgelöst.]],
	CreateNotice						= [[
Warning: 	:
- Du kannst während eines Raids keine Fraktion gründen.
- Wenn du der Leiter einer Fraktion bist wird deine alte Faktion aufgelöst.
Bitte gehe mit Vorsicht vor.]],

	CreateFaction						= "Fraktion erstellen",
	FactionName							= "Fraktions Name",
	FactionPassword					= "Passwort (optional)",

	Create									= "ERSTELLEN",
	Nevermind								= "NEVERMIND",

	JoinFaction							= "Fraktion beitreten",
	Join										= "Beitreten",

	LeaveFaction						= "Fraktion verlassen",
	Leave										= "Verlassen",

	YouNotFaction						= "Du bist momentan in keiner Fraktion.",
	YourFaction							= "Du bist in der Fraktion: ",

	StartRaid								= "Start Raid",
	ConceedRaid							= "Raid aufgeben",

	Use											= "Benutzen",
	Collect									= "Sammeln",
	Activate								= "Aktievieren",
	LookAt									= "Schaue auf",
	Drink										= "Trink",
	TalkTo									= "Rede zu",

	Door										= "Tür",
	Money										= "Geld",
	Drug										= "Droge",
	Soda										= "Soda",
	HelpNPC									= "Help NPC",
	Spawnpoint							= "Spawnpoint",
	Defusing								= "Entschärfen...",
	Plant										= "Plaziere",
	Defuse									= "Entschärfen",

	Entities								= "Entities",
	Loadout									= "Bewaffnung",
	BaseWarsSpawnlist				= "BaseWars Spawnlist",
	CategoryLeft						= "Klicke links auf eine Kategorie.",

	PrinterBeen							= "Dieser Drucker ist",
	Disabled								= "Defekt",
	Cash										= "Geld",
	MaxLevel								= "!Max Level!",
	Paper										= "Papier: %s anzahl",
	UntilFull								= "voll in %s",
	Full										= "Voll! ",
	NextUpgrade							= "NAECHSTES UPGRADE: %s",
	HoursShort							= "h",
	MinutesShort						= "m",
	SecondsShort						= "s",

	VS											= " vs ",
}

BaseWars.LANG.__LANGUAGELOOK.DUTCH = {
	Numbers = {
        [20] = {10^6, "Miljoen"},
        [19] = {10^9, "Miljard"},
        [18] = {10^12, "Biljoen"},
        [17] = {10^15, "Biljard"},
        [16] = {10^18, "Triljoen"},
        [15] = {10^21, "Triljard"},
        [14] = {10^24, "Quadriljoen"},
        [13] = {10^27, "Quadriljard"},
        [12] = {10^30, "Quintiljoen"},
        [11] = {10^33, "Quintiljard"},
        [10] = {10^36, "Sextiljoen"},
        [9] = {10^39, "Sextiljard"},
        [8] = {10^42, "Septiljoen"},
        [7] = {10^45, "Septiljard"},
        [6] = {10^48, "Octiljoen"},
        [5] = {10^51, "Octiljard"},
        [4] = {10^54, "Noniljoen"},
        [3] = {10^57, "Noniljard"},
        [2] = {10^60, "Deciljoen"},
        [1] = {10^63, "Deciljard"},
	},

	CURFORMER								= CURRENCY .. "%s",
	CURRENCY								= CURRENCY,

	Yes											= "Ja",
	No											= "Nee",
	Level										= "Level",
	Remaining								= "Overgebleven",
	Seconds									= "Seconden",
	Mins										= "Minuten",
	You											= "Je",

	NaNResult								= "Can't break the system mate",
	MaximumPay							= "Het maximale bedrag is " .. CURRENCY .. "%s. Breek onze economie niet alstublieft.",
	MinimumPay							= "Het minimale bedrag is " .. CURRENCY .. "1",
	PayRateLimit						= "Niet zo snel! Nog %s seconden te gaan",

	FactionNameTaken				= "Deze factie naam is al in gebruik!",
	FactionNotExist					= "Deze factie bestaat niet!",
	FactionCantDisband			= "Alleen de factie leider kan de factie verwijderen!",
	FactionWrongPass				= "Dat is niet het correcte passwoord!",
	FactionCantLeaveLeader	= "Je kan de factie niet verlaten omdat je de leider bent, je moet het verwijderen!",
	FactionCantPassword			= "Alleen de factie leider kan het wachtwoord aanpassen!",

	PayDay									= "Jackpot! Je krijgt " .. CURRENCY .. "%s!",

	DontBuildSpawn					= "Plaats geen props rond de spawn.",
	SpawnKill								= "Probeer niet te spawnkillen.",
	SpawnCamp								= "Probeer niet te spawncampen.",

	RaidOngoing							= "Er is al een raid aan de gang!",
	RaidSelfUnraidable			= "Je bent zelf niet raidable! (%s)",
	RaidTargetUnraidable		= "Je doelwit is niet raidable! (%s)",
	RaidOver								= "De raid tussen %s en %s is afgelopen!",
	RaidStart								= "Er is een raid gestart tussen %s en %s!",
	RaidTargNoFac						= "Je kan geen factieloze speler raiden als een factie!",
	RaidSelfNoFac						= "Je kan geen factie raiden zonder je eigen factie!",
	RaidNoFaction						= "Je kan geen factie functies gebruiken tijdens een raid!",
	CantRaidSelf						= "Je kan jezelf of je factie niet raiden!",

	CannotPurchaseRaid			= "Dat kan je niet kopen in een raid!",

	NoPrinters							= "Niet genoeg raidable printers!",
	OnCoolDown							= "Momenteel op cooldown omdat hij laatst al geraid is!",

	PayOutOwner							= "Je hebt " .. CURRENCY .. "%s gekregen voor het vernietigen van %s!",
	PayOut									= "Je hebt " .. CURRENCY .. "%s voor het vernietigen van %s!",

	SteroidEffect						= "Je voelt je vol met energie",
	SteroidRemove						= "Je energie is op",
	RegenEffect							= "Je wonden beginnen zichzelf te helen",
	RegenRemove							= "Je wonden worden niet meer geheeld",
	PainKillerEffect				= "Je voelt geen pijn",
	PainKillerRemove				= "Je voelt weer pijn",
	AntidoteEffect					= "Je voelt je heel gezond en minder aangetast door gif",
	AntidoteRemove					= "Je voelt je ziek",
	AdrenalineEffect				= "Je voelt je heel opgefokt",
	AdrenalineRemove				= "Je voelt je nier meer opgefokt",
	DoubleJumpEffect				= "Je voelt je vederlicht",
	DoubleJumpRemove				= "Je voelt je plots loodzwaar",
	ShieldEffect						= "Je voelt een soort energie rondom je",
	ShieldRemove						= "De energie die je beschermde trekt weg",
	ShieldSave							= "De persoon die je probeerde te doden werdt gered door een energie schild.",
	RageEffect							= "KIIIIIIILLLLLLLLLLLL!!!",
	RageRemove							= "Whoa, dat was een beetje overdreven",

	PowerFailure						= "GEEN STROOM!",
	HealthFailure						= "KRITIEKE SCHADE!",

	NewSpawnPoint						= "Je nieuwe Spawnpoint is ingesteld!",

	UseSpawnMenu						= "Gebruik de BaseWars spawnlist!",
	SpawnMenuMoney					= "Je hebt hier niet genoeg geld voor.",
	SpawnMenuBuy						= "Je hebt een \"%s\" gekocht voor " .. CURRENCY .. "%s.",
	SpawnMenuBuyConfirm			= "Weet je zeker dat je een \"%s\" wilt kopen voor " .. CURRENCY .. "%s?",
	SpawnMenuConf						= "Aankoopbevestiging",
	DeadBuy									= "Dode mensen kopen niks.",
	EntLimitReached					= "Je hebt de limiet bereikt van \"%s\"s.",

	StuckText								= "Je zit vast in een muur, prop of speler! Blijf kalm en druk op [CTRL], als dat niet werkt druk op [SPATIE].",

	MainMenuControl					= "F3 - Open Main Menu (Rules, Factions, Raids)",
	SpawnMenuControl				= " - Open Buy Menu (Entities, Weapons)", -- Key is detected automatically, do not add one.
	KarmaText								= "Je karma is momenteel %s",
	LevelText               = "Level: %s",
	XPText                  = "%s/%s XP",

	AFKFor									= "Je bent weg geweest voor",
	RespawnIn								= "Je kan respawnen in",

	UpgradeNoMoney					= "Je hebt niet genoeg geld om te upgraden!",
	UpgradeMaxLevel					= "Je kan deze printer niet meer upgraden!",

	WelcomeBackCrash				= "Welkom terug, de laatste keer dat je hier was is de server gecrasht.",
	Refunded								= "Je hebt " .. CURRENCY .. "%s terug gekregen.",

	GivenMoney							= "%s heeft je " .. CURRENCY .. "%s gegeven.",
	GaveMoney								= "Je geeft %s " .. CURRENCY .. "%s.",

	BountyNotEnoughMoney		= "Je hebt niet genoeg geld om een premie te zetten.",

	InvalidPlayer						= "Ongeldige speler!",
	InvalidAmount						= "Ongeldig aantal!",
	TooPoor									= "Je hebt niet genoeg geld hiervoor!",

	BaseWarsMenu						= "BaseWars Menu",
	Factions								= "Facties",
	Faction									= "Factie",
	Player									= "Speler",
	Raids										= "Raids",
	Rules										= "Regels",
	NoFaction								= "<GEEN>",

	ConfirmLeave						= [[
Weet je dat zeker dat je uit deze factie wilt gaan?
Als je de leider bent, wordt de factie vernietigt!]],
	JoinWarning							= [[
Waarschuwing: Als je de leider van een factie bent, wordt je oude factie vernietigt als je een nieuwe factie joint.]],
	CreateNotice						= [[
Waarschuwing: Een factie maken heeft een paar nadelen:
- Je kan geen factie maken tijdens een raid.
- Als je de leider bent van een bestaande factie, dan wordt die factie vernietigt.
Je bent gewaarschuwd.]],

	CreateFaction						= "Creëer Factie",
	FactionName							= "Factie naam",
	FactionPassword					= "Wachtwoord (Optioneel)",

	Create									= "CREËER",
	Nevermind								= "LAAT MAAR",

	JoinFaction							= "Join Factie",
	Join										= "JOIN",

	LeaveFaction						= "Verlaat Faction",
	Leave										= "VERLAAT",

	YouNotFaction						= "Je bent momenteel niet in een factie.",
	YourFaction							= "Jouw factie: ",

	StartRaid								= "Start Raid",
	ConceedRaid							= "Stop Raid",

	Use											= "Gebruik",
	Collect									= "Verzamel",
	Activate								= "Activeer",
	LookAt									= "Kijk naar",
	Drink										= "Drink",
	TalkTo									= "Praat met",

	Door										= "Deur",
	Money										= "Geld",
	Drug										= "Drug",
	Soda										= "Frisdrank",
	HelpNPC									= "Helper",
	Spawnpoint							= "Spawnpoint",
	Defusing								= "Ontmantelen...",
	Plant										= "Plant",
	Defuse									= "Ontmantel",

	Entities								= "Constructies",
	Loadout									= "Uitrusting",
	BaseWarsSpawnlist				= "BaseWars Spawnlijst",
	CategoryLeft						= "Klik op een categorie aan de linkerzijde.",

	PrinterBeen							= "Deze printer is",
	Disabled								= "GEDEACTIVEERD",
	Cash										= "GELD",
	MaxLevel								= "!Max Level!",
	Paper										= "Papier: %s vellen",
	UntilFull								= "%s tot vol",
	Full										= "VOL",
	NextUpgrade							= "Volgende upgrade: %s",

	HoursShort							= "h",
	MinutesShort						= "m",
	SecondsShort						= "s",

	VS											= " vs ",
}

BaseWars.LANG.__LANGUAGELOOK.SPANISH = {
	Numbers = {
        [20] = {10^6, "Millón"},
        [19] = {10^9, "Mil millones"},
        [18] = {10^12, "Billón"},
        [17] = {10^15, "Mil billones"},
        [16] = {10^18, "Trillón"},
        [15] = {10^21, "Mil trillones"},
        [14] = {10^24, "Cuatrillón"},
        [13] = {10^27, "Mil cuatrillones"},
        [12] = {10^30, "Quintillón"},
        [11] = {10^33, "Mil quintillones"},
        [10] = {10^36, "Sextillón"},
        [9] = {10^39, "Mil sextillones"},
        [8] = {10^42, "Septillón"},
        [7] = {10^45, "Mil septillones"},
        [6] = {10^48, "Octillón"},
        [5] = {10^51, "Mil octillones"},
        [4] = {10^54, "Nonillón"},
        [3] = {10^57, "Mil nonillones"},
        [2] = {10^60, "Decillón"},
        [1] = {10^63, "Mil decillones"},
	},

	CURFORMER								= "%s" .. CURRENCY,
	CURRENCY								= CURRENCY,

	Yes											= "Sí",
	No											= "No",
	Level										= "Nivel",
	Remaining								= "Restantes",
	Seconds									= "Segundos",
	Mins										= "Minutos",
	You											= "Tú",

	NaNResult								= "Pero... ¿¿que haces??",
	MaximumPay							= "La cantidad máxima es de %s" .. CURRENCY .. ". Por favor, ¡no arruines la economía!",
	MinimumPay							= "La cantidad mínima es de 1" .. CURRENCY .. ".",
	PayRateLimit						= "¡Ay, eso es demasiado rápido! (te quedan %s segundos)",

	FactionNameTaken				= "¡Ya hay otro facción con este nombre!",
	FactionNotExist					= "¡Ese facción no existe!",
	FactionCantDisband			= "¡Sólo el líder de la facción puede disolver la facción!",
	FactionWrongPass				= "!Eso no es la contraseña!",
	FactionCantLeaveLeader	= "¡No puedes salir de la facción sin disolverlo porque eres el líder!",
	FactionCantPassword			= "¡Sólo el líder puede cambiar la contraseña!",

	PayDay									= "PayDay! Has recibido %s" .. CURRENCY .. "!",

	DontBuildSpawn					= "No pongas objetos en el spawn.",
	SpawnKill								= "No intentes matar en el spawn.",
	SpawnCamp								= "No intentes campar en el spawn.",

	RaidOngoing							= "¡Ya está ocurriendo un asedio!",
	RaidSelfUnraidable			= "¡No puedes iniciar un asedio! (%s)",
	RaidTargetUnraidable		= "¡No puedes asediar ese enemigo! (%s)",
	RaidOver								= "El asedio entre %s y %s se ha acabado!",
	RaidStart								= "Un asedio entre %s y %s comenzó!",
	RaidTargNoFac						= "¡No puedes asediar un jugador sin facción, en una facción!",
	RaidSelfNoFac						= "¡No puedes asediar una facción sin estar en una facción!",
	RaidNoFaction						= "¡No puedes usar funcciones de facción en un asedio!",
	CantRaidSelf						= "¡No puedes asediar a ti mismo o tu facción!",

	CannotPurchaseRaid			= "¡No puedes comprar eso en un asedio!",

	NoPrinters							= "No hay suficientes impresoras",
	OnCoolDown							= "Tienes que esperar para asediar esta persona...",

	PayOutOwner							= "Conseguiste %s" .. CURRENCY .. " por la destrucción de tu %s!",
	PayOut									= "Conseguiste %s" .. CURRENCY .. " por destruir el %s!",

	SteroidEffect						= "Te sientes energético...",
	SteroidRemove						= "La energia se fue...",
	RegenEffect							= "Tus heridas se curan magicamente...",
	RegenRemove							= "Tus heridas se paran de curar...",
	PainKillerEffect				= "Ya no sientes dolor...",
	PainKillerRemove				= "El dolor se vuelve...",
	AntidoteEffect					= "Te sientes sano, y más resistente al veneno...",
	AntidoteRemove					= "Ya no te sientes tan sano...",
	AdrenalineEffect				= "SIENTES LA ENERGÍA YENDO POR TUS VENAS...",
	AdrenalineRemove				= "Te sientes sin energía...",
	DoubleJumpEffect				= "Te sientes ligero como una pena...",
	DoubleJumpRemove				= "De repente te sientes como un bloque de plomo...",
	ShieldEffect						= "Sientes una energía misteriosa al rededor...",
	ShieldRemove						= "La energía que te protegía se fue...",
	ShieldSave							= "La persona que atacaste fue salvado por su energía.",
	RageEffect							= "¡¡¡¡¡¡VOY A MATAR A TODOOOOOOS!!!!!",
	RageRemove							= "Uf, eso fue un poco más que debería...",

	PowerFailure						= "¡SIN ENERGÍA!",
	HealthFailure						= "¡DAÑOS MUY GRAVES!",

	NewSpawnPoint						= "Tu nuevo Spawnpoint se ha marcado!",

	UseSpawnMenu						= "Por favor, usa el spawnlist de BaseWars!",
	SpawnMenuMoney					= "No tienes dinero suficiente.",
	SpawnMenuBuy						= "Compraste un(a) \"%s\" por %s" .. CURRENCY .. ".",
	SpawnMenuBuyConfirm			= "¿Seguro que quieres comprar un(a) \"%s\" por %s" .. CURRENCY .. "?",
	SpawnMenuConf						= "Confirmación de compra",
	DeadBuy									= "Los muertos no compran nada.",
	EntLimitReached					= "Has alcanzado el límite de \"%s\".",

	StuckText								= "Estás atrapado en una pared, un objeto, o una persona! Quédate calmo y pulsa [%s]; si eso no funciona pulsa [%s].",

	MainMenuControl					= "F3 - Mostrar Menú Principal (Reglas, Facciones, Asedios)",
	SpawnMenuControl				= " - Mostrar Menú de Compra (Objetos, armas)", -- Key is detected automatically, do not add one.
	KarmaText								= "Tu karma es %s",
	LevelText               = "Nível: %s",
	XPText                  = "%s/%s XP",

	AFKFor									= "No has jugado por",
	RespawnIn								= "Puedes resucitarte en",

	UpgradeNoMoney					= "¡No tienes el dinero suficiente para una mejora!",
	UpgradeMaxLevel					= "¡Ya no puedes mejorar más esta impresora!",

	WelcomeBackCrash				= "Hola de nuevo, el servidor paró de funcionar la ultima vez que jugaste.",
	Refunded								= "Te recompensamos %s" .. CURRENCY .. ".",

	GivenMoney							= "%s te dió %s" .. CURRENCY .. ".",
	GaveMoney								= "Has dado a %s %s" .. CURRENCY .. ".",

	BountyNotEnoughMoney		= "No tienes el dinero suficiente para marcar una recompensa en esta persona.",

	InvalidPlayer						= "¡Ese jugador no existe!",
	InvalidAmount						= "¡Valor inválido!",
	TooPoor									= "¡No tienes el dinero suficiente para completar esta transacción!",

	BaseWarsMenu						= "Menú BaseWars",
	Factions								= "Facciones",
	Faction									= "Facción",
	Player									= "Jugador",
	Raids										= "Asedios",
	Rules										= "Reglas",
	NoFaction								= "<n/d>",

	ConfirmLeave						= [[
¿Seguro que quieres salir de esta facción?
¡La facción se va a disolver si eres el líder!!]],
	JoinWarning							= [[
Nota: si eres el líder de una facción, ese se va a disolver si te juntas a otra facción.]],
	CreateNotice						= [[
Advertencia: Hay que tener cuidado con crear una nueva facción:
- No se puede crear facciones en un asedio.
- Si eres el líder de una facción, ese se va a disolver.
]],

	CreateFaction						= "Crear Facción",
	FactionName							= "Nombre",
	FactionPassword					= "Contraseña (optional)",

	Create									= "CREAR FACCIÓN",
	Nevermind								= "ME EQUIVOQUÉ",

	JoinFaction							= "Juntarse a otra Facción",
	Join										= "JUNTARSE",

	LeaveFaction						= "Salir de la Facción",
	Leave										= "SALIR",

	YouNotFaction						= "No estás en una facción.",
	YourFaction							= "Tu facción: ",

	StartRaid								= "Comenzar Asedio",
	ConceedRaid							= "Acabar Asedio",

	Use											= "Usar",
	Collect									= "Colectar",
	Activate								= "Activar",
	LookAt									= "Mirar a",
	Drink										= "Beber",
	TalkTo									= "Hablar con",

	Door										= "Puerta",
	Money										= "Dinero",
	Drug										= "Droga",
	Soda										= "Bebida gasificada",
	HelpNPC									= "Asistente",
	Spawnpoint							= "Spawnpoint",
	Defusing								= "Desactivando...",
	Plant										= "Plantar",
	Defuse									= "Desactivar",

	Entities								= "Entidades",
	Loadout									= "Loadout",
	BaseWarsSpawnlist				= "BaseWars Spawnlist",
	CategoryLeft						= "Haz clic en una categoría a la izquierda.",

	PrinterBeen							= "Esta impresora ha sido",
	Disabled								= "DESACTIVADO",
	Cash										= "PASTA",
	MaxLevel								= "!MÃ¡x. NÃ­vel!",
	Paper										= "Papel: %s hojas",
	UntilFull								= "%s hasta lleno",
	Full										= "LLENO",
	NextUpgrade							= "PRÓXIMA MEJORA: %s",

	HoursShort							= "h",
	MinutesShort						= "m",
	SecondsShort						= "s",

	VS											= " vs ",
}

BaseWars.LANG.__LANGUAGELOOK.FRENCH = {
	Numbers = {
        [20] = {10^6, "Million"},
        [19] = {10^9, "Milliard"},
        [18] = {10^12, "Billion"},
        [17] = {10^15, "Billiard"},
        [16] = {10^18, "Trillion"},
        [15] = {10^21, "Trilliard"},
        [14] = {10^24, "Quadrillion"},
        [13] = {10^27, "Quadrilliard"},
        [12] = {10^30, "Quintillion"},
        [11] = {10^33, "Quintilliard"},
        [10] = {10^36, "Sextillion"},
        [9] = {10^39, "Sextilliard"},
        [8] = {10^42, "Septillion"},
        [7] = {10^45, "Septilliard"},
        [6] = {10^48, "Octillion"},
        [5] = {10^51, "Octilliard"},
        [4] = {10^54, "Nonillion"},
        [3] = {10^57, "Nonilliard"},
        [2] = {10^60, "Décillion"},
        [1] = {10^63, "Décilliard"},
	},

	CURFORMER								= CURRENCY .. "%s",
	CURRENCY								= CURRENCY,

	Yes											= "Oui",
	No											= "Non",
	Level										= "Niveau",
	Remaining								= "Restant",
	Seconds									= "Secondes",
	Mins										= "Minutes",
	You											= "Vous",

	NaNResult								= "Impossible de détruire le système, mon gars.",
	MaximumPay							= "Le montant maximum est " .. CURRENCY .. "%s. S'il vous plaît ne dérangez pas l'économie.",
	MinimumPay							= "Le montant minimum est " .. CURRENCY .. "1.",
	PayRateLimit						= "Vous venez d'être limité! %s secondes restantes.",

	FactionNameTaken				= "Ce nom de faction est déjà utilisé!",
	FactionNotExist					= "Cette faction n'existe pas!",
	FactionCantDisband			= "Seulement le chef de la faction peut la dissoudre!",
	FactionWrongPass				= "Mot de passe incorrect!",
	FactionCantLeaveLeader	= "Vous ne pouvez pas quitter la faction en tant que chef, vous devez la dissoudre!",
	FactionCantPassword			= "Seul le chef de la faction peut changer le mot de passe de celle-ci!",

	PayDay									= "Jour de paie! Vous avez reçu " .. CURRENCY .. "%s!",

	DontBuildSpawn					= "Ne mettez pas d'objets autour du spawn.",
	SpawnKill								= "N'essayez pas de spawnkill.",
	SpawnCamp								= "N'essayez pas de spawncamp.",

	RaidOngoing							= "Il y a déjà un raid qui se déroule!",
	RaidSelfUnraidable			= "Vous ne pouvez pas être raidé! (%s)",
	RaidTargetUnraidable		= "Vous ne pouvez pas raider cette cible! (%s)",
	RaidOver								= "Le raid entre %s et %s est TERMINÉ!",
	RaidStart								= "Un raid entre %s et %s a COMMENCÉ!",
	RaidTargNoFac						= "Vous ne pouvez pas raid un joueur sans faction en tant que faction!",
	RaidSelfNoFac						= "Vous ne pouvez pas raid une faction en tant que joueur!",
	RaidNoFaction						= "Vous ne pouvez pas utiliser les fonctions d'une faction pendant un raid!",
	CantRaidSelf						= "Vous ne pouvez pas commencer un raid contre vous-même ou votre faction!",

	CannotPurchaseRaid			= "Vous ne pouvez pas acheter ça pendant un raid!",

	NoPrinters							= "Vous n'avez pas assez d'imprimantes raidables!",
	OnCoolDown							= "Vous êtes en ce moment en temps de rechargement pour être raidé!",

	PayOutOwner							= "Vous avez reçu " .. CURRENCY .. "%s pour la destruction de votre %s!",
	PayOut									= "Vous avez reçu " .. CURRENCY .. "%s pour la destruction d'un %s!",

	SteroidEffect						= "Vous vous sentez plein d'énergie...",
	SteroidRemove						= "Votre énergie passe...",
	RegenEffect							= "Vous sentez vos plaies se refermer d'elle-mêmes...",
	RegenRemove							= "Votre chair cesse de se soigner...",
	PainKillerEffect				= "Vous ne sentez plus de douleur...",
	PainKillerRemove				= "Vous ressentez la douleur de nouveau...",
	AntidoteEffect					= "Vous vous sentez en très bonne santé et moins affecté par le poison...",
	AntidoteRemove					= "Vous ne vous sentez plus en très bonne santé...",
	AdrenalineEffect				= "Vous vous sentez puissant(e)...",
	AdrenalineRemove				= "Vous ne vous sentez plus puissant(e)...",
	DoubleJumpEffect				= "Vous vous sentez très léger...",
	DoubleJumpRemove				= "Vous vous sentez soudainement comme du plomb...",
	ShieldEffect						= "Vous sentez de l'énergie se rassemblant autour de vous...",
	ShieldRemove						= "L'énergie qui vous protégeait auparavant se dissipe...",
	ShieldSave							= "La personne que vous avez attaquée a été sauvée par un bouclier d'énergie.",
	RageEffect							= "TUEEEEEEEEEEEEER!!!",
	RageRemove							= "Oulà, j'en ai peut-être fait un peu trop...",

	PowerFailure						= "PLUS D'ÉNERGIE!",
	HealthFailure						= "DOMMAGES CRITIQUES!",

	NewSpawnPoint						= "Votre nouveau point d'apparition a été établi!",

	UseSpawnMenu						= "Utilisez la spawnlist de BaseWars!",
	SpawnMenuMoney					= "Vous n'avez pas assez d'argent pour ça.",
	SpawnMenuBuy						= "Vous avez acheté un(e) \"%s\" pour " .. CURRENCY .. "%s.",
	SpawnMenuBuyConfirm			= "Êtes-vous sûr(e) de vouloir acheter un(e) \"%s\" pour " .. CURRENCY .. "%s?",
	SpawnMenuConf						= "Confirmation d'achat",
	DeadBuy									= "Vous ne pouvez rien acheter en étant mort!",
	EntLimitReached					= "Vous avez atteint la limite de \"%s\"s.",

	StuckText								= "Vous êtes bloqué! Restez calme et appuyez sur [%s], si ça ne fonctionne pas appuyez sur [%s].",

	MainMenuControl					= "F3 - Ouvrir le menu principal (règles, factions, raids)",
	SpawnMenuControl				= " - Ouvrir le menu d'achat (entités, armes)",
	KarmaText								= "Votre karma est actuellement de %s.",
	LevelText            		= "Niveau: %s",
	XPText               		= "%s/%s XP",

	AFKFor									= "Vous étiez absent pendant",
	RespawnIn								= "Vous pouvez réapparaître dans",

	UpgradeNoMoney					= "Vous n'avez pas assez d'argent pour mettre à niveau!",
	UpgradeMaxLevel					= "Vous ne pouvez plus mettre à niveau cette imprimante!",

	WelcomeBackCrash				= "Bon retour, la dernière fois que vous jouiez le serveur a planté.",
	Refunded								= "Vous avez été remboursé de " .. CURRENCY .. " %s.",

	GivenMoney							= "%s vous a donné " .. CURRENCY .. "%s.",
	GaveMoney								= "Vous avez donné à %s un montant de " .. CURRENCY .. "%s.",

	BountyNotEnoughMoney		= "Vous n'avez pas assez d'argent pour placer une prime.",

	InvalidPlayer						= "Joueur invalide!",
	InvalidAmount						= "Montant invalide!",
	TooPoor									= "Vous êtes trop pauvre pour cettre transaction!",

	BaseWarsMenu						= "BaseWars Menu",
	Factions								= "Factions",
	Faction									= "Faction",
	Player									= "Joueur",
	Raids										= "Raids",
	Rules										= "Règles",
	NoFaction								= "<AUCUNE>",

	ConfirmLeave						= [[
Êtes-vous sûr de vouloir quitter cette faction?
Si vous en êtes le leader, elle sera dissoute!]],
	JoinWarning							= [[
Note: si vous êtes le leader d'une faction, en rejoindre une autre dissoudera votre précédente.]],
	CreateNotice						= [[
Avertissement: La création d'une faction est soumise a quelque règles:
- Vous ne pouvez pas créer de faction durant un raid.
- Si vous êtes le leader d'une faction existante, cette faction sera dissoute.
Veuillez procéder avec précaution.]],

	CreateFaction						= "Créer une faction",
	FactionName							= "Nom de la faction:",
	FactionPassword					= "Mot de passe (non-requis)",

	Create									= "CRÉER",
	Nevermind								= "ANNULER", -- hhhhhhhhhhhhhhhhhhhhhhhhhhhh

	JoinFaction							= "Rejoindre la faction",
	Join										= "REJOINDRE",

	LeaveFaction						= "Quitter la faction",
	Leave										= "QUITTER",

	YouNotFaction						= "Vous n'êtes actuellement dans aucune faction.",
	YourFaction							= "Votre faction: ",

	StartRaid								= "Démarrer un raid",
	ConceedRaid							= "Capituler le raid",

	Use											= "Utiliser",
	Collect									= "Récupérer",
	Activate								= "Activer",
	LookAt									= "Regarder à",
	Drink										= "Boire",
	TalkTo									= "Parler à",

	Door										= "Porte",
	Money										= "Argent",
	Drug										= "Drogue",
	Soda										= "Soda",
	HelpNPC									= "PNJ d'aide",
	Spawnpoint							= "Point d'apparition",
	Defusing								= "Désamorcer...",
	Plant										= "Planter",
	Defuse									= "Désamorcer",

	Entities								= "Entités",
	Loadout									= "Équipement",
	BaseWarsSpawnlist				= "Spawnlist BaseWars",
	CategoryLeft						= "Cliquez sur une des catégories sur la gauche.",

	PrinterBeen							= "Cette imprimante a été",
	Disabled								= "DÉSACTIVÉE",
	Cash										= "ARGENT",
	MaxLevel								= "!Niveau Maximum!",
	Paper										= "Papier: %s feuilles",
	UntilFull								= "%s avant le plein",
	Full										= "PLEIN",
	NextUpgrade							= "PROCHAINE MISE À NIVEAU: %s",

	HoursShort							= "h",
	MinutesShort						= "m",
	SecondsShort						= "s",

	VS											= " vs ",
}

BaseWars.LANG.__LANGUAGELOOK.RUSSIAN = {
	Numbers = {
        [20] = {10^6, "Миллион"},
        [19] = {10^9, "Миллиард"},
        [18] = {10^12, "Биллион"},
        [17] = {10^15, "Биллиард"},
        [16] = {10^18, "Триллион"},
        [15] = {10^21, "Триллиард"},
        [14] = {10^24, "Квадриллион"},
        [13] = {10^27, "Квадриллиард"},
        [12] = {10^30, "Квинтиллион"},
        [11] = {10^33, "Квинтиллиард"},
        [10] = {10^36, "Секстиллион"},
        [9] = {10^39, "Секстиллиард"},
        [8] = {10^42, "Септиллион"},
        [7] = {10^45, "Септиллиард"},
        [6] = {10^48, "Октиллион"},
        [5] = {10^51, "Октиллиард"},
        [4] = {10^54, "Нониллион"},
        [3] = {10^57, "Нониллиард"},
        [2] = {10^60, "Дециллион"},
        [1] = {10^63, "Дециллиард"},
	},

	CURFORMER								= "%s" .. CURRENCY,
	CURRENCY								= CURRENCY,

	Yes											= "Да",
	No											= "Нет",
	Level										= "Уровень",
	Remaining								= "Осталось",
	Seconds									= "Секунд",
	Mins										= "Минут",
	You											= "Вы",

	NaNResult								= "Не прокатит, пацан",
	MaximumPay							= "Максимальная сумма - " .. CURRENCY .. "%s. Пожалуйста, не ломайте нашу экономику.",
	MinimumPay							= "Минимальная сумма - " .. CURRENCY .. "1",
	PayRateLimit						= "Хватит спамить! Вы не можете использовать эту комманду %s секунд",

	FactionNameTaken				= "Это название фракции уже используется!",
	FactionNotExist					= "Эта фракция не существует!",
	FactionCantDisband			= "Только лидер фракции может расформировать её!",
	FactionWrongPass				= "Неверный пароль!",
	FactionCantLeaveLeader	= "Вы не можете выйти из фракции будучи лидером, вы должны расформировать её!",
	FactionCantPassword			= "Только лидер фракции может поменять её пароль!",

	PayDay									= "День зарплаты! Вы получили " .. CURRENCY .. "%s!",

	DontBuildSpawn					= "Не стройте на спавне.",
	SpawnKill								= "Не пытайтесь спавнкиллить.",
	SpawnCamp								= "Не пытайтесь кемперить на спавне.",

	RaidOngoing							= "Рейд уже идёт!",
	RaidSelfUnraidable			= "Вас нельзя рейдить! (%s)",
	RaidTargetUnraidable		= "Выбранную цель нельзя рейдить! (%s)",
	RaidOver								= "Рейд между %s и %s ЗАКОНЧИЛСЯ!",
	RaidStart								= "Рейд начался между %s и %s!",
	RaidTargNoFac						= "Вы не можете зарейдить игрока, не состоящего в фракции, будучи фракцией!",
	RaidSelfNoFac						= "Вы не можете зарейдить фракцию, будучи игроком, не состоящим в фракции!",
	RaidNoFaction						= "Вы не можете использовать функции фракции во время рейда!",
	CantRaidSelf						= "Вы не можете зарейдить себя или свою фракцию!",

	CannotPurchaseRaid			= "Вы не можете купить это во время рейда!",

	NoPrinters							= "У вас недостаточно принтеров, необходимых для рейда!",
	OnCoolDown							= "В данный момент не может быть зарейден!",

	PayOutOwner							= "Вы получили " .. CURRENCY .. "%s за уничтожение вашего %s!",
	PayOut									= "Вы получили " .. CURRENCY .. "%s за уничтожение %s!",

	SteroidEffect						= "Вы полны энергии...",
	SteroidRemove						= "Ваша энергия уходит...",
	RegenEffect							= "Ваши раны заживают сами...",
	RegenRemove							= "Ваша плоть перестаёт заживать...",
	PainKillerEffect				= "Вы не чувствуете боли...",
	PainKillerRemove				= "Вы опять чувствуете боль...",
	AntidoteEffect					= "Вы чувствуете себя здоровым, and less afflicted by poison...",
	AntidoteRemove					= "Вы больше не чувствуете себя здоровым...",
	AdrenalineEffect				= "ВАШ УРОВЕНЬ АДРЕНАЛИНА ЗАШКАЛИВАЕТ...",
	AdrenalineRemove				= "Адреналин нормализовался...",
	DoubleJumpEffect				= "Вы не ощущаете своего веса...",
	DoubleJumpRemove				= "Вдруг вы снова чувствуете себя тяжелым...",
	ShieldEffect						= "Энергия скапливается вокруг вас...",
	ShieldRemove						= "Эергия, которая вас защищала рассеивается...",
	ShieldSave							= "Игрок, которого вы атаковали был спасён энергическим щитом.",
	RageEffect							= "УБИВААААААААААААААААААААТЬ!!!",
	RageRemove							= "Охтыжбл, я слегка переборщил, не так ли...",

	PowerFailure						= "НЕТ ЭНЕРГИИ!",
	HealthFailure						= "КРИТИЧЕСКИЙ УРОН!",

	NewSpawnPoint						= "Ваша новая точка спавна была установлена!",

	UseSpawnMenu						= "Используйте меню спавна BaseWars!",
	SpawnMenuMoney					= "У вас недостаточно денег для этого.",
	SpawnMenuBuy						= "Вы купили \"%s\" за " .. CURRENCY .. "%s.",
	SpawnMenuBuyConfirm			= "Вы уверены, что хотите купить \"%s\" за " .. CURRENCY .. "%s?",
	SpawnMenuConf						= "Подтвердить покупку",
	DeadBuy									= "Мертвые не могут покупать.",
	EntLimitReached					= "Вы достигли лимита \"%s\"s.",

	StuckText								= "Вы застряли в стене, пропе или игроке! Cохраняйте спокойствие и нажимайте [%s], если не работает - нажимайте [%s].",

	MainMenuControl					= "F3 - Открыть основное меню (Правила, Фракции, Рейды)",
	SpawnMenuControl				= " - Открыть меню покупок (Объекты, Оружия)", -- Key is detected automatically, do not add one.
	KarmaText								= "Карма: %s",
	LevelText               = "Уровень: %s",
	XPText                  = "%s/%s XP",

	AFKFor									= "Вы АФК",
	RespawnIn								= "Вы сможете возродиться через",

	UpgradeNoMoney					= "У вас не хватает денег на это улучшение!",
	UpgradeMaxLevel					= "Вы больше не можете улучшать этот принтер! (Максимальный уровень)",

	WelcomeBackCrash				= "Добро пожаловать обратно, когда вы играли последний раз сервер упал.",
	Refunded								= "Вам возвратили " .. CURRENCY .. "%s.",

	GivenMoney							= "%s дал вам " .. CURRENCY .. "%s.",
	GaveMoney								= "Вы дали %s " .. CURRENCY .. "%s.",

	BountyNotEnoughMoney		= "У вас недостаточно денег, чтобы поставить награду.",

	InvalidPlayer						= "Несуществующий игрок!",
	InvalidAmount						= "Недопустимая сумма!",
	TooPoor									= "У вас недостаточно денег, чтобы совершить эту операцию!",

	BaseWarsMenu						= "Меню BaseWars",
	Factions								= "Фракции",
	Faction									= "Фракция",
	Player									= "Игрок",
	Raids										= "Рейды",
	Rules										= "Правила",
	NoFaction								= "<НЕТ>",

	ConfirmLeave						= [[
Вы уверены, что хотите покинуть эту фракцию?
Если вы её лидер, она будет расформирована!]],
	JoinWarning							= [[
Внимание: Если вы лидер фракции, вступление в другую фракцию расформирует старую.]],
	CreateNotice						= [[
Внимание: Создание фракции включает в себя пару нюансов:
- Вы не можете создавать фракции находясь в рейде.
- Если вы лидер уже существующей фракции, она будет раформирована.
Пожалуйста, действуйте с осторожностью.]],

	CreateFaction						= "Создать фракцию",
	FactionName							= "Название фракции",
	FactionPassword					= "Пароль (не обязательно)",

	Create									= "СОЗДАТЬ",
	Nevermind								= "ОТМЕНА",

	JoinFaction							= "Вступить в фракцию",
	Join										= "ВСТУПИТЬ",

	LeaveFaction						= "Покинуть фракцию",
	Leave										= "ПОКИНУТЬ",

	YouNotFaction						= "На данный момент вы не состоите в фракции.",
	YourFaction							= "Ваша фракция: ",

	StartRaid								= "Начать рейд",
	ConceedRaid							= "Сдаться",

	Use											= "Использовать",
	Collect									= "Подобрать",
	Activate								= "Активировать",
	LookAt									= "Посмотреть на",
	Drink										= "Выпить",
	TalkTo									= "Говорить с",

	Door										= "Дверь",
	Money										= "Деньги",
	Drug										= "Наркотик",
	Soda										= "Газировка",
	HelpNPC									= "NPC-помощник",
	Spawnpoint							= "Точка спавна",
	Defusing								= "Обезвреживаю...",
	Plant										= "Заложить",
	Defuse									= "Обезвреживать",

	Entities								= "Объекты",
	Loadout									= "Снаряжения",
	BaseWarsSpawnlist				= "Спавнлист BaseWars",
	CategoryLeft						= "Нажмите на категорию слева.",

	PrinterBeen							= "Этот принтер был",
	Disabled								= "ОТКЛЮЧЕН",
	Cash										= "Бабло",
	MaxLevel								= "!Максимальный уровень!",
	Paper										= "Бумага: %s листов",
	UntilFull								= "%s до полного",
	Full										= "ПОЛНЫЙ",
	NextUpgrade							= "СЛЕДУЮЩЕЕ УЛУЧШЕНИЕ: %s",

	HoursShort							= "ч",
	MinutesShort						= "м",
	SecondsShort						= "с",

	VS											= " vs ",
}

BaseWars.LANG.__LANGUAGELOOK.KOREAN = {
	Numbers = {
        [20] = {10^6, "백만"},
        [19] = {10^9, "십억"},
        [18] = {10^12, "조"},
        [17] = {10^15, "천조"},
        [16] = {10^18, "백조"},
        [15] = {10^21, "천백조"},
        [14] = {10^24, "십경"},
        [13] = {10^27, "백경"},
        [12] = {10^30, "천백경"},
        [11] = {10^33, "십자"},
        [10] = {10^36, "백자"},
        [9] = {10^39, "천백자"},
        [8] = {10^42, "십양"},
        [7] = {10^45, "백양"},
        [6] = {10^48, "천백양"},
        [5] = {10^51, "십구"},
        [4] = {10^54, "백구"},
        [3] = {10^57, "천백구"},
        [2] = {10^60, "십정"},
        [1] = {10^63, "백정"},
	},

	CURFORMER								= CURRENCY .. "%s",
	CURRENCY								= CURRENCY,

	Yes											= "네",
	No											= "아니오",
	Level										= "레벨",
	Remaining								= "남음",
	Seconds									= "초",
	Mins										= "분",
	You											= "당신",

	NaNResult								= "Can't break the system mate",
	MaximumPay							= "Maximum amount is " .. CURRENCY .. "%s. Please don't break our economy.",
	MinimumPay							= "Minimum amount is " .. CURRENCY .. "1",
	PayRateLimit						= "YOU JUST GOT RATE LIMITED! %s Seconds Left",

	FactionNameTaken				= "해당 이름은 현재 사용중입니다!",
	FactionNotExist					= "해당 세력은 존재하지 않습니다!",
	FactionCantDisband			= "세력의 리더만 세력을 해체 할 수 있습니다!",
	FactionWrongPass				= "비밀번호가 잘못되었습니다!",
	FactionCantLeaveLeader	= "당신은 세력의 리더이기 때문에 세력을 해체하기 전엔 세력을 나갈 수 없습니다!",
	FactionCantPassword			= "세력의 리더만 비밀번호를 바꿀수 있습니다!",

	PayDay									= "월급날! 당신은 " .. CURRENCY .. "%s를 받았습니다!",

	DontBuildSpawn					= "스폰지점 인근에서는 프롭을 소환할 수 없습니다.",
	SpawnKill								= "스폰킬을 하지마세요.",
	SpawnCamp								= "스폰캠핑을 하지마세요.",

	RaidOngoing							= "이미 레이드가 진행중입니다!",
	RaidSelfUnraidable			= "자기자신에게 레이드를 걸수없습니다! (%s)",
	RaidTargetUnraidable		= "해당 타겟은 레이드가 불가능합니다! (%s)",
	RaidOver								= "%s 와 %s간의 레이드가 종료되었습니다!",
	RaidStart								= "%s 와 %s간의 레이드가 시작되었습니다!",
	RaidTargNoFac						= "세력을 가진 플레이어는 무소속 플레이어에게 레이드를 걸 수 없습니다!",
	RaidSelfNoFac						= "무소속 플레이어는 세력을 가진 플레이어에게 레이드를 걸 수 없습니다!",
	RaidNoFaction						= "레이드 진행중에는 세력 속성을 사용 할 수 없습니다!",
	CantRaidSelf						= "자신의 세력에게는 레이드를 걸 수 없습니다!",

	CannotPurchaseRaid			= "레이드 진행중에는 해당 상품을 구매 할 수 없습니다!",

	NoPrinters							= "레이드를 진행하기 위해선 더 많은 돈복사기가 필요합니다!",
	OnCoolDown							= "아직 쿨타임 시간이 끝나지 않아서 레이드를 진행 할 수 없습니다!",

	PayOutOwner							= "물건을 판매하여 " .. CURRENCY .. "%s 가 입금되었습니다. (판매한 물건: %s)",
	PayOut									= "물건이 파괴되어 " .. CURRENCY .. "%s 가 입금되었습니다 (파괴된 물건: %s)",

	SteroidEffect						= "점점 힘이 차오른다...",
	SteroidRemove						= "점점 힘이 빠진다...",
	RegenEffect							= "점점 갑빠가 단단해진다...",
	RegenRemove							= "갑빠가 다시 물렁해진다...",
	PainKillerEffect				= "점점 통증이 사라진다...",
	PainKillerRemove				= "다시 통증이 찾아온다...",
	AntidoteEffect					= "몸이 점점 건강해진다...",
	AntidoteRemove					= "점점 피로가 찾아온다...",
	AdrenalineEffect				= "점점 움직임이 민첩해진다...",
	AdrenalineRemove				= "점점 움직임이 둔해진다...",
	DoubleJumpEffect				= "몸이 가벼워 진다...",
	DoubleJumpRemove				= "몸이 다시 무거워 진다...",
	ShieldEffect						= "주변에서 에너지장이 차오르는걸 느낀다...",
	ShieldRemove						= "주변에 있던 에너지장이 점점 빠져나간다...",
	ShieldSave							= "방어 매트릭스 가동!",
	RageEffect							= "죽어!!!!!",
	RageRemove							= "방금 뭔일이 있었나...",

	PowerFailure						= "전원 없음!",
	HealthFailure						= "심각한 손상!",

	NewSpawnPoint						= "새로운 스폰포인트가 설정되었습니다!",

	UseSpawnMenu						= "베이스워즈 스폰메뉴를 사용합니다!",
	SpawnMenuMoney					= "자금이 충분하지가 않습니다.",
	SpawnMenuBuy						= "\"%s\" 를 " .. CURRENCY .. "%s에 구입하였습니다.",
	SpawnMenuBuyConfirm			= "정말로 \"%s\" 를 " .. CURRENCY .. "%s에 구입하시겠습니까?",
	SpawnMenuConf						= "구매 확인",
	DeadBuy									= "사망 상태에서는 구매가 불가능합니다.",
	EntLimitReached					= "\"%s\"를 더이상 구매 할 수 없습니다.",

	StuckText								= "맵이나 프롭, 플레이어에 끼인것 같습니다 [%s]를 눌러주세요, 만약 안되면 [%s]를 눌러주세요.",

	MainMenuControl					= "F3 - 메인메뉴 열기 (규칙, 세력, 레이드)",
	SpawnMenuControl				= " - 구매메뉴 열기 (물건, 무기)", -- Key is detected automatically, do not add one.
	KarmaText								= "현재 카르마 수치: %s",
	LevelText               = "레벨: %s",
	XPText                  = "경험치: %s/%s",

	AFKFor									= "당신이 자리를 비운 시간: ",
	RespawnIn								= "리스폰까지 남은 시간: ",

	UpgradeNoMoney					= "업그레이드를 위해선 더 많은 돈이 필요합니다!",
	UpgradeMaxLevel					= "최대레벨이라 더 이상 업그레이드가 불가능합니다!",

	WelcomeBackCrash				= "죄송합니다. 서버에 오류가 발생하였습니다.",
	Refunded								= "" .. CURRENCY .. "%s만큼 환불받았습니다.",

	GivenMoney							= "%s가 " .. CURRENCY .. "%s만큼 송금했습니다.",
	GaveMoney								= "%s에게 " .. CURRENCY .. "%s만큼 송금했습니다.",

	BountyNotEnoughMoney		= "현상금을 걸만큼 충분한 자금이 없습니다.",

	InvalidPlayer						= "존재하지 않는 플레이어입니다!",
	InvalidAmount						= "잘못된 값입니다!",
	TooPoor									= "이 거래를 하기 위해서는 더 많은 자금이 필요합니다!",

	BaseWarsMenu						= "베이스워즈 메뉴",
	Factions								= "세력",
	Faction									= "세력",
	Player									= "플레이어",
	Raids										= "레이드",
	Rules										= "규칙",
	NoFaction								= "<무소속>",

	ConfirmLeave						= [[
정말로 세력을 떠나시겠습니까?
만약 당신이 세력의 리더이면 세력이 자동으로 해체됩니다!]],
	JoinWarning							= [[
주의: 만약 당신이 세력의 리더이면, 이 세력에 가입할경우 기존 세력이 해체됩니다.]],
	CreateNotice						= [[
주의: 세력을 만들기전 다음을 확인하세요.
- 레이드 진행중에는 세력을 만들 수 없습니다.
- 만약 당신이 세력의 리더이면 기존의 세력이 자동으로 해체됩니다.]],

	CreateFaction						= "세력 만들기",
	FactionName							= "세력 이름",
	FactionPassword					= "비밀번호(선택)",

	Create									= "만들기",
	Nevermind								= "취소",

	JoinFaction							= "세력 가입",
	Join										= "가입",

	LeaveFaction						= "세력 탈퇴",
	Leave										= "탈퇴",

	YouNotFaction						= "세력에 소속되어있지 않습니다.",
	YourFaction							= "당신의 세력: ",

	StartRaid								= "레이드 시작",
	ConceedRaid							= "레이드 항복",

	Use											= "사용하기",
	Collect									= "줍기",
	Activate								= "활성화하기",
	LookAt									= "바라보기",
	Drink										= "마시기",
	TalkTo									= "말걸기",

	Door										= "문",
	Money										= "돈",
	Drug										= "마약",
	Soda										= "음료수",
	HelpNPC									= "도움말 NPC",
	Spawnpoint							= "스폰포인트",
	Defusing								= "비활성화중...",
	Plant										= "땅에 심기",
	Defuse									= "비활성화",

	Entities								= "물건",
	Loadout									= "무기",
	BaseWarsSpawnlist				= "베이스워즈 구매메뉴",
	CategoryLeft						= "왼쪽에서 카테고리를 선택하세요.",

	PrinterBeen							= "이 복사기는",
	Disabled								= "작동 중지됨",
	Cash										= "돈",
	MaxLevel								= "!최대 레벨!",
	Paper										= "남은 용지: %s 장",
	UntilFull								= "%s 남음",
	Full										= "가득 참",
	NextUpgrade							= "다음 업그레이드: %s",

	HoursShort							= "시간",
	MinutesShort						= "분",
	SecondsShort						= "초",

	VS											= " vs ",
}

local INVALID_LANGUAGE	= "INVALID LANGUAGE SELECTED! NOTIFY THE SERVER ADMIN!"
local INVALID_STRING		= "INVALID STRING TRANSLATION! NOTIFY THE SERVER ADMIN!"

setmetatable(BaseWars.LANG, {
	__index = function(t, k)

		local L = BaseWars.LANG.__LANGUAGELOOK[BASEWARS_CHOSEN_LANGUAGE]
		if not L then
			return INVALID_LANGUAGE
		end
		if not L[k] then
			ErrorNoHalt("[BaseWars-Lang] You messed up a string localization:")
			debug.Trace()

			return INVALID_STRING
		end
		return L[k]

	end
})
