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
 * @version: 2.0.0
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
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.XMLProcessor;
	
	import as3.hv.core.utils.StringHelper;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	// =========================================================================
	// Squadron
	// =========================================================================
	public class Squadron
			extends CSBaseObject 
			implements ICSBaseObject
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const FILE_VERSION:String = "2.0";
		public static const BASE_TAG:String = "squadron";
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		
		// =====================================================================
		// Contructor
		// =====================================================================
		public function Squadron()
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
		 * creates an empty squadron xml
		 */
		public function createNew():void
		{
			myXML = new XML();
			myXML =
				<aeronaut XMLVersion={XMLProcessor.XMLDOCVERSION}>
					<squadron version="2.0" srcLogo="">
						<name>New Squadron</name>
					</squadron>
				</aeronaut>;
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
			
			if( Squadron.checkXML(loadedxml) ) 
			{
				this.myXML = loadedxml;
				this.updateVersion();
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"loaded File  was not a valid Squadron.",
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
			if( Squadron.checkXML(xmldoc) ) 
			{
				this.myXML = xmldoc;
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"set XML was not a valid Squadron.",
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
			if( this.myXML.squadron.@version == FILE_VERSION )
				return;
				
			if( Console.isConsoleAvailable() )
				Console.getInstance().writeln(
						"Updating Squadron File",
						DebugLevel.DEBUG,
						"from " + this.myXML.squadron.@version 
							+ " to " +FILE_VERSION
					);
			
			// update from 1.0 to 2.0
			if( this.myXML.squadron.attribute("version").length() == 0 )
			{
				// TODO add new tags
				
			}
			//this.myXML.squadron.@version = FILE_VERSION;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getName
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getName():String 
		{
			return myXML.squadron.name.text().toString();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setName
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setName(val:String):void
		{
			this.myXML.squadron.replace(
					"name", 
					<name>{StringHelper.trim(val," ")}</name>
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSrcLogo
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getSrcLogo():String
		{
			return myXML.squadron.@srcLogo;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setSrcLogo
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setSrcLogo(val:String) 
		{
			this.myXML.squadron.@srcLogo = val;
		}
	
	}
}