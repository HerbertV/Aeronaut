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
	import flash.text.TextField;
	
	import as3.hv.components.tooltip.ITooltip;
	import as3.aeronaut.Globals;
	
	// =========================================================================
	// CSListItemFeat
	// =========================================================================
	//
	// additional to the normal list item sub mc's it needs:
	// - lblLevel
	// - btnUp
	// - btnDown
	//
	public class CSListItemFeat 
			extends CSAbstractListItem
	{
		// =====================================================================
		// Variables
		// =====================================================================
		private var currLvl:int = 0;
		private var minLvl:int = 0;
		private var maxLvl:int = 0;
		
		// =====================================================================
		// Contructor
		// =====================================================================
		public function CSListItemFeat()
		{
			super();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setupLevelParams 
		 * ---------------------------------------------------------------------
		 * an additional setup function for the feats level parameters
		 *
		 * @param lvl current level
		 * @param minlvl minimum level
		 * @param maxlvel maximum level
		 */
		public function setupLevelParams(
				lvl:int, 
				minlvl:int, 
				maxlvl:int
			):void
		{
			this.currLvl = lvl;
			this.minLvl = minlvl;
			this.maxLvl = maxlvl;
			
			this.lblLevel.text = "LvL: "+ this.currLvl;
			
			if( this.maxLvl == 0 ) 
			{
				// feat has no lvls
				this.lblLevel.visible = false;
				this.btnUp.visible = false;
				this.btnDown.visible = false;
				this.myLabel.width = 191;
				
			} else {
				this.btnUp.addEventListener(
						MouseEvent.MOUSE_DOWN,
						clickUpHandler
					);
				this.btnDown.addEventListener(
						MouseEvent.MOUSE_DOWN,
						clickDownHandler
					);
			}
			
			this.updateButtons();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getLevel 
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getLevel():int
		{
			return currLvl;
		}
				
		/**
		 * ---------------------------------------------------------------------
		 * setStyle
		 * ---------------------------------------------------------------------
		 * @param s
		 */
		override public function setStyle(s:int):void 
		{
			super.setStyle(s);
			
			this.btnUp.setStyle(s);
			this.btnUp.updateView();
			
			this.btnDown.setStyle(s);
			this.btnDown.updateView();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getUpButton 
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getUpButton():CSButtonStyled 
		{
			return this.btnUp;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getDownButton 
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getDownButton():CSButtonStyled
		{
			return this.btnDown;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateView
		 * ---------------------------------------------------------------------
		 */
		override public function updateView():void
		{
			super.updateView();
			
			if( this.myStyle == CSStyle.BLACK ) 
			{
				if( !this.isActive )
				{
					this.lblLevel.textColor = 0xB1B1B1;
				} else if( this.isInvalid ) {
					this.lblLevel.textColor = 0xFF0000;
				} else {
					this.lblLevel.textColor = 0x000000;
				}
				return;
			} 
			if( this.myStyle == CSStyle.WHITE )
			{
				if( !this.isActive ) {
					this.lblLevel.textColor = 0xB1B1B1;
				} else if( this.isInvalid ) {
					this.lblLevel.textColor = 0xFF0000;
				} else {
					this.lblLevel.textColor = 0xFFFFFF;
				}
				return;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateButtons
		 * ---------------------------------------------------------------------
		 * updating the level buttons
		 */
		private function updateButtons():void
		{
			if( this.currLvl == this.maxLvl 
					|| this.isActive == false ) 
			{
				this.btnUp.setActive(false);
			} else {
				this.btnUp.setActive(true);
			}
			
			if( this.currLvl == this.minLvl 
					|| this.isActive == false ) 
			{
				this.btnDown.setActive(false);
			} else {
				this.btnDown.setActive(true);
			}
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * clickUpHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickUpHandler(e:MouseEvent):void
		{
			if( !this.isActive )
				return;
				
			if( this.currLvl < this.maxLvl )
			{
				this.currLvl = this.currLvl + 1;
				this.lblLevel.text = "LvL: "+ this.currLvl;
			}
			this.updateButtons();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clickDownHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickDownHandler(e:MouseEvent):void
		{
			if( !this.isActive )
				return;
				
			if (this.currLvl > this.minLvl) 
			{
				this.currLvl = this.currLvl - 1;
				this.lblLevel.text = "LvL: "+ this.currLvl;
			}
			this.updateButtons();
		}

	}
}
