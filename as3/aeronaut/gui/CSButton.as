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
	import flash.events.MouseEvent;
	
	import as3.hv.components.tooltip.ITooltip;
	
	// =========================================================================
	// CSButton
	// =========================================================================
	// Basic Button class 
	// is linked to Buttons inside the fla's library.
	// supports ITooltip
	//
	// The Button needs following sub mc's:
	// - unstyled_normal
	// - unstyled_inactive
	// - unstyled_rollover
	// - unstyled_click
	//
	public class CSButton
			extends CSAbstractButton
	{
		// =====================================================================
		// Variables
		// =====================================================================
		
		// =====================================================================
		// Contructor
		// =====================================================================
		public function CSButton()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * updateView
		 * ---------------------------------------------------------------------
		 */
		override public function updateView():void
		{
			this.unstyled_normal.visible = false;
			this.unstyled_inactive.visible = false;
			this.unstyled_rollover.visible = false;
			this.unstyled_click.visible = false;
			
			if( !this.isActive )
			{
				this.unstyled_inactive.visible = true;
			} else if( this.isClick ) {
				this.unstyled_click.visible = true;
			} else if( this.isRollover ) {
				this.unstyled_rollover.visible = true;
			} else {
				this.unstyled_normal.visible = true;
			}
		}
		
	}
}
