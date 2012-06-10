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
package as3.aeronaut.objects.baseData
{
	// =========================================================================
	// Rocket
	// =========================================================================
	// 
	public class Rocket
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const TYPE_ROCKET:String = "rocket";
		public static const TYPE_BOMB:String = "bomb";
		public static const TYPE_RELOADABLE:String = "reloadable";
		public static const TYPE_FUELTANK:String = "fueltank";
		
		// =====================================================================
		// Variables
		// =====================================================================
		public var myID:String;
		
		public var shortName:String;
		public var longName:String;
		
		public var type:String;
		public var slots:int;
		public var usesPerSlot:int;
		public var range:int;
		public var price:int;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		
		/**
		 * Constructor
		 * 
		 * @param id	
		 * @param short short name
		 * @param long long name
		 * @param t	type (see contants above)
		 * @param s slot number
		 * @param ups uses per slot
		 * @param r rang in hexes
		 * @param p price in dollar
		 */
		public function Rocket(
				id:String,
				short:String, 
				long:String, 
				t:String, 
				s:int, 
				ups:int, 
				r:int, 
				p:int 
			)
		{
			myID = id;
			shortName = short;
			longName = long;
			
			type = t;
			slots = s;
			usesPerSlot = ups;
			range = r;
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
			return "baseData.Rocket ["+myID+", "+longName+"]";
		}
	
	}
}