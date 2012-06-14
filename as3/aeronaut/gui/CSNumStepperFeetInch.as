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
	// CSNumStepperFeetInch
	// =========================================================================
	// shows its value as feet and inches (e.g. "5,000 ft. 11 in.")
	//
	// a step is allway an inch.
	//
	public class CSNumStepperFeetInch 
			extends CSAbstractNumStepper
	{
		// =====================================================================
		// Variables
		// =====================================================================
		// in feet
		private var minValue:int = 0;
		// in feet
		private var maxValue:int = 0;
		
		private var currentFeet:int = 0;
		private var currentInch:int = 0;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function CSNumStepperFeetInch()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getInch
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getInch():int
		{
			return this.currentInch;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getFeet
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getFeet():int
		{
			return this.currentFeet;
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
					this.currentFeet,
					this.currentInch
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setValue
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function setValue(
				feet:int,
				inch:int
			):void
		{
			this.currentFeet = feet;
			this.currentInch = inch;
			
			this.updateTextField();
			this.toggleStepButtons();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setupSteps
		 * ---------------------------------------------------------------------
		 * minimum inches are always 0
		 * maximum inches are always 11
		 *
		 * @param minFeet
		 * @param maxFeet
		 * @param startFeet
		 * @param startInch
		 */
		public function setupSteps(
				minFeet:int,
				maxFeet:int,
				startFeet:int,
				startInch:int
			):void
		{
			this.minValue = minFeet;
			this.maxValue = maxFeet;
			this.currentFeet = startFeet;
			this.currentInch = startInch;
			
			this.updateTextField();
			this.toggleStepButtons();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateTextField
		 * ---------------------------------------------------------------------
		 * fills the text field with the new value
		 */
		override protected function updateTextField():void
		{
			this.txtValue.text = CSFormatter.formatFeetInch(
					this.currentFeet,
					this.currentInch
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * stepUp
		 * ---------------------------------------------------------------------
		 * set to next value
		 */
		override public function stepUp():void
		{
			this.currentInch++;
			
			if( this.currentInch == 12 ) 
			{
				this.currentInch = 0;
				this.currentFeet++;
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
			 this.currentInch--;
			
					
			if( this.currentInch == -1 ) 
			{
				this.currentInch = 11;
				this.currentFeet--;
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
			if( this.currentFeet < this.maxValue )
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
			if( this.currentFeet == this.minValue
					&& this.currentInch == 0 )
				return false;
			
			return true;
		}
	
	}
}
