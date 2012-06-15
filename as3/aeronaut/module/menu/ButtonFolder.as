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
package as3.aeronaut.module.menu
{
	import flash.display.MovieClip;
	
	import flash.events.MouseEvent;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
 	import fl.transitions.easing.*;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.CSWindowManager;

	// =========================================================================
	// Class ButtonFolder
	// =========================================================================
	// A Folder Button from the main menu.
	// Linked to btnFolder symbol in modMenu.
	//
	public class ButtonFolder 
			extends MovieClip
			
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const FOLDER_CLOSE_POS:int = -30;
		public static const FOLDER_OPEN_POS:int = -10;
		public static const FOLDER_SPEED:Number = 0.5;
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var targetFolder:MovieClip = null;
		private var tweenFolder:Tween = null;
		private var linkedWindowType:int = -1;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function ButtonFolder()
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
		 * @param linkedTo 
		 */
		public function setup(
				target:MovieClip,
				linkedTo:int
			):void
		{
			this.targetFolder = target;
			this.linkedWindowType = linkedTo;
			
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
			if( this.tweenFolder != null) 
				if( this.tweenFolder.isPlaying ) 
					this.tweenFolder.stop();
			
			this.tweenFolder = new Tween(
					this.targetFolder,
					"x",
					Regular.easeOut,
					this.targetFolder.x,
					FOLDER_OPEN_POS,
					FOLDER_SPEED,
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
			if( this.tweenFolder != null ) 
				if( this.tweenFolder.isPlaying ) 
					this.tweenFolder.stop();
			
			this.tweenFolder = new Tween(
					this.targetFolder, 
					"x", 
					Regular.easeOut, 
					this.targetFolder.x, 
					FOLDER_CLOSE_POS, 
					FOLDER_SPEED, 
					true
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * downHandler
		 * ---------------------------------------------------------------------
		 * opens the linked window
		 *
		 * @param e 
		 */
		private function downHandler(e:MouseEvent):void
		{
			Globals.myWindowManager.openWindow(this.linkedWindowType);
		}
		
	}
}