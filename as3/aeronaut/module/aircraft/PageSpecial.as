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
 * Copyright (c) 2009-2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.module.aircraft
{
	import mdm.*;
	
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.text.TextField;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	import as3.hv.core.net.ImageLoader;
	import as3.hv.core.utils.BitmapHelper;
	
	import as3.aeronaut.CSFormatter;
	import as3.aeronaut.CSDialogs;
	import as3.aeronaut.Globals;
	import as3.aeronaut.gui.*;
	
	import as3.aeronaut.module.CSWindowAircraft;
	import as3.aeronaut.module.ICSValidate;
	
	import as3.aeronaut.objects.Aircraft;	
	
	import as3.aeronaut.objects.BaseData;
	import as3.aeronaut.objects.baseData.SpecialCharacteristic;
	import as3.aeronaut.objects.aircraftConfigs.FrameDefinition;
	
	
	// =========================================================================
	// Class PageSpecial
	// =========================================================================
	// Aircraft Page 1 Special Characteristics
	//
	public class PageSpecial
			extends AbstractPage
			implements ICSValidate
	{
		
		// =====================================================================
		// Constants
		// =====================================================================
		public static const BLUEPRINT_WIDTH:int = 701;
		public static const BLUEPRINT_HEIGHT:int = 346;
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var winAircraft:CSWindowAircraft = null;
		private var isValid:Boolean = true;
		
		private var scLimit:int = 0;
		private var scFree:int = 0;
		
		private var intAdditionalCost:int = 0;
		private var fAirframeCostMod:Number = 0.00;
		private var fCockpitCostMod:Number = 0.00;
		private var fEngineCostMod:Number = 0.00;
		private var fArmorCostMod:Number = 0.00;
		private var fSpeedCostMod:Number = 0.00;
		private var fCompleteCostMod:Number = 0.00;
		
		private var intAdditionalWeight:int = 0;
		private var fCompleteWeightMod:Number = 0.00;
		
		private var myBlueprintLoader:ImageLoader = null;
		private var srcBlueprint:String = "";
		private var loadedBlueprintSrc:String = "";
		
		private var unfilteredSCs:Array;
				
		// =====================================================================
		// Constructor
		// =====================================================================
		public function PageSpecial()
		{
			super();
			
			this.pdSpecial.setEmptySelectionText("",false);
			this.unfilteredSCs = Globals.myBaseData.getSpecialCharacteristics();
			for( var i:int = 0; i < this.unfilteredSCs.length; i++ )
				this.pdSpecial.addSelectionItem(
						this.unfilteredSCs[i].myName, 
						this.unfilteredSCs[i].myID
					);
			
			this.btnAddSpecial.setupTooltip(
					Globals.myTooltip,
					"Add selected characteristic"
				);
			this.btnAddSpecial.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					addSpecialHandler
				); 
			this.lblBlueprint.text ="";
			
			this.btnImportBlueprint.setupTooltip(
					Globals.myTooltip,
					"Import a blueprint"
				);
			this.btnImportBlueprint.addEventListener(
					MouseEvent.MOUSE_DOWN,
					importBlueprintHandler
				);
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
			
			var updateList:Boolean = false;
			
			var obj:Aircraft =  Aircraft(this.winAircraft.getObject());
			var objS:SpecialCharacteristic = null;
			var arrSC:Array =obj.getSpecialCharacteristics();
			
			this.filterSCPulldown();
			this.listSpecial.clearList();
			
			this.scLimit = Globals.myAircraftConfigs.getBTNmaxSCByIndex(
					this.winAircraft.form.numStepBaseTarget.getValue()
				);
			this.scFree = this.scLimit;
			
			for( var i:int = 0; i< arrSC.length; i++ ) 
			{
				updateList = false;
				if( i == (arrSC.length-1) ) 
					updateList = true;
				
				if( arrSC[i].countsToLimit )
					this.scFree--;
				
				objS = Globals.myBaseData.getSpecialCharacteristic(arrSC[i]);
				
				this.createSCItem(
						arrSC[i],
						objS.myName,
						updateList
					);
			}
			this.lblSCLimit.text = String(this.scLimit);
			this.lblSCFree.text = String(this.scFree);
			
			// blueprint
			if( obj.getSrcFoto() != null ) 
			{
				this.srcBlueprint = obj.getSrcFoto();
			} else {
				this.srcBlueprint = "";
			}
			this.lblBlueprint.text = this.srcBlueprint;
			this.loadBlueprint();
		
			this.updateMultipleEngines();
			this.updateAmmoLinked();
			this.updateFireLinked();
			this.recalc(); 
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 */
		public function dispose():void
		{
			this.btnAddSpecial.removeEventListener(
					MouseEvent.MOUSE_DOWN, 
					addSpecialHandler
				); 
			this.btnImportBlueprint.removeEventListener(
					MouseEvent.MOUSE_DOWN,
					importBlueprintHandler
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * validateForm
		 * ---------------------------------------------------------------------
		 */
		public function validateForm():void
		{
			var arrSC:Array = this.listSpecial.getItemIDs()
			var sc:SpecialCharacteristic;			
			var arrFoundSCGroups:Array = new Array();
			var arrInvalidSCGroups:Array = new Array();
			var frame:String = this.winAircraft.getFrameType();
			
			var idxSCMultipleEngines:int = arrSC.indexOf(BaseData.HCID_SC_MULTIPLEENGINES);
			var idxSCHightorque:int = arrSC.indexOf(BaseData.HCID_SC_HIGHTORQUE);
			
			// check groups
			// invald groups are marked later
			for( var i:int = 0; i < arrSC.length; i++ )
			{
				sc = Globals.myBaseData.getSpecialCharacteristic(arrSC[i])
				if( sc.groupID != "" ) 
				{
					if( arrFoundSCGroups.indexOf(sc.groupID) == -1 )
					{
						// everything is valid
						arrFoundSCGroups.push(sc.groupID);
					} else if( arrInvalidSCGroups.indexOf(sc.groupID) == -1 ) {
						// double group id found but add only once
						arrInvalidSCGroups.push(sc.groupID);
					}
				}
			}
			
			//check
			var limitValid:Boolean = true;
			var groupsValid:Boolean = true;
			var multiEngineAndHighTValid:Boolean = true;
			var framesValid:Boolean = true;
			
			// check sc limit 12 - BTN
			if( Globals.myRuleConfigs.getIsMaxCharacteristicCheckActive() == true
					&& scFree < 0 )
				limitValid = false;
			// check double groups
			if( arrInvalidSCGroups.length > 0 )
				groupsValid = false;
			// check hightorque only single engine
			if( idxSCMultipleEngines != -1 && idxSCHightorque!= -1 )
				multiEngineAndHighTValid = false;
			
			// mark sc free label
			this.winAircraft.setTextFieldValid(this.lblSCFree, limitValid);
			
			// mark sc with invalid groups
			// or with wrong frametype
			for( i=0; i<arrSC.length; i++ )
			{
				sc = Globals.myBaseData.getSpecialCharacteristic(arrSC[i]);
				var groupID:String = sc.groupID;
				var groupIsInvalid:Boolean = false;
				var frameIsNotAllowed:Boolean = false;
				
				if( arrInvalidSCGroups.indexOf(sc.groupID) != -1 ) 
					groupIsInvalid = true;
				
				if( !this.checkSCAllowsFrame(sc,frame) )
				{
					frameIsNotAllowed = true;
					framesValid = true;
				}
				this.listSpecial.setItemIsInvalid(
						i,
						(groupIsInvalid || frameIsNotAllowed)
					);
			}
			// mark high torque + multiple engines
			if( idxSCMultipleEngines != -1 && idxSCHightorque!= -1 )
			{ 
				this.listSpecial.setItemIsInvalid(idxSCMultipleEngines,true);
				this.listSpecial.setItemIsInvalid(idxSCHightorque,true);
			}
			
			if( Console.isConsoleAvailable() )
			{
				Console.getInstance().writeln(
						"Page Special validate:"
							+ " limit="+limitValid
							+ " groups="+groupsValid
							+ " multi+ht="+multiEngineAndHighTValid
							+ " frames="+framesValid,
						DebugLevel.DEBUG
					);
			}
			// finally set valid
			this.setValid( limitValid 
					&& groupsValid 
					&& multiEngineAndHighTValid 
					&& framesValid
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setValid
		 * ---------------------------------------------------------------------
		 * @param v
		 */
		public function setValid(v:Boolean):void 
		{
			this.isValid = v;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getIsValid
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
			obj.setSpecialCharacteristics(this.listSpecial.getItemIDs());
			// Blueprint
			obj.setSrcFoto(this.srcBlueprint);
			
			return obj;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * checkSCAllowsFrame
		 * ---------------------------------------------------------------------
		 * check if a special characteristic can be used by the frame type.
		 *
		 * @param sc
		 * @param frame
		 *
		 * @return
		 */
		private function checkSCAllowsFrame(
				sc:SpecialCharacteristic,
				frame:String
			):Boolean
		{
			for each ( var af:String in sc.allowedFrames )
			{
				if( af == frame )
					return true;
			}
			return false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * filterSCPulldown
		 * ---------------------------------------------------------------------
		 * refreshes the special characteristics pulldown
		 */
		private function filterSCPulldown()
		{
			this.pdSpecial.clearSelection();
			this.pdSpecial.clearSelectionItemList();
			
			var frame:String = this.winAircraft.getFrameType();
			for( var i:int = 0; i < this.unfilteredSCs.length; i++ )
				if( this.checkSCAllowsFrame(this.unfilteredSCs[i],frame) )
					this.pdSpecial.addSelectionItem(
							this.unfilteredSCs[i].myName, 
							this.unfilteredSCs[i].myID
						);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateMultipleEngines
		 * ---------------------------------------------------------------------
		 */
		private function updateMultipleEngines():void
		{
			var arrSC:Array = this.listSpecial.getItemIDs();
			
			var isBC:Boolean = false;
			var frame:String = this.winAircraft.getFrameType();
			
			if( frame == FrameDefinition.FT_HEAVY_BOMBER 
					|| frame == FrameDefinition.FT_LIGHT_BOMBER 
					|| frame == FrameDefinition.FT_HEAVY_CARGO 
					|| frame == FrameDefinition.FT_LIGHT_CARGO 
				)
				isBC = true;
			
			if( arrSC.indexOf(BaseData.HCID_SC_MULTIPLEENGINES) != -1 || isBC ) 
			{
				this.winAircraft.setMultipleEngines(true);
			} else {
				this.winAircraft.setMultipleEngines(false);
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateAmmoLinked
		 * ---------------------------------------------------------------------
		 */
		private function updateAmmoLinked():void
		{
			var arrSC:Array = this.listSpecial.getItemIDs()
			if( arrSC.indexOf(BaseData.HCID_SC_LINKEDAMMO) != -1 ) 
			{
				this.winAircraft.setAmmoLinked(true);
			} else {
				this.winAircraft.setAmmoLinked(false);
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateFireLinked
		 * ---------------------------------------------------------------------
		 */
		private function updateFireLinked():void
		{
			var arrSC:Array = this.listSpecial.getItemIDs()
			if( arrSC.indexOf(BaseData.HCID_SC_LINKEDFIRE) != -1 ) 
			{
				this.winAircraft.setFireLinked(true);
			} else {
				this.winAircraft.setFireLinked(false);
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getAdditionalCost
		 * ---------------------------------------------------------------------
		 * @param
		 */
		public function getAdditionalCost():int
		{
			return this.intAdditionalCost;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getAdditionalWeight
		 * ---------------------------------------------------------------------
		 * @param
		 */
		public function getAdditionalWeight():int
		{
			return this.intAdditionalWeight;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getAirframeCostMod
		 * ---------------------------------------------------------------------
		 * @param
		 */
		public function getAirframeCostMod():Number
		{
			return this.fAirframeCostMod;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getCockpitCostMod
		 * ---------------------------------------------------------------------
		 * @param
		 */
		public function getCockpitCostMod():Number
		{
			return this.fCockpitCostMod;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getEngineCostMod
		 * ---------------------------------------------------------------------
		 * @param
		 */
		public function getEngineCostMod():Number
		{
			return this.fEngineCostMod;
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * getArmorCostMod
		 * ---------------------------------------------------------------------
		 * @param
		 */
		public function getArmorCostMod():Number
		{
			return this.fArmorCostMod;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSpeedCostMod
		 * ---------------------------------------------------------------------
		 * @param
		 */
		public function getSpeedCostMod():Number
		{
			return this.fSpeedCostMod;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getCompleteCostMod
		 * ---------------------------------------------------------------------
		 * @param
		 */
		public function getCompleteCostMod():Number
		{
			return this.fCompleteCostMod;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getCompleteWeightMod
		 * ---------------------------------------------------------------------
		 * @param
		 */
		public function getCompleteWeightMod():Number
		{
			return this.fCompleteWeightMod;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * recalc
		 * ---------------------------------------------------------------------
		 * recalculates modifiers and additional cost/weight from
		 * special characteristics
		 * 
		 * Note:
		 * the cost/weight for ammo-/firelinked weapons is done in weapons page
		 */
		public function recalc():void
		{
			var objSC:SpecialCharacteristic = null;
			this.intAdditionalCost = 0;
			this.intAdditionalWeight = 0;
			this.fAirframeCostMod = 0.00;
			this.fCockpitCostMod = 0.00;
			this.fEngineCostMod = 0.00;
			this.fArmorCostMod = 0.00;
			this.fCompleteCostMod = 0.00;
			this.fSpeedCostMod = 0.00;
			this.fCompleteWeightMod = 0.00;
			
			
			var arrSC:Array = this.listSpecial.getItemIDs()
			for( var i:int = 0; i < arrSC.length; i++ )
			{
				objSC = Globals.myBaseData.getSpecialCharacteristic(arrSC[i]);
				// costs
				for( var j:int=0; j< objSC.costType.length; j++ ) 
				{
					if( objSC.costType[j] == SpecialCharacteristic.CT_AIRFRAME ) 
					{
						this.fAirframeCostMod += objSC.costChanges * 100;
						
					} else if( objSC.costType[j] == SpecialCharacteristic.CT_COCKPIT ) {
						this.fCockpitCostMod += objSC.costChanges * 100;
						
					} else if( objSC.costType[j] == SpecialCharacteristic.CT_ENGINE ) {
						this.fEngineCostMod += objSC.costChanges * 100;
						
					} else if( objSC.costType[j] == SpecialCharacteristic.CT_ARMOR ) {
						this.fArmorCostMod += objSC.costChanges * 100;
						
					} else if( objSC.costType[j] == SpecialCharacteristic.CT_ADDITIONAL ) {
						this.intAdditionalCost += int(objSC.costChanges);
					
					} else if( objSC.costType[j] == SpecialCharacteristic.CT_COMPLETE ) {
						this.fCompleteCostMod += objSC.costChanges * 100;
					
					} else if( objSC.costType[j] == SpecialCharacteristic.CT_SPEED ) {
						this.fSpeedCostMod += objSC.costChanges * 100;
					} 
				}
				//weight
				for( var k:int=0; k< objSC.weightType.length; k++ ) 
				{
					if( objSC.weightType[k] == SpecialCharacteristic.WT_ADDITIONAL ) 
					{
						this.intAdditionalWeight += int(objSC.weightChanges);
					
					} else if( objSC.weightType[k] == SpecialCharacteristic.WT_COMPLETE ) {
						this.fCompleteWeightMod += objSC.weightChanges * 100;
					}
				}
			}
			// Note: this is done to avoid a floating point problem.
			this.fAirframeCostMod /= 100;
			this.fCockpitCostMod /= 100;
			this.fEngineCostMod /= 100;
			this.fArmorCostMod /= 100;
			this.fCompleteCostMod /= 100;
			this.fSpeedCostMod /= 100;
			this.fCompleteWeightMod /= 100;
			
			// update labels
			this.winAircraft.form.lblCostAdditional.text = 
					CSFormatter.formatDollar(this.intAdditionalCost);
			this.lblAdditionalWeight.text = 
					CSFormatter.formatLbs(this.intAdditionalWeight);
			this.lblAirframeCostMod.text = String(fAirframeCostMod);
			this.lblCockpitCostMod.text = String(fCockpitCostMod);
			this.lblEngineCostMod.text = String(fEngineCostMod);
			this.lblArmorCostMod.text = String(fArmorCostMod);
			this.lblSpeedCostMod.text = String(fSpeedCostMod);
			this.lblCompleteCostMod.text = String(fCompleteCostMod);
			this.lblCompleteWeightMod.text = String(fCompleteWeightMod);
			
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * loadBlueprint
		 * ---------------------------------------------------------------------
		 */
		private function loadBlueprint():void
		{
			var src:String = this.srcBlueprint;
			if( src == "" )
				src = "default.jpg";
			
			src = mdm.Application.path
					+ Globals.PATH_IMAGES
					+ Globals.PATH_AIRCRAFT 
					+ Globals.PATH_BLUEPRINT
					+ src;
						
			// prevent multiple reloads during frame changes
			if( src == this.loadedBlueprintSrc )
				return;
			
			// cleanup
			while( this.winAircraft.form.blueprintContainer.numChildren > 0 ) 
				this.winAircraft.form.blueprintContainer.removeChildAt(0);
			
			this.myBlueprintLoader = new ImageLoader( src );
			this.myBlueprintLoader.addEventListener(
					Event.COMPLETE, 
					blueprintLoadedHandler
				); 
			this.myBlueprintLoader.load();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * createSCItem
		 * ---------------------------------------------------------------------
		 * create a new listitem and adds it to the list
		 *
		 * @param id
		 * @param name
		 * @param removable
		 * @param updateList
		 */
		public function createSCItem(
				id:String,
				name:String,
				updateList:Boolean
			):void
		{
			var item:ListItem150 = new ListItem150();
			item.setStyle(CSStyle.WHITE);
			item.setupBaseParams(
					id,
					name,
					true
				);
			this.listSpecial.addItem(item, updateList);
			this.listSpecial.addRemoveListenerToItem(
					this.listSpecial.getCountOfItems()-1,
					MouseEvent.MOUSE_DOWN, 
					removeSpecialHandler
				);
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * importBlueprintHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function importBlueprintHandler(e:MouseEvent):void
		{
			var selectedFile = CSDialogs.selectImportImage("Blueprint");
			
			if( selectedFile == "false" )
				return;
				
			var srcDir = selectedFile.substring(0,selectedFile.lastIndexOf("\\"));
			var filename = selectedFile.substring(
					selectedFile.lastIndexOf("\\")+1,
					selectedFile.length
				);
			var destDir = mdm.Application.path 
					+ Globals.PATH_IMAGES
					+ Globals.PATH_AIRCRAFT
					+ Globals.PATH_BLUEPRINT;
			var destFile = destDir + filename;
				
			Globals.lastSelectedImportDir = srcDir;
				
			if( !CSDialogs.fileExitsNotOrOverwrite(destFile) )  
				return;
			
			//final fail save to prevent deadlock
			if( selectedFile == destFile )
				return;
			
			mdm.FileSystem.copyFile(selectedFile, destFile);
			this.lblBlueprint.text = filename;
			this.srcBlueprint = filename;
					
			this.loadBlueprint();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * blueprintLoadedHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function blueprintLoadedHandler(e:Event):void
		{
			var bmp:Bitmap = this.myBlueprintLoader.getImage();
			bmp = BitmapHelper.resizeBitmap(
					bmp,
					BLUEPRINT_WIDTH, 
					BLUEPRINT_HEIGHT, 
					true
				);
			// store to prevent unnecessary reloading
			this.loadedBlueprintSrc = this.myBlueprintLoader.getFilename();
			this.winAircraft.form.blueprintContainer.addChild(bmp);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * addSpecialHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function addSpecialHandler(e:MouseEvent):void
		{
			var specialID:String = this.pdSpecial.getIDForCurrentSelection();
			
			if( specialID == CSPullDown.ID_EMPTYSELECTION ) 
				return;
			
			var obj:SpecialCharacteristic = 
					Globals.myBaseData.getSpecialCharacteristic(specialID);
			
			if( obj.countsToLimit )
				this.scFree--;				
			
			this.lblSCFree.text = String(this.scFree);
			
			this.createSCItem(
					specialID,
					obj.myName,
					true
				);
				
			this.updateMultipleEngines();
			this.updateAmmoLinked();
			this.updateFireLinked();
			this.recalc();
			this.winAircraft.form.page3.recalc();
			
			this.winAircraft.calcFreeWeight();
			this.winAircraft.calcEngineCost();
			this.winAircraft.calcAirframeCost();
			this.winAircraft.calcCockpitCost();
			this.winAircraft.calcCompleteCost();
			
			this.pdSpecial.clearSelection();
			this.winAircraft.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * removeSpecialHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function removeSpecialHandler(e:MouseEvent):void
		{
			var itemID:String = CSListItem(e.currentTarget.parent).getID();
			this.listSpecial.removeItem(itemID);
			
			var obj:SpecialCharacteristic = 
					Globals.myBaseData.getSpecialCharacteristic(itemID);
			
			if( obj.countsToLimit )
				this.scFree++;				
			
			this.lblSCFree.text = String(this.scFree);
			
			this.updateMultipleEngines();
			this.updateAmmoLinked();
			this.updateFireLinked();
			this.recalc();
			this.winAircraft.form.page3.recalc();
			
			this.winAircraft.calcFreeWeight();
			this.winAircraft.calcEngineCost();
			this.winAircraft.calcAirframeCost();
			this.winAircraft.calcCockpitCost();
			this.winAircraft.calcCompleteCost();
			
			this.winAircraft.setSaved(false);
		}
	
	}
}