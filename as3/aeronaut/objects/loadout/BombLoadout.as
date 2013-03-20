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
	/**
	 * =========================================================================
	 * BombLoadout
	 * =========================================================================
	 */ 
	public class BombLoadout
	{
		// =====================================================================
		// Variables
		// =====================================================================
		public var bay:String = "";
		public var index:int = 0;
		public var bombID:String = "";
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 * 
		 * @param b bomb bay (FL,FR,AL,AR)
		 * @param i index
		 * @param bID bomb id
		 */
		public function BombLoadout(
				b:String,
				i:int, 
				bID:String
			)
		{
			bay = b;
			index = i;
			bombID = bID;
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
			return "loadout.BombLoadout ["
				+ bay + ", "
				+ index + ", "
				+ bombID + " ]";
		}
		
	}
}