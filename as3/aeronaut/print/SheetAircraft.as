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

	import flash.display.Sprite;
	
	import as3.aeronaut.print.aircraft.*;
	
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.Aircraft;
	import as3.aeronaut.objects.Pilot;
	import as3.aeronaut.objects.Squadron;
	import as3.aeronaut.objects.Loadout;
	
	import as3.aeronaut.Globals;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	
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
		
		// armor section with armour row offsets
		public static const PWL:Object = { id: "pwl", isfront:true, x: 39.0, y: 468.5 };
		public static const NOSE:Object = { id: "nose", isfront:true, x: 145.0, y: 404.5 };
		public static const SWL:Object = { id: "swl", isfront:true, x: 250.5, y: 468.5 };
		public static const PWT:Object = { id: "pwt", isfront:false, x: 39.0, y: 532.0 };
		public static const TAIL:Object = { id: "tail", isfront:false, x: 145.0, y: 571.5 };
		public static const TAIL_TURRET:Object = { id: "tt", isfront:false, x: 145.0, y: 587.5 };
		public static const SWT:Object = { id: "swt", isfront:false, x: 250.5, y: 532.0 };
		
// TODO
// also we need to adjust the pwl,swl,pwt,swt if it is a large plane
		public static const PB:Object = { id: "pb", isfront:true, x: 0.0, y: 0 };
		public static const PS:Object = { id: "ps", isfront:false, x: 0.0, y: 0 };
		public static const SB:Object = { id: "sb", isfront:true, x: 0.0, y: 0 };
		public static const SS:Object = { id: "ss", isfront:false, x: 0.0, y: 0 };
		
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		private var myObject:Aircraft;
		
		// main pilot which is used for stats and aicraft name 
		private var pilot:Pilot;
		// all other Gunners, Co-Pilots etc
		private var crew:Array;
		// we use the squadron from the pilot
		private var squad:Squadron;
		// loadout		
		private var loadout:Loadout;		
		
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
			this.loadLoadout();
			
			if( frame == "fighter" ) 
			{
				page = new PageFighter();
				CSAbstractPrintPage(page).setSheet(this);
				page.initFromAircraft(obj);
				this.pages.push(page);
				
			} else if( frame == "heavyFighter" ) {
				page = new PageHeavyFighter();
				CSAbstractPrintPage(page).setSheet(this);
				page.initFromAircraft(obj);
				this.pages.push(page);
				
			} else if( frame == "hoplite" ) {
				page = new PageAutogyro();
				CSAbstractPrintPage(page).setSheet(this);
				page.initFromAircraft(obj);
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
				
			return true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * loadCrew
		 * ---------------------------------------------------------------------
		 * loads crew (pilots) and squadfiles.
		 */
		private function loadCrew():void
		{
			if( this.myObject.getPilotFile() != "") 
			{
				
				this.pilot = new Pilot();
				this.pilot.loadFile(
						mdm.Application.path 
							+ Globals.PATH_DATA 
							+ Globals.PATH_PILOT 
							+ this.myObject.getPilotFile()
					);
				
				if( this.pilot.getSquadronID() != "" )
				{
					this.squad = new Squadron();
					this.squad.loadFile(
							mdm.Application.path 
								+ Globals.PATH_DATA
								+ Globals.PATH_SQUADRON 
								+ this.pilot.getSquadronID()
						);
				}
				
// TODO this needs to be changed for bombers				
				if( this.myObject.getGunnerFile() != "") 
				{
					var gunner:Pilot = new Pilot();
					gunner.loadFile(
							mdm.Application.path 
								+ Globals.PATH_DATA
								+ Globals.PATH_PILOT 
								+ this.myObject.getGunnerFile()
						);
					this.crew.push(gunner);
				}
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * loadLoadout
		 * ---------------------------------------------------------------------
		 */
		private function loadLoadout():void
		{
			if( this.myObject.getLoadoutFile() == "" ) 
				return;
				
			this.loadout = new Loadout();
			this.loadout.loadFile(
					mdm.Application.path 
						+ Globals.PATH_DATA 
						+ Globals.PATH_LOADOUT
						+ this.myObject.getLoadoutFile()
				);
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
		
		/**
		 * ---------------------------------------------------------------------
		 * getSquadron
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getSquadron():Squadron
		{
			return this.squad;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getLoadout
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getLoadout():Loadout
		{
			return this.loadout;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * addArmorLines
		 * ---------------------------------------------------------------------
		 * @param count
		 * @param section
		 * @param target
		 */
		public function addArmorLines(
				count:int, 
				section:Object,
				target:Sprite
			):void 
		{
			var lines:int = count/10;
			var movLine:Sprite = null;
			var movEnd:Sprite = null;
			
			for( var i:int = 0; i < lines; i++ ) 
			{
				movLine = new SpriteSingleArmorLine();
				movLine.x = section.x; 
				
				if( section.isfront == true ) 
				{
					movLine.y = section.y - ( i * ARMORLINE_HEIGHT );
				} else {
					movLine.y = section.y + ( i * ARMORLINE_HEIGHT );
				}
				target.addChild(movLine);
			}
			
			// Legend
			if( section.id == "pwl" )
			{
				movEnd = new SpriteLegendPWL();
				
			} else if( section.id == "pwt" ) {
				movEnd = new SpriteLegendPWT();
				
			} else if( section.id == "nose" ) {
				movEnd = new SpriteLegendNose();
				
			} else if( section.id == "tail" 
					|| section.id == "tt" ) {
				movEnd = new SpriteLegendTail();
				
			} else if( section.id == "swl" ) {
				movEnd = new SpriteLegendSWL();
				
			} else if( section.id == "swt" ) {
				movEnd = new SpriteLegendSWT();
				
			} else if( section.id == "pb" ) {
				movEnd = new SpriteLegendPB();
				
			} else if( section.id == "ps" ) {
				movEnd = new SpriteLegendPS();
				
			} else if( section.id == "sb" ) {
				movEnd = new SpriteLegendSB();
				
			} else if( section.id == "ss" ) {
				movEnd = new SpriteLegendSS();
			}
			
			if( section.isfront == true ) 
			{
				movEnd.y = section.y - ((lines-1) * ARMORLINE_HEIGHT);
			} else {
				movEnd.y = section.y + (lines * ARMORLINE_HEIGHT);
			}
			movEnd.x = section.x;
			target.addChild(movEnd);
		}
		
	}
}