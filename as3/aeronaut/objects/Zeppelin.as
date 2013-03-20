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
package as3.aeronaut.objects
{
	// MDM ZINC Lib
	import mdm.*;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.XMLProcessor;
	
	
	// =========================================================================
	// Zeppelin
	// =========================================================================
	// TODO 
	public class Zeppelin 
			extends CSBaseObject 
			implements ICSBaseObject
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const FILE_VERSION:String = "1.0";
		public static const BASE_TAG:String = "zeppelin";
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		
		// =====================================================================
		// Contructor
		// =====================================================================
		public function Zeppelin()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * checkXML
		 * ---------------------------------------------------------------------
		 * @param xmldoc
		 *
		 * @return
		 */
		public static function checkXML(xmldoc:XML):Boolean
		{
			if (XMLProcessor.checkDoc(xmldoc)
					&& xmldoc.child(BASE_TAG).length() == 1 ) 
				return true;
			
			return false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * createNew
		 * ---------------------------------------------------------------------
		 * TODO
		 */
		public function createNew():void
		{
			/*
			TODO
			myXML = new XML();
			myXML =
				<aeronaut XMLVersion={XMLProcessor.XMLDOCVERSION}>
					<zeppelin version="FILE_VERSION">
						TODO
					</zeppelin>
				</aeronaut>;
			*/
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * loadFile
		 * ---------------------------------------------------------------------
		 * @param filename
		 */
		public function loadFile(filename:String):void
		{
			this.myFilename = filename;
			var loadedxml:XML = XMLProcessor.loadXML(filename);
			
			if( Zeppelin.checkXML(loadedxml) ) 
			{
				this.myXML = loadedxml;
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"loaded File  was not a valid Zeppelin.",
							DebugLevel.ERROR,
							filename
						);
				this.createNew();
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setXML
		 * ---------------------------------------------------------------------
		 * @param xmldoc
		 */
		public function setXML(xmldoc:XML):void 
		{
			if( Zeppelin.checkXML(xmldoc) ) 
			{
				this.myXML = xmldoc;
				this.updateVersion();
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"set XML was not a valid Zeppelin.",
							DebugLevel.ERROR
						);
				this.createNew();
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateVersion
		 * ---------------------------------------------------------------------
		 */
		public function updateVersion():void
		{
			if( this.myXML.zeppelin.@version == FILE_VERSION )
				return;
				
			if( Console.isConsoleAvailable() )
				Console.getInstance().writeln(
						"Updating Zeppelin File",
						DebugLevel.DEBUG,
						"from " + this.myXML.zeppelin.@version 
							+ " to " +FILE_VERSION
					);
					
			//this.myXML.loadout.@version = FILE_VERSION;
		}
	
	}
}