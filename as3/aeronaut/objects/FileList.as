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
 * Copyright (c) 2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.objects
{
	import mdm.*;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.XMLProcessor;
	
	// =========================================================================
	// FileList
	// =========================================================================
	// obsolete will be replaced by XMLFileList
	public class FileList
	{
		/**
		 * ---------------------------------------------------------------------
		 * generate
		 * ---------------------------------------------------------------------
		 * generates an array of FileListElements. 
		 *
		 * @param path 			
		 *
		 * @returns				array of files
		 */
		public static function generate(
				path:String
			):Array
		{
			path = mdm.Application.path + path;
			
			var arr:Array = new Array();
			var myFiles:Array = mdm.FileSystem.getFileList(
					path, 
					"*" + Globals.AE_EXT
				);
			
			for( var i:int=0; i<myFiles.length; i++ ) 
			{
				var loadedxml:XML = XMLProcessor.loadXML(path + myFiles[i]);
				
				if( loadedxml != null ) 
				{
					if( XMLProcessor.checkDoc(loadedxml) ) 
					{
						var fle:FileListElement = new FileListElement(
								myFiles[i],
								loadedxml..name[0]
							);
						arr.push(fle);
					}
				}
			}
			
			if( arr.length > 1 ) 
				arr.sortOn(
						"viewname",
						Array.CASEINSENSITIVE
					);
			
			return arr;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * generateFilteredLoadouts
		 * ---------------------------------------------------------------------
		 * generates an array of FileListElements. Filtered for Aircrafts.
		 *
		 * @param path 			
		 * @param filterFile
		 *
		 * @returns				array of files
		 */
		public static function generateFilteredLoadouts(
				path:String,
				filterFile:String
			):Array
		{
			path = mdm.Application.path + path;
			
			if( filterFile.lastIndexOf("\\") > -1 )
			{
				filterFile = filterFile.substring(
						(filterFile.lastIndexOf("\\")+1),
						filterFile.length
					);
			}
			
			var arr:Array = new Array();
			var myFiles:Array = mdm.FileSystem.getFileList(
					path, 
					"*" + Globals.AE_EXT
				);
			
			for( var i:int=0; i<myFiles.length; i++ ) 
			{
				var loadedxml:XML = XMLProcessor.loadXML(path + myFiles[i]);
				
				if( loadedxml != null ) 
				{
					if( XMLProcessor.checkDoc(loadedxml) ) 
					{
						if( loadedxml.loadout.@srcAircraft == filterFile )
						{
							var fle:FileListElement = new FileListElement(
									myFiles[i],
									loadedxml..name[0]
								);
							arr.push(fle);
						}
					}
				}
			}
			
			if( arr.length > 1 ) 
				arr.sortOn(
						"viewname",
						Array.CASEINSENSITIVE
					);
			
			return arr;
		}
		
	}
}