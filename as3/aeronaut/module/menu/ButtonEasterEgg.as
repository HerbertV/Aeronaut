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
	
	import as3.aeronaut.Globals;
	
	// =========================================================================
	// Class ButtonEasterEgg
	// =========================================================================
	// The Easter Egg Button from the main menu.
	// Linked to btnEasterEgg symbol in modMenu.
	//
	public class ButtonEasterEgg
			extends MovieClip
	{
		// =====================================================================
		// Variables
		// =====================================================================
		private var isBlueprintHidden:Boolean = false;
		private var isFotoHidden:Boolean = false;
		
		private var blueprint:MovieClip = null;
		private var foto:MovieClip = null;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function ButtonEasterEgg()
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
		 * @param bp
		 * @param f
		 */
		public function setup(
				bp:MovieClip,
				f:MovieClip
			):void
		{
			this.blueprint = bp;
			this.foto = f;
			
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
		 * downHandler
		 * ---------------------------------------------------------------------
		 * opens the linked window
		 *
		 * @param e 
		 */
		private function downHandler(e:MouseEvent):void
		{
			if( !this.isBlueprintHidden ) 
			{
				this.isBlueprintHidden = true;
				this.blueprint.visible = false;
				
			} else if( !isFotoHidden ) {
				this.isFotoHidden = true;
				this.foto.visible = false;
				
				// pinup manager
				Globals.myPinupManager.loadPinups();
				
				this.buttonMode = false;
				this.tabEnabled = false;
				this.removeEventListener(
						MouseEvent.MOUSE_DOWN, 
						downHandler
					);
				this.blueprint.visible = true;
			} 
		}
		
	}
}