# New-Basewars-Garry-s-Mod-2024
I've modified the basewars gamemode so that it's no longer buggy and I've added some scripts to make it more functional

English:

The addon available in "addons/nt2" displays players' names above their heads.
The other addon available in "addons/xp_kill" displays a message on the player's screen when he kills another player like in Call Of Duty, and this gives him XP.
You can modify the addon in "addons/xp_kill/lua/autorun/server/xp_system.lua".

The script in "lua/autorun/moneydarkrptobw.lua" makes the money in the gmodstore addons compatible with the basewars money.
In short, addons that are not compatible with the Basewars game mode will be compatible thanks to this script.

To configure the basewars game mode, go to "gamemodes/basewars/config.lua".

If you ask why there is a green halo or a luminous halo around a player it's normal 
it's because of Karma as soon as a player reaches 100 Karma he automatically has this halo 
if you want to deactivate it go to the file "gamemodes/basewars/config.lua" 
to line 122 or to the variable "KarmaGlowLevel" and set the value of this variable to 100 
this will deactivate the luminous halo of Karma.

To create a new printer, go to "gamemodes/basewars/entities/entities" and copy and paste a file from a printer. 
I advise you to use the file I created called "bw_printer_new.lua", copy and paste it and change the name, 
then open this file and change the values.
To add this printer, you just need to add it via the "config.lua" file available here: 
"gamemodes/basewars/config.lua"

Français:

L'addon disponible dans "addons/nt2" affiche les noms des joueurs au-dessus de leur tête.
L'autre addon disponible dans "addons/xp_kill" affiche un message sur l'écran du joueur lorsqu'il tue un autre joueur comme dans Call Of Duty, et cela lui donne de l'XP.
Vous pouvez modifier l'addon dans "addons/xp_kill/lua/autorun/server/xp_system.lua".

Le script dans "lua/autorun/moneydarkrptobw.lua" rend l'argent des addons de gmodstore compatible avec l'argent de Basewars.
En résumé, les addons qui ne sont pas compatibles avec le mode de jeu Basewars le deviendront grâce à ce script.

Pour configurer le mode de jeu Basewars, rendez-vous dans "gamemodes/basewars/config.lua".

Si vous vous demandez pourquoi il y a un halo vert ou lumineux autour d'un joueur, c'est normal, 
c'est à cause du Karma : dès qu'un joueur atteint 100 de Karma, il aura automatiquement ce halo. 
Pour le désactiver, allez dans le fichier "gamemodes/basewars/config.lua",
à la ligne 122 ou à la variable "KarmaGlowLevel", et définissez la valeur de cette variable à 100.
Cela désactivera le halo lumineux du Karma.

Pour créer une nouvelle imprimante, allez dans "gamemodes/basewars/entities/entities" et copiez-collez un fichier d'imprimante. 
Je vous conseille d'utiliser le fichier que j'ai créé appelé "bw_printer_new.lua", copiez-le et changez le nom, 
puis ouvrez ce fichier pour modifier les valeurs.
Pour ajouter cette imprimante, il suffit de l'ajouter via le fichier "config.lua" disponible ici : "gamemodes/basewars/config.lua".
