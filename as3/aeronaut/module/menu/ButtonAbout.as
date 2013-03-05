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
package as3.aeronaut.module.menu
{
	import flash.display.MovieClip;
	
	import flash.events.MouseEvent;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
 	import fl.transitions.easing.*;
	
	import as3.aeronaut.Globals;
	
	// =========================================================================
	// Class ButtonAbout
	// =========================================================================
	// The About Button from the main menu.
	// Linked to btnFolder symbol in modMenu.
	//
	public class ButtonAbout
			extends MovieClip
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const ABOUT_CLOSE_POS:int = -214;
		public static const ABOUT_OVER_POS:int = -194;
		public static const ABOUT_OPEN_POS:int = 66;
	
		public static const ABOUT_SPEED:Number = 0.5;
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var targetSheet:MovieClip = null;
		private var tweenSheet:Tween = null;
		private var isOpen:Boolean = false;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function ButtonAbout()
		{
			super();
			
			this.buttonMode = true;
			this.tabEnabled = false;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * setup
		 * ---------------------------------------------------------------------
		 * @param target 
		 */
		public function setup(
				target:MovieClip
			):void
		{
			this.targetSheet = target;
			
			this.targetSheet.buttonMode = true;
			this.targetSheet.tabEnabled = false;
			
			// set the version in the about sheet
			this.targetSheet.labelVersion.text = "Version " 
					+ Globals.VERSION;
			
			this.addEventListener(
					MouseEvent.MOUSE_OVER, 
					overHandler
				);
			this.addEventListener(
					MouseEvent.MOUSE_OUT,
					outHandler
				);
			this.addEventListener(
					MouseEvent.MOUSE_DOWN,
					downHandler
				);
			
			// for easier closing also add listener to sheet.
			this.targetSheet.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					downHandler
				);
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
			if( this.isOpen )
				return;
				
			if( this.tweenSheet != null) 
				if( this.tweenSheet.isPlaying ) 
					this.tweenSheet.stop();
			
			this.tweenSheet = new Tween(
					this.targetSheet,
					"x",
					Regular.easeOut,
					this.targetSheet.x,
					ABOUT_OVER_POS,
					ABOUT_SPEED,
					true
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * outHandler
		 * ---------------------------------------------------------------------
		 * @param e 
		 */
		private function outHandler(e:MouseEvent):void
		{
			if( this.isOpen )
				return;
				
			if( this.tweenSheet != null ) 
				if( this.tweenSheet.isPlaying ) 
					this.tweenSheet.stop();
			
			this.tweenSheet = new Tween(
					this.targetSheet, 
					"x", 
					Regular.easeOut, 
					this.targetSheet.x, 
					ABOUT_CLOSE_POS, 
					ABOUT_SPEED, 
					true
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * downHandler
		 * ---------------------------------------------------------------------
		 * opens/closes the about sheet
		 *
		 * @param e 
		 */
		private function downHandler(e:MouseEvent):void
		{
			if( this.tweenSheet != null ) 
				if( this.tweenSheet.isPlaying ) 
					this.tweenSheet.stop();
			
			if( this.isOpen )
			{
				this.isOpen = false;
				this.tweenSheet = new Tween(
						this.targetSheet, 
						"x", 
						Regular.easeOut, 
						this.targetSheet.x, 
						ABOUT_CLOSE_POS, 
						ABOUT_SPEED, 
						true
					);
			} else {
				this.isOpen = true;
				this.tweenSheet = new Tween(
						this.targetSheet, 
						"x", 
						Regular.easeOut, 
						this.targetSheet.x, 
						ABOUT_OPEN_POS, 
						ABOUT_SPEED, 
						true
					);
			}
		}
	}
}