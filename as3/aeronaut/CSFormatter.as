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
 * Copyright (c) 2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut
{
	// =========================================================================
	// CSFormatter
	// =========================================================================
	// static helper class for formatting 
	//
	public class CSFormatter
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const THOUSAND_SEPERATOR_US:String = ",";
		
		public static const INCH:String = "inch";
		public static const INCH_SHORT:String = "in.";
		public static const FEET:String = "feet";
		public static const FEET_SHORT:String = "ft.";
		public static const MILES:String = "miles";
		public static const MILES_SHORT:String = "mi.";
		
		public static const LBS:String = "lbs.";
		
		public static const DOLLAR:String = "$";
		
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * formatIntWithSeperator
		 * ---------------------------------------------------------------------
		 * formats an integer into a readable string, by adding a seperator
		 * after every 3 digits. (e.g. 5000 -> 5,000 )
		 * 
		 * @param val
		 * @param seperator
		 */
		public static function formatIntWithSeperator(
				val:int,
				seperator:String
			):String
		{
			var temp:String = String( val );
			var i:int = temp.length-1;
			var j:int = 0;
			var str:String = "";
			
			while( i >= 0 ) 
			{
				str = temp.substr(i,1) + str;
				j++;
				if( j == 3 && (i-1) >= 0 )
				{
					str = seperator + str;
					j = 0;
				}
				i--;
			}
			return str;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * formatFeet
		 * ---------------------------------------------------------------------
		 * formats a feet value into a string
		 *
		 * @param feet
		 * @param useShort
		 */
		public static function formatFeet(
				feet:int,
				useShort:Boolean=true
			):String
		{
			var str:String = CSFormatter.formatIntWithSeperator(
					feet,
					THOUSAND_SEPERATOR_US
				);
			var suffix:String = FEET;
			
			if( useShort )
				suffix = FEET_SHORT;
			
			return str + " " + suffix;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * formatFeetInch
		 * ---------------------------------------------------------------------
		 * formats a feet inch pair value into a string
		 *
		 * @param feet
		 * @param inch
		 * @param useShort
		 */
		public static function formatFeetInch(
				feet:int,
				inch:int,
				useShort:Boolean=true
			):String
		{
			var str:String = CSFormatter.formatIntWithSeperator(
					feet,
					THOUSAND_SEPERATOR_US
				);
			var sf:String = FEET;
			var si:String = INCH;
			
			if( useShort )
			{
				sf = FEET_SHORT;
				si = INCH_SHORT;
			}
			return str + " " + sf + " " + inch + " " + si;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * formatMiles
		 * ---------------------------------------------------------------------
		 * formats a miles value into a string
		 *
		 * @param feet
		 * @param useShort
		 */
		public static function formatMiles(
				miles:int,
				useShort:Boolean=true
			):String
		{
			var str:String = CSFormatter.formatIntWithSeperator(
					miles,
					THOUSAND_SEPERATOR_US
				);
			var suffix:String = MILES;
			
			if( useShort )
				suffix = MILES_SHORT;
				
			return str + " " + suffix;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * formatDollar
		 * ---------------------------------------------------------------------
		 * formats a dollar value in a string
		 *
		 * @param dollar
		 */
		public static function formatDollar(dollar:int):String
		{
			var str:String = CSFormatter.formatIntWithSeperator(
					dollar,
					THOUSAND_SEPERATOR_US
				);
			
			return str + " " + DOLLAR;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * formatLbs
		 * ---------------------------------------------------------------------
		 * formats a pounds value into a string
		 *
		 * @param lbs
		 */
		public static function formatLbs(lbs:int):String
		{
			var str:String = CSFormatter.formatIntWithSeperator(
					lbs,
					THOUSAND_SEPERATOR_US
				);
			
			return str + " " + LBS;
		}
		
		//TODO
		/*
		public static function convertFeet2Meter(feet:Number):Number
		{
		
		}
		
		public static function convertFeet2Cm(feet:Number, inch:Number):Number
		{
		
		}
		
		public static function convertMiles2Km(miles:Number):Number
		{
		
		}
		
		public static function convertLbs2Kg(lbs:Number):Number
		{
		
		}
		*/
		
	}
}