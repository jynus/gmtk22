# GMTK22
 Jynus' Game Makers Toolkit 2022 entry repo (submitted)

Play here with your browser: https://jynus.itch.io/disix-adventure or download the Windows build.

Disix Adventure: The Revenge of RNGesus is a 2d top-down-ish dungeon-crawling, action shooting adventure, where your only weapons are a pair of dice.


You only inflict damage based on the number your dice fall on AND at the same time, you hit your enemy. There are several dice that you can choose from, some of which have sides with special effects, such as an area of effect damage- highly effective against groups of enemies.

# Controls

* WASD or Arrow keys for movement
* Mouse cursor for dice aiming (direction of shooting)
* Left mouse button for primary dice shooting
* Right mouse button for secondary dice shooting
* R to reset the level and start from the beginning
* On dice selection- use mouse. Please note that you select the dice that you will drop, not the one you prefer.

# Known issues

* Sometimes it is possible to send the dice to unaccesible locations in the map. Wait for the dice to respawn (it respawns automatically if it isn't collected after 10 seconds) or in the worse case, restart the level
* There are some known glitches with textures that don't affect gameplay
* Randomness makes sometimes look like an enemy isn't being hit- but this is because the dice returns a 0. This is non-obvious because sometimes an enemy gets hit more than once and the animations don't complete.
* In general, there is a lack of content and polish: additional levels and more varied dice. The second level was crafted as an infinite one (infinite spawning- impossible to complete)- if you happen to complete it, you will restart the same level. There were planned 2 more effects: poison and stunning, but it didn't make the cut.

# Credits

Disix Adventure was planned, designed, and coded for the GMTK Game Jam in less than 2 days by a team of one. All music, sound effects, sprites, animations and textures were done from scratch during the jam, with no precreated or external assets used.

This game was done exclusively with free software: Godot Engine, LMMS, Audacity and Gimp (with the exception of the operating system, as the Jam's target audience is Windows).

Jaime Crespo "jynus" was its creator.

Thank you to the Crespo family for  testing and providing very useful feedback during development.

There is a secret area on one level. Kudos if you can find it- comment it here.


# Install instructions

Play from directly the web browser (you may need 3d acceleration).

For the Windows build, download the .zip, extract all files to the same directory (it cannot be played directly from the zip- it has to be extracted first) and run the .exe. A warning could be shown for the executable not being unsigned (you can click ok)- it won't touch your system at all.