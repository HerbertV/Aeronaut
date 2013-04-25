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
package as3.aeronaut.module.aircraft
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.gui.*;
	
	import as3.aeronaut.module.CSWindowAircraft;
	
	import as3.aeronaut.objects.Aircraft;	
	
	import as3.hv.zinc.z3.xml.XMLFileList;
	
	// =========================================================================
	// Class PageCrew
	// =========================================================================
	// Aircraft Page 4 Crew 
	//
	public class PageCrew
			extends AbstractPage 
	{
		// =====================================================================
		// Variables
		// =====================================================================
		private var winAircraft:CSWindowAircraft = null;
		
		private var intCost:int = 0;
		private var intWeight:int = 0;
		
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function PageCrew()
		{
			super();
			
			this.numStepCrew.setupSteps(1,2,1,1);
			this.numStepCrew.setActive(false);
			this.pdCoPilot.setActive(false);
// TODO for bombers			
			//this.numStepEngine.addEventListener(MouseEvent.MOUSE_DOWN, engineCountChangedHandler); 
		}
		
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * init
		 * ---------------------------------------------------------------------
		 * this is called every time the aircraft changes (loading, new) 
		 *
		 * @param win
		 */
		public function init(win:CSWindowAircraft):void
		{
			this.winAircraft = win;
			var obj:Aircraft = Aircraft(this.winAircraft.getObject());
			var frame:String = this.winAircraft.getFrameType();
			
			if( frame == "fighter" || frame == "hoplite" )
			{
				this.numStepCrew.setupSteps(1,2,1,1);
				this.pdCoPilot.setActive(false);
				this.pdCoPilot.setActiveSelectionItem(CSPullDown.ID_EMPTYSELECTION);
			
			} else if( frame == "heavyFighter" ) {
				this.numStepCrew.setupSteps(1,2,2,1);
				this.pdCoPilot.setActive(true);
				
			} 
// TODO new bomber crew members			
			//this.numStepCrew.setValue(obj.getCrewCount());
			

			this.recalc();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 */
		public function dispose():void
		{

		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateObjectFromWindow
		 * ---------------------------------------------------------------------
		 * called by updateObjectFromWindow function from our window.
		 * transfers the changed values into the object.
		 *
		 * @return
		 */
		public function updateObjectFromWindow():Aircraft
		{
			var obj:Aircraft = Aircraft(this.winAircraft.getObject());
			
			if( this.pdPilot.getIDForCurrentSelection() != CSPullDown.ID_EMPTYSELECTION )
			{
				obj.setPilotFile(this.pdPilot.getIDForCurrentSelection());
			} else {
				obj.setPilotFile("");
			}
			
			if( this.pdCoPilot.getIDForCurrentSelection() != CSPullDown.ID_EMPTYSELECTION ) {
				obj.setCoPilotFile(this.pdCoPilot.getIDForCurrentSelection());
			} else {
				obj.setCoPilotFile("");
			}
		
			obj.setCrewCount(this.numStepCrew.getValue());

			return obj;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getCost
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getCost():int
		{	
			return this.intCost;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getWeight
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getWeight():int
		{
			
// TODO loader crew costs weight			
			return this.intWeight;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateDirLists
		 * ---------------------------------------------------------------------
		 */
		public function updateDirLists():void
		{
			this.pdPilot.clearSelectionItemList();
			this.pdCoPilot.clearSelectionItemList();
			this.pdPilot.setEmptySelectionText("",true);
			this.pdCoPilot.setEmptySelectionText("",true);
			
			
			var fl:XMLFileList = new XMLFileList(Globals.AE_EXT, "name");
			var arrFLPilots:Array = fl.generate( 
					mdm.Application.path, 
					Globals.PATH_DATA 
						+ Globals.PATH_AIRCRAFT,
					Aircraft.BASE_TAG
				);	
		
// TODO add filter for copilots and other crews
// copilot filter is differnet for HeavyFighters and Bombers/Cargos
			for( var i:int = 0; i< arrFLPilots.length; i++ ) 
			{
				this.pdPilot.addSelectionItem(
						arrFLPilots[i].viewname,
						arrFLPilots[i].filename
					); 
				this.pdCoPilot.addSelectionItem(
						arrFLPilots[i].viewname,
						arrFLPilots[i].filename
					); 
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * recalc
		 * ---------------------------------------------------------------------
		 * recalcs the weight and costs
		 */
		public function recalc():void
		{
			this.intCost = this.numStepCrew.getValue() *250;		
			
			this.winAircraft.calcCockpitCost();
		}
		
	}
}