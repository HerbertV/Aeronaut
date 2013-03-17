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
 * Copyright (c) 2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.print.aircraft
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.text.TextField;
	
	import as3.aeronaut.print.CSAbstractPrintPage;
	import as3.aeronaut.print.ICSPrintPageAircraft;
	import as3.aeronaut.print.SheetAircraft;
	
	import as3.aeronaut.objects.Aircraft;
	import as3.aeronaut.objects.aircraft.Turret;
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.BaseData;
	import as3.aeronaut.objects.baseData.SpecialCharacteristic;
	import as3.aeronaut.objects.Pilot;
	import as3.aeronaut.objects.Squadron;
	import as3.aeronaut.objects.aircraftConfigs.TurretDefinition;
	
	import as3.aeronaut.CSFormatter;
	import as3.aeronaut.Globals;
	
	import as3.hv.core.utils.BitmapHelper;
	
	/**
	 * =========================================================================
	 * Class PrintPageCargo2
	 * =========================================================================
	 * Library Symbol linked class for Cargo page 2
	 * 
	 * Page 2 includes the crew and weapons
	 */
	public class PrintPageCargo2
			extends AbstractPrintPageLargeAircraft
			implements ICSPrintPageAircraft
	{
		// =====================================================================
		// Variables
		// =====================================================================
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 */
		public function PrintPageCargo2()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromAircraft
		 * ---------------------------------------------------------------------
		 * @see ICSPrintPageAircraft
		 *
		 * @param obj
		 */
		override public function initFromAircraft(obj:Aircraft):void
		{
			super.initFromAircraft(obj);
			
			// TODO crew and cargo
			//this.initPilot();
		}
		
		
	}
}