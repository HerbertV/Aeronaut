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
package as3.aeronaut.print
{
	// MDM ZINC Lib
	import mdm.*;

	import as3.aeronaut.print.aircraft.*;
	
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.Aircraft;
	import as3.aeronaut.objects.Pilot;
	
	// =========================================================================
	// Class SheetAircraft
	// =========================================================================
	// 
	//
	public class SheetAircraft 
			extends CSAbstractSheet
			implements ICSSheetAircraft
	{
		
		// =====================================================================
		// Constants
		// =====================================================================
		public static const ARMORLINE_HEIGHT:int = 8;
		
		// raster offsets
// TODO clean this up		
		public static const OFFSET_X_PWL:Number = 39.0;
		public static const OFFSET_Y_PWL:Number = 468.5;
		
		public static const OFFSET_X_NOSE:Number = 145.0;
		public static const OFFSET_Y_NOSE:Number = 404.5;
		
		public static const OFFSET_X_SWL:Number = 250.5;

		public static const OFFSET_Y_SWL:Number = 468.5;
		
		public static const OFFSET_X_PWT:Number = 39.0;
		public static const OFFSET_Y_PWT:Number = 532.0;
		
		public static const OFFSET_X_TAIL:Number = 145.0;
		public static const OFFSET_Y_TAIL:Number = 571.5;
		
		public static const OFFSET_X_TAILTURRET:Number = 145.0;

		public static const OFFSET_Y_TAILTURRET:Number = 587.5;
		
		public static const OFFSET_X_SWT:Number = 250.5;
		public static const OFFSET_Y_SWT:Number = 532.0;
		
// TODO Bomber wing sections
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		private var myObject:Aircraft;
		
		// main pilot which is used for stats and aicraft name 
		private var pilot:Pilot;
		
		// all other Gunners, Co-Pilots etc
		private var crew:Array;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function SheetAircraft()
		{
			super();
			
			crew = new Array();
		}

		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromObject
		 * ---------------------------------------------------------------------
		 * @see ICSSheet
		 *
		 * @param obj
		 */
		public function initFromObject(obj:ICSBaseObject):void
		{
			this.initFromAircraft( Aircraft(obj) );
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromAircraft
		 * ---------------------------------------------------------------------
		 * @see ICSSheetAircraft
		 *
		 * @param obj
		 */
		public function initFromAircraft(obj:Aircraft):void
		{
			this.myObject = obj;
			
			var frame:String = obj.getFrameType();
			var page:ICSPrintPageAircraft;
			
			this.loadCrew();
			
			if( frame == "fighter" ) 
			{
				page = new PageFighter();
				page.initFromAircraft(obj);
				page.setSheet(this);
				this.pages.push(page);
				
			} else if( frame == "heavyFighter" ) {
				page = new PageHeavyFighter();
				page.initFromAircraft(obj);
				page.setSheet(this);
				this.pages.push(page);
				
			} else if( frame == "hoplite" ) {
				page = new PageFighter();
				page.initFromAircraft(obj);
				page.setSheet(this);
				this.pages.push(page);
				
			} else if( frame == "heavyBomber" ) {
				//TODO
			} else if( frame == "lightBomber" ) {
				//TODO
			} else if( frame == "heavyCargo" ) {
				//TODO
			} else if( frame == "lightCargo" ) {
				//TODO
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * isReady
		 * ---------------------------------------------------------------------
		 * @see ICSSheet
		 *
		 * @return
		 */
		override public function isReady():Boolean
		{
			if( this.pages.length == 0 )
				return false;
				
			
			// TODO 
			return true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * loadCrew
		 * ---------------------------------------------------------------------
		 */
		public function loadCrew():void
		{
			if( this.myObject.getPilotFile() != "") 
			{
				
				this.pilot = new Pilot();
				this.pilot.load(
						mdm.Application.path 
							+ Globals.PATH_DATA 
							+ Globals.PATH_PILOT 
							+ obj.getPilotFile()
					);
				
// TODO this needs to be changed for bombers				
				if( this.myObject.getGunnerFile() != "") 
				{
					var gunner:Pilot = new Pilot();
					gunner.load(
							mdm.Application.path 
								+ Globals.PATH_DATA
								+ Globals.PATH_PILOT 
								+ obj.getGunnerFile()
						);
					this.crew.push(gunner);
				}
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getPilot
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getPilot():Pilot
		{
			return this.pilot;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getCrew
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getCrew():Array
		{
			return this.crew;
		}
		
	}
}