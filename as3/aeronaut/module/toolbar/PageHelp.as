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
package as3.aeronaut.module.toolbar
{
	// MDM ZINC Lib
	import mdm.*;
		
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import as3.hv.core.net.HTMLLoader;
	import as3.hv.components.progress.IProgressSymbol;
		
	import as3.aeronaut.Globals;
	import as3.aeronaut.gui.*;
	
	// =========================================================================
	// Class PageHelp
	// =========================================================================
	// The Help Page from our toolbar
	//
	public class PageHelp 
			extends AbstractPage 
	{
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var myHelpLoader:HTMLLoader = null;
		private var myProgressSymbol:IProgressSymbol = null;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function PageHelp()
		{
			super();
			
			this.myHTMLText.condenseWhite = true;
			this.myHTMLText.multiline = true;
			this.myHTMLText.styleSheet = Globals.myHTMLCSS;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * setup
		 * ---------------------------------------------------------------------
		 * @param proSym
		 */
		public function setup(proSym:IProgressSymbol):void
		{
			this.myProgressSymbol = proSym;
			
			this.myHelpLoader = new HTMLLoader(
					"",
					"HelpLoader",
					this.myHTMLText
				);
			
			this.myHTMLText.addEventListener(
					TextEvent.LINK, 
					linkHandler
				);
			this.myHTMLText.addEventListener(
					MouseEvent.MOUSE_WHEEL, 
					mouseWheelHandler
				);
			
			this.btnScrollUp.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickScrollUpHandler
				);
			this.btnScrollDown.addEventListener(
					MouseEvent.MOUSE_DOWN, 
					clickScrollDownHandler
				);

			this.myScrollbar.setup(
					myHTMLText,
					30,
					280,
					this.btnScrollUp,
					this.btnScrollDown
				);
		}	
		
		/**
		 * ---------------------------------------------------------------------
		 * showPage
		 * ---------------------------------------------------------------------
		 */
		override public function showPage():void
		{
			super.showPage();
			loadHelpPage("index.html");
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * loadHelpPage
		 * ---------------------------------------------------------------------
		 * @param file
		 */
		private function loadHelpPage(file:String):void
		{
			file = mdm.Application.path + Globals.PATH_HELP + file;
			
			this.myProgressSymbol.init();
			
			this.myHelpLoader.loadFile(file);
			
			this.myHelpLoader.addEventListener(
					Event.COMPLETE,
					loadCompleteHandler
				);
			this.myHelpLoader.addEventListener(
					ProgressEvent.PROGRESS, 
					loadProgressHandler
				);
			this.myHelpLoader.addEventListener(
					IOErrorEvent.IO_ERROR, 
					ioErrorHandler
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateScrollButtons
		 * ---------------------------------------------------------------------
		 */
		public function updateScrollButtons():void
		{
			if( this.myHTMLText.scrollV > 1 )
			{
				this.btnScrollUp.setActive(true);
			} else {
				this.btnScrollUp.setActive(false);
			}
			
			if( this.myHTMLText.scrollV < this.myHTMLText.maxScrollV )
			{
				this.btnScrollDown.setActive(true);
			} else {
				this.btnScrollDown.setActive(false);
			}
			
			this.myScrollbar.updatePosition();
		}
		
		// =====================================================================
		// EventHandler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * loadCompleteHandler
		 * ---------------------------------------------------------------------
		 *
		 * @param e
		 */
		private function loadCompleteHandler(e:Event):void 
		{
			this.myProgressSymbol.hide();
			this.myScrollbar.updateSize();
			this.updateScrollButtons();
			
			this.myHelpLoader.removeEventListener(
					Event.COMPLETE,
					loadCompleteHandler
				);
			this.myHelpLoader.removeEventListener(
					ProgressEvent.PROGRESS, 
					loadProgressHandler
				);
			this.myHelpLoader.removeEventListener(
					IOErrorEvent.IO_ERROR, 
					ioErrorHandler
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * loadProgressHandler
		 * ---------------------------------------------------------------------
		 *
		 * @param e
		 */
		private function loadProgressHandler(e:ProgressEvent):void 
		{
			this.myProgressSymbol.setProgressTo(
					this.myHelpLoader.getPercentLoaded(),
					""
				);	
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * ioErrorHandler
		 * ---------------------------------------------------------------------
		 *
		 * @param e
		 */
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			this.myProgressSymbol.hide();
			
			this.myHelpLoader.removeEventListener(
					Event.COMPLETE,
					loadCompleteHandler
				);
			this.myHelpLoader.removeEventListener(
					ProgressEvent.PROGRESS, 
					loadProgressHandler
				);
			this.myHelpLoader.removeEventListener(
					IOErrorEvent.IO_ERROR, 
					ioErrorHandler
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * linkHelpHandler
		 * ---------------------------------------------------------------------
		 * The link needs to be like this example:
		 * <a href="event:[html file name]">Text to display</a>
		 *
		 * @param e
		 */
		private function linkHandler(e:TextEvent):void 
		{
			loadHelpPage(e.text);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * mouseWheelHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function mouseWheelHandler(e:MouseEvent):void
		{
			this.updateScrollButtons();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clickScrollUpHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickScrollUpHandler(e:MouseEvent):void
		{
			if( !this.btnScrollUp.getIsActive() ) 
				return;
			
			this.myHTMLText.scrollV--;
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
			if( !this.btnScrollDown.getIsActive() )
				return;
			
			this.myHTMLText.scrollV++;
			this.updateScrollButtons();
		}
		
	}
}