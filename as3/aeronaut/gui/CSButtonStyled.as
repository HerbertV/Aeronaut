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
	
	// =========================================================================
	// CSButtonStyled
	// =========================================================================
	// Basic Button class 
	// is linked to styled Buttons inside the fla's library.
	// supports ITooltip 
	//
	// The Button needs following sub mc's:
	// - black_normal
	// - black_inactive
	// - black_rollover
	// - black_click
	// - white_normal
	// - white_inactive
	// - white_rollover
	// - white_click
	//
	public class CSButtonStyled 
			extends CSAbstractButton 
			implements ICSStyleable
	{
		// =====================================================================
		// Variables
		// =====================================================================
		// default style is black
		protected var myStyle:int = CSStyle.BLACK;
		
		// =====================================================================
		// Contructor
		// =====================================================================
		public function CSButtonStyled()
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
				} else if( this.isClick ) {
					this.black_click.visible = true;
				} else if( this.isRollover ) {
					this.black_rollover.visible = true;
				} else {
					this.black_normal.visible = true;
				}
				return;
			}
			if( this.myStyle == CSStyle.WHITE ) 
			{
				if( !this.isActive ) {
					this.white_inactive.visible = true;
				} else if( this.isClick ) {
					this.white_click.visible = true;
				} else if( this.isRollover ) {
					this.white_rollover.visible = true;
				} else {
					this.white_normal.visible = true;
				}
				return;
			}
		}
		
	}
}