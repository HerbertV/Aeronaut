﻿/*
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
 * @version: 1.1.0
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2009-2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.module
{
	import mdm.*;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import as3.aeronaut.CSFormatter;
	import as3.aeronaut.Globals;
	import as3.aeronaut.CSWindowManager;
	
	import as3.aeronaut.objects.Aircraft;	
	import as3.aeronaut.objects.aircraft.*;
	import as3.aeronaut.objects.ICSBaseObject;
	
	import as3.aeronaut.gui.*;
	
	import as3.aeronaut.module.aircraft.*;
	
	import as3.aeronaut.print.IPrintable;
//TODO
	//import as3.aeronaut.print.SheetAircraft;
	//import as3.aeronaut.print.SheetAircraftFlavor;
	
	// =========================================================================
	// CSWindowAircraft
	// =========================================================================
	// This class is a linked document class for "winAircraft.swf"
	// @see as3.aeronaut.objects.Aircraft
	//
	// Window for crating/editing Aircraft.
	public class CSWindowAircraft 
			extends CSWindow 
			implements ICSWindowAircraft, ICSValidate, IPrintable
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const MAXSPEED_WEIGHT_MATRIX:Array = new Array(
				new Array(700,1800,3300,5200,7500), // BTN1
				new Array(540,1440,2700,4320,6300), // BTN2
				new Array(400,1120,2160,3520,5200), // BTN3
				new Array(280,840,1680,2800,4200), // BTN4
				new Array(180,600,1260,2160,3300), // BTN5
				new Array(100,400,900,1600,2500), // BTN6
				new Array(40,240,600,1120,1800), // BTN7
				new Array(30,120,360,720,1200), // BTN8
				new Array(20,60,180,400,700), // BTN9
				new Array(10,25,60,160,300) // BTN10
			);
		
		public static const MAXG_WEIGHT_MATRIX:Array = new Array(
				new Array(1100,2400,3900,5600,7500), // BTN1
				new Array(900,1980,3240,4680,6300), // BTN2
				new Array(720,1600,2640,3840,5200), // BTN3
				new Array(560,1260,2100,3080,4200), // BTN4
				new Array(420,960,1620,2400,3300), // BTN5
				new Array(300,700,1200,1800,2500), // BTN6
				new Array(200,480,840,1280,1800), // BTN7
				new Array(120,300,540,840,1200), // BTN8
				new Array(60,160,300,480,700), // BTN9
				new Array(20,60,120,200,300) // BTN10
			);
		
		public static const MAXACCEL_WEIGHT_MATRIX:Array = new Array(
				new Array(1100,1200,1300), // BTN1
				new Array(900,990,1080), // BTN2
				new Array(720,800,880), // BTN3
				new Array(560,630,700), // BTN4
				new Array(420,480,540), // BTN5
				new Array(300,350,400), // BTN6
				new Array(200,240,280), // BTN7
				new Array(120,150,180), // BTN8
				new Array(20,50,105), // BTN9
				new Array(10,20,45) // BTN10
			);
		
		// first val is Loaded Weight and second val is payload
		public static const BTN_WEIGHT_MATRIX:Array = new Array(
				new Array(14500,10000), // BTN1
				new Array(13250,9000), // BTN2
				new Array(12000,8000), // BTN3
				new Array(10750,7000), // BTN4
				new Array(9500,6000), // BTN5
				new Array(8250,5000), // BTN6
				new Array(7000,4000), // BTN7
				new Array(5750,3000), // BTN8
				new Array(4500,2000), // BTN9
				new Array(3250,1000) // BTN10
			);
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var pbtnController:PageButtonController = null;
		private var rbgFrame:CSRadioButtonGroup = null;
		private var rbgProp:CSRadioButtonGroup = null;
		
		private var isValid:Boolean = true;
		private var isSaved:Boolean = true;
		
		private var myObject:Aircraft = null;
		
// TODO Noseart (or do this in pilot window) 
		//private var myNoseartLoader:Loader = null;					
		//private var srcNoseart:String ="";
		
		private var intPayload:int = 0;
		private var intLoadedWeight:int = 0;
		
		private var intMaxSpeedWeight:int = 0;
		private var intMaxGWeight:int = 0;
		private var intMaxAccelWeight:int = 0;
				
		private var intFreeWeight:int = 0;
				
		private var intEngineCost:int = 0;
		private var intAirframeCost:int = 0;
		private var intCockpitCost:int = 0;
		
		private var lastFrameType:String = "";
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function CSWindowAircraft()
		{
			super();
			
			// positions
			this.posStartX = 120;
			this.posStartY = -690;
			
			this.posOpenX = 120;
			this.posOpenY = 30;
			
			this.posMinimizedX = 1238;
			
			this.x = this.posStartX;
			this.y = this.posStartY;
		}
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * init
		 * ---------------------------------------------------------------------
		 * @see AbstractModule
		 */
		override public function init():void
		{
			super.init();
			
			this.setValid(true);
			this.setSaved(true);
			this.setStyle(CSStyle.WHITE);
			
			this.pbtnController = new PageButtonController();
			this.pbtnController.addPage(this.form.btnPage1,this.form.page1);
			this.pbtnController.addPage(this.form.btnPage2,this.form.page2);
			this.pbtnController.addPage(this.form.btnPage3,this.form.page3);
			this.pbtnController.addPage(this.form.btnPage4,this.form.page4);
// TODO add when bombers and cargoplanes ready			
			//this.pbtnController.addPage(this.form.btnPage5,this.form.page5);
			this.pbtnController.setActivePage(0);			
			
			this.form.txtName.text = "";
			
// TODO remove when bombers and cargoplanes ready
			this.form.rbtnFrameHeavyBomber.setActive(false);
			this.form.rbtnFrameLightBomber.setActive(false);
			this.form.rbtnFrameHeavyCargo.setActive(false);
			this.form.rbtnFrameLightCargo.setActive(false);
			this.form.btnPage5.setActive(false);
			
// TODO remove when we have a solution
			this.form.rbtnPropDouble.setActive(false);
			
			rbgFrame = new CSRadioButtonGroup();
			rbgFrame.addMember(this.form.rbtnFrameFighter,"fighter");
			rbgFrame.addMember(this.form.rbtnFrameHFighter,"heavyFighter");
			rbgFrame.addMember(this.form.rbtnFrameHoplite,"hoplite");
			rbgFrame.addMember(this.form.rbtnFrameHeavyBomber,"heavyBomber");
			rbgFrame.addMember(this.form.rbtnFrameLightBomber,"lightBomber");
			rbgFrame.addMember(this.form.rbtnFrameHeavyCargo,"heavyCargo");
			rbgFrame.addMember(this.form.rbtnFrameLightCargo,"lightCargo");
			this.form.rbtnFrameFighter.addEventListener(
					MouseEvent.MOUSE_DOWN,
					frameTypeChangedHandler
				);
			this.form.rbtnFrameHFighter.addEventListener(
					MouseEvent.MOUSE_DOWN,
					frameTypeChangedHandler
				);
			this.form.rbtnFrameHoplite.addEventListener(
					MouseEvent.MOUSE_DOWN,
					frameTypeChangedHandler
				);
// TODO add when bombers and cargoplanes ready
/*
			this.form.rbtnFrameHeavyBomber.addEventListener(
					MouseEvent.MOUSE_DOWN,
					frameTypeChangedHandler
				);
*/	
			rbgProp = new CSRadioButtonGroup();
			rbgProp.addMember(this.form.rbtnPropTractor,"tractor");
			rbgProp.addMember(this.form.rbtnPropPusher,"pusher");
			rbgProp.addMember(this.form.rbtnPropHoplite,"hoplite");
			rbgProp.addMember(this.form.rbtnPropDouble,"double");
			
			this.form.numStepBaseTarget.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					baseTargetChangedHandler
				);
			this.form.numStepSpeed.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					maxSpeedChangedHandler
				); 
			this.form.numStepGs.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					maxGChangedHandler
				); 
			this.form.numStepAccel.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					maxAccelChangedHandler
				); 
			
			this.form.numStepBaseTarget.setupSteps(1,10,1,1);
			this.form.numStepSpeed.setupSteps(1,5,1,1);
			this.form.numStepGs.setupSteps(1,5,1,1);
			this.form.numStepAccel.setupSteps(1,3,1,1);
			this.form.numStepDecel.setupSteps(1,5,2,1);
			this.form.numStepDecel.setActive(false);
							
			this.form.pdManufacturer.setEmptySelectionText("",true);
			var arrCo:Array = Globals.myBaseData.getCompanies();
			for( var i:int = 0; i < arrCo.length; i++ ) 
				this.form.pdManufacturer.addSelectionItem(
						arrCo[i].longName, 
						arrCo[i].myID
					);
				
// TODO maybe this needs changes for bombers			
			this.form.numStepServiceCeiling.setupSteps(5000 ,50000 ,5000, 500);
			this.form.numStepRange.setupSteps(50 ,2000 ,50, 25);
			this.form.numStepEngine.setupSteps(1,8,1,1);
			this.form.numStepEngine.setActive(false);
			this.form.numStepWingSpan.setupSteps(10 ,100 ,25, 0);
			this.form.numStepLength.setupSteps(10 ,100 ,20, 0);
			this.form.numStepHeight.setupSteps(5 ,30 ,10, 6);
//			
			this.updateDirLists();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 * @see AbstractModule
		 */
		override public function dispose():void
		{
			this.form.numStepBaseTarget.removeEventListener(
					MouseEvent.MOUSE_DOWN, 
					baseTargetChangedHandler
				);
			this.form.numStepSpeed.removeEventListener(
					MouseEvent.MOUSE_DOWN, 
					maxSpeedChangedHandler
				); 
			this.form.numStepGs.removeEventListener(
					MouseEvent.MOUSE_DOWN, 
					maxGChangedHandler
				); 
			this.form.numStepAccel.removeEventListener(
					MouseEvent.MOUSE_DOWN, 
					maxAccelChangedHandler
				); 
			
			this.form.page1.dispose();
			this.form.page2.dispose();
			this.form.page3.dispose();
			this.form.page4.dispose();
// TODO page 5
			
			super.dispose();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * loadObject
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @param fn
		 */
		public function loadObject(fn:String):void
		{
			var obj:Aircraft = new Aircraft();
			obj.loadFile(fn);
			this.initFromAircraft(obj);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * saveObject
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @param fn
		 */
		public function saveObject(fn:String):void
		{
			if( this.myObject.saveFile(fn) )				
				this.setSaved(true);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initNewObject
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 */
		public function initNewObject():void
		{
			var obj:Aircraft = new Aircraft();
			obj.createNew();
			this.initFromAircraft(obj);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromObject
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @param obj
		 */
		public function initFromObject(obj:ICSBaseObject):void
		{
			if( obj is Aircraft )
				this.initFromAircraft( Aircraft(obj) );
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromAircraft
		 * ---------------------------------------------------------------------
		 * @see ICSWindowAircraft
		 * @param obj
		 */
		public function initFromAircraft(obj:Aircraft):void
		{
			this.setValid(true);
			this.setSaved(true);
			this.myObject = obj;
			
			this.form.txtName.text = this.myObject.getName();
			rbgFrame.setValue(this.myObject.getFrameType());
			rbgProp.setValue(this.myObject.getPropType());
			this.lastFrameType = this.myObject.getFrameType();
			this.updateGUIByFrameType();

			// STATS
			this.form.numStepBaseTarget.setValue(this.myObject.getBaseTarget());
			this.calcBaseTargetWeights();
			this.form.numStepSpeed.setValue(this.myObject.getMaxSpeed());
			this.calcMaxSpeedWeight();
			this.form.numStepGs.setValue(this.myObject.getMaxGs());
			this.calcMaxGWeight();
			this.form.numStepAccel.setValue(this.myObject.getAccelRate());
			this.calcMaxAccelWeight();
			this.form.numStepDecel.setValue(this.myObject.getDecelRate());
			
			this.form.pdManufacturer.clearSelection();
			if( this.myObject.getManufacturerID() != "" ) 
				this.form.pdManufacturer.setActiveSelectionItem(
						this.myObject.getManufacturerID()
					);
						
			this.form.numStepServiceCeiling.setValue(this.myObject.getServiceCeiling());
			this.form.numStepRange.setValue(this.myObject.getRange());
			this.form.numStepEngine.setValue(this.myObject.getEngineCount());
			
			var arrW:Array = this.myObject.getWingspan();
			this.form.numStepWingSpan.setValue(int(arrW[0]),int(arrW[1]));
			var arrL:Array = this.myObject.getLength();
			this.form.numStepLength.setValue(int(arrL[0]),int(arrL[1]));
			var arrH:Array = this.myObject.getHeight();
			this.form.numStepHeight.setValue(int(arrH[0]),int(arrH[1]));
//TODO move to page
/*			
			this.form.page1.numStepCrew.setValue(this.myObject.getCrewCount());
			
			this.form.page2.numStepRocketSlots.setValue(this.myObject.getRocketSlotCount());
			this.recalcRocketHardpoints();
			
			
			
			// GUN 1
			this.initGunpointFromObject(1, this.form.page2.pdGun1, this.form.page2.rbtnGun1AmmoLinked, this.form.page2.numStepGun1Ammo, 
												this.form.page2.rbtnGun1FireLinked, this.form.page2.numStepGun1Fire, this.form.page2.rbtnGun1Turret);
		
			// GUN 2
			this.initGunpointFromObject(2, this.form.page2.pdGun2, this.form.page2.rbtnGun2AmmoLinked, this.form.page2.numStepGun2Ammo, 
												this.form.page2.rbtnGun2FireLinked, this.form.page2.numStepGun2Fire, this.form.page2.rbtnGun2Turret);
		
			// GUN 3
			this.initGunpointFromObject(3, this.form.page2.pdGun3, this.form.page2.rbtnGun3AmmoLinked, this.form.page2.numStepGun3Ammo, 
												this.form.page2.rbtnGun3FireLinked, this.form.page2.numStepGun3Fire, this.form.page2.rbtnGun3Turret);
		
			// GUN 4
			this.initGunpointFromObject(4, this.form.page2.pdGun4, this.form.page2.rbtnGun4AmmoLinked, this.form.page2.numStepGun4Ammo, 
												this.form.page2.rbtnGun4FireLinked, this.form.page2.numStepGun4Fire, this.form.page2.rbtnGun4Turret);
		
			// GUN 5
			this.initGunpointFromObject(5, this.form.page2.pdGun5, this.form.page2.rbtnGun5AmmoLinked, this.form.page2.numStepGun5Ammo, 
												this.form.page2.rbtnGun5FireLinked, this.form.page2.numStepGun5Fire, this.form.page2.rbtnGun5Turret);
		
			// GUN 6
			this.initGunpointFromObject(6, this.form.page2.pdGun6, this.form.page2.rbtnGun6AmmoLinked, this.form.page2.numStepGun6Ammo, 
												this.form.page2.rbtnGun6FireLinked, this.form.page2.numStepGun6Fire, this.form.page2.rbtnGun6Turret);
		
			// GUN 7
			this.initGunpointFromObject(7, this.form.page2.pdGun7, this.form.page2.rbtnGun7AmmoLinked, this.form.page2.numStepGun7Ammo, 
												this.form.page2.rbtnGun7FireLinked, this.form.page2.numStepGun7Fire, this.form.page2.rbtnGun7Turret);
		
			// GUN 8
			this.initGunpointFromObject(8, this.form.page2.pdGun8, this.form.page2.rbtnGun8AmmoLinked, this.form.page2.numStepGun8Ammo, 
												this.form.page2.rbtnGun8FireLinked, this.form.page2.numStepGun8Fire, this.form.page2.rbtnGun8Turret);
		
			
			//TURRETS
			var turrets:Array = this.myObject.getTurrets();
			if (turrets.length > 0) {
				// im augenblick gibts maximal eine turret
				this.form.page2.rbtnHasTurrets.setSelected(true);
				
				this.form.page2.rbtnGun1Turret.setActive(true);
				this.form.page2.rbtnGun2Turret.setActive(true);
				this.form.page2.rbtnGun3Turret.setActive(true);
				this.form.page2.rbtnGun4Turret.setActive(true);
				this.form.page2.rbtnGun5Turret.setActive(true);
				this.form.page2.rbtnGun6Turret.setActive(true);
				this.form.page2.rbtnGun7Turret.setActive(true);
				this.form.page2.rbtnGun8Turret.setActive(true);
				
			} else {
				this.form.page2.rbtnHasTurrets.setSelected(false);
			}
			this.recalcWeapons();
*/			
			this.calcEngineCost();
			this.calcAirframeCost();
			this.calcCockpitCost();
			this.calcFreeWeight();
			this.calcCompleteCost();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateObjectFromWindow
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 */
		public function updateObjectFromWindow():void
		{
			this.myObject.setName(this.form.txtName.text);
			this.myObject.setFrameType(rbgFrame.getValue());
			this.myObject.setPropType(rbgProp.getValue());
			//stats
			this.myObject.setBaseTarget(this.form.numStepBaseTarget.getValue());
			this.myObject.setMaxSpeed(this.form.numStepSpeed.getValue());
			this.myObject.setMaxGs(this.form.numStepGs.getValue());
			this.myObject.setAccelRate(this.form.numStepAccel.getValue());
			this.myObject.setDecelRate(this.form.numStepDecel.getValue());
			
			if( this.form.pdManufacturer.getIDForCurrentSelection() 
					!= CSPullDown.ID_EMPTYSELECTION ) 
			{
				this.myObject.setManufacturerID(
						this.form.pdManufacturer.getIDForCurrentSelection()
					);
			} else {
				this.myObject.setManufacturerID("");
			}
			
			if( this.form.pdLoadout.getIDForCurrentSelection()
					!= CSPullDown.ID_EMPTYSELECTION ) 
			{
				this.myObject.setLoadoutFile(
						this.form.pdLoadout.getIDForCurrentSelection()
					);
			} else {
				this.myObject.setLoadoutFile("");
			}
			this.myObject.setFreeWeight(this.intFreeWeight);
			
			this.myObject.setServiceCeiling(this.form.numStepServiceCeiling.getValue());
			this.myObject.setRange(this.form.numStepRange.getValue());
			this.myObject.setEngineCount(this.form.numStepEngine.getValue());
			
			this.myObject.setWingspan(
					this.form.numStepWingSpan.getValue()[0],
					this.form.numStepWingSpan.getValue()[1]
				);
			this.myObject.setLength( 
					this.form.numStepLength.getValue()[0],
					this.form.numStepLength.getValue()[1] 
				);
			this.myObject.setHeight( 
					this.form.numStepHeight.getValue()[0],
					this.form.numStepHeight.getValue()[1] 
				);
			
			this.myObject = this.form.page1.updateObjectFromWindow();
			this.myObject = this.form.page3.updateObjectFromWindow();
//TODO add other pages
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateDirLists
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 */
		public function updateDirLists():void
		{
			
//TODO filter loadout list by plane. issue 6
//TODO  move code into pages
/*
			var i:int=0;
			
			this.form.page2.pdLoadout.clearSelectionItemList();
			this.form.page2.pdLoadout.setEmptySelectionText("",true);
			
			var arrFLLoadout:Array = Globals.generateFileList(Globals.PATH_DATA+Globals.PATH_LOADOUT);
																																							  
			for (i=0; i< arrFLLoadout.length; i++) {
				this.form.page2.pdLoadout.addSelectionItem(arrFLLoadout[i].viewname,arrFLLoadout[i].filename); 
				
			}
			
			// PILOT und GUNNNER
			this.form.page1.pdPilot.clearSelectionItemList();
			this.form.page1.pdGunner.clearSelectionItemList();
			this.form.page1.pdPilot.setEmptySelectionText("",true);
			this.form.page1.pdGunner.setEmptySelectionText("",true);
			
			var arrFLPilots:Array = Globals.generateFileList(Globals.PATH_DATA+Globals.PATH_PILOT);
																																							  
			for (i=0; i< arrFLPilots.length; i++) {
				this.form.page1.pdPilot.addSelectionItem(arrFLPilots[i].viewname,arrFLPilots[i].filename); 
				this.form.page1.pdGunner.addSelectionItem(arrFLPilots[i].viewname,arrFLPilots[i].filename); 
			}
*/
		}
		
		
		
		/**
		 * ---------------------------------------------------------------------
		 * setSaved
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @param v
		 */
		public function setSaved(v:Boolean):void
		{
			this.isSaved = v;
			this.stampUnsavedData.visible = !v;			
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getIsSaved
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @return
		 */
		public function getIsSaved():Boolean 
		{
			return this.isSaved;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getObject
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @return
		 */
		public function getObject():ICSBaseObject
		{
			return this.myObject;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getFilename
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @return
		 */
		public function getFilename():String 
		{
			return this.myObject.getFilename();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getTitle
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @return
		 */
		public function getTitle():String
		{
			return "Aircraft";
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getWindowType
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @return
		 */
		public function getWindowType():int
		{
			return CSWindowManager.WND_AIRCRAFT;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSubPath
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @return
		 */
		public function getSubPath():String
		{
			return Globals.PATH_AIRCRAFT;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * printMe
		 * ---------------------------------------------------------------------
		 * @see IPrintable
		 */
		public function printMe():void
		{
//TODO Legacy code
/*			
			this.updateObjectFromWindow();
			
			Globals.myCSProgressBar.init("printing ...");
			var printSheet:SheetAircraft = new SheetAircraft();
			printSheet.initFromObject(this.myObject);
			
			if (Globals.myRuleConfigs.getIsPrintingAircraftFlavorSheet() == true) {
				
				var flavorSheet:SheetAircraftFlavor = printSheet.initFlavorSheet(this.myObject, this.myBlueprintLoader, this.myNoseartLoader);
				if (flavorSheet != null) {
					flavorSheet.x = -1000;
					this.stage.addChild(flavorSheet);
				}
			}
			
			Globals.myCSProgressBar.setProgressTo(50);
			// Erst ausserhlb des sichtbaren bereichs hinzufügen
			// sonst klappt das drucken nicht
			// danach wieder removen
			printSheet.x = -1000;
			this.stage.addChild(printSheet);
			printSheet.printNow();
			this.stage.removeChild(printSheet);
			printSheet = null;
			
			if (flavorSheet != null) {
				this.stage.removeChild(flavorSheet);
				flavorSheet = null;
			}
			
			Globals.myCSProgressBar.setProgressTo(100);
			Globals.myCSProgressBar.visible = false;
*/
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * validateForm
		 * ---------------------------------------------------------------------
		 * @see ICSValidate
		 */
		public function validateForm():void
		{
			this.form.page1.validateForm();
			this.form.page2.validateForm();
			this.form.page3.validateForm();
			
			var weightValid:Boolean = true;
			if( this.intFreeWeight < 0 ) 
				weightValid = false;
			
			this.setTextFieldValid(
					this.form.lblFreeWeight,
					weightValid
				);
			
			this.setValid( this.form.page1.getIsValid()
					&& this.form.page2.getIsValid()
					&& this.form.page3.getIsValid()
					&& weightValid
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setValid
		 * ---------------------------------------------------------------------
		 * @see ICSValidate
		 * @param v
		 */
		public function setValid(v:Boolean):void
		{
			this.isValid = v;
			this.stampInvalidData.visible = !v;			
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getIsValid
		 * ---------------------------------------------------------------------
		 * @see ICSValidate
		 * @return
		 */
		public function getIsValid():Boolean 
		{
			return this.isValid;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getFrameType
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getFrameType():String 
		{
			return this.rbgFrame.getValue();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setMultipleEngines
		 * ---------------------------------------------------------------------
		 * toggles the multiple engine stepper on/off
		 * @param hasMultiple
		 */
		public function setMultipleEngines(hasMultiple:Boolean):void
		{
			if( hasMultiple ) 
			{
				this.form.numStepEngine.setupSteps(2,8,2,1);
				this.form.numStepEngine.setActive(true);
			} else {
				this.form.numStepEngine.setupSteps(1,8,1,1);
				this.form.numStepEngine.setActive(false);
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setAmmoLinked
		 * ---------------------------------------------------------------------
		 * toggles the ammo links on/off
		 * @param isLinked
		 */
		public function setAmmoLinked(isLinked:Boolean):void
		{
			this.form.page2.setAmmoLinked(isLinked);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setAmmoLinked
		 * ---------------------------------------------------------------------
		 * toggles the ammo links on/off
		 * @param isLinked
		 */
		public function setFireLinked(isLinked:Boolean):void
		{
			this.form.page2.setFireLinked(isLinked);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcBaseTargetWeights
		 * ---------------------------------------------------------------------
		 */
		private function calcBaseTargetWeights():void
		{
			var currBTN:int = this.form.numStepBaseTarget.getValue();
			
			this.intLoadedWeight = BTN_WEIGHT_MATRIX[currBTN-1][0];
			this.intPayload = BTN_WEIGHT_MATRIX[currBTN-1][1];
			
			this.form.lblPayload.text = CSFormatter.formatLbs(intPayload);
			this.form.lblLoadedWeight.text = CSFormatter.formatLbs(intLoadedWeight);
			
			this.calcAirframeCost();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcMaxSpeedWeight
		 * ---------------------------------------------------------------------
		 */
		private function calcMaxSpeedWeight():void
		{
			var currBTN:int = this.form.numStepBaseTarget.getValue();
			var speed:int = this.form.numStepSpeed.getValue();
			intMaxSpeedWeight = MAXSPEED_WEIGHT_MATRIX[currBTN-1][speed-1];
			
			this.form.lblWeightSpeed.text = CSFormatter.formatLbs(intMaxSpeedWeight);
			this.form.lblSpeedMPH.text =  (speed * 50 +100) +" mph";
			
			this.calcEngineCost();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcMaxGWeight
		 * ---------------------------------------------------------------------
		 */
		private function calcMaxGWeight():void
		{
			var currBTN:int = this.form.numStepBaseTarget.getValue();
			var gs:int = this.form.numStepGs.getValue();
			intMaxGWeight = MAXG_WEIGHT_MATRIX[currBTN-1][gs-1];
			
			this.form.lblWeightGs.text = CSFormatter.formatLbs(intMaxGWeight);
			
			this.calcAirframeCost();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcMaxAccelWeight
		 * ---------------------------------------------------------------------
		 */
		private function calcMaxAccelWeight():void
		{
			var currBTN:int = this.form.numStepBaseTarget.getValue();
			var accel:int = this.form.numStepAccel.getValue();
			intMaxAccelWeight = MAXACCEL_WEIGHT_MATRIX[currBTN-1][accel-1];
			
			this.form.lblWeightAccel.text = CSFormatter.formatLbs(intMaxAccelWeight);
			this.form.lblAccelFPSS.text = (int(10 *accel * 32.8000)/10) +" fps/s";
			
			this.calcEngineCost();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcFreeWeight
		 * ---------------------------------------------------------------------
		 */
		public function calcFreeWeight():void
		{
			this.intFreeWeight = this.intPayload 
					- this.intMaxSpeedWeight 
					- this.intMaxGWeight 
					- this.intMaxAccelWeight
					- this.form.page1.getAdditionalWeight()
					- this.form.page2.getWeaponWeight()
					- this.form.page2.getHardpointWeight() 
					- this.form.page3.getWeight();
					
			this.form.lblFreeWeight.text =  CSFormatter.formatLbs(intFreeWeight);
			
			this.validateForm();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcEngineCost
		 * ---------------------------------------------------------------------
		 */
		public function calcEngineCost():void
		{
			this.intEngineCost = (this.form.numStepSpeed.getValue() *470) 
					+ (this.form.numStepAccel.getValue() *250);
			
			// note: engine count does not affect costs
			this.intEngineCost += int( this.form.page1.getEngineCostMod()
					* this.intEngineCost 
				);
			this.form.lblCostEngine.text = CSFormatter.formatDollar(
					this.intEngineCost
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcAirframeCost
		 * ---------------------------------------------------------------------
		 * gets the cost ruling from ruleconfig.ae
		 */
		public function calcAirframeCost():void
		{
			// official rule hadrcoded 
			// this.intAirframeCost = ((this.numStepBaseTarget.getValue()-1)*500)  + (this.numStepGs.getValue() *510);
			
			// using the rule from RulesConfig
			var btn:int = this.form.numStepBaseTarget.getValue();
			var frm:String = this.rbgFrame.getValue();
			var gs:int = this.form.numStepGs.getValue();
			
			this.intAirframeCost = (gs * 510) +
					Globals.myRuleConfigs.getAirframeCost(btn, frm) 
			
			// mod
			this.intAirframeCost += int( this.form.page1.getAirframeCostMod() 
					* this.intAirframeCost 
				);
			this.form.lblCostAirframe.text = CSFormatter.formatDollar(
					this.intAirframeCost
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcCockpitCost
		 * ---------------------------------------------------------------------
		 */
		public function calcCockpitCost():void
		{
			this.intCockpitCost = this.form.page4.getCost();
			// mod
			this.intCockpitCost += int( this.form.page1.getCockpitCostMod()
					* this.intCockpitCost 
				);
			this.form.lblCostCockpit.text =  CSFormatter.formatDollar(
					this.intCockpitCost
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcCompleteCost
		 * ---------------------------------------------------------------------
		 */
		public function calcCompleteCost()
		{
			var compCost:int = this.form.page1.getAdditionalCost()
					+ this.form.page2.getHardpointCost()
					+ this.form.page2.getWeaponCost() 
					+ this.form.page3.getCost() 
					+ this.intEngineCost 
					+ this.intAirframeCost 
					+ this.intCockpitCost;
			this.form.lblCostComplete.text = CSFormatter.formatDollar(compCost);
		}
				
		/**
		 * ---------------------------------------------------------------------
		 * updateGUIByFrameType
		 * ---------------------------------------------------------------------
		 */
		private function updateGUIByFrameType():void
		{
			var currFrame:String = rbgFrame.getValue();
			var currBTN:int = this.form.numStepBaseTarget.getValue();
						
			if( currFrame == "fighter" )
			{
				this.form.rbtnPropTractor.setActive(true);
				this.form.rbtnPropPusher.setActive(true);
				this.form.rbtnPropHoplite.setActive(false);
				
				if( this.rbgProp.getValue() == "hoplite" )
					this.rbgProp.setValue("tractor");
				
				if( currBTN < 5 ) 
					currBTN = 5;
				
				this.form.numStepBaseTarget.setupSteps(5,10,currBTN,1);
				this.form.numStepGs.setupSteps(1,5,1,1);
				
			} else if( currFrame == "heavyFighter" ) {
				this.form.rbtnPropTractor.setActive(true);
				this.form.rbtnPropPusher.setActive(true);
				this.form.rbtnPropHoplite.setActive(false);
				
				if( rbgProp.getValue() == "hoplite" ) 
					rbgProp.setValue("tractor");
			
				if( currBTN > 6 )
					currBTN = 6;
				
				this.form.numStepBaseTarget.setupSteps(1,6,currBTN,1);
				this.form.numStepGs.setupSteps(1,5,1,1);
				
			} else if( currFrame == "hoplite" ) {
				this.form.rbtnPropTractor.setActive(false);
				this.form.rbtnPropPusher.setActive(false);
				this.form.rbtnPropHoplite.setActive(true);
				
				if( rbgProp.getValue() != "hoplite" )
					rbgProp.setValue("hoplite");
				
				if( currBTN < 6 ) 
					currBTN = 6;
				
				this.form.numStepBaseTarget.setupSteps(6,10,currBTN,1);
				this.form.numStepGs.setupSteps(5,5,5,1);
			}
			// special characteristics
			this.form.page1.init(this);
			//armor
			this.form.page3.init(this);
// TODO init other pages
			
//TODO move to pages
/*			
			
			this.form.page2.pdGun5.setActive(true);
			this.form.page2.pdGun6.setActive(true);
			this.form.page2.pdGun7.setActive(true);
			this.form.page2.pdGun8.setActive(true);
			
			this.form.page2.rbtnHasTurrets.setActive(false);
			this.form.page2.rbtnHasTurrets.setSelected(false);
			
			
			if (currFrame == "fighter") {
				this.form.page1.numStepCrew.setupSteps(1,2,1,1);
				
				this.form.page1.pdGunner.setActive(false);
				this.form.page1.pdGunner.setActiveSelectionItem(CSPullDown.ID_EMPTYSELECTION);
			
			} else if (currFrame == "heavyFighter") {
				this.form.page1.numStepCrew.setupSteps(1,2,2,1);
				
				this.form.page2.rbtnHasTurrets.setActive(true);
				
				this.form.page1.pdGunner.setActive(true);
				
			} else if (currFrame == "hoplite") {
				this.form.page1.numStepCrew.setupSteps(1,2,1,1);
				
				
				// nur 4 guns
				this.form.page2.pdGun5.setActiveSelectionItem(CSPullDown.ID_EMPTYSELECTION);
				this.form.page2.pdGun5.setActive(false);
				this.form.page2.pdGun6.setActiveSelectionItem(CSPullDown.ID_EMPTYSELECTION);
				this.form.page2.pdGun6.setActive(false);
				this.form.page2.pdGun7.setActiveSelectionItem(CSPullDown.ID_EMPTYSELECTION);
				this.form.page2.pdGun7.setActive(false);
				this.form.page2.pdGun8.setActiveSelectionItem(CSPullDown.ID_EMPTYSELECTION);
				this.form.page2.pdGun8.setActive(false);
				
				this.form.page1.pdGunner.setActive(false);
				this.form.page1.pdGunner.setActiveSelectionItem(CSPullDown.ID_EMPTYSELECTION);
				
				this.recalcWeapons();
			
			}
			this.calcCockpitCost();
*/			
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * frameTypeChangedHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function frameTypeChangedHandler(e:MouseEvent):void
		{
			var rbtn:CSRadioButton = CSRadioButton(e.currentTarget);
			
			if( !rbtn.getIsActive()
					&& this.lastFrameType == this.rbgFrame.getValue() ) 
				return;
				
			this.lastFrameType =  this.rbgFrame.getValue();	
			this.updateGUIByFrameType();
				
			this.calcMaxGWeight();
			this.calcBaseTargetWeights();
			this.calcMaxSpeedWeight();
			this.calcFreeWeight();
			this.calcCompleteCost();
				
			this.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * baseTargetChangedHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function baseTargetChangedHandler(e:MouseEvent):void
		{
			if( !this.form.numStepBaseTarget.getIsActive() )
				return;
			
			// for free sc
			this.form.page1.init(this);
//TODO  init page 2			
			//this.calcRocketHardpoints();
				
			this.calcBaseTargetWeights();
			this.calcMaxSpeedWeight();
			this.calcMaxGWeight();
			this.calcMaxAccelWeight();
			this.calcFreeWeight();
			this.calcCompleteCost();
				
			this.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * maxSpeedChangedHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function maxSpeedChangedHandler(e:MouseEvent):void
		{
			if( !this.form.numStepSpeed.getIsActive() ) 
				return;
			
			this.calcMaxSpeedWeight();
			this.calcFreeWeight();
			this.calcCompleteCost();
			this.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * maxGChangedHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function maxGChangedHandler(e:MouseEvent):void
		{
			if( !this.form.numStepGs.getIsActive() )
				return;
				
			this.calcMaxGWeight();
			this.calcFreeWeight();
			this.calcCompleteCost();
			this.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * maxAccelChangedHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function maxAccelChangedHandler(e:MouseEvent):void
		{
			if( !this.form.numStepAccel.getIsActive() ) 
				return;
				
			this.calcMaxAccelWeight();
			this.calcFreeWeight();
			this.calcCompleteCost();
			this.setSaved(false);
		}
		
		
		
		
		
/*		
// TODO page 2		
		private function initPage2()
		{
			//this.form.page2.
			var i:int=0;
			
			this.form.page2.rbtnGun1Turret.setActive(false);
			this.form.page2.rbtnGun1FireLinked.setActive(false);
			this.form.page2.rbtnGun1AmmoLinked.setActive(false);
			
			this.form.page2.rbtnGun2Turret.setActive(false);
			this.form.page2.rbtnGun2FireLinked.setActive(false);
			this.form.page2.rbtnGun2AmmoLinked.setActive(false);
			
			this.form.page2.rbtnGun3Turret.setActive(false);
			this.form.page2.rbtnGun3FireLinked.setActive(false);
			this.form.page2.rbtnGun3AmmoLinked.setActive(false);
			
			this.form.page2.rbtnGun4Turret.setActive(false);
			this.form.page2.rbtnGun4FireLinked.setActive(false);
			this.form.page2.rbtnGun4AmmoLinked.setActive(false);
			
			this.form.page2.rbtnGun5Turret.setActive(false);
			this.form.page2.rbtnGun5FireLinked.setActive(false);
			this.form.page2.rbtnGun5AmmoLinked.setActive(false);
			
			this.form.page2.rbtnGun6Turret.setActive(false);
			this.form.page2.rbtnGun6FireLinked.setActive(false);
			this.form.page2.rbtnGun6AmmoLinked.setActive(false);
			
			this.form.page2.rbtnGun7Turret.setActive(false);
			this.form.page2.rbtnGun7FireLinked.setActive(false);
			this.form.page2.rbtnGun7AmmoLinked.setActive(false);
			
			this.form.page2.rbtnGun8Turret.setActive(false);
			this.form.page2.rbtnGun8FireLinked.setActive(false);
			this.form.page2.rbtnGun8AmmoLinked.setActive(false);
			
			this.form.page2.numStepRocketSlots.setupSteps(1,8,1,1);
			
			this.form.page2.pdLoadout.setMaxVisibleItems(6);
						
			this.form.page2.pdGun1.setMaxVisibleItems(8);
			this.form.page2.pdGun1.setEmptySelectionText("empty",true);
			this.form.page2.pdGun2.setMaxVisibleItems(8);
			this.form.page2.pdGun2.setEmptySelectionText("empty",true);
			this.form.page2.pdGun3.setMaxVisibleItems(8);
			this.form.page2.pdGun3.setEmptySelectionText("empty",true);
			this.form.page2.pdGun4.setMaxVisibleItems(8);
			this.form.page2.pdGun4.setEmptySelectionText("empty",true);
			this.form.page2.pdGun5.setMaxVisibleItems(8);
			this.form.page2.pdGun5.setEmptySelectionText("empty",true);
			this.form.page2.pdGun6.setMaxVisibleItems(8);
			this.form.page2.pdGun6.setEmptySelectionText("empty",true);
			this.form.page2.pdGun7.setMaxVisibleItems(8);
			this.form.page2.pdGun7.setEmptySelectionText("empty",true);
			this.form.page2.pdGun8.setMaxVisibleItems(6);
			this.form.page2.pdGun8.setEmptySelectionText("empty",true);
			
			var arrGuns:Array = Globals.myBaseData.getGuns();
			for (i=0; i < arrGuns.length; i++) {
				this.form.page2.pdGun1.addSelectionItem(arrGuns[i].longName, arrGuns[i].myID);
				this.form.page2.pdGun2.addSelectionItem(arrGuns[i].longName, arrGuns[i].myID);
				this.form.page2.pdGun3.addSelectionItem(arrGuns[i].longName, arrGuns[i].myID);
				this.form.page2.pdGun4.addSelectionItem(arrGuns[i].longName, arrGuns[i].myID);
				this.form.page2.pdGun5.addSelectionItem(arrGuns[i].longName, arrGuns[i].myID);
				this.form.page2.pdGun6.addSelectionItem(arrGuns[i].longName, arrGuns[i].myID);
				this.form.page2.pdGun7.addSelectionItem(arrGuns[i].longName, arrGuns[i].myID);
				this.form.page2.pdGun8.addSelectionItem(arrGuns[i].longName, arrGuns[i].myID);
			}
			
			this.form.page2.numStepGun1Fire.setupSteps(0,8,0,1);
			this.form.page2.numStepGun1Fire.setActive(false);
			this.form.page2.numStepGun2Fire.setupSteps(0,8,0,1);
			this.form.page2.numStepGun2Fire.setActive(false);
			this.form.page2.numStepGun3Fire.setupSteps(0,8,0,1);
			this.form.page2.numStepGun3Fire.setActive(false);
			this.form.page2.numStepGun4Fire.setupSteps(0,8,0,1);
			this.form.page2.numStepGun4Fire.setActive(false);
			this.form.page2.numStepGun5Fire.setupSteps(0,8,0,1);
			this.form.page2.numStepGun5Fire.setActive(false);
			this.form.page2.numStepGun6Fire.setupSteps(0,8,0,1);
			this.form.page2.numStepGun6Fire.setActive(false);
			this.form.page2.numStepGun7Fire.setupSteps(0,8,0,1);
			this.form.page2.numStepGun7Fire.setActive(false);
			this.form.page2.numStepGun8Fire.setupSteps(0,8,0,1);
			this.form.page2.numStepGun8Fire.setActive(false);
			
			this.form.page2.numStepGun1Ammo.setupSteps(0,8,0,1);
			this.form.page2.numStepGun1Ammo.setActive(false);
			this.form.page2.numStepGun2Ammo.setupSteps(0,8,0,1);
			this.form.page2.numStepGun2Ammo.setActive(false);
			this.form.page2.numStepGun3Ammo.setupSteps(0,8,0,1);
			this.form.page2.numStepGun3Ammo.setActive(false);
			this.form.page2.numStepGun4Ammo.setupSteps(0,8,0,1);
			this.form.page2.numStepGun4Ammo.setActive(false);
			this.form.page2.numStepGun5Ammo.setupSteps(0,8,0,1);
			this.form.page2.numStepGun5Ammo.setActive(false);
			this.form.page2.numStepGun6Ammo.setupSteps(0,8,0,1);
			this.form.page2.numStepGun6Ammo.setActive(false);
			this.form.page2.numStepGun7Ammo.setupSteps(0,8,0,1);
			this.form.page2.numStepGun7Ammo.setActive(false);
			this.form.page2.numStepGun8Ammo.setupSteps(0,8,0,1);
			this.form.page2.numStepGun8Ammo.setActive(false);
			
			
			
			
		}
		*/
		
		private function initEventHandler() 
		{
			// braucht man doch net
			//this.numStepEngine.addEventListener(MouseEvent.MOUSE_DOWN, engineCountChangedHandler); 
			
//TODO Page 2
			/*
			this.form.page2.rbtnHasTurrets.addEventListener(MouseEvent.MOUSE_DOWN, hasTurretsChangedHandler,false,0,true);
			
			this.form.page2.numStepRocketSlots.addEventListener(MouseEvent.MOUSE_DOWN, rocketSlotsChangedHandler,false,0,true); 
			
			this.form.page2.rbtnGun1Turret.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.rbtnGun1FireLinked.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.rbtnGun1AmmoLinked.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.pdGun1.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			
			this.form.page2.rbtnGun2Turret.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.rbtnGun2FireLinked.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.rbtnGun2AmmoLinked.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.pdGun2.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			
			this.form.page2.rbtnGun3Turret.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.rbtnGun3FireLinked.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.rbtnGun3AmmoLinked.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.pdGun3.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			
			this.form.page2.rbtnGun4Turret.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.rbtnGun4FireLinked.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.rbtnGun4AmmoLinked.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.pdGun4.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			
			this.form.page2.rbtnGun5Turret.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.rbtnGun5FireLinked.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.rbtnGun5AmmoLinked.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.pdGun5.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			
			this.form.page2.rbtnGun6Turret.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.rbtnGun6FireLinked.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.rbtnGun6AmmoLinked.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.pdGun6.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			
			this.form.page2.rbtnGun7Turret.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.rbtnGun7FireLinked.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.rbtnGun7AmmoLinked.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.pdGun7.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			
			this.form.page2.rbtnGun8Turret.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.rbtnGun8FireLinked.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.rbtnGun8AmmoLinked.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
			this.form.page2.pdGun8.addEventListener(MouseEvent.MOUSE_DOWN, gunChangedHandler,false,0,true); 
*/
			
/* TODO
			this.numStepCrew.setStyle(CSStyle.WHITE);
*/
		}
		
/*				
		// -------------------------------------------------
		// initGunpointFromObject
		// -------------------------------------------------
		// wird von initFromObject aufgerufen
		private function initGunpointFromObject(gpnum:int, pdGun:CSPullDown, 
												rbtnAmmo:CSRadioButton, numSAmmo:CSNumStepperInteger, 
												rbtnFire:CSRadioButton, numSFire:CSNumStepperInteger, rbtnTurret:CSRadioButton)
		{
			var gp:Gunpoint = this.myObject.getGunpoint(gpnum);
			//erst löschen
			pdGun.setActiveSelectionItem(CSPullDown.ID_EMPTYSELECTION);
			//jetzt setzen
			pdGun.setActiveSelectionItem(gp.gunID);
			if (gp.firelinkGroup > 0) {
				rbtnFire.setSelected(true);
			} else {
				rbtnFire.setSelected(false);
			}
			numSFire.setValue(gp.firelinkGroup);
			if (gp.ammolinkGroup > 0) {
				rbtnAmmo.setSelected(true);
			} else {
				rbtnAmmo.setSelected(false);
			}
			numSAmmo.setValue(gp.ammolinkGroup);
			if (gp.direction == Gunpoint.DIR_TURRET) {
				rbtnTurret.setSelected(true);
			} else {
				rbtnTurret.setSelected(false);
			}
		}
*/		
		
/*		
		// -------------------------------------------------
		// updateObjectFromWindow
		// -------------------------------------------------
		// bevor man speichert und druckt aufrufen
		// dann wird das XML aktuallisiert
		public function updateObjectFromWindow():void
		{
			
//TODO move to pages			
			if (this.form.page1.pdPilot.getIDForCurrentSelection() != CSPullDown.ID_EMPTYSELECTION) {
				this.myObject.setPilotFile(this.form.page1.pdPilot.getIDForCurrentSelection());
			} else {
				this.myObject.setPilotFile("");
			}
			if (this.form.page1.pdGunner.getIDForCurrentSelection() != CSPullDown.ID_EMPTYSELECTION) {
				this.myObject.setGunnerFile(this.form.page1.pdGunner.getIDForCurrentSelection());
			} else {
				this.myObject.setGunnerFile("");
			}
		
			this.myObject.setCrewCount(this.form.page1.numStepCrew.getValue());
			
			this.myObject.setRocketSlotCount(this.form.page2.numStepRocketSlots.getValue());
			
			
			// GUN 1
			this.updateObjectsGunpointFromWindow(1, this.form.page2.pdGun1.getIDForCurrentSelection(), 
							this.form.page2.numStepGun1Ammo, this.form.page2.numStepGun1Fire, this.form.page2.rbtnGun1Turret);
			
			// GUN 2
			this.updateObjectsGunpointFromWindow(2, this.form.page2.pdGun2.getIDForCurrentSelection(), 
							this.form.page2.numStepGun2Ammo, this.form.page2.numStepGun2Fire, this.form.page2.rbtnGun2Turret);
			
			// GUN 3
			this.updateObjectsGunpointFromWindow(3, this.form.page2.pdGun3.getIDForCurrentSelection(), 
							this.form.page2.numStepGun3Ammo, this.form.page2.numStepGun3Fire, this.form.page2.rbtnGun3Turret);
			
			// GUN 4
			this.updateObjectsGunpointFromWindow(4, this.form.page2.pdGun4.getIDForCurrentSelection(), 
							this.form.page2.numStepGun4Ammo, this.form.page2.numStepGun4Fire, this.form.page2.rbtnGun4Turret);
			
			// GUN 5
			this.updateObjectsGunpointFromWindow(5, this.form.page2.pdGun5.getIDForCurrentSelection(), 
							this.form.page2.numStepGun5Ammo, this.form.page2.numStepGun5Fire, this.form.page2.rbtnGun5Turret);
			
			// GUN 6
			this.updateObjectsGunpointFromWindow(6, this.form.page2.pdGun6.getIDForCurrentSelection(), 
							this.form.page2.numStepGun6Ammo, this.form.page2.numStepGun6Fire, this.form.page2.rbtnGun6Turret);
			
			// GUN 7
			this.updateObjectsGunpointFromWindow(7, this.form.page2.pdGun7.getIDForCurrentSelection(), 
							this.form.page2.numStepGun7Ammo, this.form.page2.numStepGun7Fire, this.form.page2.rbtnGun7Turret);
			
			// GUN 8
			this.updateObjectsGunpointFromWindow(8, this.form.page2.pdGun8.getIDForCurrentSelection(), 
							this.form.page2.numStepGun8Ammo, this.form.page2.numStepGun8Fire, this.form.page2.rbtnGun8Turret);
			
			//TURRETS
			var arrTur:Array = new Array();
			if (this.form.page2.rbtnHasTurrets.getIsSelected() ) {
				// gibt ja nur eine bis jetzt
				arrTur.push(new Turret(Turret.DIR_FRONT));
			}
			this.myObject.setTurrets(arrTur);
			
		}
*/		
		
		// -------------------------------------------------
		// updateObjectsGunpointFromWindow
		// -------------------------------------------------
		// wird von updateObjectFromWindow aufgerufen
//TODO move page2
		/*
		private function updateObjectsGunpointFromWindow(gpnum:int, gunid:String,  
								numSAmmo:CSNumStepperInteger, numSFire:CSNumStepperInteger, rbtnTurret:CSRadioButton)
		{
			var gp:Gunpoint = null;
			
			if (gunid == CSPullDown.ID_EMPTYSELECTION) {
				gunid = "";
			}
			gp = new Gunpoint(gpnum,gunid);
			gp.firelinkGroup = numSFire.getValue();
			gp.ammolinkGroup = numSAmmo.getValue();
			if (rbtnTurret.getIsSelected()){
				gp.direction = Gunpoint.DIR_TURRET;
			} else {
				gp.direction = Gunpoint.DIR_FORWARD;
			}
			this.myObject.setGunpoint(gp);
		}
		*/
		
		
		// -----------------------------------------------
		// updateGUIBySpecialCharacteristics
		// -----------------------------------------------
		// hier werden die GUI Elemente die mit einer Special Characteristik verknüpft sind 
		// ein- bzw angeschalten.
		private function updateGUIBySpecialCharacteristics()
		{
			
/*			
			// -----------------------------------------------
			// Linked Ammo Bins
			// -----------------------------------------------
// TODO move this to weapons page			
			if (arrSC.indexOf(BaseData.HCID_SC_LINKEDAMMO) != -1) {
				this.form.page2.rbtnGun1AmmoLinked.setActive(true);
				this.form.page2.rbtnGun2AmmoLinked.setActive(true);
				this.form.page2.rbtnGun3AmmoLinked.setActive(true);
				this.form.page2.rbtnGun4AmmoLinked.setActive(true);
				
				if (rbgFrame.getValue() != "hoplite") {
					this.form.page2.rbtnGun5AmmoLinked.setActive(true);
					this.form.page2.rbtnGun6AmmoLinked.setActive(true);
					this.form.page2.rbtnGun7AmmoLinked.setActive(true);
					this.form.page2.rbtnGun8AmmoLinked.setActive(true);
				}
			} else  {
				this.form.page2.rbtnGun1AmmoLinked.setActive(false);
				this.form.page2.rbtnGun1AmmoLinked.setSelected(false);
				this.form.page2.numStepGun1Ammo.setActive(false);
				this.form.page2.numStepGun1Ammo.setValue(0);
				
				this.form.page2.rbtnGun2AmmoLinked.setActive(false);
				this.form.page2.rbtnGun2AmmoLinked.setSelected(false);
				this.form.page2.numStepGun2Ammo.setActive(false);
				this.form.page2.numStepGun2Ammo.setValue(0);
				
				this.form.page2.rbtnGun3AmmoLinked.setActive(false);
				this.form.page2.rbtnGun3AmmoLinked.setSelected(false);
				this.form.page2.numStepGun3Ammo.setActive(false);
				this.form.page2.numStepGun3Ammo.setValue(0);
				
				this.form.page2.rbtnGun4AmmoLinked.setActive(false);
				this.form.page2.rbtnGun4AmmoLinked.setSelected(false);
				this.form.page2.numStepGun4Ammo.setActive(false);
				this.form.page2.numStepGun4Ammo.setValue(0);
				
				this.form.page2.rbtnGun5AmmoLinked.setActive(false);
				this.form.page2.rbtnGun5AmmoLinked.setSelected(false);
				this.form.page2.numStepGun5Ammo.setActive(false);
				this.form.page2.numStepGun5Ammo.setValue(0);
				
				this.form.page2.rbtnGun6AmmoLinked.setActive(false);
				this.form.page2.rbtnGun6AmmoLinked.setSelected(false);
				this.form.page2.numStepGun6Ammo.setActive(false);
				this.form.page2.numStepGun6Ammo.setValue(0);
				
				this.form.page2.rbtnGun7AmmoLinked.setActive(false);
				this.form.page2.rbtnGun7AmmoLinked.setSelected(false);
				this.form.page2.numStepGun7Ammo.setActive(false);
				this.form.page2.numStepGun7Ammo.setValue(0);
				
				this.form.page2.rbtnGun8AmmoLinked.setActive(false);
				this.form.page2.rbtnGun8AmmoLinked.setSelected(false);
				this.form.page2.numStepGun8Ammo.setActive(false);
				this.form.page2.numStepGun8Ammo.setValue(0);
				
			}
			
			// -----------------------------------------------
			// Fire Linked
			// -----------------------------------------------
			if (arrSC.indexOf(BaseData.HCID_SC_LINKEDFIRE) != -1) {
				this.form.page2.rbtnGun1FireLinked.setActive(true);
				this.form.page2.rbtnGun2FireLinked.setActive(true);
				this.form.page2.rbtnGun3FireLinked.setActive(true);
				this.form.page2.rbtnGun4FireLinked.setActive(true);
				
				if (rbgFrame.getValue() != "hoplite") {
					this.form.page2.rbtnGun5FireLinked.setActive(true);
					this.form.page2.rbtnGun6FireLinked.setActive(true);
					this.form.page2.rbtnGun7FireLinked.setActive(true);
					this.form.page2.rbtnGun8FireLinked.setActive(true);
				}
			} else  {
				this.form.page2.rbtnGun1FireLinked.setActive(false);
				this.form.page2.rbtnGun1FireLinked.setSelected(false);
				this.form.page2.numStepGun1Fire.setActive(false);
				this.form.page2.numStepGun1Fire.setValue(0);
				
				this.form.page2.rbtnGun2FireLinked.setActive(false);
				this.form.page2.rbtnGun2FireLinked.setSelected(false);
				this.form.page2.numStepGun2Fire.setActive(false);
				this.form.page2.numStepGun2Fire.setValue(0);
				
				this.form.page2.rbtnGun3FireLinked.setActive(false);
				this.form.page2.rbtnGun3FireLinked.setSelected(false);
				this.form.page2.numStepGun3Fire.setActive(false);
				this.form.page2.numStepGun3Fire.setValue(0);
				
				this.form.page2.rbtnGun4FireLinked.setActive(false);
				this.form.page2.rbtnGun4FireLinked.setSelected(false);
				this.form.page2.numStepGun4Fire.setActive(false);
				this.form.page2.numStepGun4Fire.setValue(0);
				
				this.form.page2.rbtnGun5FireLinked.setActive(false);
				this.form.page2.rbtnGun5FireLinked.setSelected(false);
				this.form.page2.numStepGun5Fire.setActive(false);
				this.form.page2.numStepGun5Fire.setValue(0);
				
				this.form.page2.rbtnGun6FireLinked.setActive(false);
				this.form.page2.rbtnGun6FireLinked.setSelected(false);
				this.form.page2.numStepGun6Fire.setActive(false);
				this.form.page2.numStepGun6Fire.setValue(0);
				
				this.form.page2.rbtnGun7FireLinked.setActive(false);
				this.form.page2.rbtnGun7FireLinked.setSelected(false);
				this.form.page2.numStepGun7Fire.setActive(false);
				this.form.page2.numStepGun7Fire.setValue(0);
				
				this.form.page2.rbtnGun8FireLinked.setActive(false);
				this.form.page2.rbtnGun8FireLinked.setSelected(false);
				this.form.page2.numStepGun8Fire.setActive(false);
				this.form.page2.numStepGun8Fire.setValue(0);
				
			}
			
			*/
			
			// ===========================================================
			// HIGH Torque wird erst im Print sheet berechnet
			
			
		}
		
		
		
		
		
		
		
		
	
		
		// ----------------------------------------------------------
		// recalcWeapons
		// ----------------------------------------------------------
		// gewichte preise, etc 
		// nur keine raketen!!!!!
// TODO page 2
/*
		private function recalcWeapons()
		{
			//var gp:Gunpoint = null;
			var gunid:String = "";
			
			// resetten
			this.intWeaponWeight = 0;
			this.intWeaponCost = 0;
			
			// gun 1
			gunid = this.form.page2.pdGun1.getIDForCurrentSelection();
			this.calcWeapon(gunid, this.form.page2.rbtnGun1AmmoLinked, this.form.page2.numStepGun1Ammo,
							this.form.page2.rbtnGun1FireLinked, this.form.page2.numStepGun1Fire, this.form.page2.rbtnGun1Turret, this.form.page2.lblGun1Weight);
			
			// gun 2
			gunid = this.form.page2.pdGun2.getIDForCurrentSelection();
			this.calcWeapon(gunid, this.form.page2.rbtnGun2AmmoLinked, this.form.page2.numStepGun2Ammo,
							this.form.page2.rbtnGun2FireLinked, this.form.page2.numStepGun2Fire, this.form.page2.rbtnGun2Turret, this.form.page2.lblGun2Weight);
			
			// gun 3
			gunid = this.form.page2.pdGun3.getIDForCurrentSelection();
			this.calcWeapon(gunid, this.form.page2.rbtnGun3AmmoLinked, this.form.page2.numStepGun3Ammo, 
							this.form.page2.rbtnGun3FireLinked, this.form.page2.numStepGun3Fire, this.form.page2.rbtnGun3Turret, this.form.page2.lblGun3Weight);
			
			// gun 4
			gunid = this.form.page2.pdGun4.getIDForCurrentSelection();
			this.calcWeapon(gunid, this.form.page2.rbtnGun4AmmoLinked, this.form.page2.numStepGun4Ammo, 
							this.form.page2.rbtnGun4FireLinked, this.form.page2.numStepGun4Fire, this.form.page2.rbtnGun4Turret, this.form.page2.lblGun4Weight);
			
			// gun 5
			gunid = this.form.page2.pdGun5.getIDForCurrentSelection();
			this.calcWeapon(gunid, this.form.page2.rbtnGun5AmmoLinked, this.form.page2.numStepGun5Ammo,
							this.form.page2.rbtnGun5FireLinked, this.form.page2.numStepGun5Fire, this.form.page2.rbtnGun5Turret, this.form.page2.lblGun5Weight);
			
			// gun 6
			gunid = this.form.page2.pdGun6.getIDForCurrentSelection();
			this.calcWeapon(gunid, this.form.page2.rbtnGun6AmmoLinked, this.form.page2.numStepGun6Ammo, 
							this.form.page2.rbtnGun6FireLinked, this.form.page2.numStepGun6Fire, this.form.page2.rbtnGun6Turret, this.form.page2.lblGun6Weight);
			
			// gun 7
			gunid = this.form.page2.pdGun7.getIDForCurrentSelection();
			this.calcWeapon(gunid, this.form.page2.rbtnGun7AmmoLinked, this.form.page2.numStepGun7Ammo, 
							this.form.page2.rbtnGun7FireLinked, this.form.page2.numStepGun7Fire, this.form.page2.rbtnGun7Turret, this.form.page2.lblGun7Weight);
			
			// gun 8
			gunid = this.form.page2.pdGun8.getIDForCurrentSelection();
			this.calcWeapon(gunid, this.form.page2.rbtnGun8AmmoLinked, this.form.page2.numStepGun8Ammo, 
							this.form.page2.rbtnGun8FireLinked, this.form.page2.numStepGun8Fire, this.form.page2.rbtnGun8Turret, this.form.page2.lblGun8Weight);
			
			
			
			// Turret basisgewicht 400lbs
			if (this.form.page2.rbtnHasTurrets.getIsSelected() ) {
				this.intWeaponWeight = this.intWeaponWeight + 400;
			}
			
			// labels updaten
// USE CSFormatter			
			
//			this.form.lblCostWeapon.text = this.createDollarString(this.intHardpointCost + this.intWeaponCost);
//			this.form.page2.lblWeaponWeight.text = this.createLbsString(this.intWeaponWeight);
			
		}
*/		
		// ----------------------------------------------------------
		// calcWeapon
		// ----------------------------------------------------------
		// wird von recalcWeapons() verwendet
//TODO page 2
/*
		private function calcWeapon(gunid:String, 
									rbtnAmmoL:CSRadioButton, numSAmmo:CSNumStepperInteger, 
									rbtnFireL:CSRadioButton, numSFire:CSNumStepperInteger, 
									rbtnTurret:CSRadioButton, lblWeight:TextField) 
		{
			var gun:Gun = null;
			var modCost:Number = 0.00;
			var gunWeight:int = 0;
			var gunCost:int = 0;
			
			if (gunid != CSPullDown.ID_EMPTYSELECTION) {
				gun = Globals.myBaseData.getGun(gunid);
				gunWeight = gun.weight;
				gunCost = gun.price;
				
				if (rbtnAmmoL.getIsSelected() == true) {
					modCost = Globals.myBaseData.getSpecialCharacteristic(BaseData.HCID_SC_LINKEDAMMO).costChanges;
					numSAmmo.setActive(true);
					if (numSAmmo.getValue() == 0) {
						numSAmmo.setValue(1);
					}
				} else {
					numSAmmo.setActive(false);
					numSAmmo.setValue(0);
				}
				
				if (rbtnFireL.getIsSelected() == true) {
					modCost = modCost + Globals.myBaseData.getSpecialCharacteristic(BaseData.HCID_SC_LINKEDFIRE).costChanges;
					numSFire.setActive(true);
					if (numSFire.getValue() == 0) {
						numSFire.setValue(1);
					}
				} else {
					numSFire.setActive(false);
					numSFire.setValue(0);
				}
				if (rbtnTurret.getIsSelected() == true) {
					gunWeight = gunWeight + (gun.weight /2);
					modCost = modCost + 0.50;
				}
				gunCost = gunCost + int(gun.price * modCost);
			} 
			this.intWeaponCost = this.intWeaponCost + gunCost;
			this.intWeaponWeight = this.intWeaponWeight + gunWeight;
			
// USE CSFormatter			
//			lblWeight.text = this.createLbsString(gunWeight);
		}
*/		
		
		
		// ----------------------------------------------------------
		// recalcRocketHardpoints
		// ----------------------------------------------------------
		// anzahl der slots und frei werdendes gewicht
// TODO page 2		
/*		
		private function recalcRocketHardpoints()
		{
			var currBTN:int = this.form.numStepBaseTarget.getValue();
			var currFrame:String = this.rbgFrame.getValue();
			var maxRHP:int = 0;
			var currRHP:int = this.form.page2.numStepRocketSlots.getValue();
			
			if (currFrame == "fighter" || currFrame == "heavyFighter") {
				maxRHP = 11 - currBTN;
			
			} else if (currFrame == "hoplite") {
				maxRHP = 11 - currBTN;
				if (maxRHP > 4 ){
					maxRHP = 4;
				}	
			}
			
			
			if (currRHP > maxRHP) {
				currRHP = maxRHP;
			}
			
			this.form.page2.numStepRocketSlots.setupSteps(0,maxRHP,currRHP,1);
			
			//aus der RuleConfig lesen
			var weightPerSlot:int = Globals.myRuleConfigs.getRocketHardpointMassreduction();
			this.intHardpointWeight =  (maxRHP - currRHP) * weightPerSlot;
// USE CSFormatter			

//			this.form.page2.lblHardpointWeight.text =  this.createLbsString(this.intHardpointWeight);
			
			this.intHardpointCost = currRHP *50;
			
// USE CSFormatter			
//			this.form.lblCostWeapon.text = this.createDollarString(this.intHardpointCost + this.intWeaponCost);
			
			
		}
*/		
		
		
		
		
		
		
		
		
		
		
// TODO move to page 2		
/*		
		private function updateTurretRadioButtons()
		{
			if (this.form.page2.rbtnHasTurrets.getIsSelected() == true ) 
			{
				this.form.page2.rbtnGun1Turret.setActive(true);
				this.form.page2.rbtnGun2Turret.setActive(true);
				this.form.page2.rbtnGun3Turret.setActive(true);
				this.form.page2.rbtnGun4Turret.setActive(true);
				this.form.page2.rbtnGun5Turret.setActive(true);
				this.form.page2.rbtnGun6Turret.setActive(true);
				this.form.page2.rbtnGun7Turret.setActive(true);
				this.form.page2.rbtnGun8Turret.setActive(true);
				
			} else {
				this.form.page2.rbtnGun1Turret.setActive(false);
				this.form.page2.rbtnGun1Turret.setSelected(false);
				this.form.page2.rbtnGun2Turret.setActive(false);
				this.form.page2.rbtnGun2Turret.setSelected(false);
				this.form.page2.rbtnGun3Turret.setActive(false);
				this.form.page2.rbtnGun3Turret.setSelected(false);
				this.form.page2.rbtnGun4Turret.setActive(false);
				this.form.page2.rbtnGun4Turret.setSelected(false);
				this.form.page2.rbtnGun5Turret.setActive(false);
				this.form.page2.rbtnGun5Turret.setSelected(false);
				this.form.page2.rbtnGun6Turret.setActive(false);
				this.form.page2.rbtnGun6Turret.setSelected(false);
				this.form.page2.rbtnGun7Turret.setActive(false);
				this.form.page2.rbtnGun7Turret.setSelected(false);
				this.form.page2.rbtnGun8Turret.setActive(false);
				this.form.page2.rbtnGun8Turret.setSelected(false);
				
			}
		}
		
		
		
		// TODO move page 2		
		private function hasTurretsChangedHandler(evtObj:MouseEvent):void
		{
			if (this.form.page2.rbtnHasTurrets.getIsActive() == true) {
				this.updateTurretRadioButtons();				
				this.recalcWeapons();
				
				this.calcFreeWeight();
				this.calcCompleteCost();
				
				this.setSaved(false);
				
				
			}
			
		}
		// TODO move to page 2		
		private function rocketSlotsChangedHandler(evtObj:MouseEvent):void
		{
			this.recalcRocketHardpoints();
			this.recalcWeapons();
			this.updateFreeWeight();
			this.calcCompleteCost();
			this.setSaved(false);
			
			
			
			
		}
		
		
// TODO move page 2		
		private function gunChangedHandler(evtObj:MouseEvent):void
		{
			this.recalcWeapons();
			this.updateFreeWeight();
			this.calcCompleteCost();
			this.setSaved(false);
			
			
			
			
		}
*/		
		
	
	}
}