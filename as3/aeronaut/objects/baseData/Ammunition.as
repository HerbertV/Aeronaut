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
package as3.aeronaut.objects.baseData
{
	
	/**
	 * =========================================================================
	 * Ammunition
	 * =========================================================================
	 */ 
	public class Ammunition
	{
		// =====================================================================
		// Variables
		// =====================================================================
		
		public var myID:String;
		
		public var shortName:String;
		public var longName:String;
		
		public var cal:int;
		public var price:int;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 * 
		 * @param id
		 * @param short shortname
		 * @param long longname
		 * @param c caliber
		 * @param p price in Dollar
		 */
		public function Ammunition(
				id:String,
				short:String, 
				long:String, 
				c:int, 
				p:int 
			)
		{
			myID = id;
			shortName = short;
			longName = long;
									
			cal = c;
			price = p;
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
			return "baseData.Ammunition ["+myID+", "+shortName+"]";
		}
	
	}
}