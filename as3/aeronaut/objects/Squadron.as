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
	import as3.aeronaut.AeronautXMLProcessor;
	
	import as3.aeronaut.objects.squadron.*;
	
	import as3.hv.core.xml.AbstractXMLProcessor;
	
	import as3.hv.core.utils.StringHelper;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	/**
	 * =========================================================================
	 * Class Squadron
	 * =========================================================================
	 */
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
		
		
		/**
		 * =====================================================================
		 * Contructor
		 * =====================================================================
		 */
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
			if( AbstractXMLProcessor.checkDoc(xmldoc)
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
				<aeronaut XMLVersion={AbstractXMLProcessor.XMLDOCVERSION} xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://xsd.veitengruber.com/aeronaut.xsd">
					<squadron version="2.0" srcLogo="" typeID="" honorLevel="1">
						<name>New Squadron</name>
						<priorityList> </priorityList>
						<characteristicList> </characteristicList>
						<description> </description>
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
			var aexml:AeronautXMLProcessor = new AeronautXMLProcessor();
			aexml.loadXML(filename);
			var loadedxml:XML = aexml.getXML();
			
			if( Squadron.checkXML(loadedxml) ) 
			{
				this.myXML = loadedxml;
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
		public function updateVersion():Boolean
		{
			if( this.myXML.squadron.@version == FILE_VERSION )
				return false;
				
			if( Console.isConsoleAvailable() )
				Console.getInstance().writeln(
						"Updating Squadron File",
						DebugLevel.DEBUG,
						"from " + this.myXML.squadron.@version 
							+ " to " +FILE_VERSION
					);
			
			// update from 1.0 to 2.0
			if( this.myXML.squadron.attribute("priorityList").length() == 0 )
			{
// TODO add new tags and attributes
				// typeID="" honorLevel="1"
/*
				<priorityList> </priorityList>
				<characteristicList> </characteristicList>
				<description> </description>
*/
			}
			//this.myXML.squadron.@version = FILE_VERSION;
			return true;
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
		
		/**
		 * ---------------------------------------------------------------------
		 * getDescription
		 * ---------------------------------------------------------------------
		 * @since 2.0
		 * 
		 * @return
		 */
		public function getDescription():String 
		{
			return myXML.squadron.description.text().toString();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setDescription
		 * ---------------------------------------------------------------------
		 * @since 2.0
		 * 
		 * @param val
		 */
		public function setDescription(val:String):void
		{
			this.myXML.squadron.replace(
					"description", 
					<description>{StringHelper.trim(val," ")}</description>
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getTypeID
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getTypeID():String
		{
			return myXML.squadron.@typeID;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setTypeID
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setTypeID(val:String) 
		{
			this.myXML.squadron.@typeID = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getHonorLevel
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getHonorLevel():int
		{
			return int(myXML.squadron.@honorLevel);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setHonorLevel
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setHonorLevel(val:int) 
		{
			this.myXML.squadron.@honorLevel = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSquadronCharacteristics
		 * ---------------------------------------------------------------------
		 * there is no object class since we need only to store the id 
		 *
		 * @return
		 */
		public function getSquadronCharacteristics():Array
		{
			var arr:Array = new Array();

			for each( var sc:XML in myXML..characteristicList ) 
				arr.push(sc.@ID);
			
			return arr;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setSquadronCharacteristics
		 * ---------------------------------------------------------------------
		 * there is no object class since we need only to store the id 
		 *
		 * @param arr
		 */
		public function setSquadronCharacteristics(arr:Array)
		{
			var newScXML:XML = <characteristicList>
							   </characteristicList>;
									
			for( var i:int = 0; i< arr.length; i++ )  
				newScXML.appendChild(
						<squardronCharacteristic ID={arr[i]} />
					);
			
			myXML.squadron.replace(
					"characteristicList",
					newScXML
				);
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * getSquadronPriorities
		 * ---------------------------------------------------------------------
		 *
		 * @return Array of SquadronTypes sorted by rank
		 */
		public function getSquadronPriorities():Array
		{
			var arr:Array = new Array();

			for each( var xml:XML in myXML..squadronPriority ) 
			{
				var obj:Priority = new Priority(
						xml.@ID, 
						xml.@rank
					);
				arr.push(obj);
			}
			if( arr.length > 1 )
				arr.sortOn(
						"rank",
						Array.CASEINSENSITIVE
					);
			
			return arr;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setSquadronPriorities
		 * ---------------------------------------------------------------------
		 *
		 * @param arr
		 */
		public function setSquadronPriorities(arr:Array)
		{
			var newpXML:XML = <priorityList>
							   </priorityList>;
									
			for( var i:int = 0; i< arr.length; i++ )  
				newpXML.appendChild(
						<squadronPriority ID={arr[i].myID} rank={arr[i].rank}/>
					);
			
			myXML.squadron.replace(
					"priorityList",
					newpXML
				);
		}
	}
}