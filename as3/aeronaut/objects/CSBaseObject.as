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
package as3.aeronaut.objects
{
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.XMLProcessor;
		
	// =========================================================================
	// CSBaseObject
	// =========================================================================
	// Base class for all CS(crimson skies) related objects that are 
	// stored as .ae files.
	//
	// e.g. Aircraft, Loadout, Pilot, Squadron, Zeppelin
	// 
	public class CSBaseObject
	{
		// =====================================================================
		// Variables
		// =====================================================================
		protected var myFilename:String = "";
		protected var myXML:XML = new XML();
				
		// =====================================================================
		// Constructor
		// =====================================================================
		public function CSBaseObject()
		{
			XML.ignoreProcessingInstructions = false;
			XML.ignoreComments = false;
			XML.ignoreWhitespace = false;
		}
				
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getFilename
		 * ---------------------------------------------------------------------
		 *
		 * @return 
		 */
		public function getFilename():String
		{
			return this.myFilename;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * saveFile
		 * ---------------------------------------------------------------------
		 *
		 * @param filename 
		 */
		public function saveFile(filename:String):void
		{
			if( filename != null 
					&& filename != "" ) 
				this.myFilename = filename;
			
			XMLProcessor.saveXML(this.myXML, this.myFilename);
		}
		
	}
}