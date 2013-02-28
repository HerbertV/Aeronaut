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
	import mdm.*;
	
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.text.TextField;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
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
		private var intAdditionalWeight:int = 0;
		private var fAirframeMod:Number = 0.00;
		private var fCockpitMod:Number = 0.00;
		private var fEngineMod:Number = 0.00;
		private var fArmorMod:Number = 0.00;
		
		private var myBlueprintLoader:ImageLoader = null;
		private var srcBlueprint:String = "";
		private var loadedBlueprintSrc:String = "";
				
		// =====================================================================
		// Constructor
		// =====================================================================
		public function PageSpecial()
		{
			super();
			
			this.pdSpecial.setEmptySelectionText("",false);
// TODO add filter by frame			
			var arrSc:Array = Globals.myBaseData.getSpecialCharacteristics();
			for( var i:int = 0; i < arrSc.length; i++ )
				this.pdSpecial.addSelectionItem(
						arrSc[i].myName, 
						arrSc[i].myID
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
			var groupID:String = "";
			var arrSC:Array = this.listSpecial.getItemIDs()
			
			var arrFoundSCGroups:Array = new Array();
			var arrInvalidSCGroups:Array = new Array();
			
			var idxSCMultipleEngines:int = arrSC.indexOf(BaseData.HCID_SC_MULTIPLEENGINES);
			var idxSCHightorque:int = arrSC.indexOf(BaseData.HCID_SC_HIGHTORQUE);
			
			// check groups first 
			for( var i:int = 0; i < arrSC.length; i++ )
			{
				groupID = Globals.myBaseData.getSpecialCharacteristic(arrSC[i]).groupID;
				if( groupID != "" ) 
				{
					if( arrFoundSCGroups.indexOf(groupID) == -1 )
					{
						// everything is valid
						arrFoundSCGroups.push(groupID);
					} else if( arrInvalidSCGroups.indexOf(groupID) == -1 ) {
						// double group id found but add only once
						arrInvalidSCGroups.push(groupID);
					}
				}
			}
			
			//check
			var limitValid:Boolean = true;
			var groupsValid:Boolean = true;
			var multiEngineAndHighTValid:Boolean = true;
			
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
			
			// mark sc
			for( i=0; i<arrSC.length; i++ )
			{
				groupID = Globals.myBaseData.getSpecialCharacteristic(arrSC[i]).groupID;
				if( arrInvalidSCGroups.indexOf(groupID) != -1 ) 
				{
					this.listSpecial.setItemIsInvalid(i,true);
				} else {
					this.listSpecial.setItemIsInvalid(i,false);
				}
			}
			// mark high torque + multiple engines
			if( idxSCMultipleEngines != -1 && idxSCHightorque!= -1 )
			{ 
				this.listSpecial.setItemIsInvalid(idxSCMultipleEngines,true);
				this.listSpecial.setItemIsInvalid(idxSCHightorque,true);
			}
			// finally set valid
			this.setValid( limitValid 
					&& groupsValid 
					&& multiEngineAndHighTValid 
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
		 * updateMultipleEngines
		 * ---------------------------------------------------------------------
		 */
		private function updateMultipleEngines():void
		{
			var arrSC:Array = this.listSpecial.getItemIDs()
// TODO bombers and cargos always multiple engines 2 to 6 
			
			if( arrSC.indexOf(BaseData.HCID_SC_MULTIPLEENGINES) != -1 ) 
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
			return this.fAirframeMod;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getCockpitCostMod
		 * ---------------------------------------------------------------------
		 * @param
		 */
		public function getCockpitCostMod():Number
		{
			return this.fCockpitMod;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getEngineCostMod
		 * ---------------------------------------------------------------------
		 * @param
		 */
		public function getEngineCostMod():Number
		{
			return this.fEngineMod;
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * getArmorCostMod
		 * ---------------------------------------------------------------------
		 * @param
		 */
		public function getArmorCostMod():Number
		{
			return this.fArmorMod;
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
// TODO add new cost and weight types
			this.intAdditionalCost = 0;
			this.intAdditionalWeight = 0;
			this.fAirframeMod = 0.00;
			this.fCockpitMod = 0.00;
			this.fEngineMod = 0.00;
			this.fArmorMod = 0.00;
			
			var arrSC:Array = this.listSpecial.getItemIDs()
			for( var i:int = 0; i < arrSC.length; i++ )
			{
				objSC = Globals.myBaseData.getSpecialCharacteristic(arrSC[i]);
				for( var j:int=0; j< objSC.costType.length; j++ ) 
				{
					if( objSC.costType[j] == SpecialCharacteristic.CT_AIRFRAME ) 
					{
						this.fAirframeMod += objSC.costChanges * 100;
						
					} else if( objSC.costType[j] == SpecialCharacteristic.CT_COCKPIT ) {
						this.fCockpitMod += objSC.costChanges * 100;
						
					} else if( objSC.costType[j] == SpecialCharacteristic.CT_ENGINE ) {
						this.fEngineMod += objSC.costChanges * 100;
						
					} else if( objSC.costType[j] == SpecialCharacteristic.CT_ARMOR ) {
						this.fArmorMod += objSC.costChanges * 100;
						
					} else if( objSC.costType[j] == SpecialCharacteristic.CT_ADDITIONAL ) {
						this.intAdditionalCost += int(objSC.costChanges);
						this.intAdditionalWeight += int(objSC.weightChanges);
					} 
				}
			}
			// Note: this is done to avoid a floating point problem.
			this.fAirframeMod /= 100;
			this.fCockpitMod /= 100;
			this.fEngineMod /= 100;
			this.fArmorMod /= 100;
			
			// update labels
			this.winAircraft.form.lblCostAdditional.text = 
					CSFormatter.formatDollar(this.intAdditionalCost);
			this.lblAdditionalWeight.text = 
					CSFormatter.formatLbs(this.intAdditionalWeight);
			this.lblAirframeCostMod.text = String(fAirframeMod);
			this.lblCockpitCostMod.text = String(fCockpitMod);
			this.lblEngineCostMod.text = String(fEngineMod);
			this.lblArmorCostMod.text = String(fArmorMod);
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
			var bmp:Bitmap =this.myBlueprintLoader.getImage();
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