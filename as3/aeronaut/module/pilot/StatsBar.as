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
 * Copyright (c) 2009-2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.module.pilot
{
	import flash.display.MovieClip;
	
	import as3.aeronaut.Globals;
	
	import as3.aeronaut.gui.CSNumStepperInteger;
	import as3.aeronaut.gui.CSNumStepperQuickDraw;
	import as3.aeronaut.gui.ICSStyleable;
	
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.Pilot;
	
	import as3.aeronaut.module.CSWindowPilot;
	
	
	// =========================================================================
	// StatsBar
	// =========================================================================
	// This class is linked to library symbol "StatsBar" inside CSWindowPilot
	// @see as3.aeronaut.objects.Pilot
	//
	public class StatsBar
			extends MovieClip
			implements ICSStyleable
	{
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var winPilot:CSWindowPilot = null;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function StatsBar()
		{
			super();
			
			this.numStepNT.setValueChangedCallback(
					stepperChangedHandler
				);
			this.numStepSS.setValueChangedCallback(
					stepperChangedHandler
				);
			this.numStepDE.setValueChangedCallback(
					stepperChangedHandler
				);
			this.numStepSH.setValueChangedCallback(
					stepperChangedHandler
				);
			this.numStepCO.setValueChangedCallback(
					stepperChangedHandler
				);
			this.numStepQD.setValueChangedCallback(
					stepperChangedHandler
				);
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * init
		 * ---------------------------------------------------------------------
		 * this is called every time the pilot changes (loading, new) and
		 * if the pilot type was changed.
		 *
		 * @param win
		 */
		public function init(win:CSWindowPilot):void
		{
			this.winPilot = win;
			
			var pilotType:String = this.winPilot.getPilotType();
			var max:int = 10;
			
			if( Globals.myRuleConfigs.getIsPilotFeatsActive() )
				max = 11;
			
			if( pilotType == Pilot.TYPE_GUNNER) 
			{
// TODO  if linked to is implemented use other pilot stats -1 
				this.numStepNT.setupSteps(0, max, 0, 1);
				this.numStepNT.setActive(false);
				this.numStepSS.setupSteps(0, max, 0, 1);
				this.numStepSS.setActive(false);
				this.numStepDE.setupSteps(0, max, 0, 1);
				this.numStepDE.setActive(false);
				this.numStepSH.setupSteps(0, max, 0, 1);
				this.numStepSH.setActive(false);
				this.numStepCO.setupSteps(0, max, 0, 1);
				this.numStepCO.setActive(false);
				
				this.numStepQD.setupSteps(0, 0, max, 0, 0);
				this.numStepQD.setActive(false);
				
			} else {
				var obj:Pilot = Pilot(this.winPilot.getObject());
				
				this.initActiveStatStepper(this.numStepNT, obj.getNaturalTouch(), max);
				this.initActiveStatStepper(this.numStepSS, obj.getSixthSense(), max);
				this.initActiveStatStepper(this.numStepDE, obj.getDeadEye(), max);
				this.initActiveStatStepper(this.numStepSH, obj.getSteadyHand(), max);
				this.initActiveStatStepper(this.numStepCO, obj.getConstitution(), max);
				
				this.numStepNT.setActive(true);
				this.numStepSS.setActive(true);
				this.numStepDE.setActive(true);
				this.numStepSH.setActive(true);
				this.numStepCO.setActive(true);
				
				var arrQD:Array = obj.getQuickDraw();
				if (arrQD[0] == 0) {
					this.numStepQD.setupSteps(1,0,max ,1,arrQD[1]);
				} else {
					this.numStepQD.setupSteps(arrQD[0],arrQD[1],max ,arrQD[0],arrQD[1]);
				}
				this.numStepQD.setActive(true);
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 */
		public function dispose():void
		{	
			this.winPilot = null;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setStyle
		 * ---------------------------------------------------------------------
		 * call this from the contructor in your implementation
		 *
		 * @param s
		 */
		public function setStyle(s:int):void
		{
			for( var i:int = 0; i < this.numChildren; i++ )
				if( this.getChildAt(i) is ICSStyleable ) 
					ICSStyleable(this.getChildAt(i)).setStyle(s);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initActiveStatStepper
		 * ---------------------------------------------------------------------
		 * 
		 * @param statStepper
		 * @param min 
		 * @param current 
		 * @param max 10 or 11
		 */
		public function initActiveStatStepper(
				statStepper:CSNumStepperInteger, 
				current:uint,
				max:uint
			):void
		{
			var min:uint = current;
			
			if( current == 0 )
			{
				current = 1;
				min = 1;
				if( statStepper.name == "numStepCO" )
				{
					current = 3;
					min = 3;
				}
			}
			
			if( this.winPilot.getPilotType() ==  Pilot.TYPE_NPC )
				min = 0;
			
			statStepper.setupSteps(min, max, current, 1);
			statStepper.setActive(true);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateCOLost
		 * ---------------------------------------------------------------------
		 * 
		 * @param lost 
		 */
		public function updateCOLost(lost:int):void
		{
			var obj:Pilot = Pilot(this.winPilot.getObject());
			var max:int = 10;
			
			if( Globals.myRuleConfigs.getIsPilotFeatsActive() )
				max = 11;
			
			this.numStepCO.setupSteps(
					(obj.getConstitution() - lost),
					max, 
					(this.numStepCO.getValue() - lost),
					1
				);
				
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
		public function updateObjectFromWindow():Pilot
		{
			var obj:Pilot = Pilot(this.winPilot.getObject());
			
			obj.setNaturalTouch(this.numStepNT.getValue());
			obj.setSixthSense(this.numStepSS.getValue());
			obj.setDeadEye(this.numStepDE.getValue());
			obj.setSteadyHand(this.numStepSH.getValue());
			obj.setConstitution(this.numStepCO.getValue());
			obj.setQuickDraw(
					this.numStepQD.getFullPoints(), 
					this.numStepQD.getSubPoints()
				);
				
			return obj;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * hasElevenStat
		 * ---------------------------------------------------------------------
		 * returns true if one stat is 11
		 *
		 * @return
		 */
		public function hasElevenStat():Boolean
		{
			if( this.numStepNT.getValue() > 10 )
				return true;
			
			if( this.numStepSS.getValue() > 10 )
				return true;
				
			if( this.numStepDE.getValue() > 10 )
				return true;
				
			if( this.numStepSH.getValue() > 10 )
				return true;
				
			if( this.numStepCO.getValue() > 10 )
				return true;
				
			if( this.numStepQD.getFullPoints() > 10 )
				return true;
			
			return false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * hasToMuchElevenStats
		 * ---------------------------------------------------------------------
		 * returns true if more than one stat is 11
		 *
		 * @return
		 */
		public function hasToMuchElevenStats():Boolean
		{
			var count:uint = 0;
			if( this.numStepNT.getValue() > 10 )
				count++;
			
			if( this.numStepSS.getValue() > 10 )
				count++;
				
			if( this.numStepDE.getValue() > 10 )
				count++;
				
			if( this.numStepSH.getValue() > 10 )
				count++;
				
			if( this.numStepCO.getValue() > 10 )
				count++;
				
			if( this.numStepQD.getFullPoints() > 10 )
				count++;
			
			if( count > 1 )
				return true;
				
			return false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcEP
		 * ---------------------------------------------------------------------
		 */
		public function calcEP():void
		{
			var pilotType:String = this.winPilot.getPilotType();
			var obj:Pilot = Pilot(this.winPilot.getObject());
			var ep:int = 0;
			
			if( pilotType != Pilot.TYPE_HERO 
					&& pilotType != Pilot.TYPE_SIDEKICK )
			{
				this.winPilot.setStatsEP(0);
				return;
			}
			
			ep += calcEPForStat(
					obj.getNaturalTouch(), 
					this.numStepNT.getValue()
				);
			ep += calcEPForStat(
					obj.getSixthSense(), 
					this.numStepSS.getValue()
				);
			ep += calcEPForStat(
					obj.getDeadEye(), 
					this.numStepDE.getValue()
				);
			ep += calcEPForStat(
					obj.getSteadyHand(), 
					this.numStepSH.getValue()
				);
			ep += calcEPForStat(
					obj.getConstitution(), 
					this.numStepCO.getValue()
				);
				
			//Special quickdraw
			// fullpoints
			ep += calcEPForStat(
					obj.getQuickDraw()[0], 
					this.numStepQD.getFullPoints()
				);
			//subpoints		
			ep += ( ( this.numStepQD.getSubPoints() 
						- obj.getQuickDraw()[1] )
					* 10
				);
			// update window
			this.winPilot.setStatsEP(ep);
		}

		/**
		 * ---------------------------------------------------------------------
		 * calcEPForStat
		 * ---------------------------------------------------------------------
		 * @param from
		 * @param to
		 */
		private function calcEPForStat(from:int, to:int):int
		{
			var ep:int = 0;
			for( var i:int = from; i < to; i++ ) 
				ep += Pilot.STAT_EPMATRIX[i];
			
			return ep;			
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * stepperChangedHandler
		 * ---------------------------------------------------------------------
		 * 
		 * @param e
		 */
		private function stepperChangedHandler(o:Object):void
		{
			this.calcEP();
			this.winPilot.calcEP();
			this.winPilot.validateForm();
			this.winPilot.setSaved(false);
		}
		
	}
}