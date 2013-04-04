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
package as3.aeronaut.objects.baseData
{
	/**
	 * =========================================================================
	 * Gun
	 * =========================================================================
	 */
	public class Gun
	{
		// =====================================================================
		// Variables
		// =====================================================================
		public var myID:String;
		
		public var shortName:String;
		public var longName:String;
		
		public var cal:int;
		
		public var weight:int;
		public var price:int;
		public var range:int;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 * 
		 * @param id	
		 * @param short short name
		 * @param long long name
		 * @param c caliber
		 * @param w weight in lbs
		 * @param p price in Dollar
		 * @param r range in hex
		 */
		public function Gun(
				id:String,
				short:String, 
				long:String, 
				c:int, 
				w:int, 
				p:int, 
				r:int 
			)
		{
			myID = id;
			shortName = short;
			longName = long;
									
			cal = c;
			weight = w;
			price = p;
			range = r;
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
			return "baseData.Gun ["+myID+", "+shortName+", "+weight+" lbs. ]";
		}
	
	}
}