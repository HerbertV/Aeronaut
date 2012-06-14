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
	
	// =========================================================================
	// CSAbstractNumStepper
	// =========================================================================
	// Dynamic abstract NumStepper class 
	//
	// Any NumStepper needs following sub mc's:
	// - BG_black
	// - BG_white
	// - buttons.btnUp
	// - buttons.btnDown
	// - txtValue
	//
	dynamic public class CSAbstractNumStepper 
			extends MovieClip 
			implements ICSStyleable
	{
		// =====================================================================
		// Variables
		// =====================================================================
		protected var myStyle:int = CSStyle.BLACK;
		
		protected var isActive:Boolean = true;
		
		protected var autoStepDelay:int = 5;
		protected var autoStepDelayCounter:int = 0;
		
		protected var isUpArrowPressed:Boolean = false;
		protected var isDownArrowPressed:Boolean = false;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function CSAbstractNumStepper()
		{
			super();
			
			this.BG_white.visible = false;
			this.txtValue.text = "";
			
			this.buttons.btnUp.addEventListener(
					MouseEvent.MOUSE_DOWN,
					clickUpHandler
				);
			this.buttons.btnDown.addEventListener(
					MouseEvent.MOUSE_DOWN,
					clickDownHandler
				);
			this.buttons.btnUp.addEventListener(
					MouseEvent.MOUSE_UP, 
					releaseUpHandler
				);
			this.buttons.btnDown.addEventListener(
					MouseEvent.MOUSE_UP, 
					releaseDownHandler
				);
			
			//for autostepper
			this.addEventListener(
					Event.ENTER_FRAME,
					enterFrameHandler
				);
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * setStyle
		 * ---------------------------------------------------------------------
		 * @param s
		 */
		public function setStyle(s:int):void 
		{
			this.myStyle = s;
			
			this.buttons.btnUp.setStyle(s);
			this.buttons.btnDown.setStyle(s);
			this.updateView();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setActive
		 * ---------------------------------------------------------------------
		 * @param a
		 */
		public function setActive(a:Boolean) 
		{
			this.isActive = a;
			
			this.toggleStepButtons();
			this.updateView();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getIsActive
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getIsActive():Boolean 
		{
			return this.isActive;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateView
		 * ---------------------------------------------------------------------
		 *
		 */
		public function updateView():void
		{
			this.BG_black.visible = false;
			this.BG_white.visible = false;
						
			this.buttons.btnUp.updateView();
			this.buttons.btnDown.updateView();
			
			if( this.myStyle == CSStyle.BLACK ) 
			{
				this.BG_black.visible = true;
				
				if( !this.isActive )
				{
					this.txtValue.textColor = 0xB1B1B1;
				} else {
					this.txtValue.textColor = 0x000000;
				}
				return;
			}
			if( this.myStyle == CSStyle.WHITE )
			{
				this.BG_white.visible = true;
			
				if( this.isActive == false )
				{
					this.txtValue.textColor = 0xB1B1B1;
				} else {
					this.txtValue.textColor = 0xFFFFFF;
				}
				return;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * toggleStepButtons
		 * ---------------------------------------------------------------------
		 * switches the step buttons active/inactive
		 */
		protected function toggleStepButtons():void
		{
			if( !this.hasNextStep()
					|| !this.isActive )
			{
				this.buttons.btnUp.setActive(false);
			} else {
				this.buttons.btnUp.setActive(true);
			}
			
			if( !this.hasPreviousStep()
					|| !this.isActive )
			{
				this.buttons.btnDown.setActive(false);
			} else {
				this.buttons.btnDown.setActive(true);
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateTextField
		 * ---------------------------------------------------------------------
		 * files the text field with the new value
		 */
		protected function updateTextField():void
		{
			throw new Error("Abstract function needs override!");
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * stepUp
		 * ---------------------------------------------------------------------
		 * set to next value
		 */
		public function stepUp():void
		{
			throw new Error("Abstract function needs override!");
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * stepDown
		 * ---------------------------------------------------------------------
		 * set to previous value
		 */
		public function stepDown():void
		{
			throw new Error("Abstract function needs override!");
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * hasNextStep
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function hasNextStep():Boolean
		{
			throw new Error("Abstract function needs override!");
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * hasPreviousStep
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function hasPreviousStep():Boolean
		{
			throw new Error("Abstract function needs override!");
		}
		
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * enterFrameHandler
		 * ---------------------------------------------------------------------
		 * for auto stepping, while a step button is pressed
		 *
		 * @param  e
		 */
		protected function enterFrameHandler(e:Event):void
		{
			// nothing pressed
			if( !this.isUpArrowPressed 
					&& !this.isDownArrowPressed )
				return;
			
			// delay a bit
			if( this.autoStepDelayCounter < this.autoStepDelay )
			{
				this.autoStepDelayCounter++;
				return;
			}
			
			this.autoStepDelayCounter = 0;
			
			if( this.isUpArrowPressed == true ) 
			{
				if( this.hasNextStep() )
				{
					this.stepUp();
					this.updateTextField();
				} else {
					this.isUpArrowPressed = false;
				}
			}
			
			if( this.isDownArrowPressed == true ) 
			{
				if( this.hasPreviousStep() )
				{
					this.stepDown();
					this.updateTextField();
				} else {
					this.isDownArrowPressed = false;
				}
			}
			this.toggleStepButtons();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clickUpHandler
		 * ---------------------------------------------------------------------
		 *
		 * @param  e
		 */
		protected function clickUpHandler(e:MouseEvent):void
		{
			if( !this.isActive )
				return;
			
			if( !this.hasNextStep() )			
				return;
			
			this.stepUp();
			this.updateTextField();
			
			this.isUpArrowPressed = true;
			this.autoStepDelayCounter = 0;
			
			this.toggleStepButtons();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * releaseUpHandler
		 * ---------------------------------------------------------------------
		 *
		 * @param  e
		 */
		protected function releaseUpHandler(e:MouseEvent):void
		{
			this.isUpArrowPressed = false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clickDownHandler
		 * ---------------------------------------------------------------------
		 *
		 * @param  e
		 */
		protected function clickDownHandler(e:MouseEvent):void
		{
			if( !this.isActive )
				return;
			
			if( !this.hasPreviousStep() )			
				return;
			
			this.stepDown();
			this.updateTextField();
			
			this.isDownArrowPressed = true;
			this.autoStepDelayCounter = 0;
			
			this.toggleStepButtons();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * releaseDownHandler
		 * ---------------------------------------------------------------------
		 *
		 * @param  e
		 */
		protected function releaseDownHandler(e:MouseEvent):void
		{
			this.isDownArrowPressed = false;
		}
	}

}
