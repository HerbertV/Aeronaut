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
package as3.aeronaut
{
	// MDM ZINC Lib
	import mdm.*;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	import as3.aeronaut.Globals;
	
	// =========================================================================
	// XMLProcessor
	// =========================================================================
	// based on AS3 xml 
	// read/write xml
	// 
	public class XMLProcessor
	{
		// =====================================================================
		// Constants
		// =====================================================================
		
		public static const XMLDOCVERSION:String = "1.0";
		
		public static const XMLROOTTAG:String = "aeronaut";
		
		// =====================================================================
		// Functions
		// =====================================================================
				
		/**
		 * ---------------------------------------------------------------------
		 * loadXML
		 * ---------------------------------------------------------------------
		 * load xml via zinc FileSystem. returns null if loading failed.
		 *
		 * @param filename 			
		 *
		 * @return loaded xml
		 */
		public static function loadXML(
				filename:String
			):XML
		{
			try 
			{
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"loading XML: ",
							DebugLevel.INFO,
							filename
						);
				
				var unicodeData:String = mdm.FileSystem.loadFileUnicode(filename);
				var xmldoc:XML = XML(unicodeData);
				
				return xmldoc;
			}
			catch (error:Error)
			{
				if( Console.isConsoleAvailable() )
				{
					Console.getInstance().writeln(
							"IO Error while loading XML: ",
							DebugLevel.ERROR,
							filename
								+ "<br>" + error.message
						);
					Console.getInstance().newLine();
				}
   			}
			return null;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * saveXML
		 * ---------------------------------------------------------------------
		 * save xml via zinc FileSystem. returns true if the save succeeded
		 * and false if it failed. 
		 *
		 * @param xmldoc
		 * @param filename
		 *
		 * @return
		 */
		public static function saveXML(
				xmldoc:XML, 
				filename:String
			):Boolean
		{
			try 
			{
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"saving XML: ",
							DebugLevel.INFO,
							filename
						);
				
				mdm.FileSystem.saveFileUnicode(
						filename, 
						xmldoc.toXMLString()
					);
			}
			catch( error:Error )
			{
				Console.getInstance().writeln(
							"IO Error while saving XML: ",
							DebugLevel.ERROR,
							filename
								+ "<br>" + error.message
						);
				Console.getInstance().newLine();
				
				return false;
			}
			return true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * checkDoc
		 * ---------------------------------------------------------------------
		 * checks the root tag and the doc version. 
		 *
		 * @param xmldoc
		 *
		 * @return
		 */
		public static function checkDoc(
				xmldoc:XML
			):Boolean
		{
			if( xmldoc.name().localName != XMLROOTTAG )
			{
				Console.getInstance().writeln(
						"Not a valid aeronaut xml.",
							DebugLevel.FATAL_ERROR
						);
				Console.getInstance().newLine();
				return false;
			}
			
			if( xmldoc.@XMLVersion != XMLDOCVERSION )
			{
				Console.getInstance().writeln(
						"XML doc version is not " + XMLDOCVERSION,
							DebugLevel.FATAL_ERROR
						);
				Console.getInstance().newLine();
				return false;
			}
			return true;	
		}
				
	}
}