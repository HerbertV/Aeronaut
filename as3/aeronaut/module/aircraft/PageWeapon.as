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
package as3.aeronaut.module.aircraft
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
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
	
	/**
	 * =========================================================================
	 * Class PageWeapon
	 * =========================================================================
	 * Aircraft Window Page 2 Weapons 
	 */
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
				
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 */
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
				var gunrow:GunRow = getGunRow(i);
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
			var frameDef:FrameDefinition = this.winAircraft.getFrameDefinition();
			
			this.numStepRocketSlots.setValue(obj.getRocketSlotCount());
			this.recalcRocketHardpoints();
			
			this.intMaxGuns = frameDef.maxGuns;
			
			this.rbtnHasTurrets.setSelected(false);
			this.rbtnHasTurrets.setActive(false);
			
			if( frameDef.allowsTurrets == 1 )
				this.rbtnHasTurrets.setActive(true);
			
			if( obj.getTurrets().length > 0 
					|| frameDef.allowsTurrets == 2 )
				this.rbtnHasTurrets.setSelected(true);
			
			// ammo/fire linked setup
			var arrSC:Array = obj.getSpecialCharacteristics();
			this.isAmmoLinked = false;
			this.isFireLinked = false;
			for each( var sc:String in arrSC )
			{
				if( sc == BaseData.HCID_SC_LINKEDAMMO )
					this.isAmmoLinked = true;
				if( sc == BaseData.HCID_SC_LINKEDFIRE )
					this.isFireLinked = true;
			}
			
			for( var i:int = 1; i < 11; i++ )
			{
				var gunrow:GunRow = getGunRow(i);
				setTurretLabel(i, gunrow.lblGunNTurret);
			
				gunrow.pdGunN.clearSelection();
				
				if( i <= this.intMaxGuns )
				{
					// active row get the values from our object
					setGunRowActive(gunrow,true);
					var gp:Gunpoint = obj.getGunpoint(i);
					
					gunrow.pdGunN.setActiveSelectionItem(gp.gunID);
					
					gunrow.numStepGunNFire.setValue(gp.firelinkGroup);
					gunrow.numStepGunNAmmo.setValue(gp.ammolinkGroup);
					
					gunrow.rbtnGunNFireLinked.setSelected(false);
					if( gp.firelinkGroup > 0 )
					{
						gunrow.numStepGunNFire.setActive(true);
						gunrow.rbtnGunNFireLinked.setSelected(true);
					}
					gunrow.rbtnGunNAmmoLinked.setSelected(false);
					if( gp.ammolinkGroup > 0 )
					{
						gunrow.numStepGunNAmmo.setActive(true);
						gunrow.rbtnGunNAmmoLinked.setSelected(true);
					}
					gunrow.rbtnGunNTurret.setSelected(false);
					if (gp.direction == Gunpoint.DIR_TURRET)
						gunrow.rbtnGunNTurret.setSelected(true);

				} else {
					// inactive row
					setGunRowActive(gunrow, false);
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
				var gunrow:GunRow = getGunRow(i);
				gunrow.pdGunN.removeEventListener(
						MouseEvent.MOUSE_DOWN, 
						gunChangedHandler
					); 
				gunrow.rbtnGunNTurret.removeEventListener(
						MouseEvent.MOUSE_DOWN, 
						gunChangedHandler
					); 
				gunrow.rbtnGunNFireLinked.removeEventListener(
						MouseEvent.MOUSE_DOWN, 
						gunChangedHandler
					); 
				gunrow.rbtnGunNAmmoLinked.removeEventListener(
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
			var frameDef:FrameDefinition = this.winAircraft.getFrameDefinition();
			var gpWithTurrets:Array = new Array();
			
			obj.setRocketSlotCount(this.numStepRocketSlots.getValue());
			
			for( var i:int = 1; i < 11; i++ )
			{
				var gunrow:GunRow = getGunRow(i);
				var gunid:String = gunrow.pdGunN.getIDForCurrentSelection();
				if (gunid == CSPullDown.ID_EMPTYSELECTION)
					gunid = "";
					
				var gp:Gunpoint = new Gunpoint(i,gunid);
				gp.firelinkGroup = gunrow.numStepGunNFire.getValue();
				gp.ammolinkGroup = gunrow.numStepGunNAmmo.getValue();
				
				if( gunrow.rbtnGunNTurret.getIsSelected() )
				{
					gp.direction = Gunpoint.DIR_TURRET;
					gpWithTurrets.push(i);
				} else {
					gp.direction = Gunpoint.DIR_FORWARD;
				}
				obj.setGunpoint(gp);
			}

			//TURRETS
			var arrTur:Array = new Array();
			var t:Turret;
			var doesExist:Boolean;
			var dir:String;
			if( this.rbtnHasTurrets.getIsSelected() ) 
			{
				for each( var gpnum:int in gpWithTurrets )
				{
					dir = frameDef.getTurretDirectionForGunPoint(gpnum);
					
					doesExist = false
					// first check if turret with this direction is already created.
					for each( t in arrTur )
					{
						if( t.direction == dir )
						{
							doesExist = true;
							t.linkedGuns.push(gpnum);
						}
					}
					
					if( doesExist )
						continue;
					
					// create a new 
					t = new Turret(dir);
					t.linkedGuns.push(gpnum);
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
		 * returns all elements of a gun point as an GunRow Object
		 *
		 * @param idx 1-10
		 *
		 * @return 
		 */
		private function getGunRow(idx:uint):GunRow
		{
			return new GunRow(
					CSPullDown(this.getChildByName("pdGun" + idx)), 
					TextField(this.getChildByName("lblGun" + idx + "Weight")),
					CSRadioButton(this.getChildByName("rbtnGun" + idx + "Turret")),
					TextField(this.getChildByName("lblGun" + idx + "Turret")),
					CSNumStepperInteger(this.getChildByName("numStepGun" + idx + "Fire")),
					CSRadioButton(this.getChildByName("rbtnGun" + idx + "FireLinked")),
					CSNumStepperInteger(this.getChildByName("numStepGun" + idx + "Ammo")),
					CSRadioButton(this.getChildByName("rbtnGun"+idx+"AmmoLinked"))
				);
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
				gunrow:GunRow, 
				active:Boolean
			):void
		{
			gunrow.pdGunN.setActive(active);
			
			gunrow.rbtnGunNTurret.setActive(
					this.rbtnHasTurrets.getIsSelected() && active
				);
			
			gunrow.numStepGunNFire.setActive(
					gunrow.rbtnGunNFireLinked.getIsSelected()
						&& active
						&& this.isFireLinked
				);
			gunrow.rbtnGunNFireLinked.setActive(
					this.isFireLinked && active
				);
			gunrow.numStepGunNAmmo.setActive(
					gunrow.rbtnGunNAmmoLinked.getIsSelected()
						&& active
						&& this.isAmmoLinked
				);
			gunrow.rbtnGunNAmmoLinked.setActive(
					this.isAmmoLinked && active
				);
			
			if( !gunrow.pdGunN.getIsActive() )
			{
				gunrow.pdGunN.setActiveSelectionItem(
						CSPullDown.ID_EMPTYSELECTION
					);
				gunrow.lblGunNWeight.text = "0 lbs.";
			}
			
			if( !gunrow.rbtnGunNTurret.getIsActive() )
				gunrow.rbtnGunNTurret.setSelected(false);
			
			if( !gunrow.numStepGunNFire.getIsActive() )
			{
				gunrow.numStepGunNFire.setValue(0);
				gunrow.rbtnGunNFireLinked.setSelected(false);
			}
			
			if( !gunrow.numStepGunNAmmo.getIsActive() )
			{
				gunrow.numStepGunNAmmo.setValue(0);
				gunrow.rbtnGunNAmmoLinked.setSelected(false);
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initGunRow
		 * ---------------------------------------------------------------------
		 * called by contructor for first time setup
		 *
		 * @param gunrow
		 */
		public function initGunRow(gunrow:GunRow):void
		{
			var arrGuns:Array = Globals.myBaseData.getGuns();
			
			// pdGunN
			gunrow.pdGunN.setMaxVisibleItems(8);
			gunrow.pdGunN.setEmptySelectionText("empty",true);
			
			for( var i:int = 0; i < arrGuns.length; i++ ) 
				gunrow.pdGunN.addSelectionItem(arrGuns[i].longName, arrGuns[i].myID);
			
			gunrow.pdGunN.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					gunChangedHandler
				); 
		
			//rbtnGunNTurret
			gunrow.rbtnGunNTurret.setActive(false);
			gunrow.rbtnGunNTurret.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					gunChangedHandler
				); 
			
			//numStepGunNFire
			gunrow.numStepGunNFire.setupSteps(0,10,0,1);
			gunrow.numStepGunNFire.setActive(false);
			
			//rbtnGunNFireLinked,
		 	gunrow.rbtnGunNFireLinked.setActive(false);
			gunrow.rbtnGunNFireLinked.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					gunChangedHandler
				); 
			
			//numStepGunNAmmo,
		 	gunrow.numStepGunNAmmo.setupSteps(0,10,0,1);
			gunrow.numStepGunNAmmo.setActive(false);
			
			//rbtnGunNAmmoLinked
			gunrow.rbtnGunNAmmoLinked.setActive(false);
			gunrow.rbtnGunNAmmoLinked.addEventListener(
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
				var gunrow:GunRow = getGunRow(i);
				
				gunrow.rbtnGunNAmmoLinked.setActive(isLinked);
				
				if( !isLinked )
				{
					gunrow.numStepGunNAmmo.setActive(isLinked);
					gunrow.numStepGunNAmmo.setValue(0);
					gunrow.rbtnGunNAmmoLinked.setSelected(false);
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
				var gunrow:GunRow = getGunRow(i);
				gunrow.rbtnGunNFireLinked.setActive(isLinked);
				
				if( !isLinked )
				{
					gunrow.numStepGunNFire.setActive(isLinked);
					gunrow.numStepGunNFire.setValue(0);
					gunrow.rbtnGunNFireLinked.setSelected(false);
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
			lbl.text = "";
			var fd:FrameDefinition = this.winAircraft.getFrameDefinition();
			
			if( fd.allowsTurrets == 0 )
				return;
			
			var arrtd:Array = fd.turretDefs;
			
			for each( var td:TurretDefinition in arrtd )
				if( td.linkedGuns.indexOf(String(idx)) > -1 )
					lbl.text = TurretDefinition.getLabelforDirection(td.direction);
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
				var gunrow:GunRow = getGunRow(i);
				setTurretLabel(i, gunrow.lblGunNTurret );
			
				if( i > intMaxGuns )
					continue;
				
				gunrow.rbtnGunNTurret.setActive(active);
				if( !active )
					gunrow.rbtnGunNTurret.setSelected(false);
					
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
			
			var frameDef:FrameDefinition = this.winAircraft.getFrameDefinition();
			var arrTurretsInUse:Array = new Array();
			var tdir:String;
			
			for( var i:int = 1; i <= intMaxGuns; i++ )
			{
				var gunrow:GunRow = getGunRow(i);
				var gunid:String = gunrow.pdGunN.getIDForCurrentSelection();
				
				if( gunid == CSPullDown.ID_EMPTYSELECTION ) 
				{
					gunrow.lblGunNWeight.text = CSFormatter.formatLbs(0);
					continue;
				}
				
				var gun:Gun = Globals.myBaseData.getGun(gunid);
				var gunWeight:int = gun.weight;
				var gunCost:int = gun.price;
				var modCost:Number = 0.00;
			
				if( gunrow.rbtnGunNAmmoLinked.getIsSelected() )
				{
					modCost = modCostAmmoLinked;
					gunrow.numStepGunNAmmo.setActive(true);
					if( gunrow.numStepGunNAmmo.getValue() == 0 ) 
						gunrow.numStepGunNAmmo.setValue(1);
				} else {
					gunrow.numStepGunNAmmo.setActive(false);
					gunrow.numStepGunNAmmo.setValue(0);
				}
				
				if( gunrow.rbtnGunNFireLinked.getIsSelected() )
				{
					modCost += modCostFireLinked;
					gunrow.numStepGunNFire.setActive(true);
					if( gunrow.numStepGunNFire.getValue() == 0 ) 
						gunrow.numStepGunNFire.setValue(1);
				} else {
					gunrow.numStepGunNFire.setActive(false);
					gunrow.numStepGunNFire.setValue(0);
				}
				
				if(	gunrow.rbtnGunNTurret.getIsSelected() )
				{
					gunWeight += (gun.weight * 0.5);
					modCost += 0.50;				
					// for later cost and weight calculation we store every active turret once.
					tdir = frameDef.getTurretDirectionForGunPoint(i);
					if( arrTurretsInUse.indexOf(tdir) == -1 )
						arrTurretsInUse.push(tdir);
				}
				gunCost += int(gun.price * modCost);
				
				gunrow.lblGunNWeight.text = CSFormatter.formatLbs(gunWeight);
				
				this.intWeaponCost += gunCost;
				this.intWeaponWeight += gunWeight;
				
				gunrow = null;
			}
			
			// now collect cost and weight changes per turret
			if( arrTurretsInUse.length > 0 )
			{
				for each( tdir in arrTurretsInUse )
				{
					var td:TurretDefinition = frameDef.getTurretDefinitionForDirection(tdir);
					this.intWeaponWeight += td.weight;
					this.intWeaponCost += td.cost;
				}
			}
			
			this.lblWeaponWeight.text = CSFormatter.formatLbs(this.intWeaponWeight);
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * recalcRocketHardpoints
		 * ---------------------------------------------------------------------
		 */
		private function recalcRocketHardpoints():void
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