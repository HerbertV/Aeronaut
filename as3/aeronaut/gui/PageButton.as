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
	
	import flash.geom.ColorTransform;
	
	import as3.aeronaut.Globals;
	
	// =========================================================================
	// Class PageButton
	// =========================================================================
	// Class for all page switich buttons
	//
	public class PageButton 
			extends CSAbstractButton 
			implements ICSStyleable
	{
		// =====================================================================
		// Variables
		// =====================================================================
		// default style is black
		protected var myStyle:int = CSStyle.BLACK;
		
		protected var myController:PageButtonController;
		protected var pageNumber:uint;
		
		protected var isSelected:Boolean = false;
		
		// =====================================================================
		// Contructor
		// =====================================================================
		public function PageButton()
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
		 * @param c PageButtonController
		 * @param pageNum 0-n
		 */
		public function setController(
				c:PageButtonController,
				pageNum:uint
			):void
		{
			this.myController = c;
			this.pageNumber = pageNum;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getPageNumber
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getPageNumber():uint
		{
			return this.pageNumber;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setStyle
		 * ---------------------------------------------------------------------
		 * @param s CSStyle
		 */
		public function setStyle(s:int):void
		{
			this.myStyle = s;
			this.updateView();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setSelected
		 * ---------------------------------------------------------------------
		 * @param sel
		 */
		public function setSelected(sel:Boolean):void
		{
			this.isSelected = sel;
			if( sel == false )
				this.isRollover = false;
			
			this.updateView();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getIsSelected
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getIsSelected():Boolean 
		{
			return this.isSelected;
		}
		/**
		 * ---------------------------------------------------------------------
		 * updateView
		 * ---------------------------------------------------------------------
		 */
		override public function updateView():void
		{
			var colorTransform:ColorTransform = this.transform.colorTransform;
			
			if( this.myStyle == CSStyle.BLACK ) 
			{
				colorTransform.color = 0x000000;
			
				if( !this.isActive )
				{
					colorTransform.color = 0x333333;
				} else if( this.isSelected ) {
					colorTransform.color = 0x660000;
				} else if( this.isClick ) {
					colorTransform.color = 0xFF0000;
				} else if( this.isRollover ) {
					colorTransform.color = 0xFF0000;
				} 
			}
			
			if( this.myStyle == CSStyle.WHITE ) 
			{
				colorTransform.color = 0xFFFFFF;
				
				if( !this.isActive ) 
				{
					colorTransform.color = 0xCCCCCC;
				} else if( this.isSelected ) {
					colorTransform.color = 0x660000;
				} else if( this.isClick ) {
					colorTransform.color = 0xFF0000;
				} else if( this.isRollover ) {
					colorTransform.color = 0xFF0000;
				} 
			}
			this.transform.colorTransform = colorTransform; 
		}
	
	}
}