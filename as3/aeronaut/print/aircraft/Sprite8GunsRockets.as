/*
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
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import as3.aeronaut.objects.Aircraft;
	import as3.aeronaut.objects.Loadout;
	
	// =========================================================================
	// Class Sprite8GunsRockets
	// =========================================================================
	// 8 Guns and Rockets (for fighters and heavy fighters)
	//
	public class Sprite8GunsRockets
			extends SpriteWeapons
	{
	
		// =====================================================================
		// Variables
		// =====================================================================
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function Sprite8GunsRockets()
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
		 */
		override public function init(
				aircraft:Aircraft,
				loadout:Loadout
			):void
		{
			this.lblHardpoints.htmlText = 
					"<b>" + aircraft.getRocketSlotCount() + "</b>";
			
			for( var i:int = 1; i < 9; i++ )
			{
				this.setupGun(i,aircraft,loadout);
				this.setupRocket(i,loadout);
			}
		}
				
	}
}