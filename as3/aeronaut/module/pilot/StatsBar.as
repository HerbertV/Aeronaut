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
	
	import flash.events.MouseEvent;
	
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
			
			
			this.numStepNT.addEventListener(
					MouseEvent.MOUSE_DOWN,
					stepperChangedHandler
				);
			this.numStepSS.addEventListener(
					MouseEvent.MOUSE_DOWN,
					stepperChangedHandler
				);
			this.numStepDE.addEventListener(
					MouseEvent.MOUSE_DOWN,
					stepperChangedHandler
				);
			this.numStepSH.addEventListener(
					MouseEvent.MOUSE_DOWN,
					stepperChangedHandler
				);
			this.numStepCO.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					stepperChangedHandler
				);
			this.numStepQD.addEventListener(
					MouseEvent.MOUSE_DOWN,
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
			
			if( pilotType == Pilot.TYPE_GUNNER) 
			{
// TODO  if linked to is implemented use other pilot stats -1 
				this.initStatStepper(this.numStepNT, 0, false);
				this.initStatStepper(this.numStepSS, 0, false);
				this.initStatStepper(this.numStepDE, 0, false);
				this.initStatStepper(this.numStepSH, 0, false);
				this.initStatStepper(this.numStepCO, 0, false);
				
				this.numStepQD.setupSteps(0, 0, 11, 0, 0);
				this.numStepQD.setActive(false);
				
			} else {
				var obj:Pilot = Pilot(this.winPilot.getObject());
				
				this.initStatStepper(this.numStepNT, obj.getNaturalTouch(), true);
				this.initStatStepper(this.numStepSS, obj.getSixthSense(), true);
				this.initStatStepper(this.numStepDE, obj.getDeadEye(), true);
				this.initStatStepper(this.numStepSH, obj.getSteadyHand(), true);
				this.initStatStepper(this.numStepCO, obj.getConstitution(), true);
				
				var arrQD:Array = obj.getQuickDraw();
				if (arrQD[0] == 0) {
					this.numStepQD.setupSteps(0,0,11 ,1,arrQD[1]);
				} else {
					this.numStepQD.setupSteps(arrQD[0],arrQD[1],11 ,arrQD[0],arrQD[1]);
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
			
			this.numStepNT.removeEventListener(
					MouseEvent.MOUSE_DOWN,
					stepperChangedHandler
				);
			this.numStepSS.removeEventListener(
					MouseEvent.MOUSE_DOWN,
					stepperChangedHandler
				);
			this.numStepDE.removeEventListener(
					MouseEvent.MOUSE_DOWN,
					stepperChangedHandler
				);
			this.numStepSH.removeEventListener(
					MouseEvent.MOUSE_DOWN,
					stepperChangedHandler
				);
			this.numStepCO.removeEventListener(
					MouseEvent.MOUSE_DOWN, 
					stepperChangedHandler
				);
			this.numStepQD.removeEventListener(
					MouseEvent.MOUSE_DOWN,
					stepperChangedHandler
				);
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
		 * initStatStepper
		 * ---------------------------------------------------------------------
		 * 
		 * @param statStepper
		 * @param min
		 * @param active
		 */
		public function initStatStepper(
				statStepper:CSNumStepperInteger, 
				min:uint,
				active:Boolean
			):void
		{
			var curr:uint = min;
			if( min == 0 )
			{
				curr = 1;
				if( statStepper.name == "numStepCO" )
					curr = 3;
			}
			if( this.winPilot.getPilotType() ==  Pilot.TYPE_NPC )
				min = 0;
			
			statStepper.setupSteps(min,11 ,curr,1);
			statStepper.setActive(active);
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
				return;
			
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
				ep += Pilot.STAT_XPMATRIX[i];
			
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
		private function stepperChangedHandler(e:MouseEvent):void
		{
			if( !e.currentTarget.getIsActive() )
				return;
			
			this.calcEP();
			this.winPilot.calcEP();
			this.winPilot.validateForm();
			this.winPilot.setSaved(false);
		}
		
	}
}