________              ___   ____     Crimson Skies      __             ________
\________\-----------/ _ | / __/______  ___  ___ ___ __/ /_----------/________/ 
    \_______\-------/ __ |/ _// __/ _ \/ _ \/ _ `/ // / __/-------/_______/ 
       \______\----/_/ |_/___/_/  \___/_//_/\_,_/\_,_/\__/----/______/

	an unoffical custom aircraft, zeppelin and pilot design/editing tool 
	for the out-of-print CRIMSON SKIES boardgame by created FASA. 
 
	Inspired by Scott Janssens' CADET. 
	Very special thanks to Patrick Koepke for releasing his 
	"Zeppelin & Bombers" sourcebook un-official.
	
	This program is dedicated to all the fans of Crimson Skies.
	
	Visit: http://www.foxforcefive.de/cs/
	
	Aeronaut is Licensed under MIT License: http://opensource.org/licenses/MIT
	Sources: http://github.com/HerbertV/Aeronaut/

================================================================================
	Version 1.1.0 beta 01
================================================================================

--------------------------------------------------------------------------------
	About:
--------------------------------------------------------------------------------
	Supports the official rules from all official sources.
	Supports FF5 housrules.
	
	Since version 1.1.0 (Work in Progress):
	Supports the "un-official" "Zeppelin & Bombers" rules written 
	by Patrick Koepke (Autor of "Pride of the Republic") 
	http://www.patrickkoepke.com/
	
	"Zeppelin & Bombers" can be downloaded here:
	http://www.montanaraiders.com/zeppelinsandbombers.html
	
	Thanks to Neil Holley for supporting me with the cadet parser:
	https://bitbucket.org/neilh/cadetparser.py/src
	That allows me to import cadet files.
	
--------------------------------------------------------------------------------
	System Requirements:
--------------------------------------------------------------------------------
- 	Windows XP / Vista / 7
- 	Recommended screen resolution 1280x800 pixel or higher 
	(works also with smaller resolutions)
- 	Printer 

--------------------------------------------------------------------------------
	Installation:
--------------------------------------------------------------------------------
	Just unpack this archive and click on the exe file.
	It is only important that you keep the sub-directories intact.

--------------------------------------------------------------------------------
	Known Issues:
--------------------------------------------------------------------------------
	With Windows 7 you need admin rights for the first launch. 
	Otherwise the file association does not work.
	This is not a bug but a security reason.
	
	see github for issues:
	http://github.com/HerbertV/Aeronaut/issues
	or visit the Aeronaut Thread:
	http://montanaraiders.com/forum/viewtopic.php?f=15&t=401
	
--------------------------------------------------------------------------------
	Hardcoded Stuff:
--------------------------------------------------------------------------------
	Some Special Characteristics have hardcoded abilities:
	
- 	Linked Ammo Bins 
		-> Enables/Disables the linked ammo radiobuttons at the gunpoints
- 	Fire-Linked Weapons 
		-> Enables/Disables the firelinked radiobuttons at the gunpoints
- 	High Torque Engine 
		-> calculates the G modifiers
- 	Multiple Engines 
		-> Enables/Disables the Numeric Stepper for the engine count
- 	Nitro
		-> draws the nitro box in in the print sheets.
		

--------------------------------------------------------------------------------
	Aircraft Blueprints:
--------------------------------------------------------------------------------
	Now you can now import blueprints. Imported blueprints are placed 
	inside "images\aircrafts\blueprints" folder. 
	You will find also a draft for the drafts folder.
	
--------------------------------------------------------------------------------
	Pinup Easter Egg:
--------------------------------------------------------------------------------
	I removed the pinup swf files from the previous version.
	Now you can place your own pngs inside "images\pinups" folder. 
	If you activate the easter egg all pngs are loaded and get a duct tape 
	close button and a drop shadow.
	You will find also a draft for landscape and portrait format pictures inside
	the drafts folder.
	
--------------------------------------------------------------------------------
	Filename convention:
--------------------------------------------------------------------------------
official rules:
Fury = Fury.ae

ff5 houesrules:
Fury = ff5_Fury.ae