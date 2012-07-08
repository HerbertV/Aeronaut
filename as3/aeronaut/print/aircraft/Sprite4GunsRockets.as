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
 * Copyright (c) 2009-2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.print.aircraft
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import as3.aeronaut.objects.Aircraft;
	
	// =========================================================================
	// Class Sprite4GunsRockets
	// =========================================================================
	// only 4 Guns and Rockets (for e.g. Autogyro)
	//
	public class Sprite4GunsRockets
			extends SpriteWeapons
	{
	
		// =====================================================================
		// Variables
		// =====================================================================
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function Sprite4GunsRockets()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromAircraft
		 * ---------------------------------------------------------------------
		 * @param obj
		 */
		override public function initFromAircraft(obj:Aircraft):void
		{
			// TODO
		}
				
	}
}