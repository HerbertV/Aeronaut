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
	// ICSWindow
	// =========================================================================
	// base interface for all CSWindow's
	// Every window has also it's own sub interface.
	public interface ICSWindow
	{
		/**
		 * ---------------------------------------------------------------------
		 * updateObjectFromWindow
		 * ---------------------------------------------------------------------
		 */
		function updateObjectFromWindow():void;
		
		/**
		 * ---------------------------------------------------------------------
		 * updateDirLists
		 * ---------------------------------------------------------------------
		 */
		function updateDirLists():void;
		
		/**
		 * ---------------------------------------------------------------------
		 * setSaved
		 * ---------------------------------------------------------------------
		 * @param v
		 */
		function setSaved(v:Boolean):void;
		
		/**
		 * ---------------------------------------------------------------------
		 * getIsSaved
		 * ---------------------------------------------------------------------
		 * @return
		 */
		function getIsSaved():Boolean;
		
		/**
		 * ---------------------------------------------------------------------
		 * getFilename
		 * ---------------------------------------------------------------------
		 * @return
		 */
		function getFilename():String;
		
		/**
		 * ---------------------------------------------------------------------
		 * saveObject
		 * ---------------------------------------------------------------------
		 * @param fn
		 */
		function saveObject(fn:String):void;
				
	}
}