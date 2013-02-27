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
	// CSAbstractList
	// =========================================================================
	// Dynamic abstract List class 
	// lists have variable height. 
	// the width debends on thier items.
	//
	// Any List needs following sub mc's:
	// - sbtnTop
	// - sbtnOneUp
	// - sbtnOneDown
	// - sbtnBottom
	// - myMask (a masking mc)
	// - containerItems ( emtpy container for items )
	// - BG_open_black
	// - BG_open_white
	//
	dynamic public class CSAbstractList 
			extends MovieClip 
			implements ICSStyleable
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const POS0_CONTAINER:int = 2;
		
		// =====================================================================
		// Variables
		// =====================================================================
		protected var myStyle:int = CSStyle.BLACK;
		
		// stores CSAbstracteListItem's
		protected var listItems:Array = new Array();
		// stores the items ids
		protected var listIDs:Array = new Array();
		
		protected var myContainerTween:Tween = null;
		protected var targetPosContainer:int = POS0_CONTAINER;
		
		protected var maxVisibleItems:int = 10;
		protected var itemHeight:int = 20;
		protected var contVisibleHeight:int = 200;
		
		protected var scrollWheelSpeed:Number = 1.0;
		
		protected var isActive:Boolean = true;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function CSAbstractList()
		{
			super();

			this.addEventListener(
					MouseEvent.MOUSE_WHEEL,
					scrollWheelHandler
				);
			this.sbtnTop.addEventListener(
					MouseEvent.MOUSE_DOWN,
					scrollTopHandler
				);
			this.sbtnOneUp.addEventListener(
					MouseEvent.MOUSE_DOWN,
					scrollOneUpHandler
				);
			this.sbtnOneDown.addEventListener(
					MouseEvent.MOUSE_DOWN,
					scrollOneDownHandler
				);
			this.sbtnBottom.addEventListener(
					MouseEvent.MOUSE_DOWN,
					scrollBottomHandler
				);
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * setStyle
		 * ---------------------------------------------------------------------
		 * @param s
		 */
		public function setStyle(s:int):void 
		{
			this.myStyle = s;
			this.updateView();
			
			this.sbtnTop.setStyle(s);
			this.sbtnOneUp.setStyle(s);
			this.sbtnOneDown.setStyle(s);
			this.sbtnBottom.setStyle(s);
			
			for( var i:uint = 0; i< this.containerItems.numChildren; i++ )
				this.containerItems.getChildAt(i).setStyle(s);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setActive
		 * ---------------------------------------------------------------------
		 * @param a
		 */
		public function setActive(a:Boolean):void 
		{
			this.sbtnTop.setActive(a);
			this.sbtnOneUp.setActive(a);
			this.sbtnOneDown.setActive(a);
			this.sbtnBottom.setActive(a);
			
			this.isActive = a;
			this.updateView();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getIsActive
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getIsActive():Boolean 
		{
			return this.isActive;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * addItem
		 * ---------------------------------------------------------------------
		 * @param item 
		 * @param update if you want to update the view
		 */
		public function addItem(
				item:CSAbstractListItem,
				update:Boolean=false
			):void
		{
			item.y = this.listItems.length* item.height;
			
			this.containerItems.addChild(item);
			this.listItems.push(item);
			this.listIDs.push(item.getID());
			
			this.itemHeight = item.height;
			
			if( update ) 
				this.updateView();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * removeItem
		 * ---------------------------------------------------------------------
		 * @param id
		 *
		 * @return index of the item
		 */
		public function removeItem(id:String):int
		{
			var idx:int = this.listIDs.indexOf(id);
			
			if( idx == -1 )
				return idx;
			
			this.containerItems.removeChildAt(idx);
			this.listItems.splice(idx,1);
			this.listIDs.splice(idx,1);
				
			//reposition remaining items
			for( var i:int=0; i< this.containerItems.numChildren; i++ ) 
				this.containerItems.getChildAt(i).y = i * this.itemHeight;
				
			this.updateView();
			
			return idx;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getCountOfItems
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getCountOfItems():int
		{
			return this.containerItems.numChildren;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * containsItem
		 * ---------------------------------------------------------------------
		 * @param id
		 *
		 * @return
		 */
		public function containsItem(id:String):Boolean
		{
			if( listIDs.indexOf(id) > -1 ) 
				return true;
			
			return false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getItemIDs
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getItemIDs():Array
		{
			return this.listIDs;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setItemIsInvalid
		 * ---------------------------------------------------------------------
		 * @param idx
		 * @param invalid
		 */
		public function setItemIsInvalid(
				idx:int,
				invalid:Boolean
			):void
		{
			CSAbstractListItem(this.listItems[idx]).setInvalid(invalid);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * addRemoveListenerToItem
		 * ---------------------------------------------------------------------
		 * to add a custom remove item listener for each implementation.
		 *
		 * @param idx
		 * @param eventType (e.g. MouseEvent.MOUSE_UP)
		 * @param removeCallback
		 */
		public function addRemoveListenerToItem(
				idx:int, 
				eventType:String, 
				removeCallback:Function
			):void 
		{
			var item:CSAbstractListItem = CSAbstractListItem(
					this.containerItems.getChildAt(idx)
				);
			
			item.getRemoveButton().addEventListener(
					eventType,
					removeCallback
				);
		}
		/**
		 * ---------------------------------------------------------------------
		 * setMaxVisibleItems
		 * ---------------------------------------------------------------------
		 * @param max
		 */
		public function setMaxVisibleItems(max:int):void
		{
			this.maxVisibleItems = max;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clearItemList
		 * ---------------------------------------------------------------------
		 * removes all items
		 */
		public function clearList():void
		{
			this.listItems = new Array();
			this.listIDs = new Array();
			
			while( this.containerItems.numChildren > 0 )
				this.containerItems.removeChildAt(0);
			
			this.updateView();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateView
		 * ---------------------------------------------------------------------
		 */
		public function updateView():void
		{
			this.sbtnTop.visible = true;
			this.sbtnOneUp.visible = true;
			this.sbtnOneDown.visible = true;
			this.sbtnBottom.visible = true;
			this.containerItems.visible = true;
			
			if( this.myStyle == CSStyle.BLACK )
			{
				this.BG_open_black.visible = true;
				this.BG_open_white.visible = false;
				
			} else if( this.myStyle == CSStyle.WHITE ) {
				this.BG_open_white.visible = true;
				this.BG_open_black.visible = false;
			}
			this.updateScrollButtons();
			this.resizeSelectionMask();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * resizeSelectionMask
		 * ---------------------------------------------------------------------
		 */
		protected function resizeSelectionMask():void
		{
			var currHeight:int = 0;
			var offset:int = 1;
			if( this.maxVisibleItems > this.listItems.length ) 
			{
				currHeight = this.listItems.length * itemHeight + offset;
			} else {
				currHeight = this.maxVisibleItems * itemHeight + offset;
			}
			
			this.contVisibleHeight = currHeight;
			this.myMask.height = currHeight;
			this.sbtnBottom.y = currHeight - this.sbtnBottom.height;
			this.sbtnOneDown.y = this.sbtnBottom.y - 30;
			
			// 120 is the height need for all four scrollbuttons
			if( currHeight < 120 ) 
			{
				this.sbtnTop.visible = false;
				this.sbtnOneUp.visible = false;
				this.sbtnOneDown.visible = false;
				this.sbtnBottom.visible = false;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateScrollButtons
		 * ---------------------------------------------------------------------
		 */
		protected function updateScrollButtons():void
		{
			var maxPos:int = POS0_CONTAINER 
					- this.containerItems.height + this.contVisibleHeight;
				
			if( this.targetPosContainer >= POS0_CONTAINER )
			{
				this.sbtnTop.setActive(false);
				this.sbtnOneUp.setActive(false);
			} else {
				this.sbtnTop.setActive(true);
				this.sbtnOneUp.setActive(true);
			}
			
			if( this.targetPosContainer <= maxPos )
			{
				this.sbtnOneDown.setActive(false);
				this.sbtnBottom.setActive(false);
			} else {
				this.sbtnOneDown.setActive(true);
				this.sbtnBottom.setActive(true);
			}
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * scrollWheelHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		protected function scrollWheelHandler(e:MouseEvent):void
		{
			if( this.maxVisibleItems >= this.listItems.length )
				return;

			var maxPos:int = POS0_CONTAINER
					- this.containerItems.height + this.contVisibleHeight;
			
			// update current position
			this.containerItems.y += e.delta * scrollWheelSpeed;
			
			// limit scrolling
			if( this.containerItems.y > POS0_CONTAINER 
					&& e.delta > 0)
				this.containerItems.y = POS0_CONTAINER;
			
			if( (this.containerItems.y - this.itemHeight ) < maxPos 
					&& e.delta < 0 ) 
				this.containerItems.y = maxPos;
			
			// update scrollbuttons
			this.targetPosContainer = this.containerItems.y;
			this.updateScrollButtons();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * scrollTopHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		protected function scrollTopHandler(e:MouseEvent):void
		{
			var sbtn:CSButtonStyled = CSButtonStyled(e.currentTarget);
			if( !sbtn.getIsActive() )
				return;
				
			if (this.myContainerTween != null) 
				this.myContainerTween.stop();
				
			this.targetPosContainer = POS0_CONTAINER;
			this.myContainerTween = new Tween(
					this.containerItems, 
					"y", 
					Regular.easeOut, 
					this.containerItems.y, 
					this.targetPosContainer, 
					1.0, 
					true
				);
				
			this.updateScrollButtons();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * scrollOneUpHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		protected function scrollOneUpHandler(e:MouseEvent):void
		{
			var sbtn:CSButtonStyled = CSButtonStyled(e.currentTarget);
			if( !sbtn.getIsActive() ) 
				return;
				
			if( this.myContainerTween != null ) 
				this.myContainerTween.stop();
				
			if( (this.targetPosContainer + this.itemHeight ) < POS0_CONTAINER )
			{
				this.targetPosContainer = this.targetPosContainer + this.itemHeight;
			} else {
				this.targetPosContainer = POS0_CONTAINER;
			}
				
			this.myContainerTween = new Tween(
					this.containerItems, 
					"y",
					None.easeIn, 
					this.containerItems.y, 
					this.targetPosContainer, 
					0.4, 
					true
				);
				
			this.updateScrollButtons();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * scrollOneUpHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		protected function scrollOneDownHandler(e:MouseEvent):void
		{
			var sbtn:CSButtonStyled = CSButtonStyled(e.currentTarget);
			if( !sbtn.getIsActive() )
				return;
				
			if( this.myContainerTween != null )
				this.myContainerTween.stop();
				
			var maxPos:int = POS0_CONTAINER
					- this.containerItems.height + this.contVisibleHeight;
			
			if( (this.targetPosContainer - this.itemHeight ) > maxPos ) 
			{
				this.targetPosContainer = this.targetPosContainer - this.itemHeight;
			} else {
				this.targetPosContainer = maxPos;
			}
				
			this.myContainerTween = new Tween(
					this.containerItems, 
					"y", 
					None.easeIn, 
					this.containerItems.y, 
					this.targetPosContainer, 
					0.4, 
					true
				);
				
			this.updateScrollButtons();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * scrollOneUpHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		protected function scrollBottomHandler(e:MouseEvent):void
		{
			var sbtn:CSButtonStyled = CSButtonStyled(e.currentTarget);
			if( !sbtn.getIsActive() ) 
				return;
				
			if( this.myContainerTween != null ) 
				this.myContainerTween.stop();
			
			this.targetPosContainer = POS0_CONTAINER 
					- this.containerItems.height + this.contVisibleHeight;
					
			this.myContainerTween = new Tween(
					this.containerItems, 
					"y", 
					Regular.easeOut, 
					this.containerItems.y, 
					this.targetPosContainer, 
					1.0, 
					true
				);
				
			this.updateScrollButtons();
		}
		
	}
}
