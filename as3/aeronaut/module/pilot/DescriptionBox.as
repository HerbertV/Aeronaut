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
 * Copyright (c) 2009-2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.module.pilot
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import flash.events.MouseEvent;
	import flash.events.FocusEvent;

	import as3.aeronaut.gui.*;
	
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.Pilot;
	
	import as3.aeronaut.module.CSWindowPilot;
	
	
	// =========================================================================
	// DescriptionBox
	// =========================================================================
	// This class is linked to library symbol "DescriptionBox" inside CSWindowPilot
	// @see as3.aeronaut.objects.Pilot
	//
	public class DescriptionBox
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
		public function DescriptionBox()
		{
			super();
			
			this.txtDescription.addEventListener(
					MouseEvent.MOUSE_WHEEL, 
					wheelHandler
				);
			this.txtDescription.addEventListener(
					FocusEvent.FOCUS_OUT, 
					focusLostHandler
				);
			this.btnDescScrollUp.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickScrollUpHandler
				);
			this.btnDescScrollDown.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickScrollDownHandler
				);
			
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
			var obj:Pilot = Pilot(this.winPilot.getObject());
			
			this.txtDescription.text = obj.getDescription();
			this.updateScrollButtons();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 */
		public function dispose():void
		{
			this.txtDescription.removeEventListener(
					MouseEvent.MOUSE_WHEEL, 
					wheelHandler
				);
			this.txtDescription.removeEventListener(
					FocusEvent.FOCUS_OUT, 
					focusLostHandler
				);
			this.btnDescScrollUp.removeEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickScrollUpHandler
				);
			this.btnDescScrollDown.removeEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickScrollDownHandler
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
		 * updateScrollButtons
		 * ---------------------------------------------------------------------
		 */
		public function updateScrollButtons():void
		{
			if( this.txtDescription.scrollV > 1 )
			{
				this.btnDescScrollUp.setActive(true);
			} else {
				this.btnDescScrollUp.setActive(false);
			}
			
			if( this.txtDescription.scrollV < this.txtDescription.maxScrollV )
			{
				this.btnDescScrollDown.setActive(true);
			} else {
				this.btnDescScrollDown.setActive(false);
			}
		}
		
		// =====================================================================
		// Event handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * wheelHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function wheelHandler(e:MouseEvent):void
		{
			this.updateScrollButtons();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * focusLostHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function focusLostHandler(e:FocusEvent):void
		{
			this.updateScrollButtons();
			this.winPilot.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clickScrollUpHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickScrollUpHandler(e:MouseEvent):void
		{
			if( !this.btnDescScrollUp.getIsActive() )
				return;
			
			this.txtDescription.scrollV -=1;
			this.updateScrollButtons();
			
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clickScrollDownHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickScrollDownHandler(e:MouseEvent):void
		{
			if( !this.btnDescScrollDown.getIsActive() )
				return;
			
			this.txtDescription.scrollV +=1;
			this.updateScrollButtons();
		}
		
	}
}