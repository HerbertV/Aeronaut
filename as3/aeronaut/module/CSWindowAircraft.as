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
	
	import as3.aeronaut.objects.FileList;
	import as3.aeronaut.objects.Aircraft;	
	import as3.aeronaut.objects.aircraft.*;
	import as3.aeronaut.objects.ICSBaseObject;
	
	import as3.aeronaut.gui.*;
	
	import as3.aeronaut.module.aircraft.*;
	
	import as3.aeronaut.print.IPrintable;
	import as3.aeronaut.print.PrintManager;
	
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
// TODO page 5 for Z&B
			
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
//TODO add page 5
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
					var arrFLLoadout:Array = FileList.generateFilteredLoadouts(
							Globals.PATH_DATA + Globals.PATH_LOADOUT,
							this.getFilename()
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
			
			this.intLoadedWeight = Aircraft.BTN_WEIGHT_MATRIX[currBTN-1][0];
			this.intPayload = Aircraft.BTN_WEIGHT_MATRIX[currBTN-1][1];
			
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
			intMaxSpeedWeight = Aircraft.MAXSPEED_WEIGHT_MATRIX[currBTN-1][speed-1];
			
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
			intMaxGWeight = Aircraft.MAXG_WEIGHT_MATRIX[currBTN-1][gs-1];
			
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
			intMaxAccelWeight = Aircraft.MAXACCEL_WEIGHT_MATRIX[currBTN-1][accel-1];
			
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
			// weapons
			this.form.page2.init(this);
			//armor
			this.form.page3.init(this);
			//crew
			this.form.page4.init(this);
// TODO init page 5			
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
		 * @param o
		 */
		private function baseTargetChangedHandler(o:Object):void
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
		 * @param o
		 */
		private function maxSpeedChangedHandler(o:Object):void
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
		 * @param o
		 */
		private function maxGChangedHandler(o:Object):void
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
		 * @param o
		 */
		private function maxAccelChangedHandler(o:Object):void
		{
			this.calcMaxAccelWeight();
			this.calcFreeWeight();
			this.calcCompleteCost();
			this.setSaved(false);
		}
	
	}
}