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
package as3.aeronaut.module
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
 	import fl.transitions.easing.*;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.CSWindowManager;
	
	import as3.aeronaut.gui.ICSStyleable;
	import as3.aeronaut.gui.CSStyle;
	
	import as3.hv.core.net.AbstractModule;
	
	// =========================================================================
	// Class CSWindow
	// =========================================================================
	// abstract base class for all windows:
	// - CSWindowPilot
	// - CSWindowSquadron
	// - CSWindowAircraft
	// - CSWindowLoadout
	// - CSWindowZeppelin
	//
	// handles the interactions with CSWindowManager (open, close, ...)
	//
	// Each CSWindow needs following sub mc's:
	// - btnWinClose
	// - btnWinMin
	// - btnWinMax
	// - form
	// 
	public dynamic class CSWindow 
			extends AbstractModule 
			implements ICSStyleable
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const WIN_STATE_OPEN:int = 1;
		public static const WIN_STATE_MINIMIZED:int = 2;
		
		// =====================================================================
		// Variables
		// =====================================================================
		protected var currentWinState:int = 1;
		protected var myStyle:int = 0;
		
		// ----------------------------------------------------------
		// override the position values in your implementation
		// ----------------------------------------------------------
		// position for opening a new window
		protected var posStartX:int = 0;
		protected var posStartY:int = 0;
		// position visible on desk
		protected var posOpenX:int = 0;
		protected var posOpenY:int = 0;
		// position minimized
		protected var posMinimizedX:int = 0;
		protected var posMinimizedY:int = 0;

		protected var myMovementTweenX:Tween = null;
		protected var myMovementTweenY:Tween = null;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function CSWindow()
		{
			super();
			
			this.moduleVersion = Globals.version;
			
			this.btnWinClose.setupTooltip(Globals.myTooltip,"close");
			this.btnWinClose.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					winCloseHandler,
					false,
					0,
					true
				);
			
			this.btnWinMin.setupTooltip(Globals.myTooltip,"minimize");
			this.btnWinMin.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					winMinHandler,
					false,
					0,
					true
				);
			
			this.btnWinMax.setupTooltip(Globals.myTooltip,"maximize");
			this.btnWinMax.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					winMaxHandler,
					false,
					0,
					true
				);
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * setFormVisible
		 * ---------------------------------------------------------------------
		 * toggle the visibility of the form. 
		 * During movement of a window a form needs to be hidden to save
		 * performance.
		 *
		 * @param v 
		 */
		public function setFormVisible(v:Boolean):void
		{
			if( this.getChildByName("form") != null )
				this.form.visible = v;
			
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
			var i:int=0;
			
			this.myStyle = s;
			
			for( i=0; i<this.numChildren; i++ )
				if( this.getChildAt(i) is ICSStyleable ) 
					ICSStyleable(this.getChildAt(i)).setStyle(s);
				
			if( this.getChildByName("form") != null ) 
				for( i=0; i<this.form.numChildren; i++ )
					if( this.form.getChildAt(i) is ICSStyleable ) 
						ICSStyleable(this.form.getChildAt(i)).setStyle(s);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setTextFieldValid
		 * ---------------------------------------------------------------------
		 *
		 * @param tf
		 * @param valid
		 */
		protected function setTextFieldValid(
				tf:TextField, 
				valid:Boolean
			):void
		{
			if( valid ) 
			{
				if( this.myStyle == CSStyle.BLACK )
				{
					tf.textColor = 0x000000;
				} else if( this.myStyle == CSStyle.WHITE ) {
					tf.textColor = 0xFFFFFF;
				}
			} else {
				tf.textColor = 0xFF0000;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * isMoving
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function isMoving():Boolean
		{
			if( this.myMovementTweenX != null )
				return this.myMovementTweenX.isPlaying;
			
			return false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * stopTween
		 * ---------------------------------------------------------------------
		 * if movement needs interuption
		 */
		protected function stopTween():void
		{
			if( this.myMovementTweenX != null )
				if( this.myMovementTweenX.isPlaying )
					this.myMovementTweenX.stop();
			
			if( this.myMovementTweenY != null )
				if( this.myMovementTweenY.isPlaying )
					this.myMovementTweenY.stop();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * openWin
		 * ---------------------------------------------------------------------
		 * starts the open window tween
		 */
		public function openWin():void
		{
			this.stopTween();
			
			this.myMovementTweenX = new Tween(
					this, 
					"x", 
					Regular.easeOut, 
					posStartX, 
					posOpenX, 
					1.5, 
					true
				);
			this.myMovementTweenY = new Tween(
					this, 
					"y", 
					Regular.easeOut, 
					posStartY, 
					posOpenY, 
					1.5,
					true
				);
			
			this.currentWinState = WIN_STATE_OPEN;
			this.btnWinMin.setActive(true);
			this.btnWinMax.setActive(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * closeWin
		 * ---------------------------------------------------------------------
		 * starts the close window tween
		 */
		public function closeWin():void
		{
			this.setFormVisible(false);
			this.stopTween();
			
			this.myMovementTweenX = new Tween(
					this, 
					"x", 
					Regular.easeOut, 
					this.x, 
					posStartX, 
					0.5, 
					true
				);
			this.myMovementTweenY = new Tween(
					this,
					"y",
					Regular.easeOut,
					this.y,
					posStartY, 
					0.5, 
					true
				);
			
			this.myMovementTweenX.addEventListener(
					TweenEvent.MOTION_FINISH,
					tweenCloseFinished,
					false,
					0,
					true
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * minizeWin
		 * ---------------------------------------------------------------------
		 * move window to the minimized stack. 
		 * The position is calculated by the CSWindowManager.
		 *
		 * @param posY 
		 */
		public function minizeWin(posY:int):void
		{
			this.stopTween();
			
			this.myMovementTweenX = new Tween(
					this, 
					"x", 
					Regular.easeOut, 
					this.x, 
					posMinimizedX, 
					1.0, 
					true
				);
			this.myMovementTweenY = new Tween(
					this, 
					"y", 
					Regular.easeOut, 
					this.y, 
					posY, 
					1.0, 
					true
				);
			
			this.currentWinState = WIN_STATE_MINIMIZED;
			this.btnWinMin.setActive(false);
			this.btnWinMax.setActive(true);
			this.setFormVisible(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * maximizeWin
		 * ---------------------------------------------------------------------
		 * move window to the desk's center. 
		 */
		public function maximizeWin():void
		{
			this.stopTween();
			
			this.myMovementTweenX = new Tween(
					this, 
					"x", 
					Regular.easeOut, 
					this.x, 
					posOpenX, 
					1.0, 
					true
				);
			this.myMovementTweenY = new Tween(
					this, 
					"y", 
					Regular.easeOut, 
					this.y, 
					posOpenY, 
					1.0, 
					true
				);
			
			this.currentWinState = WIN_STATE_OPEN;
			this.btnWinMin.setActive(true);
			this.btnWinMax.setActive(false);
			this.setFormVisible(true);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * tweenCloseFinished
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		protected function tweenCloseFinished(e:TweenEvent) 
		{
			Globals.myWindowManager.removeClosedResources();
			this.myMovementTweenX.removeEventListener(
					TweenEvent.MOTION_FINISH,
					tweenCloseFinished
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * tweenMoveFinished
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		protected function tweenMoveFinished(e:TweenEvent) 
		{
			this.setFormVisible(true);
			this.myMovementTweenX.removeEventListener(
					TweenEvent.MOTION_FINISH,
					tweenMoveFinished
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * winCloseHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function winCloseHandler(e:MouseEvent):void
		{
			Globals.myWindowManager.closeMe(this);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * winMinHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function winMinHandler(e:MouseEvent):void
		{
			Globals.myWindowManager.minimizeMe(this);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * winMaxHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function winMaxHandler(e:MouseEvent):void
		{
			Globals.myWindowManager.maximizeMe(this);
		}
		
	}
}