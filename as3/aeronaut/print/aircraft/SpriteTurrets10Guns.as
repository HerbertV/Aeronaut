﻿/*
 *    ___   ____                        __  
 *   / _ | / __/______  ___  ___ ___ __/ /_ 
 *  / __ |/ _// __/ _ \/ _ \/ _ `/ // / __/ 
 * /_/ |_/___/_/  \___/_//_/\_,_/\_,_/\__/
 *
 * An unoffical custom aircraft, pilot design and editing tool 
 * for the out-of-print CRIMSON SKIES boardgame by created FASA. 
 * 
 * Inspired by Scott Janssens' CADET. 
 * Visit: http://www.foxforcefive.de/cs/
 * -----------------------------------------------------------------------------
 * @author: Herbert Veitengruber 
 * @version: 1.0.0
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2009-2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.print.aircraft
{
	import as3.aeronaut.objects.Pilot;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import as3.aeronaut.objects.Aircraft;
	import as3.aeronaut.objects.aircraft.*;
	import as3.aeronaut.objects.Loadout;
	import as3.aeronaut.objects.loadout.*;
	import as3.aeronaut.objects.baseData.Gun;
	import as3.aeronaut.objects.baseData.Ammunition;
	
	import as3.aeronaut.Globals;
		
	// =========================================================================
	// Class SpriteTurrets10Guns
	// =========================================================================
	// linked to SpriteBomberTurrets10
	//
	public class SpriteTurrets10Guns
			extends SpriteTurrets
	{
	
		// =====================================================================
		// Variables
		// =====================================================================
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function SpriteTurrets10Guns()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * init
		 * ---------------------------------------------------------------------
		 * @param aircraft
		 * @param loadout
		 * @param gunners array of exact 6 pilots if there is no gunner 
		 * 			the arrays value is null
		 */
		override public function init(
				aircraft:Aircraft,
				loadout:Loadout,
				gunners:Array
			):void
		{
			var i:int = 0;
			for( i = 1; i < 11; i++ )
				this.setupGun(i, aircraft, loadout);
			
			for ( i = 0; i < 6; i++ )
				this.setupGunner((i+1), gunners[i]);
		}
		
	}
}