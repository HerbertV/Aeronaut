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
 * Copyright (c) 2009-2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut
{
	import mdm.*;
	
	import as3.aeronaut.module.ICSWindow;
		
	/**
	 * =========================================================================
	 * Class CSDialogs
	 * =========================================================================
	 * static Dialog helper class
	 * with all preset Dialogs needed in Aeronaut
	 */
	public class CSDialogs
	{
	
		/**
		 * ---------------------------------------------------------------------
		 * selectLoadAE
		 * ---------------------------------------------------------------------
		 * returns the selected file or "false"
		 * 
		 * @param iwin ICSWindow Interface 
		 *
		 * @return
		 */
		public static function selectLoadAE(iwin:ICSWindow):String
		{
			var t:String = "Aeronaut File";
			var p:String = Globals.PATH_DATA;
			
			if( iwin != null )
			{
				t = iwin.getTitle();
				p += iwin.getSubPath();
			}
			mdm.Dialogs.BrowseFile.allowMultiple = false;
    		mdm.Dialogs.BrowseFile.title = "Load " + t;
    		mdm.Dialogs.BrowseFile.filterList = "Aeronaut|*" + Globals.AE_EXT;
    		mdm.Dialogs.BrowseFile.buttonText = "Load"
			
			mdm.Dialogs.BrowseFile.defaultDirectory = mdm.Application.path + p;
			
			return mdm.Dialogs.BrowseFile.show();	
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * selectSaveAE
		 * ---------------------------------------------------------------------
		 * returns the selected file or "false"
		 * 
		 * @param iwin ICSWindow Interface 
		 *
		 * @return
		 */
		public static function selectSaveAE(iwin:ICSWindow):String
		{
			var fullPath:String = iwin.getFilename();
			var defaultFile:String = "";
			
			mdm.Dialogs.BrowseFile.allowMultiple = false;
			mdm.Dialogs.BrowseFile.title = "Save " + iwin.getTitle();
    		mdm.Dialogs.BrowseFile.filterList = "Aeronaut|*" + Globals.AE_EXT;
    		mdm.Dialogs.BrowseFile.buttonText = "Save";
			
			if( fullPath == "" )
			{
				fullPath = mdm.Application.path 
						+ Globals.PATH_DATA 
						+ iwin.getSubPath();
			} else {
				defaultFile = fullPath.substring(
						(fullPath.lastIndexOf("\\")+1),
						fullPath.length
					);
				fullPath = fullPath.substring(
						0,
						fullPath.lastIndexOf("\\")
					);
			}
			
			mdm.Dialogs.BrowseFile.defaultDirectory = fullPath;
			mdm.Dialogs.BrowseFile.defaultFilename = defaultFile;
    			
			return mdm.Dialogs.BrowseFile.show();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * selectImportImage
		 * ---------------------------------------------------------------------
		 * returns the selected file or "false"
		 * 
		 * @param titleSuffix
		 *
		 * @return
		 */
		public static function selectImportImage(titleSuffix:String):String
		{
			var importDir:String = mdm.System.Paths.personal;
			
			if( Globals.lastSelectedImportDir != null ) 
				importDir = Globals.lastSelectedImportDir;
			
			mdm.Dialogs.BrowseFile.title = "Import " + titleSuffix;
			mdm.Dialogs.BrowseFile.allowMultiple = false;
			mdm.Dialogs.BrowseFile.dialogText = "Choose a image file for import.";		
			mdm.Dialogs.BrowseFile.buttonText = "Import"
			mdm.Dialogs.BrowseFile.filterList = "Images (*.jpg;*.gif;*.png)|*.jpg;*.gif;*.png"			
			mdm.Dialogs.BrowseFile.filterText = "Images (*.jpg;*.gif;*.png)|*.jpg;*.gif;*.png"
			mdm.Dialogs.BrowseFile.defaultDirectory = importDir;
						
			return mdm.Dialogs.BrowseFile.show();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * fileExitsNotOrOverwrite
		 * ---------------------------------------------------------------------
		 * dialog with file exist check included.
		 * returns true if the file doesn't exist or the user want to overwrite
		 * it.
		 *
		 * @return
		 */
		public static function fileExitsNotOrOverwrite(filePath:String):Boolean
		{
			if ( mdm.FileSystem.fileExists(filePath) ) 
				return mdm.Dialogs.promptModal(
						filePath
							+"\nexists already."
							+ "\nDo you want to overwrite it?",
						"yesno",
						"alert"
					);
					
			return true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * changesNotSaved
		 * ---------------------------------------------------------------------
		 * warning dialog for unsaved changes. 
		 * returns true if the user wants to discard the changes.
		 *
		 * @return
		 */
		public static function changesNotSaved():Boolean
		{
			return mdm.Dialogs.promptModal(
					"Your current changes are not saved."
						+ "\nAll changes will be lost if you proceed."
						+ "\nContinue anyway?", 
					"yesno", 
					"alert"
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * wantToExit
		 * ---------------------------------------------------------------------
		 * want to exit question
		 *
		 * @return
		 */
		public static function wantToExit():Boolean
		{
			return mdm.Dialogs.promptModal(
					"Are you sure you want to exit?", 
					"yesno", 
					"alert"
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * onlyValidPrint
		 * ---------------------------------------------------------------------
		 * info 
		 *
		 * @return
		 */
		public static function onlyValidPrint():Boolean
		{
			return mdm.Dialogs.promptModal(
					"Only valid files can be printed!", 
					"okcancel", 
					"info"
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * onlyValidSave
		 * ---------------------------------------------------------------------
		 * info 
		 *
		 * @return
		 */
		public static function onlyValidSave():Boolean
		{
			return mdm.Dialogs.promptModal(
					"Only valid files can be saved!", 
					"okcancel", 
					"info"
				);
		}
	}
}