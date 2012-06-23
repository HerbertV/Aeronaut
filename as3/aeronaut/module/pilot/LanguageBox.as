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
	
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.Pilot;
	import as3.aeronaut.objects.pilot.LearnedLanguage;
	import as3.aeronaut.objects.baseData.Language;
	
	import as3.aeronaut.module.CSWindowPilot;
	
	
	// =========================================================================
	// LanguageBox
	// =========================================================================
	// This class is linked to library symbol "LanguageBox" inside CSWindowPilot
	// @see as3.aeronaut.objects.Pilot
	//
	public class LanguageBox
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
		public function LanguageBox()
		{
			super();
			
			this.pdLanguage.setEmptySelectionText("",false);
			if( Globals.myRuleConfigs.getIsPilotFeatsActive() ) 
			{
				var arr:Array = Globals.myBaseData.getLanguages();
				for( var i:int = 0; i < arr.length; i++ ) 
					this.pdLanguage.addSelectionItem(
							arr[i].myName, 
							arr[i].myID
						);
				
				this.btnAddLanguage.setupTooltip(
						Globals.myTooltip,
						"Add selected language"
					);
				this.btnAddLanguage.addEventListener(
						MouseEvent.MOUSE_DOWN,
						clickAddLanguageHandler
					);
			
			} else {
				this.pdLanguage.setActive(false);
				this.btnAddLanguage.setActive(false);
				this.listLanguage.setActive(false);
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
			
			this.btnAddLanguage.setActive(true);
			this.pdLanguage.setActive(true);
					
			this.listLanguage.clearList();
			if( pilotType == Pilot.TYPE_GUNNER ) 
			{
				this.btnAddLanguage.setActive(false);
				this.pdLanguage.setActive(false);
				this.pdLanguage.clearSelection();
				
				return;
			}
			
			var arrLL:Array = obj.getLearnedLanguages();
			var updateList:Boolean = false;
			
			for( var i:int = 0; i < arrLL.length; i++ )
			{
				var language:Language = Globals.myBaseData.getLanguage(arrLL[i].myID);
				var isM:String = "";
				
				if( i == arrLL.length-1 ) 
					updateList = true;
				if( arrLL[i].isMotherTongue )
					isM = " (M)";
					
				this.createLanguageItem(
						language.myID,
						language.myName + isM,
						false,
						updateList
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
			
			var arrLanguageIDs:Array = this.listLanguage.getItemIDs();
			var mother:LearnedLanguage = obj.getMotherTongue();
			var arrLL:Array = new Array();
			for( var i:int = 0; i < arrLanguageIDs.length; i++) 
			{
				var isMother:Boolean = false;
				if( mother != null ) 
					if( arrLanguageIDs[i] == mother.myID ) 
						isMother = true;
				
				var ll:LearnedLanguage = new LearnedLanguage(
						arrLanguageIDs[i],
						isMother
					);
				arrLL.push(ll);
			}
			obj.setLearnedLanguages(arrLL);
			
			return obj;
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
			var objcount:int = obj.getLearnedLanguages().length;
			var listcount:int = this.listLanguage.getCountOfItems();
				
			this.winPilot.setLanguageEP(
					(listcount - objcount) 
						* Globals.myBaseData.getLanguageXPCost()
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * createLanguageItem
		 * ---------------------------------------------------------------------
		 * create a new listitem and adds it to the list
		 *
		 * @param id
		 * @param name
		 * @param removable
		 * @param updateList
		 */
		public function createLanguageItem(
				id:String,
				name:String,
				removeable:Boolean,
				updateList:Boolean
			):void
		{
			var item:ListItem150 = new ListItem150();
			item.setupBaseParams(
					id,
					name,
					removeable
				);
			this.listLanguage.addItem(item, updateList);
			if( removeable )
				this.listLanguage.addRemoveListenerToItem(
						this.listLanguage.getCountOfItems()-1,
						MouseEvent.MOUSE_DOWN, 
						removeLanguageHandler
					);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * removeLanguageItem
		 * ---------------------------------------------------------------------
		 * @param id
		 */
		public function removeLanguageItem(id:String):void
		{
			this.listLanguage.removeItem(id);
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * clickAddLanguageHandler
		 * ---------------------------------------------------------------------
		 * 
		 * @param e
		 */
		private function clickAddLanguageHandler(e:MouseEvent):void
		{
			var id:String = this.pdLanguage.getIDForCurrentSelection();
			
			if( id == CSPullDown.ID_EMPTYSELECTION 
					|| this.listLanguage.containsItem(id) )
				return;
				
			var obj:Language = Globals.myBaseData.getLanguage(id);
			
			this.createLanguageItem(
					id,
					obj.myName,
					true,
					true
				);
			
			this.calcEP();
			this.winPilot.calcEP();
			this.winPilot.validateForm();
				
			this.pdLanguage.clearSelection();
			this.winPilot.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * removeLanguageHandler
		 * ---------------------------------------------------------------------
		 * 
		 * @param e
		 */
		private function removeLanguageHandler(e:MouseEvent):void
		{
			var itemID:String = CSListItem(e.currentTarget.parent).getID();
			this.listLanguage.removeListItem(itemID);
			
			this.calcEP();
			this.winPilot.calcEP();
			this.winPilot.validateForm();
			
			this.winPilot.setSaved(false);
		}
		
	}
}