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
 * Copyright (c) 2009-2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.gui
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import flash.text.TextField;
	import flash.text.TextFormat;

	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
 	import fl.transitions.easing.*;
	
	// =========================================================================
	// CSListFeat
	// =========================================================================
	// special feat list
	// FF5 house rule
	public class CSListFeat 
			extends CSAbstractList 
	{
		// =====================================================================
		// Variables
		// =====================================================================
		private var listLevels:Array = new Array();
		
		// =====================================================================
		// Contructor
		// =====================================================================
		public function CSListFeat()
		{
			super();
			
			this.maxVisibleItems = 6;
			this.itemHeight = 30;
			this.contVisibleHeight = 180;
			this.scrollWheelSpeed = 3.0;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * addItem
		 * ---------------------------------------------------------------------
		 * @param item 
		 * @param update if you want to update the view
		 */
		override public function addItem(
				item:CSAbstractListItem,
				update:Boolean=false
			):void
		{
			super.addItem(item,update);
			
			this.listLevels.push(item.getLevel());
			
			item.getUpButton().addEventListener(
					MouseEvent.MOUSE_DOWN,
					updateLevelHandler
				);
			item.getDownButton().addEventListener(
					MouseEvent.MOUSE_DOWN,
					updateLevelHandler
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * removeItem
		 * ---------------------------------------------------------------------
		 * @param id
		 *
		 * @return index of the item
		 */
		override public function removeItem(id:String):int
		{
			var idx:int = super.removeItem(id);
			
			if( idx == -1 )
				return idx;
			
			this.listLevels.splice(idx,1);
			
			return idx;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * addLevelChangeListenersToItem
		 * ---------------------------------------------------------------------
		 * for external EP calculation
		 *
		 * @param idx
		 * @param eventType (e.g. MouseEvent.MOUSE_UP)
		 * @param levelchangeCallback
		 */
		public function addLevelChangeListenersToItem(
				idx:int, 
				eventType:String, 
				levelchangeCallback:Function
			):void 
		{
			var item:CSListItemFeat = CSListItemFeat(
					this.containerItems.getChildAt(idx)
				);
			
			item.getUpButton().addEventListener(
					eventType,
					levelchangeCallback
				);
			item.getDownButton().addEventListener(
					eventType,
					levelchangeCallback
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getItemLevels
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getItemLevels():Array
		{
			return this.listLevels;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clearItemList
		 * ---------------------------------------------------------------------
		 * removes all items
		 */
		override public function clearList():void
		{
			super.clearList();
			this.listLevels = new Array();
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * updateLevelHandler
		 * ---------------------------------------------------------------------
		 * for updating the internal feat level array.
		 *
		 * @param e
		 */
		private function updateLevelHandler(e:MouseEvent):void
		{
			var item:CSListItemFeat = CSListItemFeat(e.currentTarget.parent);
			var idx:int = this.listIDs.indexOf(item.getID());
			
			this.listLevels[idx] = item.getLevel();
		}
		
	}
}
