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
 * Copyright (c) 2009-2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.objects.loadout
{
	// =========================================================================
	// RocketLoadout
	// =========================================================================
	// 
	public class RocketLoadout
	{
		// =====================================================================
		// Variables
		// =====================================================================
		public var slotNumber:int = 0;
		public var subSlot:int = 0;
		public var rocketID:String = "";
		
		// =====================================================================
		// Constructor
		// =====================================================================
		
		/**
		 * Constructor
		 * 
		 * @param sN slot number
		 * @param sS subslot
		 * @param rID rocket id
		 */
		public function RocketLoadout(
				sN:int, 
				sS:int, 
				rID:String
			)
		{
			slotNumber = sN;
			subSlot = sS;
			rocketID = rID;
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
			return "loadout.RocketLoadout ["
				+ slotNumber + ", "
				+ subSlot + ", "
				+ rocketID + " ]";
		}
		
	}
}