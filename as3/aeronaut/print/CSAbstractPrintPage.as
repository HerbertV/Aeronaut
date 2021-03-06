﻿/*
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
 * @version: 1.1.0
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2009-2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.print
{
	import flash.display.MovieClip;
	
	import as3.aeronaut.Globals;
	
	/**
	 * =========================================================================
	 * Class CSAbstractPrintPage
	 * =========================================================================
	 * Abstract base class for all print pages
	 */
	dynamic public class CSAbstractPrintPage
			extends MovieClip
	{
		// =====================================================================
		// Variables
		// =====================================================================
		protected var mySheet:CSAbstractSheet;
		
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 */
		public function CSAbstractPrintPage()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * init
		 * ---------------------------------------------------------------------
		 * Call this from your initFromObject function.
		 */
		public function init():void
		{
			this.lblVersion.text = "printed with Aeronaut v." +Globals.VERSION;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSheet
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getSheet():CSAbstractSheet
		{
			return mySheet;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setSheet
		 * ---------------------------------------------------------------------
		 * @param s
		 */
		public function setSheet(s:CSAbstractSheet):void
		{
			this.mySheet = s;
		}
			
	}
}