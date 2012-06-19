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
		
	// =========================================================================
	// CSWindowLoadout
	// =========================================================================
	// This class is a linked document class for "winLoadout.swf"
	// @see as3.aeronaut.objects.Loadout
	//
	// Window for crating/editing Loadouts.
	//
	public class CSWindowLoadout 
			extends CSWindow 
			implements ICSWindowLoadout, ICSValidate
	{
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var isSaved:Boolean = true;
		private var isValid:Boolean = true;
		
		private var myObject:Loadout = null;
		private var myAircraft:Aircraft = null;
		
		private var intFreeHardpoints:int = 0;
		private var intAmmoCost:int = 0;
		private var intRocketCost:int = 0;
		
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
			
			// ROCKETS
			var arrRock:Array = Globals.myBaseData.getRockets();
			// init 8 slots
			for( var slot:int = 1; slot < 9; slot++ )
			{
				var pdA:CSPullDown = this.getRocketPullDown(slot,"a");
				var pdB:CSPullDown = this.getRocketPullDown(slot,"b");
				pdA.setEmptySelectionText("",true);
				pdB.setEmptySelectionText("",true);
				
				if( slot > 4 )
				{
					pdA.setMaxVisibleItems(7);
					pdB.setMaxVisibleItems(7);
				}
				pdB.setActive(false);
			
				for( var i:int = 0; i < arrRock.length; i++ ) 
				{
					pdA.addSelectionItem(
							arrRock[i].longName, 
							arrRock[i].myID
						);
					
					if( arrRock[i].slots == 1 
							&& arrRock[i].usesPerSlot > 1 ) 
						pdB.addSelectionItem(
								arrRock[i].longName, 
								arrRock[i].myID
							);
				}
				pdA.addEventListener(
						MouseEvent.MOUSE_DOWN, 
						rocketChangedHandler
					);
				pdB.addEventListener(
						MouseEvent.MOUSE_DOWN, 
						rocketChangedHandler
					);
			}
			
			// GUN AMMUNITION
			// add eventlissteners
			for( var gnum:int = 1; gnum < 9; gnum++ )
			{
				var pdG:CSPullDown = this.getAmmoPullDown(gnum);
				pdG.addEventListener(
						MouseEvent.MOUSE_DOWN, 
						ammoChangedHandler
					);
			}
			
			// AIRCRAFT Selector
			this.form.pdAircraft.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					aircraftChangedHandler
				); 
			
			this.form.lblHardpoints.text = "0";
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
			for( var slot:int = 1; slot < 9; slot++ )
			{
				var pdA:CSPullDown = this.getRocketPullDown(slot,"a");
				var pdB:CSPullDown = this.getRocketPullDown(slot,"b");
				
				pdA.removeEventListener(
						MouseEvent.MOUSE_DOWN, 
						rocketChangedHandler
					);
				pdB.removeEventListener(
						MouseEvent.MOUSE_DOWN, 
						rocketChangedHandler
					);
					
				pdA.clearSelectionItemList();
				pdB.clearSelectionItemList();
			}
			
			for( var gnum:int = 1; gnum < 9; gnum++ )
			{
				var pdG:CSPullDown = this.getAmmoPullDown(gnum);
				pdG.removeEventListener(
						MouseEvent.MOUSE_DOWN, 
						ammoChangedHandler
					);
				pdG.clearSelectionItemList();
			}
			
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
			this.myObject = obj;
			
			// name
			this.form.txtName.text = this.myObject.getName();

			this.resetAllGuns();
			// aircraft link
			if( this.myObject.getSrcAircraft() != "" ) 
			{
				this.form.pdAircraft.setActiveSelectionItem(
						this.myObject.getSrcAircraft()
					);
				this.loadAircraft(this.myObject.getSrcAircraft());
				this.updateUIByAircraft();
			}
			
			var i:int = 0;
			// ammunition
			var arr:Array = this.myObject.getGunAmmos();
			for( i = 0; i < arr.length; i++ ) 
			{
				var pdG:CSPullDown = this.getAmmoPullDown(arr[i].gunPointNumber);
				pdG.setActiveSelectionItem(arr[i].ammoID);
			}
			// rockets
			arr = this.myObject.getRocketLoadouts();
			for( i = 0; i < arr.length; i++ ) 
			{
				var pdA:CSPullDown = this.getRocketPullDown(arr[i].slotNumber,"a");
				var pdB:CSPullDown = this.getRocketPullDown(arr[i].slotNumber,"b");
				
				if( arr[i].subSlot < 2 ) 
				{
					// sub slot = 0,1 
					pdA.setActiveSelectionItem(arr[i].rocketID);				
				} else {
					// sub slot = 2
					var t:String = Globals.myBaseData.getRocket(arr[i].rocketID).type
					if( t != Rocket.TYPE_RELOADABLE) 
						pdB.setActive(true);
					
					pdB.setActiveSelectionItem(arr[i].rocketID);
				}
			}
			this.updateFreeHardpoints();
			// costs
			this.calcAmmoCosts();
			this.calcRocketCosts();
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
			if( id != CSPullDown.ID_EMPTYSELECTION ) 
			{
				this.myObject.setSrcAircraft(id);
			} else{
				this.myObject.setSrcAircraft("");
			}
			
			// ammunition
			var arr:Array = new Array();
			for( var gnum:int = 1; gnum < 9; gnum++ )
			{
				id = this.getAmmoPullDown(gnum).getIDForCurrentSelection();
				if( id == CSPullDown.ID_EMPTYSELECTION ) 
					continue;
			
				var ga:GunAmmo = new GunAmmo(gnum, id);
				arr.push(ga);
			}
			this.myObject.setGunAmmos(arr);
			
			//rockets
			arr = new Array();
			for( var slot:int = 1; slot < 9; slot++ )
			{
				var pdA:CSPullDown = this.getRocketPullDown(slot,"a");
				var pdB:CSPullDown = this.getRocketPullDown(slot,"b");
				var subslot:int = 0;
				var rl:RocketLoadout = null;
			
				// slot a
				id = pdA.getIDForCurrentSelection();
				if( id != CSPullDown.ID_EMPTYSELECTION )
				{				
					if( Globals.myBaseData.getRocket(id).usesPerSlot > 1 )
						subslot = 1;
					rl = new RocketLoadout(slot, subslot, id);
					arr.push(rl);
				}
				// slot b
				id = pdB.getIDForCurrentSelection();
				if( id != CSPullDown.ID_EMPTYSELECTION ) 
				{
					rl = new RocketLoadout(slot,2,id);
					arr.push(rl);
				}
			}
			this.myObject.setRocketLoadouts(arr);
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
			this.setValid(true);
			
			if( this.intFreeHardpoints < 0 ) 
				this.setValid(false);
			
			this.setTextFieldValid( this.form.lblHardpoints, this.isValid );
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
		 * getRocketPullDown
		 * ---------------------------------------------------------------------
		 *
		 * @param slot 1-8
		 * @param subslot a or b
		 * @return
		 */
		private function getRocketPullDown(
				slot:uint,
				subslot:String
			):CSPullDown
		{
			return CSPullDown(
					this.form.getChildByName("pdRocket"+slot+subslot)
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getRocketBSlotPullDown
		 * ---------------------------------------------------------------------
		 * get linkend rocket B-Slot pulldown.
		 *
		 * @param pd an A-Slot pulldown
		 * @return
		 */
		private function getRocketBSlotPullDown(pd:CSPullDown):CSPullDown
		{
			var pdBname:String = pd.name.substring(0,pd.name.length-1) + "b";
			return CSPullDown(
					this.form.getChildByName(pdBname)
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getAmmoPullDown
		 * ---------------------------------------------------------------------
		 *
		 * @param slot 1-8
		 * @return
		 */
		private function getAmmoPullDown(
				slot:uint
			):CSPullDown
		{
			return CSPullDown(
					this.form.getChildByName("pdGun"+slot+"Ammo")
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getCalLabel
		 * ---------------------------------------------------------------------
		 *
		 * @param slot 1-8
		 * @return
		 */
		private function getCalLabel(
				slot:uint
			):TextField
		{
			return TextField(
					this.form.getChildByName("lblGun"+slot+"Caliber")
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * resetAllGuns
		 * ---------------------------------------------------------------------
		 */
		private function resetAllGuns():void
		{
			for( var slot:int = 1; slot < 9; slot++ )
			{
				var pdG:CSPullDown = this.getAmmoPullDown(slot);
				pdG.clearSelection();
				pdG.clearSelectionItemList();
				pdG.setEmptySelectionText("",true);
				pdG.setActive(false);
				
				this.getCalLabel(slot).text = "";
			}
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
			if( this.myAircraft == null ) 
				return;
			
			// max hardpoints of this aircraft
			this.form.lblHardpoints.text = String(
					this.myAircraft.getRocketSlotCount()
				);
			
			// hoplite adjustment
			for( var slot:int = 5; slot < 9; slot++ )
			{
				var pdA:CSPullDown = this.getRocketPullDown(slot,"a");
				
				if( this.myAircraft.getFrameType() == "hoplite" )
				{
					pdA.clearSelection();
					pdA.setActive(false);
					
					var pdB:CSPullDown = this.getRocketPullDown(slot,"b");
					pdB.clearSelection();
					pdB.setActive(false);
					
				} else {
					pdA.setActive(true);
				}
			}
			
			// gunpoints and ammunition
			for( var gnum:int = 1; gnum < 8; gnum++ )
			{
				var currGP:Gunpoint = this.myAircraft.getGunpoint(gnum);
				
				// no gun go next slot
				if( currGP.gunID == "") 
					continue;
				
				var currGun:Gun = Globals.myBaseData.getGun(currGP.gunID);
				var arrAmmo:Array = Globals.myBaseData.getAmmunitionByCaliber(currGun.cal);
				var pdG:CSPullDown = this.getAmmoPullDown(gnum);
				
				this.getCalLabel(gnum).text = String(currGun.cal);
					
				for( var i:int = 0; i < arrAmmo.length; i++) 
					pdG.addSelectionItem(
							arrAmmo[i].longName,
							arrAmmo[i].myID
						); 
				
				pdG.setActive(true);
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateFreeHardpoints
		 * ---------------------------------------------------------------------
		 */
		private function updateFreeHardpoints():void 
		{
			if( this.myAircraft == null ) 
				return;
			
			// hardpoints from aircraft
			this.intFreeHardpoints = this.myAircraft.getRocketSlotCount();
			
			for( var slot:int = 1; slot < 9; slot++ )
			{
				// slot a only check need 
				var pdA:CSPullDown = this.getRocketPullDown(slot,"a");
				var id:String = pdA.getIDForCurrentSelection();
				
				if( id != CSPullDown.ID_EMPTYSELECTION ) 
					this.intFreeHardpoints -= Globals.myBaseData.getRocket(id).slots;
			}
			this.form.lblHardpoints.text = String(this.intFreeHardpoints);
			this.validateForm();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcAmmoCosts
		 * ---------------------------------------------------------------------
		 * sums up the ammo price
		 */
		private function calcAmmoCosts():void
		{
			this.intAmmoCost = 0;
			
			for( var gnum:int = 1; gnum < 8; gnum++ )
			{
				var id:String = this.getAmmoPullDown(gnum).getIDForCurrentSelection();
				if( id != CSPullDown.ID_EMPTYSELECTION ) 
					this.intAmmoCost += Globals.myBaseData.getAmmunition(id).price;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcRocketCosts
		 * ---------------------------------------------------------------------
		 * sums up the rocket price
		 */
		private function calcRocketCosts() 
		{
			this.intRocketCost = 0;
			
			for( var slot:int = 1; slot < 9; slot++ )
			{
				var pdA:CSPullDown = this.getRocketPullDown(slot,"a");
				var pdB:CSPullDown = this.getRocketPullDown(slot,"b");
			
				//slot a
				var id:String = pdA.getIDForCurrentSelection();
				if( id != CSPullDown.ID_EMPTYSELECTION ) 
					this.intRocketCost += Globals.myBaseData.getRocket(id).price;
				//slot b
				id = pdB.getIDForCurrentSelection();
				if( id != CSPullDown.ID_EMPTYSELECTION ) 
					this.intRocketCost += Globals.myBaseData.getRocket(id).price;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcCosts
		 * ---------------------------------------------------------------------
		 * sums up the ammo and rocket costs
		 */
		private function calcCosts() 
		{
			this.form.lblCost.text = CSFormatter.formatDollar(
					this.intAmmoCost 
						+ this.intRocketCost
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
				
			this.resetAllGuns();
			this.loadAircraft(file);
			this.updateUIByAircraft();
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * ammoChangedHandler
		 * ---------------------------------------------------------------------
		 * eventhandler for all gun ammo pulldowns
		 *
		 * @param e
		 */
		private function ammoChangedHandler(e:MouseEvent):void
		{
			if( !(CSPullDown(e.currentTarget)).getIsActive() ) 
				return;
				
			this.setSaved(false);
			this.calcAmmoCosts();
			this.calcCosts();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * rocketChangedHandler
		 * ---------------------------------------------------------------------
		 * eventhandler for all rocket pulldowns
		 *
		 * @param e
		 */
		private function rocketChangedHandler(e:MouseEvent):void
		{
			var pd:CSPullDown = CSPullDown(e.currentTarget);
			var pdName:String = pd.name;
			
			if( !pd.getIsActive() )
				return;
			
			this.setSaved(false);
				
			// b-slot rocket pulldown
			if( pdName.lastIndexOf("b") == (pdName.length - 1) )
			{
				this.calcRocketCosts();
				this.calcCosts();
				return;
			}
			
			// a-slot rocket pulldown
			var id:String = pd.getIDForCurrentSelection();
			var pdB:CSPullDown = this.getRocketBSlotPullDown(pd);
			
			if( id != CSPullDown.ID_EMPTYSELECTION ) 
			{
				var rock:Rocket = Globals.myBaseData.getRocket(id);
				if( rock.usesPerSlot > 1 )
				{
					if( rock.type == Rocket.TYPE_RELOADABLE) 
					{
						pdB.setActive(false);
						pdB.setActiveSelectionItem(id);
					} else {
						pdB.setActive(true);
					}
				} else {
					pdB.clearSelection();
					pdB.setActive(false);
				}
			} else {
				pdB.clearSelection();
				pdB.setActive(false);
			}
			this.updateFreeHardpoints();
			this.calcRocketCosts();
			this.calcCosts();
		}
	
	}
}