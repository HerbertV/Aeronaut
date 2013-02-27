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
	// =========================================================================
	// Feat
	// =========================================================================
	// optional FF5 Ruling
	public class Feat
	{
		// =====================================================================
		// Variables
		// =====================================================================
		public var myID:String;
		public var myName:String;

		public var xpCost:Array = new Array();
		public var maxLevel:int = 0;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		
		/**
		 * Constructor
		 * 
		 * @param id	
		 * @param n	
		 * @param xp
		 * @param lvl
		 */
		public function Feat(
				id:String,
				n:String, 
				xp:Array, 
				lvl:int
			)
		{
			myID = id;
			myName = n;
			
			xpCost = xp;
			maxLevel = lvl;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getXPCostForLevel
		 * ---------------------------------------------------------------------
		 * 
		 * @param lvl 
		 *
		 * @return
		 */
		public function getXPCostForLevel(lvl:int):int
		{
			if( maxLevel == 0 ) 
				return int(xpCost[0]);
			
			if( lvl < maxLevel )
				return int(xpCost[lvl]);
			
			return 0;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getXPCostString
		 * ---------------------------------------------------------------------
		 *
		 * @return
		 */
		public function getXPCostString():String
		{
			var str:String ="[";
			
			for( var i:int = 0; i < xpCost.length; i++) 
			{
				str += xpCost[i] + " EP";
				if( i < (xpCost.length-1) )
					str += ",";
			}
			
			str += "]";
			return str;
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * toString
		 * ---------------------------------------------------------------------
		 *
		 * @return Object as string
		 */
		public function toString():String
		{
			return "baseData.Feat ["+myID+", "+myName+"]";
		}
	
	}
}