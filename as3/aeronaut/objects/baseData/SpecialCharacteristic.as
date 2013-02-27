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
 * @version: 1.1.0
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
	// SpecialCharacteristic
	// =========================================================================
	// 
	public class SpecialCharacteristic
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const CT_AIRFRAME:String = "airframe";
		public static const CT_COCKPIT:String = "cockpit";
		public static const CT_ENGINE:String = "engine";
		
		public static const CT_ARMOR:String = "armor";
		public static const CT_ADDITIONAL:String = "additional";
		
		public static const CT_WEAPON:String = "weapon";

		// =====================================================================
		// Variables
		// =====================================================================
		public var myID:String;
		
		public var myName:String;
		public var myDescription:String;
		
		public var groupID:String;
		
		public var costType:Array;
		
		public var costChanges:Number;
		public var weightChanges:Number;
		
		public var hasHardcodedAbility:Boolean;
		
		public var countsToLimit:Boolean;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		
		/**
		 * Constructor
		 * 
		 * @param id	
		 * @param n name
		 * @param gid group id
		 * @param cT cost type
		 * @param cC cost changes
		 * @param wC weight changes
		 * @param hasHCA has hardcoded ability
		 * @param limit if it counts to the 12-BTN limit or not
		 */
		public function SpecialCharacteristic(
				id:String,
				n:String, 
				gid:String, 
				cT:Array, 
				cC:Number, 
				wC:Number, 
				hasHCA:Boolean,
				limit:Boolean
			)
		{
			myID = id;
			myName = n;
			
			// TODO Decription
			
			groupID = gid;
			costType = cT;
			costChanges = cC;
			weightChanges = wC;
			hasHardcodedAbility = hasHCA;
			countsToLimit = limit;
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
			return "baseData.SpecialCharacteristic ["
				+ myID + ", " 
				+ myName + ", " 
				+ groupID + ", " 
				+ costType + "]";
		}
	
	}
}