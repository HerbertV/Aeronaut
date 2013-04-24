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
	import flash.display.DisplayObject;
	import flash.text.TextField;
	
	import flash.events.MouseEvent;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.CSWindowManager;
	import as3.aeronaut.CSFormatter;
	
	import as3.aeronaut.gui.CSStyle;
	import as3.aeronaut.gui.CSPullDown;
	import as3.aeronaut.gui.PageButtonController;
	
	import as3.aeronaut.objects.FileList;
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.BaseData;
	import as3.aeronaut.objects.baseData.Gun;
	import as3.aeronaut.objects.baseData.Rocket;
	import as3.aeronaut.objects.Loadout;	
	import as3.aeronaut.objects.loadout.GunAmmo;	
	import as3.aeronaut.objects.loadout.RocketLoadout;	
	import as3.aeronaut.objects.Aircraft;	
	import as3.aeronaut.objects.aircraft.Gunpoint;
	import as3.aeronaut.objects.aircraftConfigs.FrameDefinition;
		
	// =========================================================================
	// CSWindowLoadout
	// =========================================================================
	// This class is a linked document class for "winLoadout.swf"
	// @see as3.aeronaut.objects.Loadout
	//
	// Window for creating/editing Loadouts.
	//
	public class CSWindowLoadout 
			extends CSWindow 
			implements ICSWindowLoadout, ICSValidate
	{
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var pbtnController:PageButtonController = null;
		
		private var isSaved:Boolean = true;
		private var isValid:Boolean = true;
		
		private var myObject:Loadout = null;
		private var myAircraft:Aircraft = null;
		
		// becomes true if file was updated after loading
		private var fileWasUpdated:Boolean = false;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function CSWindowLoadout()
		{
			super();
			
			// positions
			this.posStartX = 220;
			this.posStartY = -610;
			
			this.posOpenX = 220;
			this.posOpenY = 72;
			
			this.posMinimizedX = 1245;
			
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
			this.setStyle(CSStyle.BLACK);
			
			this.pbtnController = new PageButtonController();
			this.pbtnController.addPage(this.form.btnPage1,this.form.page1);
			this.pbtnController.addPage(this.form.btnPage2,this.form.page2);
			this.pbtnController.addPage(this.form.btnPage3,this.form.page3);
			this.pbtnController.setActivePage(0);
			
			this.form.page1.resetAllGuns();
			this.form.btnPage2.setActive(false);
			this.form.btnPage3.setActive(false);
			
			// AIRCRAFT Selector
			this.form.pdAircraft.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					aircraftChangedHandler
				); 
			
			this.form.lblCost.text = "0 $";
			
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
			this.form.page1.dispose();
			this.form.page2.dispose();
			this.form.page3.dispose();
			
			this.form.pdAircraft.removeEventListener(
					MouseEvent.MOUSE_DOWN, 
					aircraftChangedHandler
				); 
			this.form.pdAircraft.clearSelectionItemList();
			
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
			var obj:Loadout = new Loadout();
			obj.loadFile(fn);
			this.fileWasUpdated = obj.updateVersion();
			this.initFromLoadout(obj);
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
			var obj:Loadout = new Loadout();
			obj.createNew();
			this.fileWasUpdated = false;
			this.initFromLoadout(obj);
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
			if( obj is Loadout )
				this.initFromLoadout( Loadout(obj) );
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromLoadout
		 * ---------------------------------------------------------------------
		 * @see ICSWindowLoadout
		 * @param obj
		 */
		public function initFromLoadout(obj:Loadout):void
		{
			this.setSaved(true);
			this.setValid(true);
			
			if( this.fileWasUpdated )
				this.setSaved(false);
			
			this.myObject = obj;
			
			// name
			this.form.txtName.text = this.myObject.getName();

			// aircraft link
			if( this.myObject.getSrcAircraft() != "" ) 
			{
				this.form.pdAircraft.setActiveSelectionItem(
						this.myObject.getSrcAircraft()
					);
				this.loadAircraft(this.myObject.getSrcAircraft());
				this.updateUIByAircraft();
			}
			// costs
			this.calcCosts();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateObjectFromWindow
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 */
		public function updateObjectFromWindow():void
		{
			var id:String = "";
			
			// name
			this.myObject.setName(this.form.txtName.text);
			
			// aircraft linking
			id = this.form.pdAircraft.getIDForCurrentSelection();
// TODO store relative sub folders
			if( id != CSPullDown.ID_EMPTYSELECTION ) 
			{
				this.myObject.setSrcAircraft(id);
			} else{
				this.myObject.setSrcAircraft("");
			}
			
			// ammunition
			this.myObject = this.form.page1.updateObjectFromWindow();
			this.myObject = this.form.page2.updateObjectFromWindow();
			this.myObject = this.form.page3.updateObjectFromWindow();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateDirLists
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 */
		public function updateDirLists():void
		{
			this.form.pdAircraft.clearSelectionItemList();
			this.form.pdAircraft.setEmptySelectionText(
					"Choose an Aircraft",
					false
				);
			
			var flAircraft:Array = FileList.generate(
					Globals.PATH_DATA + Globals.PATH_AIRCRAFT
				);

			for( var i:int=0; i< flAircraft.length; i++ ) 
				this.form.pdAircraft.addSelectionItem(
						flAircraft[i].viewname,
						flAircraft[i].filename
					); 
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
		 * getAircraft
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getAircraft():Aircraft
		{
			return this.myAircraft;
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
			return "Loadout";
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
			return CSWindowManager.WND_LOADOUT;
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
			return Globals.PATH_LOADOUT;
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
			
			this.setValid( this.form.page1.getIsValid()
					&& this.form.page2.getIsValid()
					&& this.form.page3.getIsValid()
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
		 * loadAircraft
		 * ---------------------------------------------------------------------
		 * @param filename
		 */
		private function loadAircraft(filename:String):void
		{
			if( filename == "" )
				return;
				
			var file:String = mdm.Application.path
					+ Globals.PATH_DATA 
					+ Globals.PATH_AIRCRAFT 
					+ filename;
			this.myAircraft = new Aircraft();
			this.myAircraft.loadFile(file);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateUIByAircraft
		 * ---------------------------------------------------------------------
		 */
		private function updateUIByAircraft():void
		{
			this.form.btnPage1.setActive(true);
			this.form.btnPage2.setActive(false);
			this.form.btnPage3.setActive(false);
			this.pbtnController.setActivePage(0);
			
			this.form.page1.init(this);
			this.form.page2.init(this);
			this.form.page3.init(this);
			
			if( this.myAircraft == null ) 
				return;
			
			var frameType:String = this.myAircraft.getFrameType();
			
			
			if( frameType == FrameDefinition.FT_LIGHT_BOMBER
					|| frameType == FrameDefinition.FT_HEAVY_BOMBER
				)
			{
				this.form.btnPage3.setActive(true);
			} 
			
			if( frameType == FrameDefinition.FT_AUTOGYRO
					|| frameType == FrameDefinition.FT_FIGHTER
					|| frameType == FrameDefinition.FT_HEAVY_FIGHTER
				)
			{
				this.form.btnPage2.setActive(true);
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcCosts
		 * ---------------------------------------------------------------------
		 * sums up the ammo and rocket costs
		 */
		public function calcCosts() 
		{
			this.form.lblCost.text = CSFormatter.formatDollar(
					this.form.page1.getCost()
						+ this.form.page2.getCost()
						+ this.form.page3.getCost()
				);
		}
		
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * aircraftChangedHandler
		 * ---------------------------------------------------------------------
		 * eventhandler for aircraft selector
		 *
		 * @param e
		 */
		private function aircraftChangedHandler(e:MouseEvent):void
		{
			// in this case the id is the filename
			var file:String = this.form.pdAircraft.getIDForCurrentSelection();
			if( file == CSPullDown.ID_EMPTYSELECTION) 
				return;
				
			this.setSaved(false);
				
			this.loadAircraft(file);
			this.updateUIByAircraft();
		}
	
	}
}