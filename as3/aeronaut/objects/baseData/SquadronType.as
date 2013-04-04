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
 * Copyright (c) 2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.objects.baseData 
{
	/**
	 * =========================================================================
	 * SquadronType
	 * =========================================================================
	 * for Z&B Sqaudron/Unit rules
	 */
	public class SquadronType 
	{
		// =====================================================================
		// Variables
		// =====================================================================
		public var myID:String;
		public var myName:String;
		public var size:int;

		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 * 
		 * @param	id
		 * @param	n
		 * @param	s
		 */
		public function SquadronType(
				id:String,
				n:String, 
				s:int
			) 
		{
			myID = id;
			myName = n;
			size = s;
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
			return "baseData.SquadronType ["+myID+", "+myName+"]";
		}
		
	}

}