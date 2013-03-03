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
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import as3.aeronaut.CSFormatter;
	import as3.aeronaut.Globals;
	import as3.aeronaut.gui.*;
	
	import as3.aeronaut.module.CSWindowAircraft;
	import as3.aeronaut.module.ICSValidate;
	
	import as3.aeronaut.objects.Aircraft;	
	import as3.aeronaut.objects.aircraft.Gunpoint;	
	import as3.aeronaut.objects.aircraft.Turret;	
	import as3.aeronaut.objects.BaseData;
	import as3.aeronaut.objects.baseData.Gun;
	import as3.aeronaut.objects.aircraftConfigs.FrameDefinition;
	import as3.aeronaut.objects.aircraftConfigs.TurretDefinition;
	
	
	// =========================================================================
	// Class PageWeapon
	// =========================================================================
	// Aircraft Page 2 Weapons 
	//
	public class PageWeapon
			extends AbstractPage
			implements ICSValidate
	{
		// =====================================================================
		// Variables
		// =====================================================================
		private var winAircraft:CSWindowAircraft = null;
		private var isValid:Boolean = true;
		
		private var intWeaponWeight:int = 0;
		private var intHardpointWeight:int = 0;
		
		private var intWeaponCost:int = 0;
		private var intHardpointCost:int = 0;
		//depends on airframe type
		private var intMaxGuns:int = 10;
		
		// to prevent searching sc's evertime
		private var isAmmoLinked:Boolean = false;
		private var isFireLinked:Boolean = false;
		
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function PageWeapon()
		{
			super();
			
			this.numStepRocketSlots.setupSteps(1,8,1,1);
			this.numStepRocketSlots.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					rocketSlotsChangedHandler
				); 
			
			this.rbtnHasTurrets.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					hasTurretsChangedHandler
				);
			
			for( var i:int = 1; i < 11; i++ )
			{
				var gunrow:Object = getGunRow(i);
				initGunRow(gunrow);
				gunrow = null;
			}
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
			var obj:Aircraft = Aircraft(this.winAircraft.getObject());
			var frame:String = this.winAircraft.getFrameType();
			var frameDef:FrameDefinition = this.winAircraft.getFrameDefinition();
			
			this.numStepRocketSlots.setValue(obj.getRocketSlotCount());
			this.recalcRocketHardpoints();
			
			this.intMaxGuns = frameDef.maxGuns;
			
			this.rbtnHasTurrets.setSelected(false);
			this.rbtnHasTurrets.setActive(false);
			
			if( frameDef.allowsTurrets > 0 )
				this.rbtnHasTurrets.setActive(true);
			
			if( obj.getTurrets().length > 0 )
				this.rbtnHasTurrets.setSelected(true);
//TODO new turret handling
			
			// ammo/fire linked setup
			var arrSC:Array = obj.getSpecialCharacteristics();
			var idxAmmo:int = arrSC.indexOf(BaseData.HCID_SC_LINKEDAMMO);
			var idxFire:int = arrSC.indexOf(BaseData.HCID_SC_LINKEDFIRE);
			
			this.isAmmoLinked = false;
			if( idxAmmo != -1 )
				this.isAmmoLinked = true;
			
			this.isFireLinked = false;
			if( idxFire != -1 )
				this.isFireLinked = true;
			
			for( var i:int = 1; i < 11; i++ )
			{
				var gunrow:Object = getGunRow(i);
				setTurretLabel(i, TextField(gunrow["lblGunNTurret"]) );
			
				if( i <= this.intMaxGuns )
				{
					// active row get the values from our object
					setGunRowActive(gunrow,true);
					var gp:Gunpoint = obj.getGunpoint(i);
					
					CSPullDown(gunrow["pdGunN"]).setActiveSelectionItem(CSPullDown.ID_EMPTYSELECTION);
					CSPullDown(gunrow["pdGunN"]).setActiveSelectionItem(gp.gunID);
					TextField(gunrow["lblGunNWeight"]).text = "0 lbs.";
			
					CSNumStepperInteger(gunrow["numStepGunNFire"]).setValue(gp.firelinkGroup);
					CSNumStepperInteger(gunrow["numStepGunNAmmo"]).setValue(gp.ammolinkGroup);
					
					CSRadioButton(gunrow["rbtnGunNFireLinked"]).setSelected(false);
					if( gp.firelinkGroup > 0 )
					{
						CSNumStepperInteger(gunrow["numStepGunNFire"]).setActive(true);
						CSRadioButton(gunrow["rbtnGunNFireLinked"]).setSelected(true);
					}
					CSRadioButton(gunrow["rbtnGunNAmmoLinked"]).setSelected(false);
					if( gp.ammolinkGroup > 0 )
					{
						CSNumStepperInteger(gunrow["numStepGunNAmmo"]).setActive(true);
					CSRadioButton(gunrow["rbtnGunNAmmoLinked"]).setSelected(true);
					}
					CSRadioButton(gunrow["rbtnGunNTurret"]).setSelected(false);
					if (gp.direction == Gunpoint.DIR_TURRET)
						CSRadioButton(gunrow["rbtnGunNTurret"]).setSelected(true);
//TODO new turret handling
					
				} else {
					// inactive row
					setGunRowActive(gunrow,false);
				}
				gunrow = null;
			}
			this.recalcWeapons();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 */
		public function dispose():void
		{
			this.numStepRocketSlots.removeEventListener(
					MouseEvent.MOUSE_DOWN, 
					rocketSlotsChangedHandler
				); 
			this.rbtnHasTurrets.removeEventListener(
					MouseEvent.MOUSE_DOWN, 
					hasTurretsChangedHandler
				);
			
			for( var i:int = 1; i < 11; i++ )
			{
				var gunrow:Object = getGunRow(i);
				CSPullDown(gunrow["pdGunN"]).removeEventListener(
						MouseEvent.MOUSE_DOWN, 
						gunChangedHandler
					); 
				CSRadioButton(gunrow["rbtnGunNTurret"]).removeEventListener(
						MouseEvent.MOUSE_DOWN, 
						gunChangedHandler
					); 
				CSRadioButton(gunrow["rbtnGunNFireLinked"]).removeEventListener(
						MouseEvent.MOUSE_DOWN, 
						gunChangedHandler
					); 
				CSRadioButton(gunrow["rbtnGunNAmmoLinked"]).removeEventListener(
						MouseEvent.MOUSE_DOWN, 
						gunChangedHandler
					); 
				gunrow = null;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * validateForm
		 * ---------------------------------------------------------------------
		 */
		public function validateForm():void
		{
			
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
			var gpWithTurrets:Array = new Array();
			
			obj.setRocketSlotCount(this.numStepRocketSlots.getValue());
			
			for( var i:int = 1; i < 11; i++ )
			{
				var gunrow:Object = getGunRow(i);
				var gunid:String = CSPullDown(gunrow["pdGunN"]).getIDForCurrentSelection();
				if (gunid == CSPullDown.ID_EMPTYSELECTION)
					gunid = "";
					
				var gp:Gunpoint = new Gunpoint(i,gunid);
				gp.firelinkGroup = CSNumStepperInteger(gunrow["numStepGunNFire"]).getValue();
				gp.ammolinkGroup = CSNumStepperInteger(gunrow["numStepGunNAmmo"]).getValue();
				
				if( CSRadioButton(gunrow["rbtnGunNTurret"]).getIsSelected() )
				{
					gp.direction = Gunpoint.DIR_TURRET;
					gpWithTurrets.push(i);
				} else {
					gp.direction = Gunpoint.DIR_FORWARD;
				}
				obj.setGunpoint(gp);
			
			}
//TODO bomber turrets
			//TURRETS
			var arrTur:Array = new Array();
			if( this.rbtnHasTurrets.getIsSelected() ) 
			{
				var t:Turret;
				// front turret
				if( gpWithTurrets.indexOf(1) > -1 
						|| gpWithTurrets.indexOf(2) > -1 )
				{
					t = new Turret(TurretDefinition.DIR_FRONT);
					if( gpWithTurrets.indexOf(1) > -1 )
						t.linkedGuns.push(1);
					if( gpWithTurrets.indexOf(2) > -1 )
						t.linkedGuns.push(2);
					
					arrTur.push(t);
				}
//TODO  Adjust this for bombers
				// rear turret
				if( gpWithTurrets.indexOf(7) > -1 
						|| gpWithTurrets.indexOf(8) > -1 )
				{
					t = new Turret(TurretDefinition.DIR_REAR);
					if( gpWithTurrets.indexOf(7) > -1 )
						t.linkedGuns.push(7);
					if( gpWithTurrets.indexOf(8) > -1 )
						t.linkedGuns.push(8);
					
					arrTur.push(t);
				}
			}
			obj.setTurrets(arrTur);
			return obj;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getGunRow
		 * ---------------------------------------------------------------------
		 * returns all elements of a gun slot as an Object
		 *
		 * @param idx 1-10
		 *
		 * @return 
		 */
		private function getGunRow(idx:uint):Object
		{
			var gunrow:Object = {
					pdGunN:
						this.getChildByName("pdGun"+idx), 
					lblGunNWeight:
						this.getChildByName("lblGun"+idx+"Weight"),
					rbtnGunNTurret:
						this.getChildByName("rbtnGun"+idx+"Turret"),
					lblGunNTurret:
						this.getChildByName("lblGun"+idx+"Turret"),
					numStepGunNFire:
						this.getChildByName("numStepGun"+idx+"Fire"),
					rbtnGunNFireLinked:
						this.getChildByName("rbtnGun"+idx+"FireLinked"),
					numStepGunNAmmo:
						this.getChildByName("numStepGun"+idx+"Ammo"),
					rbtnGunNAmmoLinked:
						this.getChildByName("rbtnGun"+idx+"AmmoLinked")
				}; 
			return gunrow;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setGunRowActive
		 * ---------------------------------------------------------------------
		 * activates/deactivates a gun row
		 *
		 * @param gunrow
		 * @param active
		 */
		private function setGunRowActive(
				gunrow:Object, 
				active:Boolean
			):void
		{
			CSPullDown(gunrow["pdGunN"]).setActive(active);
			
			CSRadioButton(gunrow["rbtnGunNTurret"]).setActive(
					this.rbtnHasTurrets.getIsSelected() && active
				);
			
			CSNumStepperInteger(gunrow["numStepGunNFire"]).setActive(
					CSRadioButton(gunrow["rbtnGunNFireLinked"]).getIsSelected()
						&& active
						&& this.isFireLinked
				);
			CSRadioButton(gunrow["rbtnGunNFireLinked"]).setActive(
					this.isFireLinked && active
				);
			CSNumStepperInteger(gunrow["numStepGunNAmmo"]).setActive(
					CSRadioButton(gunrow["rbtnGunNAmmoLinked"]).getIsSelected()
						&& active
						&& this.isAmmoLinked
				);
			CSRadioButton(gunrow["rbtnGunNAmmoLinked"]).setActive(
					this.isAmmoLinked && active
				);
			
			if( !CSPullDown(gunrow["pdGunN"]).getIsActive() )
			{
				CSPullDown(gunrow["pdGunN"]).setActiveSelectionItem(
						CSPullDown.ID_EMPTYSELECTION
					);
				TextField(gunrow["lblGunNWeight"]).text = "0 lbs.";
			}
			
			if( !CSRadioButton(gunrow["rbtnGunNTurret"]).getIsActive() )
				CSRadioButton(gunrow["rbtnGunNTurret"]).setSelected(false);
			
			if( !CSNumStepperInteger(gunrow["numStepGunNFire"]).getIsActive() )
			{
				CSNumStepperInteger(gunrow["numStepGunNFire"]).setValue(0);
				CSRadioButton(gunrow["rbtnGunNFireLinked"]).setSelected(false);
			}
			
			if( !CSNumStepperInteger(gunrow["numStepGunNAmmo"]).getIsActive() )
			{
				CSNumStepperInteger(gunrow["numStepGunNAmmo"]).setValue(0);
				CSRadioButton(gunrow["rbtnGunNAmmoLinked"]).setSelected(false);
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initGunRow
		 * ---------------------------------------------------------------------
		 * called by contructor for first time setup
		 *
		 * @param gunrow object
		 */
		public function initGunRow(gunrow:Object):void
		{
			var arrGuns:Array = Globals.myBaseData.getGuns();
			
			// pdGunN
			var pd:CSPullDown = CSPullDown(gunrow["pdGunN"]);
			pd.setMaxVisibleItems(8);
			pd.setEmptySelectionText("empty",true);
			
			for( var i:int = 0; i < arrGuns.length; i++ ) 
				pd.addSelectionItem(arrGuns[i].longName, arrGuns[i].myID);
			
			pd.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					gunChangedHandler
				); 
		
			//rbtnGunNTurret
			CSRadioButton(gunrow["rbtnGunNTurret"]).setActive(false);
			CSRadioButton(gunrow["rbtnGunNTurret"]).addEventListener(
					MouseEvent.MOUSE_DOWN, 
					gunChangedHandler
				); 
			
			//numStepGunNFire
			CSNumStepperInteger(gunrow["numStepGunNFire"]).setupSteps(0,10,0,1);
			CSNumStepperInteger(gunrow["numStepGunNFire"]).setActive(false);
			
			//rbtnGunNFireLinked,
		 	CSRadioButton(gunrow["rbtnGunNFireLinked"]).setActive(false);
			CSRadioButton(gunrow["rbtnGunNFireLinked"]).addEventListener(
					MouseEvent.MOUSE_DOWN, 
					gunChangedHandler
				); 
			
			//numStepGunNAmmo,
		 	CSNumStepperInteger(gunrow["numStepGunNAmmo"]).setupSteps(0,10,0,1);
			CSNumStepperInteger(gunrow["numStepGunNAmmo"]).setActive(false);
			
			//rbtnGunNAmmoLinked
			CSRadioButton(gunrow["rbtnGunNAmmoLinked"]).setActive(false);
			CSRadioButton(gunrow["rbtnGunNAmmoLinked"]).addEventListener(
					MouseEvent.MOUSE_DOWN, 
					gunChangedHandler
				); 
		}
				
		/**
		 * ---------------------------------------------------------------------
		 * setAmmoLinked
		 * ---------------------------------------------------------------------
		 * toggles the ammo links on/off
		 * called by page 1 sc
		 *
		 * @param isLinked
		 */
		public function setAmmoLinked(isLinked:Boolean):void
		{
			this.isAmmoLinked = isLinked;
			
			for( var i:int = 1; i <= intMaxGuns; i++ )
			{
				var gunrow:Object = getGunRow(i);
				
				CSRadioButton(gunrow["rbtnGunNAmmoLinked"]).setActive(isLinked);
				
				if( !isLinked )
				{
					CSNumStepperInteger(gunrow["numStepGunNAmmo"]).setActive(isLinked);
					CSNumStepperInteger(gunrow["numStepGunNAmmo"]).setValue(0);
					CSRadioButton(gunrow["rbtnGunNAmmoLinked"]).setSelected(false);
				}
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setAmmoLinked
		 * ---------------------------------------------------------------------
		 * toggles the ammo links on/off 
		 * called by page 1 sc
		 *
		 * @param isLinked
		 */
		public function setFireLinked(isLinked:Boolean):void
		{
			this.isFireLinked = isLinked;
			
			for( var i:int = 1; i <= intMaxGuns; i++ )
			{
				var gunrow:Object = getGunRow(i);
				CSRadioButton(gunrow["rbtnGunNFireLinked"]).setActive(isLinked);
				
				if( !isLinked )
				{
					CSNumStepperInteger(gunrow["numStepGunNFire"]).setActive(isLinked);
					CSNumStepperInteger(gunrow["numStepGunNFire"]).setValue(0);
					CSRadioButton(gunrow["rbtnGunNFireLinked"]).setSelected(false);
				}
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setTurretLabel
		 * ---------------------------------------------------------------------
		 * 
		 * @param idx
		 * @param lbl
		 */
		private function setTurretLabel(
				idx:uint,
				lbl:TextField
			):void
		{
//TODO add new turrets for Z&B				
			if( idx > intMaxGuns 
			   		|| !this.rbtnHasTurrets.getIsActive() )
			{
				lbl.text = "";
				return;
			}
			
			switch( idx )
			{
				case 1:
				case 2:
					lbl.text = "Nose";
					break;
					
				case 7:
				case 8:
					lbl.text = "Aft";
					break;
				
				default:
					lbl.text = "";
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateTurrets
		 * ---------------------------------------------------------------------
		 */
		public function updateTurrets():void
		{
			var active:Boolean = this.rbtnHasTurrets.getIsSelected();
			
			for( var i:int = 1; i < 11; i++ )
			{	
				var gunrow:Object = getGunRow(i);
				setTurretLabel(i, TextField(gunrow["lblGunNTurret"]) );
			
				if( i > intMaxGuns )
					continue;
				
				CSRadioButton(gunrow["rbtnGunNTurret"]).setActive(active);
				if( !active )
					CSRadioButton(gunrow["rbtnGunNTurret"]).setSelected(false);
					
				gunrow = null;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getWeaponCost
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getWeaponCost():int
		{
			return this.intWeaponCost;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getWeaponWeight
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getWeaponWeight():int
		{
			return this.intWeaponWeight;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getHardpointCost
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getHardpointCost():int
		{
			return this.intHardpointCost;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getHardpointWeight
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getHardpointWeight():int
		{
			return this.intHardpointWeight;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * recalcWeapons
		 * ---------------------------------------------------------------------
		 */
		private function recalcWeapons():void
		{
			// reset
			this.intWeaponWeight = 0;
			this.intWeaponCost = 0;
			
			var modCostAmmoLinked:Number = 
				Globals.myBaseData.getSpecialCharacteristic(BaseData.HCID_SC_LINKEDAMMO).costChanges;
			
			var modCostFireLinked:Number = 
				Globals.myBaseData.getSpecialCharacteristic(BaseData.HCID_SC_LINKEDFIRE).costChanges;
			
			for( var i:int = 1; i <= intMaxGuns; i++ )
			{
				var gunrow:Object = getGunRow(i);
				var gunid:String =
					CSPullDown(gunrow["pdGunN"]).getIDForCurrentSelection();
				
				if( gunid == CSPullDown.ID_EMPTYSELECTION ) 
				{
					TextField(gunrow["lblGunNWeight"]).text = CSFormatter.formatLbs(0);
					continue;
				}
				
				var gun:Gun = Globals.myBaseData.getGun(gunid);
				var gunWeight:int = gun.weight;
				var gunCost:int = gun.price;
				var modCost:Number = 0.00;
			
				if( CSRadioButton(gunrow["rbtnGunNAmmoLinked"]).getIsSelected() )
				{
					modCost = modCostAmmoLinked;
					CSNumStepperInteger(gunrow["numStepGunNAmmo"]).setActive(true);
					if( CSNumStepperInteger(gunrow["numStepGunNAmmo"]).getValue() == 0 ) 
						CSNumStepperInteger(gunrow["numStepGunNAmmo"]).setValue(1);
				} else {
					CSNumStepperInteger(gunrow["numStepGunNAmmo"]).setActive(false);
					CSNumStepperInteger(gunrow["numStepGunNAmmo"]).setValue(0);
				}
				
				if( CSRadioButton(gunrow["rbtnGunNFireLinked"]).getIsSelected() )
				{
					modCost += modCostFireLinked;
					CSNumStepperInteger(gunrow["numStepGunNFire"]).setActive(true);
					if( CSNumStepperInteger(gunrow["numStepGunNFire"]).getValue() == 0 ) 
						CSNumStepperInteger(gunrow["numStepGunNFire"]).setValue(1);
				} else {
					CSNumStepperInteger(gunrow["numStepGunNFire"]).setActive(false);
					CSNumStepperInteger(gunrow["numStepGunNFire"]).setValue(0);
				}
				
				if(	CSRadioButton(gunrow["rbtnGunNTurret"]).getIsSelected() )
				{
					gunWeight += (gun.weight/2);
					modCost += 0.50;
				}
				gunCost += int(gun.price * modCost);
				
				TextField(gunrow["lblGunNWeight"]).text = CSFormatter.formatLbs(gunWeight);
				
				this.intWeaponCost += gunCost;
				this.intWeaponWeight += gunWeight;
				
				gunrow = null;
			}
			
			// Turret base weight 400lbs
			if (this.rbtnHasTurrets.getIsSelected() ) 
				this.intWeaponWeight += 400;

			this.lblWeaponWeight.text = CSFormatter.formatLbs(this.intWeaponWeight);
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * recalcRocketHardpoints
		 * ---------------------------------------------------------------------
		 */
		private function recalcRocketHardpoints()
		{
			var currBTN:int = this.winAircraft.form.numStepBaseTarget.getValue();
			var frame:String = this.winAircraft.getFrameType();
			var maxRHP:int = 11 - currBTN;
			var currRHP:int = this.numStepRocketSlots.getValue();
			
			if( frame == FrameDefinition.FT_AUTOGYRO )
			{
				if( maxRHP > 4 )
					maxRHP = 4;
			}
			
			if( frame == FrameDefinition.FT_HEAVY_BOMBER
			   		|| frame == FrameDefinition.FT_LIGHT_BOMBER
			   		|| frame == FrameDefinition.FT_HEAVY_CARGO
			   		|| frame == FrameDefinition.FT_LIGHT_CARGO
			   )
			{
				maxRHP = 0;
			}
			
			if( currRHP > maxRHP ) 
				currRHP = maxRHP;
			
			this.numStepRocketSlots.setupSteps(0,maxRHP,currRHP,1);
			
			//read RuleConfig
			var weightPerSlot:int = 
				Globals.myRuleConfigs.getRocketHardpointMassreduction();
			
			this.intHardpointWeight = (maxRHP - currRHP) * weightPerSlot;
			this.lblHardpointWeight.text = 
				CSFormatter.formatLbs(this.intHardpointWeight);
			
			this.intHardpointCost = currRHP *50;
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * hasTurretsChangedHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function hasTurretsChangedHandler(e:MouseEvent):void
		{
			if( !this.rbtnHasTurrets.getIsActive() ) 
				return;
				
			this.updateTurrets();
			this.recalcWeapons();
				
			this.winAircraft.calcFreeWeight();
			this.winAircraft.calcCompleteCost();
			this.winAircraft.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * rocketSlotsChangedHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function rocketSlotsChangedHandler(e:MouseEvent):void
		{
			this.recalcRocketHardpoints();
			this.recalcWeapons();
			
			this.winAircraft.calcFreeWeight();
			this.winAircraft.calcCompleteCost();
			this.winAircraft.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * rocketSlotsChangedHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function gunChangedHandler(e:MouseEvent):void
		{
			this.recalcWeapons();
			
			this.winAircraft.calcFreeWeight();
			this.winAircraft.calcCompleteCost();
			this.winAircraft.setSaved(false);
		}	
		
	}
}