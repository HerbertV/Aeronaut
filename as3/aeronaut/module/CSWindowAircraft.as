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
 * @version: 1.1.0
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2009-2013 Herbert Veitengruber 
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
	
	import as3.hv.core.net.BinaryLoader;
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	import as3.hv.zinc.z3.xml.XMLFileList;
	
	import as3.aeronaut.CSFormatter;
	import as3.aeronaut.Globals;
	import as3.aeronaut.CSWindowManager;
	import as3.aeronaut.CSDialogs;
	
	import as3.aeronaut.objects.Aircraft;	
	import as3.aeronaut.objects.aircraft.*;
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.Loadout;
	
	import as3.aeronaut.objects.aircraftConfigs.*;
	
	import as3.aeronaut.gui.*;
	
	import as3.aeronaut.module.aircraft.*;
	
	import as3.aeronaut.print.IPrintable;
	import as3.aeronaut.print.PrintManager;
	
	import as3.aeronaut.cadet.AircraftImporter;
	import as3.aeronaut.cadet.AbstractCadetImporter;
	
	/**
	 * =========================================================================
	 * CSWindowAircraft
	 * =========================================================================
	 * This class is a linked document class for "winAircraft.swf"
	 * @see as3.aeronaut.objects.Aircraft
	 *
	 * Window for crating/editing Aircraft.
	 */
	public class CSWindowAircraft 
			extends CSWindow 
			implements ICSWindowAircraft, ICSValidate, IPrintable
	{
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var pbtnController:PageButtonController = null;
		private var rbgFrame:CSRadioButtonGroup = null;
		private var rbgProp:CSRadioButtonGroup = null;
		
		private var isValid:Boolean = true;
		private var isSaved:Boolean = true;
		
		private var myObject:Aircraft = null;
		
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
		private var frameDef:FrameDefinition = null;
		
		// becomes true if file was updated after loading
		private var fileWasUpdated:Boolean = false;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 */
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
			this.pbtnController.addPage(this.form.btnPage5,this.form.page5);
			this.pbtnController.setActivePage(0);			
			
			this.form.txtName.text = "";
			
// TODO remove when we have a solution
			this.form.rbtnPropDouble.setActive(false);
			
			rbgFrame = new CSRadioButtonGroup();
			rbgFrame.addMember(
					this.form.rbtnFrameFighter,
					FrameDefinition.FT_FIGHTER
				);
			rbgFrame.addMember(
					this.form.rbtnFrameHFighter,
					FrameDefinition.FT_HEAVY_FIGHTER
				);
			rbgFrame.addMember(
					this.form.rbtnFrameHoplite,
					FrameDefinition.FT_AUTOGYRO
				);
			rbgFrame.addMember(
					this.form.rbtnFrameHeavyBomber,
					FrameDefinition.FT_HEAVY_BOMBER
				);
			rbgFrame.addMember(
					this.form.rbtnFrameLightBomber,
					FrameDefinition.FT_LIGHT_BOMBER
				);
			rbgFrame.addMember(
					this.form.rbtnFrameHeavyCargo,
					FrameDefinition.FT_HEAVY_CARGO
				);
			rbgFrame.addMember(
					this.form.rbtnFrameLightCargo,
					FrameDefinition.FT_LIGHT_CARGO
				);
			
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
			this.form.rbtnFrameHeavyBomber.addEventListener(
					MouseEvent.MOUSE_DOWN,
					frameTypeChangedHandler
				);
			this.form.rbtnFrameLightBomber.addEventListener(
					MouseEvent.MOUSE_DOWN,
					frameTypeChangedHandler
				);
			this.form.rbtnFrameHeavyCargo.addEventListener(
					MouseEvent.MOUSE_DOWN,
					frameTypeChangedHandler
				);
			this.form.rbtnFrameLightCargo.addEventListener(
					MouseEvent.MOUSE_DOWN,
					frameTypeChangedHandler
				);

			rbgProp = new CSRadioButtonGroup();
			rbgProp.addMember(
					this.form.rbtnPropTractor,
					FrameDefinition.PT_TRACTOR
				);
			rbgProp.addMember(
					this.form.rbtnPropPusher,
					FrameDefinition.PT_PUSHER
				);
			rbgProp.addMember(
					this.form.rbtnPropHoplite,
					FrameDefinition.PT_AUTOGYRO
				);
			rbgProp.addMember(
					this.form.rbtnPropDouble,
					FrameDefinition.PT_DOUBLE
				);
			
			this.form.numStepBaseTarget.setAutoStepActive(false);
			this.form.numStepBaseTarget.setValueChangedCallback(
					baseTargetChangedHandler
				);
			this.form.numStepSpeed.setAutoStepActive(false);
			this.form.numStepSpeed.setValueChangedCallback(
					maxSpeedChangedHandler
				); 
			this.form.numStepGs.setAutoStepActive(false);
			this.form.numStepGs.setValueChangedCallback(
					maxGChangedHandler
				); 
			this.form.numStepAccel.setAutoStepActive(false);
			this.form.numStepAccel.setValueChangedCallback(
					maxAccelChangedHandler
				); 

			var arrList:Array = Globals.myAircraftConfigs.getBTNList();
			this.form.numStepBaseTarget.setListOffset(1);
			this.form.numStepBaseTarget.setupSteps(1,10,1,arrList);
			this.form.numStepSpeed.setupSteps(1,5,1,1);
			this.form.numStepGs.setupSteps(1,5,1,1);
			this.form.numStepAccel.setupSteps(1,3,1,1);
			this.form.numStepDecel.setupSteps(1,5,2,1);
			this.form.numStepDecel.setActive(false);
							
			this.form.pdManufacturer.setEmptySelectionText("",true);
			var arrCo:Array = Globals.myCompanies.getCompanies();
			for( var i:int = 0; i < arrCo.length; i++ ) 
				this.form.pdManufacturer.addSelectionItem(
						arrCo[i].longName, 
						arrCo[i].myID
					);
				
			this.form.numStepServiceCeiling.setupSteps(5000 ,50000 ,5000, 500);
			this.form.numStepServiceCeiling.setupTooltip(Globals.myTooltip, "");
			this.form.numStepRange.setupSteps(50 ,2500 ,50, 25);
			this.form.numStepRange.setupTooltip(Globals.myTooltip,"");
			this.form.numStepEngine.setupSteps(1,8,1,1);
			this.form.numStepEngine.setActive(false);
			this.form.numStepWingSpan.setupSteps(10 ,100 ,25, 0);
			this.form.numStepWingSpan.setupTooltip(Globals.myTooltip,"");
			this.form.numStepLength.setupSteps(10 ,100 ,20, 0);
			this.form.numStepLength.setupTooltip(Globals.myTooltip,"");
			this.form.numStepHeight.setupSteps(5 ,30 ,10, 6);
			this.form.numStepHeight.setupTooltip(Globals.myTooltip, "");
			
			this.form.btnImportCadet.setupTooltip(Globals.myTooltip,"Import CADET Aircraft");
			this.form.btnImportCadet.addEventListener(
					MouseEvent.MOUSE_DOWN,
					importCadetHandler
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 * @see AbstractModule
		 */
		override public function dispose():void
		{
			this.form.page1.dispose();
			this.form.page2.dispose();
			this.form.page3.dispose();
			this.form.page4.dispose();
			this.form.page5.dispose();
			
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
			this.fileWasUpdated = obj.updateVersion();
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
			this.fileWasUpdated = false;
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
			if( this.fileWasUpdated )
				this.setSaved(false);
			
			this.myObject = obj;
			
			this.form.txtName.text = this.myObject.getName();
			rbgFrame.setValue(this.myObject.getFrameType());
			rbgProp.setValue(this.myObject.getPropType());
			this.lastFrameType = this.myObject.getFrameType();
			
			// STATS
			this.form.numStepBaseTarget.setValue(this.myObject.getBaseTarget());
			this.form.numStepSpeed.setValue(this.myObject.getMaxSpeed());
			this.form.numStepGs.setValue(this.myObject.getMaxGs());
			this.form.numStepAccel.setValue(this.myObject.getAccelRate());
			this.form.numStepDecel.setValue(this.myObject.getDecelRate());
			// this also updates the pages
			this.updateGUIByFrameType();

			this.calcBaseTargetWeights();
			this.calcMaxSpeedWeight();
			this.calcMaxGWeight();
			this.calcMaxAccelWeight();
			
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
	
			this.calcEngineCost();
			this.calcAirframeCost();
			this.calcCockpitCost();
			this.calcFreeWeight();
			this.calcCompleteCost();
			
			this.updateDirLists();
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
			this.myObject = this.form.page2.updateObjectFromWindow();
			this.myObject = this.form.page3.updateObjectFromWindow();
			this.myObject = this.form.page4.updateObjectFromWindow();
			this.myObject = this.form.page5.updateObjectFromWindow();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateDirLists
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 */
		public function updateDirLists():void
		{
			this.form.pdLoadout.clearSelectionItemList();
			this.form.pdLoadout.setEmptySelectionText("",true);
			
			// loadout can only shown if we have a filename
			if( this.myObject != null )
			{
				if( this.myObject.getFilename() != "" )
				{
					var fl:XMLFileList = new XMLFileList(Globals.AE_EXT, "name");
					fl.addFilter( "loadout", "srcAircraft", (this.getFilename()) );
					
					var arrFLLoadout:Array = fl.generate( 
							mdm.Application.path, 
							Globals.PATH_DATA 
								+ Globals.PATH_LOADOUT,
							Loadout.BASE_TAG
						);
					
					for( var i:int=0; i< arrFLLoadout.length; i++ ) 
						this.form.pdLoadout.addSelectionItem(
								arrFLLoadout[i].viewname,
								arrFLLoadout[i].filename
							);
				}
			}
			
			this.form.page4.updateDirLists();
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
			this.updateObjectFromWindow();

			Globals.myPrintManager.addSheet("printAircraft.swf",this.myObject);
			Globals.myPrintManager.printNow();
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
			//validation for bomb weight
			this.form.page5.validateForm();
			
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
					&& this.form.page5.getIsValid()
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
		 * getFrameDefinition
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getFrameDefinition():FrameDefinition 
		{
			return this.frameDef;
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
			
			this.intLoadedWeight = 
					Globals.myAircraftConfigs.getBTNLoadedWeightByIndex(currBTN);
			this.intPayload = 
					Globals.myAircraftConfigs.getBTNPayloadByIndex(currBTN);
			
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
			intMaxSpeedWeight = 
					Globals.myAircraftConfigs.getMaxSpeedWeight(currBTN, speed);
			
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
			intMaxGWeight = Globals.myAircraftConfigs.getMaxGWeight(currBTN, gs);
			
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
			intMaxAccelWeight = 
					Globals.myAircraftConfigs.getMaxAccelWeight(currBTN, accel);
			
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
					
			// weight modifier for Z&B SCs
			this.intFreeWeight -= int( this.intPayload 
					* this.form.page1.getCompleteWeightMod()
				);	
					
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
			var currBTN:int = this.form.numStepBaseTarget.getValue();
			
			var maxSpeedCost:int = Globals.myAircraftConfigs.getMaxSpeedCost(
							currBTN, 
							this.form.numStepSpeed.getValue()
						);
			
			this.intEngineCost = maxSpeedCost
					+ Globals.myAircraftConfigs.getMaxAccelCost(
							currBTN, 
							this.form.numStepAccel.getValue()
						);
			
			// note: engine count does not affect costs
			this.intEngineCost += int( this.form.page1.getEngineCostMod()
					* this.intEngineCost 
				);
			// Speed modifier for Z&B SCs
			this.intEngineCost += int( this.form.page1.getSpeedCostMod()
					* maxSpeedCost 
				);
			
			this.form.lblCostEngine.text = CSFormatter.formatDollar(
					this.intEngineCost
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcAirframeCost
		 * ---------------------------------------------------------------------
		 * gets the cost from aircraftConfigs.ae
		 */
		public function calcAirframeCost():void
		{
			var btn:int = this.form.numStepBaseTarget.getValue();
			var gs:int = this.form.numStepGs.getValue();
			
			this.intAirframeCost = Globals.myAircraftConfigs.getMaxGCost(btn, gs)
					+ Globals.myAircraftConfigs.getBTNCostByIndex(btn);
					
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
			
			// complete cost mod for Z&B SCs
			compCost += int( this.form.page1.getCompleteCostMod()
					* compCost
				);
			
			// update Labels
			this.form.lblCostWeapon.text = CSFormatter.formatDollar(
					this.form.page2.getHardpointCost()
						+ this.form.page2.getWeaponCost()
				);
				
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
			// first set the actual frame definition
			this.frameDef = Globals.myAircraftConfigs.getFrameDefinition(currFrame);
			
			if( Console.isConsoleAvailable() )
				Console.getInstance().writeln(
						this.frameDef.toString(),
						DebugLevel.INFO
					);
				
			// prop setup
			var lastProp:String = this.rbgProp.getValue()
			
			this.form.rbtnPropTractor.setActive(false);
			this.form.rbtnPropPusher.setActive(false);
			this.form.rbtnPropHoplite.setActive(false);
			
			var lastPropFound:Boolean = false;
			for each( var ap:String in this.frameDef.allowedProps )
			{
				if( ap == FrameDefinition.PT_PUSHER )
					this.form.rbtnPropPusher.setActive(true);
				else if( ap == FrameDefinition.PT_TRACTOR )
					this.form.rbtnPropTractor.setActive(true);
				else if( ap == FrameDefinition.PT_AUTOGYRO )
					this.form.rbtnPropHoplite.setActive(true);
				
				if( ap == lastProp )
					lastPropFound = true;
			}
			
			if( !lastPropFound )
				this.rbgProp.setValue(this.frameDef.allowedProps[0]);
			
			// btn setup
			var currBTN:int = this.form.numStepBaseTarget.getValue();
			var arrListBTN:Array = Globals.myAircraftConfigs.getBTNList();
			
			if( currBTN < this.frameDef.minBaseTarget )
				currBTN = this.frameDef.minBaseTarget;
			if( currBTN > this.frameDef.maxBaseTarget )
				currBTN = this.frameDef.maxBaseTarget;
					
			this.form.numStepBaseTarget.setupSteps(
					this.frameDef.minBaseTarget,
					this.frameDef.maxBaseTarget,
					currBTN,
					arrListBTN
				);
			
			// speed setup
			var currSpeed:int = this.form.numStepSpeed.getValue();
			
			if( currSpeed < this.frameDef.minSpeed )
				currSpeed = this.frameDef.minSpeed;
			if( currSpeed > this.frameDef.maxSpeed )
				currSpeed = this.frameDef.maxSpeed;
					
			this.form.numStepSpeed.setupSteps(
					this.frameDef.minSpeed,
					this.frameDef.maxSpeed,
					currSpeed,
					1
				);
			
			// Gs setup
			var currGs:int = this.form.numStepGs.getValue();
			this.form.numStepGs.setActive(true);
				
			if( currGs < this.frameDef.minGs )
				currGs = this.frameDef.minGs;
			if( currGs > this.frameDef.maxGs )
				currGs = this.frameDef.maxGs;
					
			this.form.numStepGs.setupSteps(
					this.frameDef.minGs,
					this.frameDef.maxGs,
					currGs,
					1
				);
			if( this.frameDef.minGs == this.frameDef.maxGs )
				this.form.numStepGs.setActive(false);
				
			// Accel setup
			var currAccel:int = this.form.numStepAccel.getValue();
			this.form.numStepAccel.setActive(true);
				
			if( currAccel < this.frameDef.minAccel )
				currAccel = this.frameDef.minAccel;
			if( currAccel > this.frameDef.maxAccel )
				currAccel = this.frameDef.maxAccel;
					
			this.form.numStepAccel.setupSteps(
					this.frameDef.minAccel,
					this.frameDef.maxAccel,
					currAccel,
					1
				);
			if( this.frameDef.minAccel == this.frameDef.maxAccel )
				this.form.numStepAccel.setActive(false);
			
			// Decel setup
			var currDecel:int = this.form.numStepDecel.getValue();
			this.form.numStepDecel.setActive(true);
				
			if( currDecel < this.frameDef.minDecel )
				currDecel = this.frameDef.minDecel;
			if( currDecel > this.frameDef.maxDecel )
				currDecel = this.frameDef.maxDecel;
					
			this.form.numStepDecel.setupSteps(
					this.frameDef.minDecel,
					this.frameDef.maxDecel,
					currDecel,
					1
				);
			if( this.frameDef.minDecel == this.frameDef.maxDecel )
				this.form.numStepDecel.setActive(false);
							
			// special characteristics
			this.form.page1.init(this);
			// weapons
			this.form.page2.init(this);
			//armor
			this.form.page3.init(this);
			//crew
			this.form.page4.init(this);
			//bombs cargo
			this.form.page5.init(this);
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		
		/**
		 * ---------------------------------------------------------------------
		 * importCadetHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function importCadetHandler(e:MouseEvent):void
		{
			// abort import if window contains unsaved data 
			// and the user wants to discard it.
			if( !this.getIsSaved() )
				if( !CSDialogs.changesNotSaved() )
					return;
			
			var file:String = AbstractCadetImporter.selectImportCadetFile(
					"Aircraft",
					"cdt"
				);
				
			if( file == "false" )
				return;
				
			var loader:BinaryLoader = new BinaryLoader(file);
			loader.addEventListener(
					Event.COMPLETE, 
					cadetLoadedHandler
				); 
			loader.load();	
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * cadetLoadedHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function cadetLoadedHandler(e:Event):void
		{
			var loader:BinaryLoader = BinaryLoader(e.currentTarget);
			var importer:AircraftImporter = new AircraftImporter(loader.getBytes());
			
			if ( !importer.parseBytes() )
			{
				AbstractCadetImporter.invalidFile(loader.getFilename());
				return;
			}
			this.fileWasUpdated = false;
			this.initFromAircraft(importer.getAircraft());
			// every import is unsaved.
			this.setSaved(false);
			
		}
		
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
			this.calcMaxAccelWeight();
			this.calcFreeWeight();
			this.calcCompleteCost();
				
			this.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * baseTargetChangedHandler
		 * ---------------------------------------------------------------------
		 * @param vc
		 */
		private function baseTargetChangedHandler(e:NumStepperValueChangedEvent):void
		{
			// for free sc
			this.form.page1.init(this);
			// for rocket Hardpoints
			this.form.page2.init(this);
				
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
		private function maxSpeedChangedHandler(e:NumStepperValueChangedEvent):void
		{
			this.calcMaxSpeedWeight();
			this.calcFreeWeight();
			this.calcCompleteCost();
			this.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * maxGChangedHandler
		 * ---------------------------------------------------------------------
		 * @param vc
		 */
		private function maxGChangedHandler(e:NumStepperValueChangedEvent):void
		{
			this.calcMaxGWeight();
			this.calcFreeWeight();
			this.calcCompleteCost();
			this.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * maxAccelChangedHandler
		 * ---------------------------------------------------------------------
		 * @param vc
		 */
		private function maxAccelChangedHandler(e:NumStepperValueChangedEvent):void
		{
			this.calcMaxAccelWeight();
			this.calcFreeWeight();
			this.calcCompleteCost();
			this.setSaved(false);
		}
	
	}
}