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
package as3.aeronaut.print
{
	import mdm.*;
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	import flash.geom.Rectangle;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	
	import flash.printing.*;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	import as3.hv.components.progress.IProgressSymbol;
	
	import as3.aeronaut.module.CSWindowLoader;
	import as3.aeronaut.Globals;
	
	import as3.aeronaut.objects.ICSBaseObject;
		
	// =========================================================================
	// Class PrintManager
	// =========================================================================
	// handles the printing que
	//
	public class PrintManager
			implements IEventDispatcher
	{
		// =====================================================================
		// Variables
		// =====================================================================
		// static singleton instance 
		private static var myInstance:PrintManager = new PrintManager();
		
		private var dispatcher:EventDispatcher;
		
		private var pageRect:Rectangle = null;
		private var pageCount:uint = 0;
		
		// loaded sheets (ICSSheet)
		private var arrSheets:Array = new Array();
		// file names with full path (Strings)
		private var arrSheetFiles:Array = new Array();
		//ICSBaseObject's
		private var arrObjects:Array = new Array();
		
		// for loading the sheet swf files
		private var loader:CSWindowLoader = null;
		
		private var printContainer:MovieClip = null;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		/**
		 * Constructor 
		 *
		 * Cannot called directly since this class is a singleton.
		 * use getInstance instead.
		 *
		 */
		public function PrintManager()
		{
			if( myInstance )
				throw new Error("PrintManager is a singleton class, use getInstance() instead");
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getInstance
		 * ---------------------------------------------------------------------
		 *
		 * @returns 	the instance of the PrintManager
		 */
		public static function getInstance():PrintManager
		{
			return PrintManager.myInstance;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * init
		 * ---------------------------------------------------------------------
		 * @param container
		 * @param rect the page rectangle
		 */
		public function init(
				container:MovieClip,
				rect:Rectangle=null
			):void
		{
			this.dispatcher = new EventDispatcher(this);
			
			this.pageRect = rect;
			this.printContainer = container;
			
			if( rect == null )
				this.pageRect = new Rectangle(15,15,560,780);
			
			if( Console.isConsoleAvailable() )
			{
				Console.getInstance().writeln(
						"<b> &gt; &gt; PrintManager READY &lt; &lt; </b>",
						DebugLevel.COMMAND,
						null,
						false
					);
				Console.getInstance().newLine();
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * addSheet
		 * ---------------------------------------------------------------------
		 *
		 * @param sheetFile filepath of the sheet swf
		 * @param obj that needs to be printed
		 */
		public function addSheet(
				sheetFile:String, 
				obj:ICSBaseObject
			):void
		{
			this.arrSheetFiles.push(sheetFile);
			this.arrObjects.push(obj);
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * printNow
		 * ---------------------------------------------------------------------
		 * This starts the printing process, all sheets will be loaded and
		 * filled with data.
		 */
		public function printNow():void
		{
			//reset page count
			pageCount = 0;
			
			for( var i:int = 0; i < arrSheetFiles.length; i++ )
			{
				var l:CSWindowLoader = new CSWindowLoader(
						mdm.Application.path 
							+ Globals.PATH_MODULES
							+ arrSheetFiles[i],
						this.printContainer	
					);
				
				l.addNext( this.loader );
				l.addEventListener(Event.COMPLETE,sheetLoaded);
				this.loader = l;
			}
			if( this.loader != null )
				this.loader.load();
			
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initPrintJob
		 * ---------------------------------------------------------------------
		 * send everything to printer. 
		 * returns false if there was a problem during printing
		 *
		 * @return
		 */
		private function initPrintJob():Boolean
		{
			var pj:PrintJob = new PrintJob();
			var pjOptions = new PrintJobOptions();
			//is needed for alpha transparency.
			pjOptions.printAsBitmap = true;
			
			if( pj.start() ) 
			{ 
				var offsetX:int = pageRect.x;
				var offsetY:int = pageRect.y;
				var neededWidth:int = pageRect.width;
				var neededHeight:int = pageRect.height;
			
				var deltaWidth:int = (pj.pageWidth - neededWidth) / 2;
				var deltaHeight:int = (pj.pageHeight - neededHeight) / 2;
				if( pj.pageWidth < neededWidth 
						|| pj.pageHeight < neededHeight ) 
				{
					// log a warning message
					if( Console.isConsoleAvailable() )
						Console.getInstance().writeln(
								"Printing page size is too small.",
								DebugLevel.WARNING,
								"Please reduce your page margins."
							);
				}
				
				// center page
				if( deltaWidth > 0 ) 
				{
					offsetX -= deltaWidth;
					neededWidth += deltaWidth;
				}
				if( deltaHeight > 0 ) 
				{
					offsetY -= deltaHeight;
					neededHeight += deltaHeight;
				}
				pageRect = new Rectangle(offsetX, offsetY, neededWidth, neededHeight);
				
				var sheet:CSAbstractSheet;
				var page:Sprite;
				 
				// add pages to job
				for each( sheet in this.arrSheets )
				{
					for each( page in sheet.getPages() )
					{
						page.x = -1000;
						// move page from the container to the stage.
						// printAsBitmap works only if our page is on stage
						this.printContainer.stage.addChild(page);
						try 
						{
							pj.addPage(page,pageRect,pjOptions);
							pageCount++;
						} catch(e:Error) {
							// log a warning message
							if( Console.isConsoleAvailable() )
								Console.getInstance().writeln(
									"Problem with printing:",
									DebugLevel.ERROR,
									e.toString()
								);
							return false;		
						}
					}
				}
				
				if( pageCount > 0 ) 
					pj.send();
					
				// remove pages	
				for each( sheet in this.arrSheets )
					for each( page in sheet.getPages() )
						this.printContainer.stage.removeChild(page);
			}
			
			this.arrSheets = new Array();
		 	this.arrSheetFiles = new Array();
			this.arrObjects = new Array();
		
			return true;
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * sheetLoaded
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function sheetLoaded(e:Event):void
		{
			var sheet:ICSSheet = ICSSheet(this.loader.getModule());
			sheet.initFromObject(arrObjects.shift());
			
			this.arrSheets.push(sheet);
			
			this.loader = CSWindowLoader(this.loader.getNext());
			
			if( this.loader != null ) 
				this.loader.load();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * waitHandler
		 * ---------------------------------------------------------------------
		 * wait until all resources are loaded and all sheets are ready
		 *
		 * @param e
		 */
		public function waitHandler(e:Event):void
		{
			if( this.arrSheets.length == 0 )
				return;
			
			for( var i:int = 0; i < this.arrSheets.length; i++ )
				if( !this.arrSheets[i].isReady() )
					return;
			
			this.initPrintJob();
		}
		
		// =====================================================================
		// IEventDispatcher functions
		// =====================================================================
		// redirect all to dispatcher
		//
		// @see flash.events.IEventDispatcher
		// @see flash.events.EventDispatcher
		/**
		 * ---------------------------------------------------------------------
		 * addEventListener
		 * ---------------------------------------------------------------------
		 */
		final public function addEventListener(
				type:String, 
				listener:Function, 
				useCapture:Boolean = false, 
				priority:int = 0, 
				useWeakReference:Boolean = false
			):void
		{
        	dispatcher.addEventListener(
					type, 
					listener, 
					useCapture, 
					priority
				);
		}
			   
		/**
		 * ---------------------------------------------------------------------
		 * dispatchEvent
		 * ---------------------------------------------------------------------
		 */
		final public function dispatchEvent(evt:Event):Boolean
		{
			return dispatcher.dispatchEvent(evt);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * hasEventListener
		 * ---------------------------------------------------------------------
		 */
		final public function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * removeEventListener
		 * ---------------------------------------------------------------------
		 */
		final public function removeEventListener(
				type:String, 
				listener:Function, 
				useCapture:Boolean = false
			):void
		{
			dispatcher.removeEventListener(
					type, 
					listener, 
					useCapture
				);
		}
					   
		/**
		 * ---------------------------------------------------------------------
		 * willTrigger
		 * ---------------------------------------------------------------------
		 */
		final public function willTrigger(type:String):Boolean 
		{
			return dispatcher.willTrigger(type);
		}
		
	}
}