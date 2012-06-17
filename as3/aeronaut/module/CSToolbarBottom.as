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
package as3.aeronaut.module
{
	// MDM ZINC Lib
	import mdm.*;
		
	import flash.display.MovieClip;
	
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
 	import fl.transitions.easing.*;
	
	import as3.hv.core.net.AbstractModule;
	import as3.hv.components.progress.IProgressSymbol;
		
	import as3.aeronaut.Globals;
	import as3.aeronaut.CSDialogs;
	
	import as3.aeronaut.print.IPrintable;
	import as3.aeronaut.gui.*;
	import as3.aeronaut.module.toolbar.*;
	
	// =========================================================================
	// Class CSToolbarBottom
	// =========================================================================
	// The toolbar.
	// Also used for in-app-help and "modal popups"
	// This class is a linked document class to "modToolbar.swf"
	//
	public class CSToolbarBottom 
			extends AbstractModule 
			implements ICSToolbarBottom
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const TOOLBAR_CLOSE_POS:int = 690;
		public static const TOOLBAR_OPEN_POS:int = 250;
						
		public static const TBSTATE_CLOSED:int = 0;
		public static const TBSTATE_HELP:int = 1;
		public static const TBSTATE_ADDEP:int = 2;
		public static const TBSTATE_OPTIONS:int = 3;
		
		public static const HEADLINE_CLOSED:String = "AE-Tool-Book";
		public static const HEADLINE_HELP:String = "Help";
		public static const HEADLINE_ADDEP:String = "Add Experience and Mission Update";
		public static const HEADLINE_OPTIONS:String = "Options";
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var toolbarState:int=0;
		private var myMovementTweenY:Tween = null;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function CSToolbarBottom()
		{
			super();
			
			this.moduleVersion = Globals.version;
			this.y = TOOLBAR_CLOSE_POS;
			
			// loading symbol
			this.myProgress.visible = false;
						
			this.lblHeadline.htmlText ="<b>"+HEADLINE_CLOSED+"</b>";
			
			// Do style
			for( var i:int = 0; i < this.numChildren; i++ )
				if( this.getChildAt(i) is ICSStyleable ) 
					ICSStyleable(this.getChildAt(i)).setStyle(CSStyle.BLACK);
		}
	
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * init
		 * ---------------------------------------------------------------------
		 */
		override public function init():void
		{
			this.btnNew.setupTooltip(
					Globals.myTooltip,
					"New <i>(CTRL+N)</i>"
				);
			this.btnNew.setActive(false);
			this.btnNew.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickNewHandler
				);
			
			this.btnOpen.setupTooltip(
					Globals.myTooltip,
					"Open File <i>(CTRL+L)</i>"
				);
			this.btnOpen.setActive(true);
			this.btnOpen.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickOpenHandler
				);
			
			this.btnSave.setupTooltip(
					Globals.myTooltip,
					"Save File <i>(CTRL+S)</i>"
				);
			this.btnSave.setActive(false);
			this.btnSave.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickSaveHandler
				);
			
			this.btnDelete.setupTooltip(
					Globals.myTooltip,
					"Delete <i>(CTRL+D)</i>"
				);
			this.btnDelete.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickDeleteHandler
				);
			
			this.btnPrint.setupTooltip(
					Globals.myTooltip,
					"Print <i>(CTRL+P)</i>"
				);
			this.btnPrint.setActive(false);
			this.btnPrint.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickPrintHandler
				);
			
			this.btnOptions.setupTooltip(
					Globals.myTooltip,
					"Options"
				);
			this.btnOptions.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickOptionsHandler
				);
			
			this.btnHelp.setupTooltip(
					Globals.myTooltip,
					"Help"
				);
			this.btnHelp.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickHelpHandler
				);
			this.btnClose.setActive(false);
			this.btnClose.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickCloseHandler
				);
			this.btnClose.setupTooltip(
					Globals.myTooltip,
					"Close Tool Book"
				);
			
			// Toolbook Pages
			this.hideToolbookPages();
			this.tbPageHelp.setup(this.myProgress);
			this.tbPageOptions.setup();
			this.tbPagePilotEP.setup();
			
			//add toolbar shorcut listener
			this.stage.addEventListener(
					KeyboardEvent.KEY_DOWN, 
					keyDownHandler
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 */
		override public function dispose():void
		{
			// since the toolbar is never removed during runtime there in
			// nothing to do here.
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * hideToolbookPages
		 * ---------------------------------------------------------------------
		 */
		private function hideToolbookPages()
		{
			this.tbPageHelp.visible = false;
			this.tbPageOptions.visible = false;
			this.tbPagePilotEP.visible = false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * changeState
		 * ---------------------------------------------------------------------
		 * @param newState
		 */
		public function changeState(newState:int):void
		{
			if( this.toolbarState == newState )
				return;
				
			//if book was closed open it
			if( this.toolbarState == TBSTATE_CLOSED )
			{
				this.openBook();
				this.btnClose.setActive(true);
			}
			
			// switch states
			this.hideToolbookPages();
			
			switch( newState )
			{
				case TBSTATE_CLOSED:
					this.lblHeadline.htmlText = "<b>" 
							+ HEADLINE_CLOSED + "</b>";
					this.btnClose.setActive(false);
					this.closeBook();
					break;
				
				case TBSTATE_HELP:
					this.lblHeadline.htmlText = "<b>" 
							+ HEADLINE_HELP + "</b>";
					this.tbPageHelp.showPage();
					break;
				
				case TBSTATE_ADDEP:
					this.lblHeadline.htmlText = "<b>" 
							+ HEADLINE_ADDEP + "</b>";
					this.tbPagePilotEP.showPage();
					break;
					
				case TBSTATE_OPTIONS:
					this.lblHeadline.htmlText = "<b>" 
							+ HEADLINE_OPTIONS + "</b>";
					this.tbPageOptions.showPage();
					break;
					
				default:
					break;
			}
				
			this.toolbarState = newState;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateEPInfosFromPilot
		 * ---------------------------------------------------------------------
		 * prepares the data from the active pilot window
		 *
		 * @param win
		 * @param mission
		 * @param currentCO
		 */
		public function updateEPInfosFromPilot(
				win:ICSWindowPilot,
				mission:int,
				currentCO:int
			):void
		{
			this.tbPagePilotEP.updateEPInfosFromPilot(
					win,
					mission,
					currentCO
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * stopTween
		 * ---------------------------------------------------------------------
		 */
		private function stopTween()
		{
			if( this.myMovementTweenY == null)
				return;
				
			if( this.myMovementTweenY.isPlaying )
				this.myMovementTweenY.stop();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * openBook
		 * ---------------------------------------------------------------------
		 */
		public function openBook():void
		{
			this.stopTween();
			this.myMovementTweenY = new Tween(
					this, 
					"y", 
					Regular.easeOut, 
					this.y, 
					TOOLBAR_OPEN_POS, 
					1.5, 
					true
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * closeBook
		 * ---------------------------------------------------------------------
		 */
		public function closeBook():void
		{
			this.stopTween();
			this.myMovementTweenY = new Tween(
					this, 
					"y", 
					Regular.easeOut, 
					this.y, 
					TOOLBAR_CLOSE_POS, 
					0.5, 
					true
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateToolbar
		 * ---------------------------------------------------------------------
		 */
		public function updateToolbar():void
		{
			if( Globals.myWindowManager.getActiveWindow() != null )
			{
				this.btnNew.setActive(true);
				this.btnOpen.setActive(true);
				this.btnSave.setActive(true);
				if( Globals.myWindowManager.getActiveWindow() is IPrintable )
				{ 
					this.btnPrint.setActive(true);
				} else {
					this.btnPrint.setActive(false);
				}
				
			} else {
				this.btnNew.setActive(false);
				this.btnOpen.setActive(true);
				this.btnSave.setActive(false);
				this.btnPrint.setActive(false);
			}
		}
		
		// =====================================================================
		// EventHandler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * clickNewHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickNewHandler(e:MouseEvent):void
		{
			if( Globals.myWindowManager.isActiveWindowSaved() )
			{
				Globals.myWindowManager.createNewObjectInWindow(
						Globals.myWindowManager.getActiveWindow()
					);
			} else {
				// alert dialog
				if( CSDialogs.changesNotSaved() )
					Globals.myWindowManager.createNewObjectInWindow(
							Globals.myWindowManager.getActiveWindow()
						);
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clickOpenHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickOpenHandler(e:MouseEvent):void
		{
			if( Globals.myWindowManager.getActiveWindow() == null )
			{
				// open new window and unknown ae
				var filePath = CSDialogs.selectLoadAE(null);
				if (filePath != "false") 
					Globals.myWindowManager.openWindowFromUnkownFile(filePath);
				
			} else if( Globals.myWindowManager.isActiveWindowSaved() ) {
				// load into active window
				Globals.myWindowManager.loadActiveWindow();
				
			} else {
				// alert dialog
				if( CSDialogs.changesNotSaved() )
					Globals.myWindowManager.loadActiveWindow();
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clickSaveHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickSaveHandler(e:MouseEvent):void
		{
			if( Globals.myWindowManager.isActiveWindowValid() )
			{
				Globals.myWindowManager.saveActiveWindow();
			} else {
				CSDialogs.onlyValidSave();
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clickDeleteHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickDeleteHandler(e:MouseEvent):void
		{
// TODO			
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clickPrintHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickPrintHandler(e:MouseEvent):void
		{
			if( Globals.myWindowManager.isActiveWindowValid() ) 
			{
				Globals.myWindowManager.printActiveWindow();
			} else {
				CSDialogs.onlyValidPrint();
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clickOptionsHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickOptionsHandler(e:MouseEvent):void
		{
			this.changeState(TBSTATE_OPTIONS);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clickHelpHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickHelpHandler(e:MouseEvent):void
		{
			this.changeState(TBSTATE_HELP);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clickCloseHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickCloseHandler(e:MouseEvent):void
		{
			if( this.btnClose.getIsActive() == true 
					&& toolbarState != TBSTATE_CLOSED ) 
				this.changeState(TBSTATE_CLOSED);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * keyDownHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		function keyDownHandler(e:KeyboardEvent):void
		{
			if( e.charCode == Keyboard.ESCAPE )
			{
				// --------------------------------------------------------
				// ESC for window closing
				// --------------------------------------------------------
				// Important in zinc settings disable ESC for closing.
				if( !Globals.myWindowManager.areAllWindowsSaved() ) 
				{
					if( CSDialogs.changesNotSaved() ) 
						mdm.Application.exit();
					
				} else {
					if( CSDialogs.wantToExit() ) 
						mdm.Application.exit();
				}
				return;
			} 
			
			if( e.ctrlKey == true ) 
			{
				// --------------------------------------------------------
				// Shortcuts
				// --------------------------------------------------------
				var char:String = String.fromCharCode(e.charCode).toUpperCase();
				if( char == "N" ) {
					if (Globals.myWindowManager.getActiveWindow() != null ) 
						this.clickNewHandler(null);
					
				} else if( char == "L" ) {
					this.clickOpenHandler(null);
					
				} else if( char == "S" ) {
					if( Globals.myWindowManager.getActiveWindow() != null ) 
						this.clickSaveHandler(null);
					
				} else if( char == "D" ) {
					this.clickDeleteHandler(null);
					
				} else if( char == "P" ) {
					if( Globals.myWindowManager.getActiveWindow() != null )
						if( Globals.myWindowManager.getActiveWindow() is IPrintable ) 
							this.clickPrintHandler(null);
					
				} else if( e.charCode == Keyboard.TAB ) {
					if (Globals.myWindowManager.getMinimizedWindows().length > 0) 
						Globals.myWindowManager.maximizeMe(
								Globals.myWindowManager.getMinimizedWindows()[0]
							);
				}
			}
		}
	
	}
}
	
	
	
	