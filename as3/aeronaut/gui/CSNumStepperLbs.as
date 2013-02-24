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
	
	import as3.aeronaut.CSFormatter;
	
	// =========================================================================
	// CSNumStepperLbs
	// =========================================================================
	// a integer based stepper which formats it's output for lbs:
	// e.g. 5,000 lbs
	//
	public class CSNumStepperLbs 
			extends CSAbstractNumStepper
	{
		// =====================================================================
		// Variables
		// =====================================================================
		protected var minValue:int = 0;
		protected var maxValue:int = 0;
		
		protected var stepValue:int = 1;
		protected var currentValue:int = 0;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function CSNumStepperLbs()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getValue
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getValue():int
		{
			return this.currentValue;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setValue
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setValue(val:int):void
		{
			this.currentValue = val;
			
			this.updateTextField();
			this.toggleStepButtons();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setupSteps
		 * ---------------------------------------------------------------------
		 * @param min
		 * @param max
		 * @param start
		 * @param step
		 */
		public function setupSteps(
				min:int, 
				max:int, 
				start:int,
				step:int=1
			):void
		{
			this.minValue = min;
			this.maxValue = max;
			this.currentValue = start;
			this.stepValue = step;
			
			this.updateTextField();
			this.toggleStepButtons();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateTextField
		 * ---------------------------------------------------------------------
		 * fills the text field with the new value
		 * also updates the tooltip
		 */
		override protected function updateTextField():void
		{
			this.txtValue.text = CSFormatter.formatLbs(this.currentValue);
			
			var kg:Number = CSFormatter.convertLbs2Kg(this.currentValue);
			this.tooltipText = CSFormatter.formatKg(kg);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * stepUp
		 * ---------------------------------------------------------------------
		 * set to next value
		 */
		override public function stepUp():void
		{
			this.currentValue += this.stepValue;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * stepDown
		 * ---------------------------------------------------------------------
		 * set to previous value
		 */
		override public function stepDown():void
		{
			this.currentValue -= this.stepValue;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * hasNextStep
		 * ---------------------------------------------------------------------
		 * @return
		 */
		override public function hasNextStep():Boolean
		{
			if( this.currentValue < this.maxValue )
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
			if( this.currentValue > this.minValue ) 
				return true;
			
			return false;
		}
		
	}
}
