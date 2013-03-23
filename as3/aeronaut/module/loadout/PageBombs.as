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
	import as3.aeronaut.objects.baseData.Rocket;
	import as3.aeronaut.objects.Loadout;	
	import as3.aeronaut.objects.loadout.RocketLoadout;	
	import as3.aeronaut.objects.Aircraft;	
	import as3.aeronaut.objects.aircraftConfigs.FrameDefinition;
	
	/**
	 * =========================================================================
	 * Class PageBombs
	 * =========================================================================
	 * Loadout Window Page 3 Bombs 
	 */
	public class PageBombs
			extends AbstractPage
				implements ICSValidate
	{
		// =====================================================================
		// Variables
		// =====================================================================
		private var winLoadout:CSWindowLoadout = null;
		private var isValid:Boolean = true;
		
		private var intFreeWeight:int = 0;
		private var intBombCost:int = 0;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 */
		public function PageBombs() 
		{
			super();
			// TODO
			/*
			var arrRock:Array = filterRockets();
			
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
			
			this.form.lblHardpoints.text = "0";
			*/
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
			
			this.lblFreeWeight.text = "0";
			
			var loadout:Loadout = Loadout(winLoadout.getObject());
			var aircraft:Aircraft = winLoadout.getAircraft();
			if( aircraft == null )
				return;
			// TODO
			/*	
			// max hardpoints of this aircraft
			this.lblHardpoints.text = String(
					aircraft.getRocketSlotCount()
				);
			
			var frameType:String = aircaft.getFrameType();
			
			// rocket adjustments for autogyro
			for( var slot:int = 5; slot < 9; slot++ )
			{
				var pdA:CSPullDown = this.getRocketPullDown(slot,"a");
				
				if( frameType == FrameDefinition.FT_AUTOGYRO )
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
			
			// rockets
			var arr:Array = loadout.getRocketLoadouts();
			
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
			this.calcRocketCosts();
			*/
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 */
		public function dispose():void
		{
			// TODO
			/*
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
			*/
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * validateForm
		 * ---------------------------------------------------------------------
		 */
		public function validateForm():void
		{
			this.setValid(true);
			//TODO
			/*
			if( this.intFreeHardpoints < 0 ) 
				this.setValid(false);
			
			this.setTextFieldValid( this.lblHardpoints, this.isValid );
			*/
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
			// TODO
			/*
			var arr:Array = new Array();
			
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
			obj.setRocketLoadouts(arr);
			*/
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
			return this.intBombCost;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcBombCosts
		 * ---------------------------------------------------------------------
		 * sums up the bomb prices
		 */
		private function calcBombCosts() 
		{
			this.intBombCost = 0;
			// TODO
			/*
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
			*/
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * filterBombs
		 * ---------------------------------------------------------------------
		 * filters bombs
		 * that can placed into bomb racks
		 *
		 * @return
		 */
		private function filterBombs():Array
		{
			var arrRock:Array = Globals.myBaseData.getRockets();
			var arrFiltered:Array = new Array();
			
			for( var i:int=0; i<arrRock.length; i++ )
				if( arrRock[i].weight > 0 )
					arrFiltered.push(arrRock[i]);
			
			return arrFiltered;
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * updateFreeWeight
		 * ---------------------------------------------------------------------
		 */
		private function updateFreeWeight():void 
		{
			var aircraft:Aircraft = winLoadout.getAircraft();
			if( aircraft == null )
				return;
			// TODO
			/*
			// hardpoints from aircraft
			this.intFreeHardpoints = aircraft.getRocketSlotCount();
			
			for( var slot:int = 1; slot < 9; slot++ )
			{
				// slot a only check need 
				var pdA:CSPullDown = this.getRocketPullDown(slot,"a");
				var id:String = pdA.getIDForCurrentSelection();
				
				if( id != CSPullDown.ID_EMPTYSELECTION ) 
					this.intFreeHardpoints -= Globals.myBaseData.getRocket(id).slots;
			}
			this.form.lblHardpoints.text = String(this.intFreeHardpoints);
			*/
			this.validateForm();
		}
		
		
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * bombChangedHandler
		 * ---------------------------------------------------------------------
		 * eventhandler for all bomb pulldowns
		 *
		 * @param e
		 */
		private function bombChangedHandler(e:MouseEvent):void
		{
			var pd:CSPullDown = CSPullDown(e.currentTarget);
			var pdName:String = pd.name;
			
			if( !pd.getIsActive() )
				return;
			
			this.winLoadout.setSaved(false);
			// TODO	
			/*
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
			*/
			this.updateFreeWeight();
			this.calcBombCosts();
			this.winLoadout.calcCosts();
		}
	}

}