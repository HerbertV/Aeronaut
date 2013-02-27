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
package as3.aeronaut.objects.loadout
{
	// =========================================================================
	// GunAmmo
	// =========================================================================
	// 
	public class GunAmmo
	{
		// =====================================================================
		// Variables
		// =====================================================================
		public var gunPointNumber:int = 0;
		public var ammoID:String = "";
		
		// =====================================================================
		// Constructor
		// =====================================================================
		
		/**
		 * Constructor
		 * 
		 * @param gp	gun point number
		 * @param aID	ammo id
		 */
		public function GunAmmo(
				gp:int, 
				aID:String
			)
		{
			this.gunPointNumber = gp;
			this.ammoID = aID;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * toString
		 * ---------------------------------------------------------------------
		 *
		 * @return Object as string
		 */
		public function toString():String
		{
			return "loadout.GunAmmo [ " 
				+ this.gunPointNumber + ", "
				+ this.ammoID + " ]";
		}
		
		
	}
	
	
	
	
	
}