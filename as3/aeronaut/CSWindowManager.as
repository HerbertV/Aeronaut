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
package as3.aeronaut
{
	// MDM ZINC Lib
	import mdm.*;
	
	import flash.display.MovieClip;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import as3.aeronaut.module.CSWindowLoader;
	import as3.aeronaut.module.CSWindow;
	import as3.aeronaut.module.ICSWindow;
	import as3.aeronaut.module.ICSValidate;
	import as3.aeronaut.module.ICSToolbarBottom;
	
	import as3.aeronaut.print.IPrintable;
	
	import as3.aeronaut.objects.Aircraft;
	import as3.aeronaut.objects.Loadout;
	import as3.aeronaut.objects.Pilot;
	import as3.aeronaut.objects.Squadron;
	import as3.aeronaut.objects.Zeppelin;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	import as3.hv.core.net.AbstractModule;
	
	/**
	 * =========================================================================
	 * Class CSWindowManager
	 * =========================================================================
	 * for handling the window managment
	 */ 
	public class CSWindowManager
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const WND_PILOT:int = 0;
		public static const WND_SQUAD:int = 1;
		public static const WND_AIRCRAFT:int = 2;
		public static const WND_LOADOUT:int = 3;
		public static const WND_ZEPPELIN:int = 4;
		
		public static const WND_MIN_OFFSET:int = 20;
		public static const WND_MIN_PADDING:int = 130;
		
		public static const MAX_OPEN_WINDOWS:int = 6;
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var myWindowContainer:MovieClip = null;
		
		private var myWindowLoader:CSWindowLoader = null;
		
		private var activeWindow:CSWindow = null;
		private var minimizedWindows:Array = new Array();
		
		private var closingWindow:CSWindow = null;
		
		private var loadingWindowFilename:String = null;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 * 
		 * @param cont container for all CSWindows
		 */
		public function CSWindowManager(cont:MovieClip)
		{
			if( Console.isConsoleAvailable() )
			{
				Console.getInstance().writeln(
						"<b> &gt; &gt; CSWindowManager READY &lt; &lt; </b>",
						DebugLevel.COMMAND,
						null,
						false
					);
				Console.getInstance().newLine();
			}
			this.myWindowContainer = cont;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * loadWindowModul
		 * ---------------------------------------------------------------------
		 * loads the sub module swf file for a window.
		 * 
		 * @param type
		 */
		private function loadWindowModul(type:int):Boolean
		{
			var filename:String = "";
			
			switch( type ) 
			{
				case WND_PILOT:
					filename = mdm.Application.path 
						+ Globals.PATH_MODULES
						+ "winPilot.swf";
					break;
					
				case WND_SQUAD:
					filename = mdm.Application.path 
						+ Globals.PATH_MODULES
						+ "winSquad.swf";
					break;
				
				case WND_AIRCRAFT:
					filename = mdm.Application.path 
						+ Globals.PATH_MODULES
						+ "winAircraft.swf";
					break;
				
				case WND_LOADOUT:
					filename = mdm.Application.path 
						+ Globals.PATH_MODULES
						+ "winLoadout.swf";
					break;
					
				case WND_ZEPPELIN:
					filename = mdm.Application.path 
						+ Globals.PATH_MODULES
						+ "winZeppelin.swf";
					break;
								
				default:
					return false;
			}
			
			this.myWindowLoader = new CSWindowLoader(
					filename,
					this.myWindowContainer
				);
			this.myWindowLoader.load();
			
			return true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateDirListsInOpenWindows
		 * ---------------------------------------------------------------------
		 */
		private function updateDirListsInOpenWindows():void
		{
			for( var i:int=0; i < this.minimizedWindows.length; i++ ) 
				ICSWindow(this.minimizedWindows[i]).updateDirLists();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getActiveWindow
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getActiveWindow():CSWindow 
		{
			return this.activeWindow;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getMinimizedWindows
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getMinimizedWindows():Array 
		{
			return this.minimizedWindows;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * isActiveWindowSaved
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function isActiveWindowSaved():Boolean 
		{
			if( this.activeWindow == null )
				return true;
				
			return ICSWindow(this.activeWindow).getIsSaved();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * isActiveWindowSaved
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function areAllWindowsSaved():Boolean
		{
			if( !isActiveWindowSaved() ) 
				return false;
			
			for( var i:int = 0; i < minimizedWindows.length; i++ ) 
				if( !ICSWindow(minimizedWindows[i]).getIsSaved() )
					return false;
			
			return true;
		}
													 
		/**
		 * ---------------------------------------------------------------------
		 * isActiveWindowValid
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function isActiveWindowValid():Boolean 
		{
			if( this.activeWindow == null )
				return true;
				
			if( this.activeWindow is ICSValidate ) 
				return ICSValidate(this.activeWindow).getIsValid();
				
			return true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * openWindow
		 * ---------------------------------------------------------------------
		 * opens a window by type.
		 * called from main menu (left)
		 *
		 * @param type
		 * @param filename *.ae file to load after window loading is finished
		 */
		public function openWindow(
				type:int,
				filename:String=null
			):void
		{
			// wait until previous loader is finished
			if( this.myWindowLoader != null )
				return;
			
			if( this.loadWindowModul(type) )
			{
				this.loadingWindowFilename = filename;
				
				// add listeners
				this.myWindowLoader.addEventListener(
						Event.COMPLETE,
						openWindowComplete
					);
				this.myWindowLoader.addEventListener(
						IOErrorEvent.IO_ERROR,
						openWindowError
					);
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * createNewObjectInWindow
		 * ---------------------------------------------------------------------
		 * creates a new empty object for the window
		 *
		 * @param win
		 */
		public function createNewObjectInWindow(win:CSWindow):void
		{
			if( win == null )
				return;
			
			ICSWindow(win).initNewObject();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * openWindowComplete
		 * ---------------------------------------------------------------------
		 * loading complete handler
		 *
		 * @param e
		 */
		private function openWindowComplete(e:Event):void
		{
			var newWin:CSWindow = CSWindow(this.myWindowLoader.getModule());
			
			if( newWin == null ) 
			{
				openWindowError(null);
				return;
			}
			
			if( this.loadingWindowFilename == null )
			{
				this.createNewObjectInWindow(newWin);
			} else {
				ICSWindow(newWin).loadObject( this.loadingWindowFilename );
			}
			this.minimizeActiveWindow();
			this.activeWindow = newWin;
			newWin.openWin();
				
			Globals.myToolbarBottom.updateToolbar();
			
			// just to clean up the loader
			openWindowError(null);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * openWindowError
		 * ---------------------------------------------------------------------
		 * loading error handler
		 * just clean up.
		 * also called by openWindowComplete
		 *
		 * @param e
		 */
		private function openWindowError(e:IOErrorEvent):void
		{
			this.myWindowLoader.removeEventListener(
					Event.COMPLETE,
					openWindowComplete
				);
			this.myWindowLoader.removeEventListener(
					IOErrorEvent.IO_ERROR,
					openWindowError
				);
			this.myWindowLoader.dispose();
			this.myWindowLoader = null;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * openWindowFromUnkownFile
		 * ---------------------------------------------------------------------
		 * called by double click on an .ae file 
		 */
		public function openWindowFromUnkownFile(filename:String):void
		{
			if( this.myWindowLoader != null )
				return;
			
			var aexml:AeronautXMLProcessor = new AeronautXMLProcessor();
			aexml.loadXML(filename);
			var loadedxml:XML = aexml.getXML();
			
			if( loadedxml == null )
				return;
				
			if( Aircraft.checkXML(loadedxml) ) 
			{
				openWindow(WND_AIRCRAFT,filename);
				
			} else if( Pilot.checkXML(loadedxml) ) {
				openWindow(WND_PILOT,filename);
				
			} else if( Loadout.checkXML(loadedxml) ) {
				openWindow(WND_LOADOUT,filename);
				
			} else if( Squadron.checkXML(loadedxml) ) {
				openWindow(WND_SQUAD,filename);
				
			} else if( Zeppelin.checkXML(loadedxml) ) {
				openWindow(WND_ZEPPELIN,filename);
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * saveActiveWindow
		 * ---------------------------------------------------------------------
		 * 
		 * @param saveAs 
		 *			true = save as
		 *			false = save and auto overwrite
		 */
		public function saveActiveWindow(saveAs:Boolean):void
		{
			if( this.activeWindow == null )
				return;
			
			var iwin:ICSWindow = ICSWindow(this.activeWindow);
			iwin.updateObjectFromWindow();
			
			var filePath:String = iwin.getFilename();
			
			if( saveAs )
				filePath = CSDialogs.selectSaveAE(iwin);
			
			if( filePath == "false" )
				return;
			
			var exitsNotOrOverwrite:Boolean = true;
			
			if( saveAs )
				exitsNotOrOverwrite = CSDialogs.fileExitsNotOrOverwrite(filePath);
			
			if( exitsNotOrOverwrite )
			{
				Globals.myCSProgressBar.init();
				Globals.myCSProgressBar.setProgressTo(33,"saving ...");
				
				iwin.saveObject(filePath);
				Globals.myCSProgressBar.setProgressTo(66,"saving ...");
				this.updateDirListsInOpenWindows();
				Globals.myToolbarBottom.updateToolbar();
				
				Globals.myCSProgressBar.setProgressTo(100, "saving finished.");
				Globals.myCSProgressBar.hide();
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * loadActiveWindow
		 * ---------------------------------------------------------------------
		 */
		public function loadActiveWindow():void
		{
			if( this.activeWindow == null )
				return;
			
			var filePath:String = CSDialogs.selectLoadAE(
					ICSWindow(this.activeWindow) 
				);
			
			if( filePath == "false" )
				return;
			
			Globals.myCSProgressBar.init();
			Globals.myCSProgressBar.setProgressTo(0, "loading ... ");
			
			ICSWindow(this.activeWindow).loadObject( filePath );
			Globals.myToolbarBottom.updateToolbar();
						
			Globals.myCSProgressBar.setProgressTo(100, "loading finished");
			Globals.myCSProgressBar.hide();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * printActiveWindow
		 * ---------------------------------------------------------------------
		 */
		public function printActiveWindow():void
		{
			if( this.activeWindow == null ) 
				return;
				
			if( this.activeWindow is IPrintable )
				IPrintable(this.activeWindow).printMe();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * spliceMinimizedWindow
		 * ---------------------------------------------------------------------
		 * just removes the win from the minimizedWindows array.
		 */
		private function spliceMinimizedWindow(win:CSWindow):void
		{
			for( var i:int=0; i < this.minimizedWindows.length; i++ ) 
			{
				if( this.minimizedWindows[i] == win ) 
				{
					this.minimizedWindows.splice(i,1);
					break;
				}
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * closeMe
		 * ---------------------------------------------------------------------
		 * @param win
		 */
		public function closeMe(win:CSWindow):void
		{
			// abort close if window contains unsaved data 
			// and the user wants to discard it.
			if( !ICSWindow(win).getIsSaved() )
				if( !CSDialogs.changesNotSaved() )
					return;
			
			if( closingWindow == null ) 
			{
				// animated closing
				this.closingWindow = win;
				if( win == this.activeWindow ) 
				{
					this.activeWindow = null;
				} else {
					this.spliceMinimizedWindow(win);
					this.updateMinimizedWindowsPos();
				}
				this.closingWindow.closeWin();
				
			} else {
				// if another closing is in progress
				// we do fast close the window (without animation)
				if( win == this.activeWindow ) 
				{
					this.activeWindow = null;
				} else {
					this.spliceMinimizedWindow(win);
					this.updateMinimizedWindowsPos();
				}
				win.visible = false;
				this.myWindowContainer.removeChild(win);
				win.dispose();
			}
			Globals.myToolbarBottom.updateToolbar();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * removeClosedResources
		 * ---------------------------------------------------------------------
		 */
		public function removeClosedResources():void
		{
			this.myWindowContainer.removeChild(this.closingWindow);
			this.closingWindow = null;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * minimizeMe
		 * ---------------------------------------------------------------------
		 * @param win
		 */
		public function minimizeMe(win:CSWindow):void
		{
			if( win == this.activeWindow ) 
				this.minimizeActiveWindow();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * minimizeMe
		 * ---------------------------------------------------------------------
		 * @param win
		 */
		public function maximizeMe(win:CSWindow):void
		{
			this.spliceMinimizedWindow(win);
			this.minimizeActiveWindow();
			
			this.activeWindow = win;
			this.myWindowContainer.setChildIndex(
					this.activeWindow, 
					this.myWindowContainer.numChildren-1
				);
			this.activeWindow.maximizeWin();
			
			this.updateMinimizedWindowsPos();
			Globals.myToolbarBottom.updateToolbar();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcMinimizeYPos
		 * ---------------------------------------------------------------------
		 * @param idx
		 */
		private function calcMinimizeYPos(idx:int):int
		{
			return WND_MIN_OFFSET + (WND_MIN_PADDING*idx);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateMinimizedWindowsPos
		 * ---------------------------------------------------------------------
		 */
		private function updateMinimizedWindowsPos()
		{
			for( var i:int=0; i < this.minimizedWindows.length; i++ )
				this.minimizedWindows[i].minizeWin(this.calcMinimizeYPos(i));
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * minimizeActiveWindow
		 * ---------------------------------------------------------------------
		 */
		private function minimizeActiveWindow()
		{
			if( this.activeWindow == null )
				return;
			
			this.activeWindow.minizeWin(
					this.calcMinimizeYPos(this.minimizedWindows.length)
				);
			this.minimizedWindows.push(this.activeWindow);
			this.activeWindow = null;
			Globals.myToolbarBottom.updateToolbar();
		}
	
	}
}