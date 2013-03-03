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
package as3.aeronaut.module.aircraft
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.gui.*;
	
	import as3.aeronaut.module.CSWindowAircraft;
	import as3.aeronaut.module.ICSValidate;
	
	import as3.aeronaut.objects.Aircraft;	
	
	
	// =========================================================================
	// Class PageBombCargo
	// =========================================================================
	// Aircraft Page 5 Bomb Bay and Cargo Rooms 
	//
	public class PageBombCargo
			extends AbstractPage 
				implements ICSValidate
	{
		// =====================================================================
		// Variables
		// =====================================================================
		private var winAircraft:CSWindowAircraft = null;
		private var isValid:Boolean = true;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function PageBombCargo()
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
		 * this is called every time the aircraft changes (loading, new) 
		 *
		 * @param win
		 */
		public function init(win:CSWindowAircraft):void
		{
			this.winAircraft = win;
			var obj:Aircraft = Aircraft(this.winAircraft.getObject());
			
//TODO
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 */
		public function dispose():void
		{
// TODO
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * validateForm
		 * ---------------------------------------------------------------------
		 */
		public function validateForm():void
		{
// TODO
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * validateForm
		 * ---------------------------------------------------------------------
		 * @param v
		 */
		public function setValid(v:Boolean):void 
		{
			this.isValid = v;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * validateForm
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getIsValid():Boolean 
		{
			return this.isValid;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateObjectFromWindow
		 * ---------------------------------------------------------------------
		 * called by updateObjectFromWindow function from our window.
		 * transfers the changed values into the object.
		 *
		 * @return
		 */
		public function updateObjectFromWindow():Aircraft
		{
			var obj:Aircraft = Aircraft(this.winAircraft.getObject());
//TODO
			return obj;
		
		}
	
	}
}