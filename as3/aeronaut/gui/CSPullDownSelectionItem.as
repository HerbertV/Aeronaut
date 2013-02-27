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
	import flash.text.TextField;
	
	// =========================================================================
	// CSPullDownSelectionItem
	// =========================================================================
	// 
	public class CSPullDownSelectionItem 
			extends MovieClip 
			implements ICSStyleable
	{
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var myStyle:int = CSStyle.BLACK;
		
		private var isActive:Boolean = true;
		private var isRollover:Boolean = false;
		private var isClick:Boolean = false;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function CSPullDownSelectionItem()
		{
			super();
			
			this.buttonMode = true;
			this.tabEnabled = false;
			
			this.myLabel.text = "";

			this.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * resizeWidth
		 * ---------------------------------------------------------------------
		 * @param newW
		 */
		public function resizeWidth(newW:int):void
		{
			this.myLabel.width = newW;
			this.touchLayer.width = newW;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setLabel
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setLabel(val:String):void
		{
			this.myLabel.text = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getLabel
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getLabel():String
		{
			return this.myLabel.text;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setStyle
		 * ---------------------------------------------------------------------
		 * @param s
		 */
		public function setStyle(s:int):void 
		{
			this.myStyle = s;
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
		 * resetState
		 * ---------------------------------------------------------------------
		 */
		public function resetState():void
		{
			this.isRollover = false;
			this.isClick = false;
		
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateView
		 * ---------------------------------------------------------------------
		 */
		public function updateView():void
		{
			if( this.myStyle == CSStyle.BLACK ) 
			{
				if( !this.isActive ) 
				{
					this.myLabel.textColor = 0xB1B1B1;
				} else if( this.isClick ) {
					this.myLabel.textColor = 0x000000;
				} else if( this.isRollover ) {
					this.myLabel.textColor = 0xFF0000;
				} else {
					this.myLabel.textColor = 0x000000;
				}
				return;			
			}
			if( this.myStyle == CSStyle.WHITE ) 
			{
				if( !this.isActive )
				{
					this.myLabel.textColor = 0xB1B1B1;
				} else if( this.isClick == true ) {
					this.myLabel.textColor = 0xFFFFFF;
				} else if( this.isRollover == true ) {
					this.myLabel.textColor = 0xFF0000;
				} else {
					this.myLabel.textColor = 0xFFFFFF;
				}
			}
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * overHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function overHandler(e:MouseEvent):void
		{
			if( !this.isActive )
				return;
			
			this.isRollover = true;
			this.updateView();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * outHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function outHandler(e:MouseEvent):void
		{
			this.isRollover = false;
			this.updateView();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * downHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function downHandler(e:MouseEvent):void
		{
			if( !this.isActive )
				return;
			
			this.isClick = true;
			this.updateView();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * upHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function upHandler(e:MouseEvent):void
		{
			if( !this.isActive )
				return;
			
			this.isClick = false;
			this.updateView();
		}

	}
}
