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
	
	import flash.events.MouseEvent;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
 	import fl.transitions.easing.*;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.CSWindowManager;
	
	import as3.hv.core.net.AbstractModule;
	
	// =========================================================================
	// Class CSMenuLeft
	// =========================================================================
	// The main menu.
	// This class is a linked document class to "modMenu.swf"
	//
	public class CSMenuLeft 
			extends AbstractModule
	{
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function CSMenuLeft()
		{
			super();
			
			this.moduleVersion = Globals.version;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * init
		 * ---------------------------------------------------------------------
		 */
		override public function init():void
		{
			// button folder1
			this.btnFolder1.setup(
					this.folder1,
					CSWindowManager.WND_PILOT
				);
			// button folder2
			this.btnFolder2.setup(
					this.folder2,
					CSWindowManager.WND_SQUAD
				);
			// button folder3
			this.btnFolder3.setup(
					this.folder3,
					CSWindowManager.WND_AIRCRAFT
				);
			// button folder4
			this.btnFolder4.setup(
					this.folder4,
					CSWindowManager.WND_LOADOUT
				);
			// button folder5
			this.btnFolder5.setup(
					this.folder5,
					CSWindowManager.WND_ZEPPELIN
				);
			//button about
			this.about.setup(this.aboutSheet);
			//button easteregg
			this.easteregg.setup(
					this.blueprint,
					this.foto
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 */
		override public function dispose():void
		{
			// since the main menu is never removed during runtime there in
			// nothing to do here.
		}
				
	}
}