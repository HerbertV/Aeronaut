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
	
	import as3.aeronaut.Globals;
	
	// =========================================================================
	// Class AbstractPage
	// =========================================================================
	// Abstract class for all toolbar/toolbook pages
	//
	public class AbstractPage 
			extends MovieClip 
			implements ICSStyleable
	{
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function AbstractPage()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * setStyle
		 * ---------------------------------------------------------------------
		 * @param s CSStyle
		 */
		public function setStyle(s:int):void
		{
			for( var i:int = 0; i < this.numChildren; i++ )
				if( this.getChildAt(i) is ICSStyleable ) 
					ICSStyleable(this.getChildAt(i)).setStyle(s);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * showPage
		 * ---------------------------------------------------------------------
		 */
		public function showPage():void
		{
			this.visible = true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * showPage
		 * ---------------------------------------------------------------------
		 */
		public function hidePage():void
		{
			this.visible = false;
		}
	}
}