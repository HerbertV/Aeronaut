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
 * Copyright (c) 2009-2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.objects.pilot
{
	// =========================================================================
	// LearnedLanguage
	// =========================================================================
	// FF5 optional rule
	public class LearnedLanguage
	{
		// =====================================================================
		// Variables
		// =====================================================================
		public var myID:String;
		public var isMotherTongue:Boolean = false;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		
		/**
		 * Constructor
		 * 
		 * @param id
		 * @param isMT is mother tongue
		 */
		public function LearnedLanguage(
				id:String,
				isMT:Boolean
			)
		{
			myID = id;
			isMotherTongue = isMT;
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
			return "pilot.LearnedLanguage ["+myID+", "+isMotherTongue+"]";
		}
	
	}
}