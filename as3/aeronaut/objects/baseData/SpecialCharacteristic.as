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
		// possible cost types
		public static const CT_ADDITIONAL:String = "additional";
		
		public static const CT_AIRFRAME:String = "airframe";
		public static const CT_COCKPIT:String = "cockpit";
		public static const CT_ENGINE:String = "engine";
		public static const CT_ARMOR:String = "armor";
		public static const CT_WEAPON:String = "weapon";
		public static const CT_COMPLETE:String = "complete";
		public static const CT_SPEED:String = "speed";
		
		// possible weight types
		public static const WT_ADDITIONAL:String = "additional";
		
		public static const WT_COMPLETE:String = "complete";
		
		
		// =====================================================================
		// Variables
		// =====================================================================
		public var myID:String;
		
		public var myName:String;
		public var myDescription:String;
		
		public var groupID:String;
		
		public var allowedFrames:Array;
		
		public var costType:Array;
		public var costChanges:Number;
		
		public var weightType:Array;
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
		 * @param frames array of allowed frames
		 * @param cT cost types
		 * @param cC cost changes
		 * @param WT weight types
		 * @param wC weight changes
		 * @param hasHCA has hardcoded ability
		 * @param limit if it counts to the 12-BTN limit or not
		 * @param desc description string
		 */
		public function SpecialCharacteristic(
				id:String,
				n:String, 
				gid:String, 
				frames:Array,
				cT:Array, 
				cC:Number, 
				wT:Array, 
				wC:Number, 
				hasHCA:Boolean,
				limit:Boolean,
				desc:String
			)
		{
			myID = id;
			myName = n;
			allowedFrames = frames;
			groupID = gid;
			costType = cT;
			costChanges = cC;
			weightType = wT;
			weightChanges = wC;
			hasHardcodedAbility = hasHCA;
			countsToLimit = limit;
			myDescription = desc;
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