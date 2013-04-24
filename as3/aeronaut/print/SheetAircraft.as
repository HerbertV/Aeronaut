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
		private var coPilot:Pilot;
		private var crewChief:Pilot;
		private var loadMaster:Pilot;
		private var bombardier:Pilot;
		private var gunners:Array = new Array();
		private var guards:Array = new Array();
		private var crewLoaders:Array = new Array();
		
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
		
			initArmorRows();
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
			var page1:ICSPrintPageAircraft = null;
			var page2:ICSPrintPageAircraft = null;
			var pageFlavor:ICSPrintPageAircraft = null;
			
			if( frame == FrameDefinition.FT_FIGHTER ) 
			{
				page1 = new PageFighter();
				
			} else if( frame == FrameDefinition.FT_HEAVY_FIGHTER ) {
				page1 = new PageHeavyFighter();
				
			} else if( frame == FrameDefinition.FT_AUTOGYRO ) {
				page1 = new PageAutogyro();
				
			} else if( frame == FrameDefinition.FT_HEAVY_BOMBER
					|| frame == FrameDefinition.FT_LIGHT_BOMBER ) {
				page1 = new Page1Bomber();
				page2 = new Page2Bomber();
				
			} else if( frame == FrameDefinition.FT_HEAVY_CARGO
					|| frame == FrameDefinition.FT_LIGHT_CARGO ) {
				page1 = new Page1Cargo();
				page2 = new Page2Cargo();	
			}
			
			CSAbstractPrintPage(page1).setSheet(this);
			page1.initFromAircraft(this.myObject);
			this.pages.push(page1);
		
			if( page2 != null )
			{
				CSAbstractPrintPage(page2).setSheet(this);
				page2.initFromAircraft(this.myObject);
				this.pages.push(page2);
			}
			
			if( pageFlavor != null )
			{
// TODO also add flavor sheet if it is selected							
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
// FIXME when changed to new as3.hv.zinc.z3.xml.XMLFileList 
// all file pathes stored in object are relative pathes 
// so we can remove here the path assembling except for the application path

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
				
				if( this.myObject.getCoPilotFile() != "") 
				{
					this.coPilot = new Pilot();
					coPilot.loadFile(
							mdm.Application.path 
								+ Globals.PATH_DATA
								+ Globals.PATH_PILOT 
								+ this.myObject.getCoPilotFile()
						);
				}
				
				if( this.myObject.getCrewChiefFile() != "") 
				{
					this.crewChief = new Pilot();
					crewChief.loadFile(
							mdm.Application.path 
								+ Globals.PATH_DATA
								+ Globals.PATH_PILOT 
								+ this.myObject.getCrewChiefFile()
						);
				}
				
				if( this.myObject.getLoadMasterFile() != "") 
				{
					this.loadMaster = new Pilot();
					loadMaster.loadFile(
							mdm.Application.path 
								+ Globals.PATH_DATA
								+ Globals.PATH_PILOT 
								+ this.myObject.getLoadMasterFile()
						);
				}
				
				if( this.myObject.getBombardierFile() != "") 
				{
					this.bombardier = new Pilot();
					bombardier.loadFile(
							mdm.Application.path 
								+ Globals.PATH_DATA
								+ Globals.PATH_PILOT 
								+ this.myObject.getBombardierFile()
						);
				}
				
				var i:int;
				var arr:Array = this.myObject.getGunnerFiles();
				var firstGunner:Pilot = null;
				
				for( i = 0; i < arr.length; i++ ) 
				{
					if( arr[i] != "" )
					{
						var p:Pilot = new Pilot();
						p.loadFile(
								mdm.Application.path 
									+ Globals.PATH_DATA
									+ Globals.PATH_PILOT 
									+ arr[i]
							);
						if ( i == 0 )
						{
							firstGunner = p;
						} else {
							// update the stats from first gunner
							if ( firstGunner != null 
									&& !p.canLevelUp() 
									&& p.getType() != Pilot.TYPE_NPC 
								)
							{
								p.setDeadEye(firstGunner.getDeadEye()-1);
								p.setConstitution(firstGunner.getConstitution()-1);
								p.setNaturalTouch(firstGunner.getNaturalTouch()-1);
								p.setQuickDraw(firstGunner.getQuickDraw()-1);
								p.setSixthSense(firstGunner.getSixthSense()-1);
								p.setSteadyHand(firstGunner.getSteadyHand()-1);
							}
						}
						this.gunners.push(p);
						
					} else {
						this.gunners.push(null);
					}
				}
				
				arr = this.myObject.getGuardFiles();
				
				for( i = 0; i < arr.length; i++ ) 
				{
					if( arr[i] != "" )
					{
						var p:Pilot = new Pilot();
						p.loadFile(
								mdm.Application.path 
									+ Globals.PATH_DATA
									+ Globals.PATH_PILOT 
									+ arr[i]
							);
						this.guards.push(p);
					
					} else {
						this.guards.push(null);
					}
				}
		
				arr = this.myObject.getLoaderFiles();
				
				for( i = 0; i < arr.length; i++ ) 
				{
					if( arr[i] != "" )
					{
						var p:Pilot = new Pilot();
						p.loadFile(
								mdm.Application.path 
									+ Globals.PATH_DATA
									+ Globals.PATH_PILOT 
									+ arr[i]
							);
						this.crewLoaders.push(p);
					
					} else {
						this.crewLoaders.push(null);
					}
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
		 * getCoPilot
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getCoPilot():Pilot
		{
			return this.coPilot;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getCrewChief
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getCrewChief():Pilot
		{
			return this.crewChief;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getLoadMaster
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getLoadMaster():Pilot
		{
			return this.loadMaster;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getBombardier
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getBombardier():Pilot
		{
			return this.bombardier;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getGunners
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getGunners():Array
		{
			return this.gunners;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getGuards
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getGuards():Array
		{
			return this.guards;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getCrewLoaders
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getCrewLoaders():Array
		{
			return this.crewLoaders;
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
			var useBC:Boolean = false;
			var frame:String = this.myObject.getFrameType();
			
			if( frame == FrameDefinition.FT_HEAVY_BOMBER 
					|| frame == FrameDefinition.FT_LIGHT_BOMBER 
					|| frame == FrameDefinition.FT_HEAVY_CARGO 
					|| frame == FrameDefinition.FT_LIGHT_CARGO ) 
				useBC = true;
			
			for( var i:int = 0; i < lines; i++ ) 
			{
				movLine = new SpriteSingleArmorLine();
				movLine.x = section.x; 
				if( useBC )
					movLine.x = section.xBC;
				
				if( section.isfront == true ) 
				{
					if( useBC )
						movLine.y = section.yBC - ( i * ARMORLINE_HEIGHT );
					else
						movLine.y = section.y - ( i * ARMORLINE_HEIGHT );
				} else {
					if( useBC )
						movLine.y = section.yBC + ( i * ARMORLINE_HEIGHT );
					else
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
				if( useBC )
					movEnd.y = section.yBC - ((lines-1) * ARMORLINE_HEIGHT );
				else
					movEnd.y = section.y - ((lines-1) * ARMORLINE_HEIGHT);
			} else {
				if( useBC )
					movEnd.y = section.yBC + (lines * ARMORLINE_HEIGHT );
				else
					movEnd.y = section.y + (lines * ARMORLINE_HEIGHT);
			}
			movEnd.x = section.x;
			if( useBC )
				movEnd.x = section.xBC;
				
			target.addChild(movEnd);
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * initArmorRows
		 * ---------------------------------------------------------------------
		 * setup the coordinates for the armor rows
		 */
		private function initArmorRows()
		{
			if( PWL != null )
				return;
				
			PWL = new ArmorRow(
					ArmorRow.ID_PWL,
					true,
					27.0,
					447.5,
					21.0,
					361.5
				);
			NOSE = new ArmorRow(
					ArmorRow.ID_NOSE,
					true,
					133.0,
					383.5,
					233.5,
					299
				);
			SWL = new ArmorRow(
					ArmorRow.ID_SWL,
					true,
					238.5,
					447.5,
					444.0,
					361.5
				);
			PWT = new ArmorRow(
					ArmorRow.ID_PWT,
					false,
					27.0,
					511.0,
					21.0,
					450.5
				);
			TAIL = new ArmorRow(
					ArmorRow.ID_TAIL,
					false,
					133.0,
					550.5,
					233.5,
					504.5
				);
			TAIL_TURRET = new ArmorRow(
					ArmorRow.ID_TAIL_TURRET,
					false,
					133.0,
					566.5
				);
			SWT = new ArmorRow(
					ArmorRow.ID_SWT,
					false,
					238.5,
					511.0,
					444,
					450.5
				);
			// BC only rows
			PB = new ArmorRow(
					ArmorRow.ID_PB,
					true,
					0.0,
					0.0,
					127,
					361.5
				);
			PS = new ArmorRow(
					ArmorRow.ID_PS,
					false,
					0.0,
					0.0,
					127,
					489
				);
			SB = new ArmorRow(
					ArmorRow.ID_SB,
					true,
					0.0,
					0.0,
					339,
					361.5
				);
			SS = new ArmorRow(
					ArmorRow.ID_SS,
					false,
					0.0,
					0.0,
					339,
					489
				);
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