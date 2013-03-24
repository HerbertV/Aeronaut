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
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.CSFormatter;
	import as3.aeronaut.gui.*;
	
	import as3.aeronaut.module.ICSValidate;
	import as3.aeronaut.module.CSWindowLoadout;
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.BaseData;
	import as3.aeronaut.objects.baseData.Rocket;
	import as3.aeronaut.objects.Loadout;	
	import as3.aeronaut.objects.loadout.BombLoadout;	
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
			var arrBombs:Array = filterBombs();
			
			// init all Pulldowns
			for( var slot:int = 1; slot < 9; slot++ )
			{
				var pdFL:CSPullDown = this.getBombPullDown("FL",slot);
				var pdFR:CSPullDown = this.getBombPullDown("FR",slot);
				var pdAL:CSPullDown = this.getBombPullDown("AL",slot);
				var pdAR:CSPullDown = this.getBombPullDown("AR",slot);
				
				pdFL.setEmptySelectionText("",true);
				pdFR.setEmptySelectionText("",true);
				pdAL.setEmptySelectionText("",true);
				pdAR.setEmptySelectionText("",true);
				
// TODO check if max visible items is needed.
				/*
				if( slot > 4 )
				{
					pdA.setMaxVisibleItems(7);
					pdB.setMaxVisibleItems(7);
				}
				*/
				
				for( var i:int = 0; i < arrBombs.length; i++ ) 
				{
					pdFL.addSelectionItem(
							arrBombs[i].longName, 
							arrBombs[i].myID
						);
					pdFR.addSelectionItem(
							arrBombs[i].longName, 
							arrBombs[i].myID
						);
					pdAL.addSelectionItem(
							arrBombs[i].longName, 
							arrBombs[i].myID
						);
					pdAR.addSelectionItem(
							arrBombs[i].longName, 
							arrBombs[i].myID
						);
				
				}
				pdFL.addEventListener(
						MouseEvent.MOUSE_DOWN, 
						bombChangedHandler
					);
				pdFR.addEventListener(
						MouseEvent.MOUSE_DOWN, 
						bombChangedHandler
					);
				pdAL.addEventListener(
						MouseEvent.MOUSE_DOWN, 
						bombChangedHandler
					);
				pdAR.addEventListener(
						MouseEvent.MOUSE_DOWN, 
						bombChangedHandler
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
			this.lblFreeWeight.text = "0 lbs.";
			
			var loadout:Loadout = Loadout(winLoadout.getObject());
			var aircraft:Aircraft = winLoadout.getAircraft();
			
			if( aircraft == null )
				return;
			
			var arr:Array = loadout.getBombLoadouts();
			for( var i:int = 0; i < arr.length; i++ ) 
			{
				var pd:CSPullDown = this.getBombPullDown(arr[i].bay,arr[i].index);
				pd.setActiveSelectionItem(arr[i].bombID);				
			}
			this.updateFreeWeight();
			this.calcBombCosts();
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 */
		public function dispose():void
		{
			for( var slot:int = 1; slot < 9; slot++ )
			{
				var pdFL:CSPullDown = this.getBombPullDown("FL",slot);
				var pdFR:CSPullDown = this.getBombPullDown("FR",slot);
				var pdAL:CSPullDown = this.getBombPullDown("AL",slot);
				var pdAR:CSPullDown = this.getBombPullDown("AR",slot);
				
				pdFL.removeEventListener(
						MouseEvent.MOUSE_DOWN, 
						bombChangedHandler
					);
				pdFR.removeEventListener(
						MouseEvent.MOUSE_DOWN, 
						bombChangedHandler
					);
				pdAL.removeEventListener(
						MouseEvent.MOUSE_DOWN, 
						bombChangedHandler
					);
				pdAR.removeEventListener(
						MouseEvent.MOUSE_DOWN, 
						bombChangedHandler
					);
				
					
				pdFL.clearSelectionItemList();
				pdFR.clearSelectionItemList();
				pdAL.clearSelectionItemList();
				pdAR.clearSelectionItemList();
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * validateForm
		 * ---------------------------------------------------------------------
		 */
		public function validateForm():void
		{
			this.setValid(true);
			
			if( this.intFreeWeight < 0 ) 
				this.setValid(false);
			
			if( this.winLoadout == null )
				return;
			this.winLoadout.setTextFieldValid( this.lblFreeWeight, this.isValid );
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
			var arr:Array = new Array();
			
			var pdFL:CSPullDown;
			var pdFR:CSPullDown;
			var pdAL:CSPullDown;
			var pdAR:CSPullDown;
			
			var id:String;
			var bl:BombLoadout;
			
			for( var index:int = 1; index < 9; index++ )
			{
				pdFL = this.getBombPullDown("FL",index);
				pdFR = this.getBombPullDown("FR",index);
				pdAL = this.getBombPullDown("AL",index);
				pdAR = this.getBombPullDown("AR",index);
				
				id = pdFL.getIDForCurrentSelection();
				if( id != CSPullDown.ID_EMPTYSELECTION )
				{				
					bl = new BombLoadout("FL", index, id);
					arr.push(bl);
				}
				id = pdFR.getIDForCurrentSelection();
				if( id != CSPullDown.ID_EMPTYSELECTION )
				{				
					bl = new BombLoadout("FR", index, id);
					arr.push(bl);
				}
				id = pdAL.getIDForCurrentSelection();
				if( id != CSPullDown.ID_EMPTYSELECTION )
				{				
					bl = new BombLoadout("AL", index, id);
					arr.push(bl);
				}
				id = pdAR.getIDForCurrentSelection();
				if( id != CSPullDown.ID_EMPTYSELECTION )
				{				
					bl = new BombLoadout("AR", index, id);
					arr.push(bl);
				}
			}
			obj.setBombLoadouts(arr);
			
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
			
			var pdFL:CSPullDown;
			var pdFR:CSPullDown;
			var pdAL:CSPullDown;
			var pdAR:CSPullDown;
			var id:String;
			
			for( var slot:int = 1; slot < 9; slot++ )
			{
				pdFL = this.getBombPullDown("FL",slot);
				pdFR = this.getBombPullDown("FR",slot);
				pdAL = this.getBombPullDown("AL",slot);
				pdAR = this.getBombPullDown("AR",slot);
				
				id = pdFL.getIDForCurrentSelection();
				if( id != CSPullDown.ID_EMPTYSELECTION ) 
					this.intBombCost += Globals.myBaseData.getRocket(id).price;
					
				id = pdFR.getIDForCurrentSelection();
				if( id != CSPullDown.ID_EMPTYSELECTION ) 
					this.intBombCost += Globals.myBaseData.getRocket(id).price;
					
				id = pdAL.getIDForCurrentSelection();
				if( id != CSPullDown.ID_EMPTYSELECTION ) 
					this.intBombCost += Globals.myBaseData.getRocket(id).price;
					
				id = pdAR.getIDForCurrentSelection();
				if( id != CSPullDown.ID_EMPTYSELECTION ) 
					this.intBombCost += Globals.myBaseData.getRocket(id).price;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getBombPullDown
		 * ---------------------------------------------------------------------
		 *
		 * @param bay 
		 * @param slot 1-8
		 * @return
		 */
		private function getBombPullDown(
				bay:String,
				slot:uint
			):CSPullDown
		{
			return CSPullDown(
					this.getChildByName("pdBomb"+bay+slot)
				);
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
			
			this.intFreeWeight = aircraft.getFreeWeight();
			
			var pdFL:CSPullDown;
			var pdFR:CSPullDown;
			var pdAL:CSPullDown;
			var pdAR:CSPullDown;
			var id:String;
			
			for( var slot:int = 1; slot < 9; slot++ )
			{
				pdFL = this.getBombPullDown("FL",slot);
				pdFR = this.getBombPullDown("FR",slot);
				pdAL = this.getBombPullDown("AL",slot);
				pdAR = this.getBombPullDown("AR",slot);
				
				id = pdFL.getIDForCurrentSelection();
				if( id != CSPullDown.ID_EMPTYSELECTION ) 
					this.intFreeWeight -= Globals.myBaseData.getRocket(id).weight;
					
				id = pdFR.getIDForCurrentSelection();
				if( id != CSPullDown.ID_EMPTYSELECTION ) 
					this.intFreeWeight -= Globals.myBaseData.getRocket(id).weight;
					
				id = pdAL.getIDForCurrentSelection();
				if( id != CSPullDown.ID_EMPTYSELECTION ) 
					this.intFreeWeight -= Globals.myBaseData.getRocket(id).weight;
					
				id = pdAR.getIDForCurrentSelection();
				if( id != CSPullDown.ID_EMPTYSELECTION ) 
					this.intFreeWeight -= Globals.myBaseData.getRocket(id).weight;
			}	
			this.lblFreeWeight.text = CSFormatter.formatLbs(this.intFreeWeight);
			this.winLoadout.validateForm();
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
			this.updateFreeWeight();
			this.calcBombCosts();
			this.winLoadout.calcCosts();
		}
	}

}