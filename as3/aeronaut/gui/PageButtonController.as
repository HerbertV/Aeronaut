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
	import flash.events.MouseEvent;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
		
	// =========================================================================
	// PageButtonController
	// =========================================================================
	// to controll the page switching
	//
	public class PageButtonController
	{
		// =====================================================================
		// Variables
		// =====================================================================
		private var buttons:Array = new Array();
		private var pages:Array = new Array();
		private var activePage:int = -1;
	
		// =====================================================================
		// Contructor
		// =====================================================================
		public function PageButtonController()
		{
			
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getActivePage
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getActivePage():uint 
		{
			return this.activePage;
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * setActivePage
		 * ---------------------------------------------------------------------
		 * @param idx
		 */
		public function setActivePage(idx:uint):void
		{
			if( idx == 	this.activePage
					|| idx >= this.pages.length )
				return;

			for( var i:int=0; i<this.pages.length; i++ )
				AbstractPage(this.pages[i]).hidePage();
			
			if( this.activePage != -1 )
				PageButton(this.buttons[this.activePage]).setSelected(false);	
			
			PageButton(this.buttons[idx]).setSelected(true);	
			AbstractPage(this.pages[idx]).showPage();
			
			this.activePage = idx;
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * addPage
		 * ---------------------------------------------------------------------
		 * adds a page/button pair to the controller.
		 *
		 * @param btn
		 * @param page
		 */
		public function addPage(
				btn:PageButton,
				page:AbstractPage
			):void
		{
			this.buttons.push(btn);
			this.pages.push(page);
			
			btn.setController(this,this.buttons.length-1);
			btn.addEventListener(MouseEvent.MOUSE_DOWN,clickHandler);
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * clickHandler
		 * ---------------------------------------------------------------------
		 * @param e 
		 */
		private function clickHandler(e:MouseEvent):void
		{
			var btn:PageButton = PageButton(e.currentTarget);
			
			if( !btn.getIsActive() )
				return;
				
			this.setActivePage(btn.getPageNumber());
		}
		
	}
}