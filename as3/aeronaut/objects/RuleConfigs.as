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
	// MDM ZINC Lib
	import mdm.*;
		
	import as3.aeronaut.Globals;
	import as3.aeronaut.AeronautXMLProcessor;
	
	import as3.hv.core.xml.AbstractXMLProcessor;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	/**
	 * =========================================================================
	 * RuleConfigs
	 * =========================================================================
	 */ 
	public class RuleConfigs
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const FILE_VERSION:String = "1.1";
		
		public static const USE_OFFICIAL:String = "official";
		public static const USE_CUSTOM:String = "custom";
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var ready:Boolean = false;
		private var settingsChanged:Boolean = false;
		private var myXML:XML = new XML();
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 */
		public function RuleConfigs()
		{
			var file:String = mdm.Application.path 
					+ Globals.PATH_DATA
					+ "ruleConfigs"
					+ Globals.AE_EXT;
			
			var aexml:AeronautXMLProcessor = new AeronautXMLProcessor();
			aexml.loadXML(file);
			this.myXML = aexml.getXML();
			
			if( this.myXML == null ) 
				return;
			
			if( AbstractXMLProcessor.checkDoc(this.myXML) == false ) 
				return;
			
			ready = true;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * isReady
		 * ---------------------------------------------------------------------
		 *
		 * @return
		 */
		public function isReady():Boolean
		{
			return ready;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * saveFile
		 * ---------------------------------------------------------------------
		 */
		public function saveFile()
		{
			if( this.ready == true 
					&& this.settingsChanged == true )
			{
				var file:String = mdm.Application.path 
						+ Globals.PATH_DATA 
						+ "ruleConfigs"
						+ Globals.AE_EXT;
				
				var aexml:AeronautXMLProcessor = new AeronautXMLProcessor();
				aexml.saveXML(file,this.myXML);
				this.settingsChanged = false;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getIsPrintingAircraftFlavorSheet
		 * ---------------------------------------------------------------------
		 * <genericSettings>
		 * 	<printAircraftFlavorSheet doPrint="false"/>
		 * </genericSettings>
		 *
		 * @return
		 */
		public function getIsPrintingAircraftFlavorSheet():Boolean
		{
			if( ready )
				if( this.myXML..genericSettings.printAircraftFlavorSheet.@doPrint == "true" ) 
					return true;
			
			return false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setIsPrintingAircraftFlavorSheet
		 * ---------------------------------------------------------------------
		 *
		 * @param val
		 */
		public function setPrintingAircraftFlavorSheet(val:Boolean)
		{
			if( ready ) 
			{
				if( val == true )
				{
					this.myXML..genericSettings.printAircraftFlavorSheet.@doPrint = "true";
				} else {
					this.myXML..genericSettings.printAircraftFlavorSheet.@doPrint = "false";
				}
				this.settingsChanged = true;
			} 
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getIsPilotFeatsActive
		 * ---------------------------------------------------------------------
		 * <activatePilotFeats active="true"/>
		 *
		 * @return
		 */
		public function getIsPilotFeatsActive():Boolean
		{
			if( ready )
				if( this.myXML.ruleConfigs.activatePilotFeats.@active == "true" ) 
					return true;
			 
			return false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setPilotFeatsActive
		 * ---------------------------------------------------------------------
		 *
		 * @param val
		 */
		public function setPilotFeatsActive(val:Boolean)
		{
			if( ready )
			{
				if( val == true ) 
				{
					this.myXML.ruleConfigs.activatePilotFeats.@active = "true";
				} else {
					this.myXML.ruleConfigs.activatePilotFeats.@active = "false";
				}
				this.settingsChanged = true;
			} 
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getIsMaxCharacteristicCheckActive
		 * ---------------------------------------------------------------------
		 * <activateMaxCharacteristicCheck active="true"/>
		 *
		 * @return
		 */
		public function getIsMaxCharacteristicCheckActive():Boolean
		{
			if( ready ) 
				if( this.myXML.ruleConfigs.activateMaxCharacteristicCheck.@active == "true" )
					return true;
					
			return false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setMaxCharacteristicCheckActive
		 * ---------------------------------------------------------------------
		 *
		 * @param val
		 */
		public function setMaxCharacteristicCheckActive(val:Boolean)
		{
			if( ready )
			{
				if( val == true )
				{
					this.myXML.ruleConfigs.activateMaxCharacteristicCheck.@active = "true";
				} else {
					this.myXML.ruleConfigs.activateMaxCharacteristicCheck.@active = "false";
				}
				this.settingsChanged = true;
			} 
		}
				
		/**
		 * ---------------------------------------------------------------------
		 * getRocketHardpointMassreduction
		 * ---------------------------------------------------------------------
		 * <modifiedRocketHardpoints useRule="official">
		 * 		<ruleMRHP type="official" massReduction="-10"/>
		 * </modifiedRocketHardpoints>
		 *	
		 * @return returns the massreduction in lbs
		 */
		public function getRocketHardpointMassreduction():int
		{
			if( ready ) 
			{
				var useRule:String = this.myXML.ruleConfigs.modifiedRocketHardpoints.@useRule;
				var xml:XMLList = this.myXML..ruleMRHP.(@type == useRule);
				return int(xml.@massReduction);
			} 
			return 0;
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * useRuleRocketHardpointMassreduction
		 * ---------------------------------------------------------------------
		 *	
		 * @param val
		 */
		public function useRuleRocketHardpointMassreduction(val:String)
		{
			this.myXML.ruleConfigs.modifiedRocketHardpoints.@useRule  = val;
			this.settingsChanged = true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * usesRuleRocketHardpointMassreduction
		 * ---------------------------------------------------------------------
		 *	
		 * @return which rule is used official or ff5
		 */
		public function usesRuleRocketHardpointMassreduction():String
		{
			return this.myXML.ruleConfigs.modifiedRocketHardpoints.@useRule;
		}
	
	}
}