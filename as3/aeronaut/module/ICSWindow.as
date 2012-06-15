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
		 * returns the absolut path including the filename. 
		 * Or "" if there exists no file.
		 *
		 * @return
		 */
		function getFilename():String;
		
		/**
		 * ---------------------------------------------------------------------
		 * getTitle
		 * ---------------------------------------------------------------------
		 * returns the window title (e.g. "Pilot", "Aircraft", ...)
		 *
		 * @since 1.1.0
		 * @return
		 */
		function getTitle():String;
		
		/**
		 * ---------------------------------------------------------------------
		 * getWindowType
		 * ---------------------------------------------------------------------
		 * returns a CSWindowManager window type constant (e.g. WND_PILOT) 
		 *
		 * @since 1.1.0
		 * @return
		 */
		function getWindowType():int;
		
		/**
		 * ---------------------------------------------------------------------
		 * getSubPath
		 * ---------------------------------------------------------------------
		 * returns the base subpath where the data for this window is stored.
		 * (e.g. Globals.PATH_AIRCRAFT )
		 *
		 * @since 1.1.0
		 * @return
		 */
		function getSubPath():String;
				
		/**
		 * ---------------------------------------------------------------------
		 * saveObject
		 * ---------------------------------------------------------------------
		 * fn is the absolute path to the file.
		 * 
		 * @param fn
		 */
		function saveObject(fn:String):void;
				
	}
}