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
 * Special thanks to Neil Holley
 * who wrote a cadet file parser in python.
 * https://bitbucket.org/neilh/cadetparser.py/src
 * Which I used as concept for the import feature.
 * 
 * Copyright (c) 2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.cadet 
{
	// MDM ZINC Lib
	import mdm.*;
	
	import flash.utils.ByteArray;
	
	/**
	 * =========================================================================
	 * AbstractCadetImporter
	 * =========================================================================
	 * Abstract base class for all cadet import classes.
	 * 
	 */
	public class AbstractCadetImporter 
	{
		// =====================================================================
		// Constants
		// =====================================================================
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		private static var lastSelectedCadetDir:String = "";
		
		protected var bytes:ByteArray;
		
		
		/**
		 * =====================================================================
		 * Contructor
		 * =====================================================================
		 * 
		 * @param b
		 */
		public function AbstractCadetImporter(b:ByteArray) 
		{
			bytes = b;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * selectImportImage
		 * ---------------------------------------------------------------------
		 * returns the selected file path or "false"
		 * 
		 * @param titleSuffix
		 * @param ext extension of the cadet file (cdt or cdp)
		 *
		 * @return
		 */
		public static function selectImportCadetFile(
				titleSuffix:String, 
				ext:String
			):String
		{
			var importDir:String = mdm.System.Paths.personal;
			
			if( AbstractCadetImporter.lastSelectedCadetDir != "" ) 
				importDir = AbstractCadetImporter.lastSelectedCadetDir;
			
			mdm.Dialogs.BrowseFile.title = "Import CADET " + titleSuffix;
			mdm.Dialogs.BrowseFile.allowMultiple = false;
			mdm.Dialogs.BrowseFile.dialogText = "Choose a CADET file for import.";		
			mdm.Dialogs.BrowseFile.buttonText = "Import"
			mdm.Dialogs.BrowseFile.filterList = "Cadet (*." + ext + ")|*." + ext;		
			mdm.Dialogs.BrowseFile.filterText = "Cadet (*." + ext + ")|*." + ext;
			mdm.Dialogs.BrowseFile.defaultDirectory = importDir;
						
			var selected:String = mdm.Dialogs.BrowseFile.show();
			
			if( selected != "false" )
			{
				AbstractCadetImporter.lastSelectedCadetDir = 
						selected.substring(0,selected.lastIndexOf("\\"));
			}
			return selected;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * invalidFile
		 * ---------------------------------------------------------------------
		 * Dialog that pops up if the parsing failed.
		 * 
		 * @param filePath
		 *
		 * @return
		 */
		public static function invalidFile(filePath:String):void
		{
			mdm.Dialogs.promptModal(
						filePath
							+"\nis no valid CADET file.",
						"okcancel",
						"alert"
					);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * parseBytes
		 * ---------------------------------------------------------------------
		 * parses the ByteArray
		 * 
		 * @return returns false if something went wrong
		 */
		public function parseBytes():Boolean
		{
			throw new Error("Abstract function needs override!");
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * parseString
		 * ---------------------------------------------------------------------
		 * parses a string entry in our byte array.
		 * All cadet strings start with an integer that define the string length.
		 * 
		 * @return
		 */
		protected function parseString():String
		{
			var len:int = bytes.readInt();
			return bytes.readUTFBytes(len);
		}
	}

}