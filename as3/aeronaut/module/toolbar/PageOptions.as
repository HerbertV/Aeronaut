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
package as3.aeronaut.module.toolbar
{
	// MDM ZINC Lib
	import mdm.*;
		
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import as3.aeronaut.objects.RuleConfigs;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.gui.*;
	
	// =========================================================================
	// Class PageOptions
	// =========================================================================
	// The Options Page from our toolbar
	//
	public class PageOptions 
			extends AbstractPage 
	{
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var rbgRocketHPMass:CSRadioButtonGroup = null;
		private var rbgAircraftCost:CSRadioButtonGroup = null;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function PageOptions()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * setup
		 * ---------------------------------------------------------------------
		 */
		public function setup():void
		{
			this.rbgRocketHPMass = new CSRadioButtonGroup();
			this.rbgRocketHPMass.addMember(
					this.rbtnOfficialRocketHPMass,
					RuleConfigs.USE_OFFICIAL
				);
			this.rbgRocketHPMass.addMember(
					this.rbtnCustomRocketHPMass,
					RuleConfigs.USE_CUSTOM
				);
			
			this.btnSaveSettings.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickSaveHandler
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * showPage
		 * ---------------------------------------------------------------------
		 */
		override public function showPage():void
		{
			super.showPage();
			
			this.rbtnUsePilotFeats.setSelected(
					Globals.myRuleConfigs.getIsPilotFeatsActive()
				);
			this.rbtnCheckMaxCharacteristics.setSelected(
					Globals.myRuleConfigs.getIsMaxCharacteristicCheckActive()
				);
			
			this.rbgRocketHPMass.setValue(
					Globals.myRuleConfigs.usesRuleRocketHardpointMassreduction()
				);
			
			this.rbtnPrintAircraftFlavorSheet.setSelected(
					Globals.myRuleConfigs.getIsPrintingAircraftFlavorSheet()
				);
		}
		
		// =====================================================================
		// EventHandler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * clickSaveHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickSaveHandler(e:MouseEvent):void
		{
			Globals.myRuleConfigs.setPilotFeatsActive(
					this.rbtnUsePilotFeats.getIsSelected()
				);
			Globals.myRuleConfigs.setMaxCharacteristicCheckActive(
					this.rbtnCheckMaxCharacteristics.getIsSelected()
				);
			
			Globals.myRuleConfigs.useRuleRocketHardpointMassreduction(
					this.rbgRocketHPMass.getValue()
				);
			
			Globals.myRuleConfigs.setPrintingAircraftFlavorSheet(
					this.rbtnPrintAircraftFlavorSheet.getIsSelected()
				);
			
			Globals.myRuleConfigs.saveFile();
		}
	
	}
}