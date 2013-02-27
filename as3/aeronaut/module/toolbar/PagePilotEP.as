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
	import flash.text.TextField;
		
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.FocusEvent;
	
	import as3.aeronaut.objects.RuleConfigs;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.gui.*;
	
	import as3.aeronaut.module.CSToolbarBottom;
	import as3.aeronaut.module.ICSToolbarBottom;
	import as3.aeronaut.module.ICSWindowPilot;
	
	// =========================================================================
	// Class PagePilotEP
	// =========================================================================
	// The Pilot EP and Misson Page from our toolbar
	//
	public class PagePilotEP
			extends AbstractPage 
	{
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var linkedPilotWindow:ICSWindowPilot = null;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function PagePilotEP()
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
			this.rbtnSurvived.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickButtonsHandler
				);
			this.rbtn1stKill.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickKillButtonsHandler
				);
			this.rbtn2ndKill.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickKillButtonsHandler
				);
			this.rbtn3rdKill.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickKillButtonsHandler
				);
			
			this.numStepAdditionalKills.setupSteps(0,10,0,1);
			this.numStepAdditionalKills.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickKillButtonsHandler
				);
			
			this.rbtnLanding.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickButtonsHandler
				);
			this.rbtnMomento.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickButtonsHandler
				);
			this.rbtnCargo.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickButtonsHandler
				);
			
			this.rbtnBailOutNagativ.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickButtonsHandler
				);
			this.rbtnFled.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickButtonsHandler
				);
			
			this.txtStuntEP.restrict = "0-9";
			this.txtOtherEP.restrict = "0-9";

			this.txtStuntEP.addEventListener(
					TextEvent.TEXT_INPUT, 
					textInputHandler
				);
			this.txtOtherEP.addEventListener(
					TextEvent.TEXT_INPUT, 
					textInputHandler
				);
			this.txtStuntEP.addEventListener(
					FocusEvent.FOCUS_OUT, 
					textFocusHandler
				);
			this.txtOtherEP.addEventListener(
					FocusEvent.FOCUS_OUT,
					textFocusHandler
				);

			this.btnOk.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickOkHandler
				);
			this.btnCancel.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickCancelHandler
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
			
			this.rbtnSurvived.setSelected(false);
			this.rbtn1stKill.setSelected(false);
			this.rbtn2ndKill.setSelected(false);
			this.rbtn3rdKill.setSelected(false);
			
			this.numStepAdditionalKills.setValue(0);
			
			this.rbtnLanding.setSelected(false);
			this.rbtnMomento.setSelected(false);
			this.rbtnCargo.setSelected(false);
			
			this.rbtnBailOutNagativ.setSelected(false);
			this.rbtnFled.setSelected(false);
			
			this.txtStuntEP.text = "0";
			this.txtOtherEP.text = "0";
			
			this.lblNewEP.text = "0";
			
			this.rbtnLostAircraft.setSelected(false);
			this.rbtnBailOutPositiv.setSelected(false);
						
			this.updateEPChecklist();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateEPInfosFromPilot
		 * ---------------------------------------------------------------------
		 * prepares the data from the active pilot window
		 * 
		 * @param win
		 * @param missiom
		 * @param currentCO
		 */
		public function updateEPInfosFromPilot(
				win:ICSWindowPilot,
				mission:int,
				currentCO:int
			):void
		{
			this.linkedPilotWindow = win;
			// automatical count the missions up
			this.numStepMissionCounter.setupSteps(1,999,mission+1,1);
			// if all COs are lost the pilot is dead
			this.numStepCOLost.setupSteps(0 ,currentCO-1 , 0,1);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateEPChecklist
		 * ---------------------------------------------------------------------
		 */
		private function updateEPChecklist()
		{
			if( this.rbtn1stKill.getIsSelected() ) {
				this.rbtn2ndKill.setActive(true);
			} else {
				this.rbtn2ndKill.setActive(false);
				this.rbtn2ndKill.setSelected(false);
			}
			
			if( this.rbtn2ndKill.getIsSelected() ) {
				this.rbtn3rdKill.setActive(true);
			} else {
				this.rbtn3rdKill.setActive(false);
				this.rbtn3rdKill.setSelected(false);
			}
			
			if( this.rbtn3rdKill.getIsSelected() == true ) {
				this.numStepAdditionalKills.setActive(true);
			} else {
				this.numStepAdditionalKills.setActive(false);
				this.numStepAdditionalKills.setValue(0);
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateNewEP
		 * ---------------------------------------------------------------------
		 */
		private function updateNewEP()
		{
			var newEP:int = 0;
			
			if( this.rbtnSurvived.getIsSelected() )
				newEP += 20;
			
			if( this.rbtn1stKill.getIsSelected() )
				newEP += 20;
			
			if( this.rbtn2ndKill.getIsSelected() ) 
				newEP += 40;
			
			if( this.rbtn3rdKill.getIsSelected() ) 
				newEP += 60;
			
			newEP += (this.numStepAdditionalKills.getValue() * 80);
			
			if( this.rbtnLanding.getIsSelected() ) 
				newEP += 10;
			
			if( this.rbtnMomento.getIsSelected() )
				newEP += 5;
			
			if( this.rbtnCargo.getIsSelected() ) 
				newEP += 10;
			
			if( this.rbtnBailOutNagativ.getIsSelected() ) 
				newEP -= 20;
			
			if( this.rbtnFled.getIsSelected() ) 
				newEP -= 10;
			
			newEP += int( this.txtStuntEP.text );
			newEP += int( this.txtOtherEP.text );
						
			this.lblNewEP.text = String( newEP );
		}
		
		// =====================================================================
		// EventHandler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * clickOkHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickOkHandler(e:MouseEvent):void
		{
			//Update Pilot Xp in CSwindowpilot
			this.updateNewEP();
			
			var kills:int = 0;
			if( this.rbtn1stKill.getIsSelected() ) 
				kills++;
			
			if( this.rbtn2ndKill.getIsSelected() ) 
				kills++;
			
			if( this.rbtn3rdKill.getIsSelected() )
				kills++;
			
			kills += this.numStepAdditionalKills.getValue();
			
			// send updates to window
			this.linkedPilotWindow.updateNewEPAndMissionStuff(
					int(this.lblNewEP.text), 
					this.numStepCOLost.getValue(),
					this.numStepMissionCounter.getValue(), 
					kills, 
					this.rbtnBailOutPositiv.getIsSelected(),
					this.rbtnLostAircraft.getIsSelected()
				);
			//close toolbar
			Globals.myToolbarBottom.changeState(0);
			this.linkedPilotWindow = null;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clickCancelHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickCancelHandler(e:MouseEvent):void
		{
			Globals.myToolbarBottom.changeState(0);
			this.linkedPilotWindow = null;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clickKillButtonsHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickKillButtonsHandler(e:MouseEvent):void
		{
			this.updateEPChecklist();
			this.updateNewEP();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clickButtonsHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickButtonsHandler(e:MouseEvent):void
		{
			this.updateNewEP();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * textInputHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function textInputHandler(e:TextEvent):void
		{
			var numExp:RegExp = /[0-9]/;
            // default handling gets the new digit after
			// updateNewEp was called so we need to handle 
			// the complete input by our selfs.
			e.preventDefault();  

			var targetField:TextField = (e.target as TextField);
			
			if( !numExp.test(e.text) )
				return;
				
			if( targetField.text.length >= 3 )
			{
				targetField.text = targetField.text.substring(0,3); 
				return;
			}
			if( targetField.text == "0" )
			{
				targetField.text = e.text;
			} else {
				var lastcaret:int = targetField.caretIndex;
				var txtlen:int = targetField.text.length;
				var beforeCaret:String = targetField.text.substring(0,lastcaret);
				var afterCaret:String = targetField.text.substring(lastcaret,txtlen);
				
				targetField.text = beforeCaret + e.text + afterCaret;
				targetField.setSelection(lastcaret+1,lastcaret+1);
			}
			
			this.updateNewEP();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * textFocusHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function textFocusHandler(e:FocusEvent):void
		{
			this.updateNewEP();
		}
	
	}
}