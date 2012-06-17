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
	import flash.text.TextField;
	
	import flash.geom.Rectangle;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// =========================================================================
	// CSScrollbar
	// =========================================================================
	// Scrollbar (only the Dragger without the line)
	// is linked to scrollbars inside the fla's library. 
	//
	// The Scrollbar needs following sub mc's:
	// - black_normal
	// - black_inactive
	// - black_rollover
	// - black_click
	// - white_normal
	// - white_inactive
	// - white_rollover
	// - white_click
	//
	public class CSScrollbar
			extends CSAbstractButton 
			implements ICSStyleable
	{
		// =====================================================================
		// Variables
		// =====================================================================
		// default style is black
		protected var myStyle:int = CSStyle.BLACK;
		
		private var scrollingText:TextField = null;
		private var scrollTop:int = 0;
		private var scrollBottom:int = 0;
		
		private var scrollButtonUp:CSAbstractButton = null;
		private var scrollButtonDown:CSAbstractButton = null;
		
		// =====================================================================
		// Contructor
		// =====================================================================
		public function CSScrollbar()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * setup
		 * ---------------------------------------------------------------------
		 * @param txt
		 * @param top
		 * @param bottom
		 * @param sbtnUp
		 * @param sbtnDown
		 */
		public function setup(
				txt:TextField, 
				top:int, 
				bottom:int,
				sbtnUp:CSAbstractButton=null,
				sbtnDown:CSAbstractButton=null
			):void 
		{
			this.scrollingText = txt;
			this.scrollTop = top;
			this.scrollBottom = bottom;
			
			this.scrollButtonUp = sbtnUp;
			this.scrollButtonDown = sbtnDown;
			
			this.addEventListener(
					MouseEvent.MOUSE_DOWN,
					startScroll
				);
			this.stage.addEventListener(
					MouseEvent.MOUSE_UP,
					stopScroll
				);
			
			this.updateView();
			
			this.updatePosition();
			this.updateSize();
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
		 * updateView
		 * ---------------------------------------------------------------------
		 */
		override public function updateView():void
		{
			this.black_normal.visible = false;
			this.black_inactive.visible = false;
			this.black_rollover.visible = false;
			this.black_click.visible = false;
			
			this.white_normal.visible = false;
			this.white_inactive.visible = false;
			this.white_rollover.visible = false;
			this.white_click.visible = false;
			
			if( this.myStyle == CSStyle.BLACK ) 
			{
				if( !this.isActive )
				{
					this.black_inactive.visible = true;
				} else if( this.isClick == true ) {
					this.black_click.visible = true;
				} else if( this.isRollover == true ) {
					this.black_rollover.visible = true;
				} else {
					this.black_normal.visible = true;
				}
				return;
			}
			if( this.myStyle == CSStyle.WHITE ) 
			{
				if (this.isActive == false) {
					this.white_inactive.visible = true;
				} else if (this.isClick == true) {
					this.white_click.visible = true;
				} else if (this.isRollover == true) {
					this.white_rollover.visible = true;
				} else {
					this.white_normal.visible = true;
				}
				return;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updatePosition
		 * ---------------------------------------------------------------------
		 * updates the scrollbars position
		 */
		public function updatePosition():void
		{
			if( this.scrollingText == null )
				return;
			
			if( this.scrollingText.maxScrollV == 1 )
			{
				this.setActive(false);
				this.visible = false;
				return;
			}
			
			this.setActive(true);
			this.visible = true;
			
			var percent:Number = this.scrollingText.scrollV 
					/ this.scrollingText.maxScrollV;
			
			this.y = this.scrollTop 
					+ (percent * ( this.scrollBottom - this.height ) );
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateSize
		 * ---------------------------------------------------------------------
		 * updates the scrollbars size
		 */
		public function updateSize():void
		{
			if( this.scrollingText == null )
				return;
			
			var maxDistance:Number = this.scrollBottom - this.scrollTop;
			
			// since there is no function to get max visible lines
			var visibleLines:int = this.scrollingText.numLines 
					- this.scrollingText.maxScrollV;
			this.height = this.scrollBottom * visibleLines 
					/ this.scrollingText.numLines;
			
		}
		
		
		
		/**
		 * ---------------------------------------------------------------------
		 * startScroll Event
		 * ---------------------------------------------------------------------
		 * scrollbar -> textfield
		 *
		 * @param e 		MouseEvent
		 */
		private function startScroll(e:MouseEvent):void
		{
			this.startDrag(
					false,
					new Rectangle(
							this.x,
							this.scrollTop,
							0,
							this.scrollBottom - this.height
						)
				);
			this.addEventListener(
					Event.ENTER_FRAME,
					doScroll
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * stopScroll Event
		 * ---------------------------------------------------------------------
		 * scrollbar -> textfield
		 *
		 * @param e 		MouseEvent
		 */
		private function stopScroll(e:MouseEvent):void
		{
			this.stopDrag();
			this.removeEventListener(
					Event.ENTER_FRAME,
					doScroll
				);
			
			// finally call doScroll to make the last update
			doScroll(null);
			
			this.isClick = false;
			this.updateView();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * doScroll Event
		 * ---------------------------------------------------------------------
		 * scrollbar -> textfield
		 *
		 * @param e 		MouseEvent
		 */
		private function doScroll(e:Event):void
		{
			var percent:Number = (this.y - this.scrollTop)
					/ ( this.scrollBottom - this.height ) 
			
			this.scrollingText.scrollV = percent 
					* (this.scrollingText.maxScrollV + 1);
			
			if( this.scrollButtonUp == null 
					|| this.scrollButtonDown == null )
				return;
				
			if( this.scrollingText.scrollV > 1 )
			{
				this.scrollButtonUp.setActive(true);
			} else {
				this.scrollButtonUp.setActive(false);
			}
			
			if( this.scrollingText.scrollV < this.scrollingText.maxScrollV )
			{
				this.scrollButtonDown.setActive(true);
			} else {
				this.scrollButtonDown.setActive(false);
			}
		}
		
	}
}
