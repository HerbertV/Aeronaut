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
package as3.aeronaut.print
{
	// MDM ZINC Lib
	import mdm.*;

	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import as3.aeronaut.print.aircraft.*;
	
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.Aircraft;
	import as3.aeronaut.objects.Pilot;
	import as3.aeronaut.objects.Squadron;
	import as3.aeronaut.objects.Loadout;
	import as3.aeronaut.objects.aircraftConfigs.FrameDefinition;
	
	import as3.aeronaut.Globals;
	
	import as3.hv.core.net.ImageLoader;
	
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
		public static const SQUADLOGO_WIDTH:int = 150;
		public static const SQUADLOGO_HEIGHT:int = 40;
	
		public static const ARMORLINE_HEIGHT:int = 8;
		
		// =====================================================================
		// Variables
		// =====================================================================
		// armor section with armour row offsets
		public static var PWL:ArmorRow;
		public static var NOSE:ArmorRow;
		public static var SWL:ArmorRow;
		public static var PWT:ArmorRow;
		public static var TAIL:ArmorRow;
		public static var TAIL_TURRET:ArmorRow;
		public static var SWT:ArmorRow;
		public static var PB:ArmorRow;
		public static var PS:ArmorRow;
		public static var SB:ArmorRow;
		public static var SS:ArmorRow;

		
		private var myObject:Aircraft;
		
		// main pilot which is used for stats and aicraft name 
		private var pilot:Pilot;
		// all other Gunners, Co-Pilots etc
		private var crew:Array;
		// we use the squadron from the pilot
		private var squad:Squadron;
		private var squadLogo:Bitmap;
		
		// loadout		
		private var loadout:Loadout;		
		
		private var loader:ImageLoader;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 */
		public function SheetAircraft()
		{
			super();
			crew = new Array();
			
			if( PWL != null )
				return;
				
// TODO extend with BC offsets				
			PWL = new ArmorRow(
					ArmorRow.ID_PWL,
					true,
					39.0,
					468.5
				);
			NOSE = new ArmorRow(
					ArmorRow.ID_NOSE,
					true,
					145.0,
					404.5
				);
			SWL = new ArmorRow(
					ArmorRow.ID_SWL,
					true,
					250.5,
					468.5
				);
			PWT = new ArmorRow(
					ArmorRow.ID_PWT,
					false,
					39.0,
					532.0
				);
			TAIL = new ArmorRow(
					ArmorRow.ID_TAIL,
					false,
					145.0,
					571.5
				);
			TAIL_TURRET = new ArmorRow(
					ArmorRow.ID_TAIL_TURRET,
					false,
					145.0,
					587.5
				);
			SWT = new ArmorRow(
					ArmorRow.ID_SWT,
					false,
					250.5,
					532.0
				);
			// BC only rows
			PB = new ArmorRow(
					ArmorRow.ID_PB,
					true,
					0.0,
					0.0,
					0.0,
					0.0
				);
			PS = new ArmorRow(
					ArmorRow.ID_PS,
					false,
					0.0,
					0.0,
					0.0,
					0.0
				);
			SB = new ArmorRow(
					ArmorRow.ID_SB,
					true,
					0.0,
					0.0,
					0.0,
					0.0
				);
			SS = new ArmorRow(
					ArmorRow.ID_SS,
					false,
					0.0,
					0.0,
					0.0,
					0.0
				);
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
			
			this.loadCrew();
			this.loadLoadout();
			
			if( this.loader != null )
			{
				this.loader.addEventListener(
						Event.COMPLETE, 
						imageLoadedHandler
					);
				this.loader.load();
			} else {
				this.initPages();
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initPages
		 * ---------------------------------------------------------------------
		 */
		private function initPages():void
		{
			var frame:String = this.myObject.getFrameType();
			var page:ICSPrintPageAircraft;
			
// TODO also add flavor sheet if it is selected			
			if( frame == FrameDefinition.FT_FIGHTER ) 
			{
				page = new PageFighter();
				CSAbstractPrintPage(page).setSheet(this);
				page.initFromAircraft(this.myObject);
				this.pages.push(page);
				
			} else if( frame == FrameDefinition.FT_HEAVY_FIGHTER ) {
				page = new PageHeavyFighter();
				CSAbstractPrintPage(page).setSheet(this);
				page.initFromAircraft(this.myObject);
				this.pages.push(page);
				
			} else if( frame == FrameDefinition.FT_AUTOGYRO ) {
				page = new PageAutogyro();
				CSAbstractPrintPage(page).setSheet(this);
				page.initFromAircraft(this.myObject);
				this.pages.push(page);
				
			} else if( frame == FrameDefinition.FT_LIGHT_BOMBER ) {
				//TODO
			} else if( frame == FrameDefinition.FT_LIGHT_BOMBER ) {
				//TODO
			} else if( frame == FrameDefinition.FT_HEAVY_CARGO ) {
				//TODO
			} else if( frame == FrameDefinition.FT_LIGHT_CARGO ) {
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
			
			if( this.loader != null )
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
					
					if( squad.getSrcLogo() != "" )
					{
						var l:ImageLoader = new ImageLoader(
								mdm.Application.path 
									+ Globals.PATH_IMAGES
									+ Globals.PATH_SQUADRON
									+ squad.getSrcLogo(),
								"SquadLogoLoader"	
							);
						l.addNext(this.loader);
						this.loader = l;
					}
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
		 * getSquadLogo
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getSquadLogo():Bitmap
		{
			if( this.squadLogo == null )
				return null;
				
			return new Bitmap(this.squadLogo.bitmapData.clone());
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
				section:ArmorRow,
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
			if( section.id == ArmorRow.ID_PWL )
			{
				movEnd = new SpriteLegendPWL();
				
			} else if( section.id == ArmorRow.ID_PWT ) {
				movEnd = new SpriteLegendPWT();
				
			} else if( section.id == ArmorRow.ID_NOSE ) {
				movEnd = new SpriteLegendNose();
				
			} else if( section.id == ArmorRow.ID_TAIL 
					|| section.id == ArmorRow.ID_TAIL_TURRET ) {
				movEnd = new SpriteLegendTail();
				
			} else if( section.id == ArmorRow.ID_SWL ) {
				movEnd = new SpriteLegendSWL();
				
			} else if( section.id == ArmorRow.ID_SWT ) {
				movEnd = new SpriteLegendSWT();
				
			} else if( section.id == ArmorRow.ID_PB ) {
				movEnd = new SpriteLegendPB();
				
			} else if( section.id == ArmorRow.ID_PS ) {
				movEnd = new SpriteLegendPS();
				
			} else if( section.id == ArmorRow.ID_SB ) {
				movEnd = new SpriteLegendSB();
				
			} else if( section.id == ArmorRow.ID_SS ) {
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
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * imageLoadedHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function imageLoadedHandler(e:Event):void
		{
			var current:ImageLoader = ImageLoader(e.currentTarget);
			var bmp:Bitmap = current.getImage();
			bmp.smoothing = true;

			if( current.getName() == "SquadLogoLoader" ) {
				this.squadLogo = bmp;
			}
			var nl:ImageLoader = ImageLoader( current.getNext() );
			current.dispose();
			this.loader = nl;

			if( this.loader == null )
			{
				this.initPages();
				return;
			}
			this.loader.addEventListener(
					Event.COMPLETE, 
					imageLoadedHandler
				);
			
			this.loader.load();
		}
		
	}
}