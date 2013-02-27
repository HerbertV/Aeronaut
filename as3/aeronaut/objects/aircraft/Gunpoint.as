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
package as3.aeronaut.objects.aircraft
{
	
	// =========================================================================
	// Gunpoint
	// =========================================================================
	// 
	public class Gunpoint
	{
		// =====================================================================
		// Constants
		// =====================================================================
		
		public static const DIR_FORWARD = "forward";
		public static const DIR_TURRET = "turret";
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		public var pointNumber:int;
		public var gunID:String = "";
		
		public var firelinkGroup:int = 0;
		public var ammolinkGroup:int = 0;
		
		public var direction:String = "forward";
		
		// =====================================================================
		// Constructor
		// =====================================================================
		
		/**
		 * Constructor
		 * 
		 * @param num	gun point number
		 * @param gid	gun id
		 */
		public function Gunpoint(
				num:int, 
				gid:String
			)
		{
			pointNumber = num;
			gunID = gid;
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
			return "aircraft.Gunpoint[ " + pointNumber + " , " + gunID + " ]";
		}
		
	}
}