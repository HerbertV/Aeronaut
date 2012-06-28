﻿/*
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
	// CSPullDown
	// =========================================================================
	//
	public class CSPullDown 
			extends MovieClip 
			implements ICSStyleable
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const POS0_CONTAINER:int = 32;
		public static const ID_EMPTYSELECTION:String = "!THISISEMPTY!";
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var myStyle:int = CSStyle.BLACK;
				
		private var isActive:Boolean = true;
		private var isOpen:Boolean = false;
		
		private var emptySelectionText:String = "";
		private var showEmptySelectionInList:Boolean = false;
		
		private var currentSelectionIdx:int = -1;
		private var lastSelectionIdx:int = -1;
							
		private var selectionItems:Array = new Array();
		private var selectionIDs:Array = new Array();
		
		private var myContainerTween:Tween = null;
		private var targetPosContainer:int = POS0_CONTAINER;
		
		private var maxVisibleItems:int = 10;
		private var itemHeight:int = 21;
		private var contVisibleHeight:int = 220;
		
		private var scrollWheelSpeed:Number = 3.0;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function CSPullDown()
		{
			super();
			
			//this.BG_black.visible = false;
			this.BG_white.visible = false;
			this.frame_white.visible = false;
			//this.frame_black.visible = false;
			
			this.txtValue.text = "";
			this.switchPullDownList();
			
			this.addEventListener(
					MouseEvent.ROLL_OUT,
					closePullDownHandler
				);
			this.addEventListener(
					MouseEvent.MOUSE_WHEEL, 
					onMouseWheelEvent
				);
			
			this.btnOpen.addEventListener(
					MouseEvent.MOUSE_DOWN,
					openPullDownHandler
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
		 * toString
		 * ---------------------------------------------------------------------
		 * @return
		 */
		override public function toString():String
		{
			var str:String = "gui.CSPullDown [selectionIDs="
					+selectionIDs.length 
					+ ", selectionItems="
					+ selectionItems.length
					+ ", containerItems=" 
					+ containerItems.numChildren;
			
			for( var i:int=0; i<selectionIDs.length; i++) 
				str += "\n - "+ selectionIDs[i];
			
			return str +"\n ]";
		}
		
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
			
			this.btnOpen.setStyle(s);
			this.sbtnTop.setStyle(s);
			this.sbtnOneUp.setStyle(s);
			this.sbtnOneDown.setStyle(s);
			this.sbtnBottom.setStyle(s);
			
			for( var i:uint = 0; i< this.selectionItems.length; i++ )
				selectionItems[i].setStyle(s);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setEmptySelectionText
		 * ---------------------------------------------------------------------
		 * @param s
		 * @param showInList
		 */
		public function setEmptySelectionText(
				s:String,
				showInList:Boolean
			):void
		{
			this.emptySelectionText = s;
			this.showEmptySelectionInList = showInList;
			
			if( currentSelectionIdx == -1 )
				this.txtValue.text = this.emptySelectionText;
			
			if( this.showEmptySelectionInList ) 
				this.addSelectionItem(s,ID_EMPTYSELECTION);
			
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * addSelectionItem
		 * ---------------------------------------------------------------------
		 * @param lbl
		 * @param id
		 */
		public function addSelectionItem(
				lbl:String, 
				id:String
			):void
		{
			var newitem:CSPullDownSelectionItem = new CSPullDownSelectionItem();
			
			newitem.setStyle(this.myStyle);
			newitem.setLabel(lbl);
			newitem.resizeWidth(this.txtValue.width);
			
			newitem.y = this.selectionItems.length * newitem.height;
			
			newitem.addEventListener(
					MouseEvent.MOUSE_DOWN,
					clickItemHandler
				);
			
			this.containerItems.addChild(newitem);
			this.selectionItems.push(newitem);
			this.selectionIDs.push(id);
			
			this.itemHeight = newitem.height;
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
		 * clearSelectionItemList
		 * ---------------------------------------------------------------------
		 */
		public function clearSelectionItemList():void
		{
			this.selectionItems = new Array();
			this.selectionIDs = new Array();
			
			while( this.containerItems.numChildren > 0 )
				this.containerItems.removeChildAt(0);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clearSelection
		 * ---------------------------------------------------------------------
		 */
		public function clearSelection()
		{
			this.currentSelectionIdx = -1;
			this.txtValue.text = this.emptySelectionText;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setActiveSelectionItem
		 * ---------------------------------------------------------------------
		 * @param id
		 */
		public function setActiveSelectionItem(id:String)
		{
			var idx:int = this.selectionIDs.indexOf(id);
			
			if( idx != -1 ) 
			{
				this.txtValue.text = this.selectionItems[idx].getLabel();
				this.currentSelectionIdx = idx;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getIDForCurrentSelection
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getIDForCurrentSelection():String
		{
			if( currentSelectionIdx > -1 ) 
				return this.selectionIDs[currentSelectionIdx];
			
			return ID_EMPTYSELECTION;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getIDForLastSelection
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getIDForLastSelection():String
		{
			if( lastSelectionIdx > -1 )
				return this.selectionIDs[lastSelectionIdx];
			
			return ID_EMPTYSELECTION;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setActive
		 * ---------------------------------------------------------------------
		 * @param a
		 */
		public function setActive(a:Boolean):void
		{
			this.isActive = a;
			
			this.btnOpen.setActive(a);
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
		 * updateView
		 * ---------------------------------------------------------------------
		 */
		public function updateView():void
		{
			this.BG_black.visible = false;
			this.BG_white.visible = false;
			this.frame_white.visible = false;
			this.frame_black.visible = false;
			
			this.frame_black.alpha = 1.0;
			this.frame_white.alpha = 1.0;
						
			if( this.myStyle == CSStyle.BLACK ) 
			{
				this.BG_black.visible = true;
				this.frame_black.visible = true;
				
				if( !this.isActive ) 
				{
					this.txtValue.textColor = 0xB1B1B1;
					this.frame_black.alpha = 0.2;
				} else {
					this.txtValue.textColor = 0x000000;
				}
				return;
			} 
			if( this.myStyle == CSStyle.WHITE )
			{
				this.BG_white.visible = true;
				this.frame_white.visible = true;
			
				if ( !this.isActive )
				{
					this.txtValue.textColor = 0xB1B1B1;
					this.frame_white.alpha = 0.2;
				} else {
					this.txtValue.textColor = 0xFFFFFF;
				}
				return;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * switchPullDownList
		 * ---------------------------------------------------------------------
		 */
		private function switchPullDownList()
		{
			this.BG_open_white.visible = false;
			this.BG_open_black.visible = false;
			this.sbtnTop.visible = false;
			this.sbtnOneUp.visible = false;
			this.sbtnOneDown.visible = false;
			this.sbtnBottom.visible = false;
			
			this.containerItems.visible = false;
			
			if( this.isOpen ) 
			{
				this.sbtnTop.visible = true;
				this.sbtnOneUp.visible = true;
				this.sbtnOneDown.visible = true;
				this.sbtnBottom.visible = true;
				this.containerItems.visible = true;
				
				if( this.myStyle == CSStyle.BLACK )
				{
					this.BG_open_black.visible = true;
				} else if( this.myStyle == CSStyle.WHITE ) {
					this.BG_open_white.visible = true;
				}
				this.updateScrollButtons();
				this.resizeSelectionMask();
				
			} else if (this.myContainerTween != null) {
				this.myContainerTween.stop();
				this.containerItems.y = POS0_CONTAINER;
				this.targetPosContainer = POS0_CONTAINER;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * resizeSelectionMask
		 * ---------------------------------------------------------------------
		 */
		private function resizeSelectionMask()
		{
			var currHeight:int = 0;
			var offset:int = 1;
			
			if( this.maxVisibleItems > this.selectionItems.length )
			{
				currHeight = this.selectionItems.length * itemHeight + offset;
			} else {
				currHeight = this.maxVisibleItems * itemHeight + offset;
			}
			
			this.BG_open_white.height = currHeight;
			this.BG_open_black.height = currHeight;
			this.contVisibleHeight = currHeight;
			this.myMask.height = currHeight +2;
			this.sbtnBottom.y = 32 + currHeight - this.sbtnBottom.height;
			this.sbtnOneDown.y = this.sbtnBottom.y - 30;
			
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
		private function updateScrollButtons()
		{
			var maxPos:int = POS0_CONTAINER 
					- this.containerItems.height 
					+ this.contVisibleHeight;
				
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
		 * onMouseWheelEvent
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function onMouseWheelEvent(e:MouseEvent):void
		{
			if( !this.isActive )
				return;
			
			if( !this.isOpen )
				return;
				
			var maxPos:int = POS0_CONTAINER 
					- this.containerItems.height 
					+ this.contVisibleHeight;
			
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
		 * openPullDownHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function openPullDownHandler(e:MouseEvent):void
		{
			if( !this.isActive )
				return;
				
			this.isOpen = !this.isOpen;
			this.switchPullDownList();
			
			this.parent.setChildIndex(
					this,
					this.parent.numChildren-1
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * closePullDownHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function closePullDownHandler(e:MouseEvent):void
		{
			if( !this.isActive )
				return;
				
			if( this.isOpen == true )
			{
				this.isOpen = false;
				this.switchPullDownList();
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clickItemHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickItemHandler(e:MouseEvent):void
		{
			var citem:CSPullDownSelectionItem = CSPullDownSelectionItem(
					e.currentTarget
				);
			
			if( !citem.getIsActive() ) 
				return;
				
			for( var i:int=0; i<this.selectionItems.length; i++ )
			{
				if( this.selectionItems[i] == citem ) 
				{
					this.lastSelectionIdx = this.currentSelectionIdx;
					this.currentSelectionIdx = i;
					this.txtValue.text = citem.getLabel();
					this.openPullDownHandler(null);
					citem.resetState();
					break;
				}
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * scrollTopHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function scrollTopHandler(e:MouseEvent):void
		{
			var sbtn:CSButtonStyled = CSButtonStyled(e.currentTarget);
			
			if( !sbtn.getIsActive() )
				return;
				
			if( this.myContainerTween != null )
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
		private function scrollOneUpHandler(e:MouseEvent):void
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
		 * scrollOneDownHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function scrollOneDownHandler(e:MouseEvent):void
		{
			var sbtn:CSButtonStyled = CSButtonStyled(e.currentTarget);
			
			if( !sbtn.getIsActive() )
				return;
				
			if( this.myContainerTween != null )
				this.myContainerTween.stop();
				
			var maxPos:int = POS0_CONTAINER 
					- this.containerItems.height 
					+ this.contVisibleHeight;
			
			if( (this.targetPosContainer - this.itemHeight ) > maxPos )
			{
				this.targetPosContainer = this.targetPosContainer - this.itemHeight;
			} else {
				this.targetPosContainer = maxPos ;
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
		 * scrollBottomHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function scrollBottomHandler(e:MouseEvent):void
		{
			var sbtn:CSButtonStyled = CSButtonStyled(e.currentTarget);
			
			if( !sbtn.getIsActive() )
				return;
				
			if( this.myContainerTween != null )
				this.myContainerTween.stop();
				
			this.targetPosContainer = POS0_CONTAINER
					- this.containerItems.height 
					+ this.contVisibleHeight;
					
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
