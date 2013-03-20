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
package as3.aeronaut.objects
{
	/**
	 * =========================================================================
	 * ICSBaseObject
	 * =========================================================================
	 * Interface for CS(Crimson skies) objects that are store as ae files.
	 * e.g. Aircraft, Loadout, Pilot, Squadron, Zeppelin
	 */ 
	public interface ICSBaseObject
	{
		/**
		 * ---------------------------------------------------------------------
		 * createNew
		 * ---------------------------------------------------------------------
		 * creates an empty xml structure for this object
		 */
		function createNew():void;
				
		/**
		 * ---------------------------------------------------------------------
		 * loadFile
		 * ---------------------------------------------------------------------
		 * load xml file and parses it
		 * 
		 * @param	filename
		 */		
		function loadFile(filename:String):void;
				
		/**
		 * ---------------------------------------------------------------------
		 * setXML
		 * ---------------------------------------------------------------------
		 * updates the xml with the new one
		 * 
		 * @param	xmldoc
		 */
		function setXML(xmldoc:XML):void;
		
		
		/**
		 * ---------------------------------------------------------------------
		 * updateVersion
		 * ---------------------------------------------------------------------
		 * if the version of this file has changed this function adjust
		 * the file to fit into the new version.
		 * 
		 * best way is to call it after loading was a success.
		 * 
		 * @return returns true if a update was done.
		 */
		function updateVersion():Boolean;
				
	}	
}