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
package as3.aeronaut.gui
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	
	// =========================================================================
	// CSObjectStepper
	// =========================================================================
	// a stepper that works with a list which is stepped through by an index.
	//
	public class CSListStepper
			extends CSAbstractNumStepper
	{
		// =====================================================================
		// Variables
		// =====================================================================
		protected var minValue:int = 0;
		protected var maxValue:int = 0;
		
		protected var stepValue:int = 1;
		protected var currentValue:int = 0;
		protected var listOffset:int = 0;
		
		protected var arrList:Array = new Array();
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function CSListStepper()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * setListOffset
		 * ---------------------------------------------------------------------
		 * sets an offset for the list that is added for getValue()
		 * and subtracted in setValue()
		 *
		 * important: 
		 * the function needs to be called before the 
		 * first call of setupSteps or get/set value
		 *
		 * @param val
		 */
		public function setListOffset(val:int):void
		{
			this.listOffset = val;
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * getValue
		 * ---------------------------------------------------------------------
		 * returns the index of the list incl. offset
		 *
		 * @return
		 */
		public function getValue():int
		{
			return this.currentValue + this.listOffset;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setValue
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setValue(val:int):void
		{
			this.currentValue = val - this.listOffset;
			
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
		 * @param valueList
		 */
		public function setupSteps(
				min:int, 
				max:int, 
				start:int,
				valueList:Array
			):void
		{
			this.arrList = valueList;
			this.minValue = min - this.listOffset;
			this.maxValue = max - this.listOffset;
			this.currentValue = start - this.listOffset;
			
			this.updateTextField();
			this.toggleStepButtons();
		}
			
		/**
		 * ---------------------------------------------------------------------
		 * updateTextField
		 * ---------------------------------------------------------------------
		 * fills the text field with the new value from the list
		 */
		override protected function updateTextField():void
		{
			if( this.arrList == null )
				return;
			
			if( this.currentValue >= this.arrList.length )
			{
				this.txtValue.text = "n.a.";
				return;
			}
			
			this.txtValue.text = String( this.arrList[this.currentValue] );
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
