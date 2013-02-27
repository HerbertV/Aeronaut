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
	import flash.text.TextField;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	
	import as3.hv.components.tooltip.ITooltip;
	import as3.aeronaut.Globals;
	
	// =========================================================================
	// CSAbstractListItem
	// =========================================================================
	// Dynamic abstract List class 
	// lists have variable height. 
	// the width debends on thier items.
	//
	// Any ListItem needs following sub mc's:
	// - btnRemove
	// - myLabel
	//
	dynamic public class CSAbstractListItem 
			extends MovieClip 
			implements ICSStyleable
	{
		
		// =====================================================================
		// Variables
		// =====================================================================
		protected var myStyle:int = CSStyle.BLACK;
		
		protected var isActive:Boolean = true;
		protected var isInvalid:Boolean = false;
		protected var isRemoveable:Boolean = true;
		
		protected var myID:String = "";
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function CSAbstractListItem()
		{
			super();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setupBaseParams 
		 * ---------------------------------------------------------------------
		 * Problem in Flash CS3 is, if you link a class file to library 
		 * symbol you can only use the default Constructor.
		 * So we need a seperate setup function. 
		 *
		 * @param id
		 * @param lbl
		 * @param removeable
		 * @param removeTooltip
		 */
		public function setupBaseParams(
				id:String,
				lbl:String,
				removeable:Boolean=false,
				removeTooltip:String="remove item"
			):void
		{
			this.myLabel.text = lbl;
			this.myID = id;
			this.isRemoveable = removeable;
			this.btnRemove.setActive(this.isRemoveable);

			if( this.isRemoveable ) 
				this.btnRemove.setupTooltip(
						Globals.myTooltip,
						removeTooltip
					);
		}
		/**
		 * ---------------------------------------------------------------------
		 * getID
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getID():String
		{
			return myID;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setStyle
		 * ---------------------------------------------------------------------
		 * @param s
		 */
		public function setStyle(s:int):void 
		{
			this.myStyle = s;
			this.btnRemove.setStyle(s);
			this.btnRemove.updateView();
			this.updateView();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setActive
		 * ---------------------------------------------------------------------
		 * @param a
		 */
		public function setActive(a:Boolean):void 
		{
			this.isActive = a;
			this.btnRemove.setActive(a);
			this.updateView();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setInvalid
		 * ---------------------------------------------------------------------
		 * @param i
		 */
		public function setInvalid(i:Boolean):void 
		{
			this.isInvalid = i;
			this.updateView();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getIsActive
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getIsActive():Boolean
		{
			return this.isActive;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getIsRemoveable
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getIsRemoveable():Boolean
		{
			return isRemoveable;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getRemoveButton
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getRemoveButton():CSButtonStyled 
		{
			return this.btnRemove;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateView
		 * ---------------------------------------------------------------------
		 */
		public function updateView():void 
		{
			if( this.myStyle == CSStyle.BLACK ) 
			{
				if( !this.isActive ) 
				{
					this.myLabel.textColor = 0xB1B1B1;
				} else if( this.isInvalid ) {
					this.myLabel.textColor = 0xFF0000;
				} else {
					this.myLabel.textColor = 0x000000;
				}
				return;
				
			} 
			
			if( this.myStyle == CSStyle.WHITE )
			{
				if ( !this.isActive ) 
				{
					this.myLabel.textColor = 0xB1B1B1;
				} else if( this.isInvalid ) {
					this.myLabel.textColor = 0xFF0000;
				} else {
					this.myLabel.textColor = 0xFFFFFF;
				}
				return;
			}
		}
	
	}
}
