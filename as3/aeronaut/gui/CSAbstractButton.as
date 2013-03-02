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
	
	import as3.hv.components.tooltip.ITooltip;
	
	// =========================================================================
	// CSAbstractButton
	// =========================================================================
	// Abstract Button class 
	// supports ITooltip
	//
	public class CSAbstractButton
			extends MovieClip
	{
		// =====================================================================
		// Variables
		// =====================================================================
		protected var tooltipText:String = "";
		protected var myTooltip:ITooltip = null;
		
		protected var isActive:Boolean = true;
		protected var isRollover:Boolean = false;
		protected var isClick:Boolean = false;
		
		// =====================================================================
		// Contructor
		// =====================================================================
		public function CSAbstractButton()
		{
			super();
			
			this.updateView();
			
			this.buttonMode = true;
			this.tabEnabled = false;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * setActive
		 * ---------------------------------------------------------------------
		 * @param a
		 */
		public function setActive(a:Boolean):void
		{
			this.isActive = a;
			
			if( !this.isActive ) 
			{
				this.isRollover = false;
				this.isClick = false;
			}
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
		 * setupTooltip
		 * ---------------------------------------------------------------------
		 * @param tt
		 * @param txt
		 */
		public function setupTooltip(
				tt:ITooltip, 
				txt:String
			):void
		{
			this.myTooltip = tt;
			this.tooltipText = txt;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateView
		 * ---------------------------------------------------------------------
		 */
		public function updateView():void
		{
			throw new Error("Abstract function needs override!");
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * overHandler
		 * ---------------------------------------------------------------------
		 * @param e MouseEvent
		 */
		protected function overHandler(e:MouseEvent):void
		{
			if( !this.isActive )
				return;
				
			this.isRollover = true;
			this.updateView();
				
			if( this.myTooltip != null 
					&& this.tooltipText != "" ) 
			{
				this.myTooltip.setLabel(tooltipText)
				//showTooltip(delayShow:int=0,delayHide:int=-1)
				this.myTooltip.showTooltip(2,5);
			}
			
			this.stage.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * outHandler
		 * ---------------------------------------------------------------------
		 * @param e MouseEvent
		 */
		protected function outHandler(e:MouseEvent):void
		{
			this.isClick = false;
			this.isRollover = false;
			this.updateView();
			
			if( myTooltip != null ) 
				this.myTooltip.hide();
				
			if( this.stage != null ) 
				this.stage.removeEventListener(MouseEvent.MOUSE_OUT, outHandler);	
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * downHandler
		 * ---------------------------------------------------------------------
		 * @param e MouseEvent
		 */
		protected function downHandler(e:MouseEvent):void
		{
			if ( !this.isActive )
				return;
			
			this.isClick = true;
			this.updateView();
				
			if( this.myTooltip != null ) 
				this.myTooltip.hide();
				
			if( this.stage != null ) 
				this.stage.removeEventListener(MouseEvent.MOUSE_OUT, outHandler);		
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * upHandler
		 * ---------------------------------------------------------------------
		 * @param e MouseEvent
		 */
		protected function upHandler(e:MouseEvent):void
		{
			if( !this.isActive ) 
				return;
				
			this.isClick = false;
			this.updateView();
		}
		
	}
}
