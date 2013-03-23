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
package as3.aeronaut.module.loadout 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.CSFormatter;
	import as3.aeronaut.gui.*;
	
	import as3.aeronaut.module.ICSValidate;
	import as3.aeronaut.module.CSWindowLoadout;
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.BaseData;
	import as3.aeronaut.objects.baseData.Gun;
	import as3.aeronaut.objects.Loadout;	
	import as3.aeronaut.objects.loadout.GunAmmo;	
	import as3.aeronaut.objects.Aircraft;	
	import as3.aeronaut.objects.aircraft.Gunpoint;
	import as3.aeronaut.objects.aircraftConfigs.FrameDefinition;
	
	/**
	 * =========================================================================
	 * Class PageGuns
	 * =========================================================================
	 * Loadout Window Page 1 Guns 
	 */
	public class PageGuns 
			extends AbstractPage
				implements ICSValidate
	{
		// =====================================================================
		// Variables
		// =====================================================================
		private var winLoadout:CSWindowLoadout = null;
		private var isValid:Boolean = true;
		
		private var intAmmoCost:int = 0;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 */
		public function PageGuns() 
		{
			super();
			
			// add eventlisteners
			for( var gnum:int = 1; gnum < 11; gnum++ )
			{
				var pdG:CSPullDown = this.getAmmoPullDown(gnum);
				pdG.addEventListener(
						MouseEvent.MOUSE_DOWN, 
						ammoChangedHandler
					);
			}
		}
		
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * init
		 * ---------------------------------------------------------------------
		 * this is called every time the loadout changes (loading, new) 
		 *
		 * @param win
		 */
		public function init(win:CSWindowLoadout):void
		{
			this.winLoadout = win;
			this.resetAllGuns();
			
			var loadout:Loadout = Loadout(winLoadout.getObject());
			var aircraft:Aircraft = winLoadout.getAircraft();
			var i:int = 0;
			var pdG:CSPullDown;
			
			for( var gnum:int = 1; gnum < 11; gnum++ )
			{
				if ( aircraft == null )
					continue;
					
				var currGP:Gunpoint = aircraft.getGunpoint(gnum);
				
				// no gun go next slot
				if( currGP.gunID == "") 
					continue;
				
				var currGun:Gun = Globals.myBaseData.getGun(currGP.gunID);
				var arrAmmo:Array = Globals.myBaseData.getAmmunitionByCaliber(currGun.cal);
				pdG = this.getAmmoPullDown(gnum);
				
				this.getCalLabel(gnum).text = String(currGun.cal);
					
				for( i = 0; i < arrAmmo.length; i++) 
					pdG.addSelectionItem(
							arrAmmo[i].longName,
							arrAmmo[i].myID
						); 
				
				pdG.setActive(true);
			}
			
			// ammunition
			var arr:Array = loadout.getGunAmmos();
			for( i = 0; i < arr.length; i++ ) 
			{
				pdG = this.getAmmoPullDown(arr[i].gunPointNumber);
				pdG.setActiveSelectionItem(arr[i].ammoID);
			}
			this.calcAmmoCosts();
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 */
		public function dispose():void
		{
			for( var gnum:int = 1; gnum < 11; gnum++ )
			{
				var pdG:CSPullDown = this.getAmmoPullDown(gnum);
				pdG.removeEventListener(
						MouseEvent.MOUSE_DOWN, 
						ammoChangedHandler
					);
				pdG.clearSelectionItemList();
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
		 * validateForm
		 * ---------------------------------------------------------------------
		 * @param v
		 */
		public function setValid(v:Boolean):void 
		{
			this.isValid = v;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * validateForm
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
		public function updateObjectFromWindow():Loadout
		{
			var obj:Loadout = Loadout(this.winLoadout.getObject());
			var id:String;
			var arr:Array = new Array();
			
			for( var gnum:int = 1; gnum < 11; gnum++ )
			{
				id = this.getAmmoPullDown(gnum).getIDForCurrentSelection();
				if( id == CSPullDown.ID_EMPTYSELECTION ) 
					continue;
			
				var ga:GunAmmo = new GunAmmo(gnum, id);
				arr.push(ga);
			}
			obj.setGunAmmos(arr);
			
			return obj;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getCost
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getCost():int
		{
			return this.intAmmoCost;
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
					this.getChildByName("pdGun"+slot+"Ammo")
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
					this.getChildByName("lblGun"+slot+"Caliber")
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * resetAllGuns
		 * ---------------------------------------------------------------------
		 */
		private function resetAllGuns():void
		{
			for( var slot:int = 1; slot < 11; slot++ )
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
		 * calcAmmoCosts
		 * ---------------------------------------------------------------------
		 * sums up the ammo price
		 */
		private function calcAmmoCosts():void
		{
			this.intAmmoCost = 0;
			
			for( var gnum:int = 1; gnum < 11; gnum++ )
			{
				var id:String = this.getAmmoPullDown(gnum).getIDForCurrentSelection();
				if( id != CSPullDown.ID_EMPTYSELECTION ) 
					this.intAmmoCost += Globals.myBaseData.getAmmunition(id).price;
			}
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
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
				
			this.winLoadout.setSaved(false);
			this.calcAmmoCosts();
			this.winLoadout.calcCosts();
		}
	}

}