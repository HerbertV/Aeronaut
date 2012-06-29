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
package as3.aeronaut.module.pilot
{
	import flash.display.MovieClip;
	
	import flash.events.MouseEvent;
	
	import as3.aeronaut.Globals;
	
	import as3.aeronaut.gui.*;
	
	import as3.aeronaut.objects.BaseData;
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.Pilot;
	import as3.aeronaut.objects.pilot.LearnedFeat;
	import as3.aeronaut.objects.baseData.Feat;
	
	import as3.aeronaut.module.CSWindowPilot;
	
	
	// =========================================================================
	// FeatBox
	// =========================================================================
	// This class is linked to library symbol "FeatBox" inside CSWindowPilot
	// @see as3.aeronaut.objects.Pilot
	//
	public class FeatBox
			extends MovieClip
			implements ICSStyleable
	{
		// =====================================================================
		// Variables
		// =====================================================================
		private var winPilot:CSWindowPilot = null;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function FeatBox()
		{
			super();
			
			this.pdFeat.setEmptySelectionText("",false);
			if( Globals.myRuleConfigs.getIsPilotFeatsActive() ) 
			{
				var arr:Array = Globals.myBaseData.getFeats();
				for( var i:int = 0; i < arr.length; i++ ) 
					this.pdFeat.addSelectionItem(
							arr[i].myName + " "+ arr[i].getXPCostString(), 
							arr[i].myID
						);
				
				this.btnAddFeat.setupTooltip(
						Globals.myTooltip,
						"Add selected feat"
					);
				this.btnAddFeat.addEventListener(
						MouseEvent.MOUSE_DOWN,
						clickAddFeatHandler
					);
			} else {
				this.pdFeat.setActive(false);
				this.btnAddFeat.setActive(false);
				this.listFeat.setActive(false);
			}
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * init
		 * ---------------------------------------------------------------------
		 * this is called every time the pilot changes (loading, new) and
		 * if the pilot type was changed.
		 *
		 * @param win
		 */
		public function init(win:CSWindowPilot):void
		{
			this.winPilot = win;
			
			if( !Globals.myRuleConfigs.getIsPilotFeatsActive() )
				return;
			
			var obj:Pilot = Pilot(this.winPilot.getObject());
			var pilotType:String = this.winPilot.getPilotType();
			
			this.btnAddFeat.setActive(true);
			this.pdFeat.setActive(true);
			
			this.listFeat.clearList();
			if( pilotType == Pilot.TYPE_GUNNER ) 
			{
				this.btnAddFeat.setActive(false);
				this.pdFeat.setActive(false);
				this.pdFeat.clearSelection();
				
				return;
			}
			
			var arrLF:Array = obj.getLearnedFeats();
			var updateList:Boolean = false;
			
			for( var i:int =0; i < arrLF.length; i++ ) 
			{
				var feat:Feat = Globals.myBaseData.getFeat(arrLF[i].myID);
				
				if( i == arrLF.length-1 ) 
					updateList = true;
				
				var item:CSListItemFeat = new CSListItemFeat();
				item.setupBaseParams(
						feat.myID,
						feat.myName,
						false
					);
				item.setupLevelParams(
						arrLF[i].currentLevel,  
						arrLF[i].currentLevel, 
						feat.maxLevel 
					);
				this.listFeat.addItem(item, updateList);
				this.listFeat.addLevelChangeListenersToItem(
						this.listFeat.getCountOfItems()-1,
						MouseEvent.MOUSE_DOWN, 
						featLevelChangeHandler
					);
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 */
		public function dispose():void
		{
			this.btnAddFeat.removeEventListener(
					MouseEvent.MOUSE_DOWN,
					clickAddFeatHandler
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setStyle
		 * ---------------------------------------------------------------------
		 * call this from the contructor in your implementation
		 *
		 * @param s
		 */
		public function setStyle(s:int):void
		{
			for( var i:int = 0; i < this.numChildren; i++ )
				if( this.getChildAt(i) is ICSStyleable ) 
					ICSStyleable(this.getChildAt(i)).setStyle(s);
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
		public function updateObjectFromWindow():Pilot
		{
			var obj:Pilot = Pilot(this.winPilot.getObject());
		
			if( !Globals.myRuleConfigs.getIsPilotFeatsActive() )
				return obj;
				
			var arrFeatIDs:Array = this.listFeat.getItemIDs();
			var arrFeatLevels:Array = this.listFeat.getItemLevels();
			var arrLF:Array = new Array();
			
			for( var i:int = 0; i < arrFeatIDs.length; i++ ) 
			{
				var lf:LearnedFeat = new LearnedFeat(arrFeatIDs[i]);
				lf.currentLevel = arrFeatLevels[i];
				arrLF.push(lf);
			}
			obj.setLearnedFeats(arrLF);
			
			return obj;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * hasAceOfAces
		 * ---------------------------------------------------------------------
		 * returns true if pilot has the ace of aces feat
		 *
		 * @return
		 */
		public function hasAceOfAces():Boolean 
		{
			if( !Globals.myRuleConfigs.getIsPilotFeatsActive() )
				return false;
				
			var arrFeatIDs:Array = this.listFeat.getItemIDs();
			if( arrFeatIDs.indexOf(BaseData.HCID_F_ACEOFACES) > -1 )
				return true;
				
			return false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcEP
		 * ---------------------------------------------------------------------
		 */
		public function calcEP():void
		{
			if( !Globals.myRuleConfigs.getIsPilotFeatsActive() )
				return;
			
			var pilotType:String = this.winPilot.getPilotType();
			if( pilotType != Pilot.TYPE_HERO 
					&& pilotType != Pilot.TYPE_SIDEKICK )
				return;
			
			var obj:Pilot = Pilot(this.winPilot.getObject());
			var feat:Feat = null;
			var learnedfeat:LearnedFeat = null;
			var listIDs:Array = this.listFeat.getItemIDs();
			var listLevels:Array = this.listFeat.getItemLevels();
			var arrLearnedFeats:Array = obj.getLearnedFeats();
			var ep:int = 0;
			
			for( var i:int = 0; i < listIDs.length; i++ ) 
			{
				feat = Globals.myBaseData.getFeat(listIDs[i]); 
				learnedfeat = null;
				
				for( var j:int = 0; j < arrLearnedFeats.length; j++ ) 
				{
					if( arrLearnedFeats[j].myID == feat.myID ) 
					{
						learnedfeat = arrLearnedFeats[j];
						break;
					}
				}
				if( learnedfeat != null )
				{	
					// already learned 
					// calculate only feat with levels
					if( feat.maxLevel > 0 ) 
						for( var m:int = learnedfeat.currentLevel; 
								m < listLevels[i]; 
								m++
							) 
							ep += feat.getXPCostForLevel(m);
					
				} else {
					// new feat
					if( feat.maxLevel == 0 )
					{
						ep += feat.getXPCostForLevel(0);
					} else {
						for( var k:int = 0; k < listLevels[i]; k++ ) 
							ep += feat.getXPCostForLevel(k);
					}
				}
			}
			this.winPilot.setFeatEP(ep);
		}					

		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * clickAddFeatHandler
		 * ---------------------------------------------------------------------
		 * 
		 * @param e
		 */
		private function clickAddFeatHandler(e:MouseEvent):void
		{
			var id:String = this.pdFeat.getIDForCurrentSelection();
			
			if( id == CSPullDown.ID_EMPTYSELECTION 
					|| this.listFeat.containsItem(id) )
				return;
				
			var obj:Feat = Globals.myBaseData.getFeat(id);
			var minLvl = 0;
				
			if( obj.maxLevel > 0 ) 
				minLvl = 1;
			
			var item:CSListItemFeat = new CSListItemFeat();
			item.setupBaseParams(
					id,
					obj.myName,
					true
				);
			item.setupLevelParams(
					minLvl,  
					minLvl, 
					obj.maxLevel
				);
			this.listFeat.addItem(item, true);
			
			this.listFeat.addRemoveListenerToItem(
					this.listFeat.getCountOfItems()-1,
					MouseEvent.MOUSE_DOWN, 
					removeFeatHandler
				);
			this.listFeat.addLevelChangeListenersToItem(
					this.listFeat.getCountOfItems()-1,
					MouseEvent.MOUSE_DOWN, 
					featLevelChangeHandler
				);
				
			this.calcEP();
			this.winPilot.calcEP();
			this.winPilot.validateForm();
				
			this.pdFeat.clearSelection();
			this.winPilot.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * featLevelChangeHandler
		 * ---------------------------------------------------------------------
		 * 
		 * @param e
		 */
		private function featLevelChangeHandler(e:MouseEvent):void
		{
			this.calcEP();
			this.winPilot.calcEP();
			this.winPilot.validateForm();
				
			this.winPilot.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * removeFeatHandler
		 * ---------------------------------------------------------------------
		 * 
		 * @param e
		 */
		private function removeFeatHandler(e:MouseEvent):void
		{
			var itemID:String = CSListItemFeat(e.currentTarget.parent).getID();
			this.listFeat.removeItem(itemID);
			
			this.calcEP();
			this.winPilot.calcEP();
			this.winPilot.validateForm();
				
			this.winPilot.setSaved(false);
		}
	
	}
}