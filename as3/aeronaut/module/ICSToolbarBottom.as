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
	
	// =========================================================================
	// ICSToolbarBottom
	// =========================================================================
	// interface for the toolbar book
	// 
	public interface ICSToolbarBottom
	{
		
		/**
		 * ---------------------------------------------------------------------
		 * changeState
		 * ---------------------------------------------------------------------
		 * @param newState
		 */
		function changeState(newState:int):void;
		
		/**
		 * ---------------------------------------------------------------------
		 * updateXPInfosFromPilot
		 * ---------------------------------------------------------------------
		 * @param win
		 * @param mission
		 * @param currentCO
		 */
		function updateXPInfosFromPilot(
				win:ICSWindowPilot,
				mission:int, 
				currentCO:int
			):void;
		
		/**
		 * ---------------------------------------------------------------------
		 * openBook
		 * ---------------------------------------------------------------------
		 */
		function openBook():void;
		
		/**
		 * ---------------------------------------------------------------------
		 * closeBook
		 * ---------------------------------------------------------------------
		 */
		function closeBook():void;
		
		/**
		 * ---------------------------------------------------------------------
		 * updateToolbar
		 * ---------------------------------------------------------------------
		 */
		function updateToolbar():void;
	
	}
}