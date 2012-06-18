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
package as3.aeronaut.module
{
	import as3.aeronaut.objects.Pilot;	
	
	// =========================================================================
	// ICSWindowPilot
	// =========================================================================
	// interface for a Pilot window
	// 
	public interface ICSWindowPilot 
			extends ICSWindow
	{
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromPilot
		 * ---------------------------------------------------------------------
		 * @param obj
		 */
		function initFromPilot(obj:Pilot):void;
		
		/**
		 * ---------------------------------------------------------------------
		 * updateNewEPAndMissionStuff
		 * ---------------------------------------------------------------------
		 * @param newEP gained expirence
		 * @param coLost constitution loss
		 * @param mission 
		 * @param kills
		 * @param positiveBailout
		 * @param craftLost
		 */
		function updateNewEPAndMissionStuff(
				newEP:int, 
				coLost:int, 
				mission:int, 
				kills:int, 
				positiveBailout:Boolean, 
				craftLost:Boolean
			):void;
		
	}
}