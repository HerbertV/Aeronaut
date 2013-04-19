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
package as3.aeronaut.module.toolbar
{
	import flash.text.TextField;
		
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.gui.*;
	
	import as3.aeronaut.module.CSToolbarBottom;
	import as3.aeronaut.module.ICSToolbarBottom;
	import as3.aeronaut.module.ICSWindow;
	
	/**
	 * =========================================================================
	 * Class PageAddCompany
	 * =========================================================================
	 * Page for adding a new custom company for airplanes and zeppelins
	 */
	public class PageAddCompany
			extends AbstractPage 
	{
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var linkedWindow:ICSWindow = null;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 */
		public function PageAddCompany()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * setup
		 * ---------------------------------------------------------------------
		 */
		public function setup():void
		{
// TODO setup inputs
			/*
			
			this.btnOk.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickOkHandler
				);
			this.btnCancel.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickCancelHandler
				);
			*/
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * showPage
		 * ---------------------------------------------------------------------
		 */
		override public function showPage():void
		{
			super.showPage();
//TODO			
		}
			
		// =====================================================================
		// EventHandler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * clickOkHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickOkHandler(e:MouseEvent):void
		{
//TODO	save new company
//TODO force reload companies
			//close toolbar
			Globals.myToolbarBottom.changeState(0);
			this.linkedWindow = null;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clickCancelHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickCancelHandler(e:MouseEvent):void
		{
			Globals.myToolbarBottom.changeState(0);
			this.linkedPilotWindow = null;
		}
		
		
		
		
	
	}
}