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
package as3.aeronaut.gui
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	
	import as3.aeronaut.objects.Pilot;
	
	// =========================================================================
	// CSNumStepperQuickDraw
	// =========================================================================
	// Special Numeric Stepper for extended Quickdraw rule.
	//
	public class CSNumStepperQuickDraw 
			extends CSAbstractNumStepper
	{
		// =====================================================================
		// Variables
		// =====================================================================
		// min full points
		private var minFull:int = 0;
		// min float value
		private var minSub:int = 0;
		// max value is full stat points
		private var maxValue:int = 0;
		// full stat points
		private var currentFullValue:int = 0;
		// float stat points
		private var currentSubValue:int = 0;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function CSNumStepperQuickDraw()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getFullPoints
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getFullPoints():int
		{
			return this.currentFullValue;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSubPoints
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getSubPoints():int
		{
			return this.currentSubValue;
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * getValue
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getValue():Array
		{
			return new Array(
					this.currentFullValue, 
					this.currentSubValue
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setValue
		 * ---------------------------------------------------------------------
		 * @param full
		 * @param sub
		 */
		public function setValue(
				full:int,
				sub:int
			):void
		{
			this.currentFullValue = full;
			this.currentSubValue = sub;
			
			this.updateTextField();
			this.toggleStepButtons();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setupSteps
		 * ---------------------------------------------------------------------
		 * @param minF
		 * @param minS
		 * @param maxF
		 * @param startFull
		 * @param startSub
		 */
		public function setupSteps(
				minF:int, 
				minS:int,
				maxFull:int,
				startFull:int, 
				startSub:int
			):void
		{
			this.minFull = minF;
			this.minSub = minS;
			this.maxValue = maxFull;
			this.currentFullValue = startFull;
			this.currentSubValue = startSub;
			
			this.updateTextField();
			this.toggleStepButtons();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateTextField
		 * ---------------------------------------------------------------------
		 * files the text field with the new value
		 */
		override protected function updateTextField():void
		{
			if( this.currentSubValue > 0 )
			{
				this.txtValue.text = this.currentFullValue 
						+ "." 
						+ this.currentSubValue;
			} else {
				this.txtValue.text = String( this.currentFullValue );
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * stepUp
		 * ---------------------------------------------------------------------
		 * set to next value
		 */
		override public function stepUp():void
		{
			var maxSubVal:int = Pilot.STAT_XPMATRIX[this.currentFullValue]/10;
							
			this.currentSubValue++;
			if( this.currentSubValue >= maxSubVal )
			{
				this.currentSubValue = 0;
				this.currentFullValue++;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * stepDown
		 * ---------------------------------------------------------------------
		 * set to previous value
		 */
		override public function stepDown():void
		{
			this.currentSubValue--;
			
			if( this.currentSubValue <= -1 )
			{
				this.currentFullValue--;
				var maxSubVal:int = Pilot.STAT_XPMATRIX[this.currentFullValue]/10;
				this.currentSubValue = maxSubVal -1 ;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * hasNextStep
		 * ---------------------------------------------------------------------
		 * @return
		 */
		override public function hasNextStep():Boolean
		{
			if( this.currentFullValue < this.maxValue )
				return true;
				
			return false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * hasPreviousStep
		 * ---------------------------------------------------------------------
		 * @return
		 */
		override public function hasPreviousStep():Boolean
		{
			if( this.currentFullValue == this.minFull 
					&& this.currentSubValue == this.minSub )
				return false;
			
			return true;
		}
		
	}
}
