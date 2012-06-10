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
package as3.aeronaut
{
	// MDM ZINC Lib
	import mdm.*;
		
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	
	import flash.geom.Rectangle;
	
	import flash.events.*;
    
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	import as3.hv.core.math.TrueRandom;
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	import as3.aeronaut.Globals;
	
	// =========================================================================
	// CSPinupManager
	// =========================================================================
	// for managing the pictures from images/pinpus
	// checks the path for pngs and adds it to the list 
	//
	// if the easteregg button is found the pictures are shown ;)
	public class CSPinupManager
	{
		// =====================================================================
		// Variables
		// =====================================================================
		private var myPinupURLs:Array = new Array();
		
		private var myPinupContainer:MovieClip;
		
		private var maxCounter:int = 0;
		
		private var currentLoader:Loader = null;
		private var currLoadClip:MovieClip = null;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		
		public function CSPinupManager(cont:MovieClip)
		{
			this.myPinupContainer = cont;
			
			var path:String = mdm.Application.path 
					+ Globals.PATH_IMAGES
					+ Globals.PATH_PINUP;
			
			myPinupURLs = mdm.FileSystem.getFileList(
					path, 
					"*.png"
				);
			
			
			this.maxCounter = this.myPinupURLs.length;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * loadPinups
		 * ---------------------------------------------------------------------
		 * 
		 */
		public function loadPinups():void
		{
			if( this.myPinupURLs.length > 0 ) 
			{
				Globals.myCSProgressBar.init();
				this.setupNextLoad(String(this.myPinupURLs.pop()));
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setupNextLoad
		 * ---------------------------------------------------------------------
		 *
		 * @param file
		 */
		private function setupNextLoad(file:String):void
		{
			var path:String = mdm.Application.path 
					+ Globals.PATH_IMAGES
					+ Globals.PATH_PINUP;
			
			currentLoader = new Loader();
			currentLoader.contentLoaderInfo.addEventListener(
					Event.COMPLETE, 
					loadCompleteHandler
				);
            currentLoader.contentLoaderInfo.addEventListener(
					ProgressEvent.PROGRESS, 
					loadProgressHandler
				);
            currentLoader.contentLoaderInfo.addEventListener(
					IOErrorEvent.IO_ERROR, 
					ioErrorHandler
				);
			
			currentLoader.load( new URLRequest(path + file) );
			
			this.currLoadClip = new MovieClip();
			this.currLoadClip.addChild(currentLoader);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * startDragHandler
		 * ---------------------------------------------------------------------
		 *
		 * @param e
		 */
		private function startDragHandler(e:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(e.currentTarget);
			this.myPinupContainer.setChildIndex(mc,maxCounter-1);
			mc.startDrag(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * startDragHandler
		 * ---------------------------------------------------------------------
		 *
		 * @param e
		 */
		private function stopDragHandler(e:MouseEvent):void
		{
			MovieClip(e.currentTarget).stopDrag();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * loadCompleteHandler
		 * ---------------------------------------------------------------------
		 *
		 * @param e
		 */
		private function loadCompleteHandler(e:Event):void 
		{
			//random position
			var rndX:int = TrueRandom.generateRangedInt(200);
			var rndY:int = TrueRandom.generateRangedInt(300);
			
			this.currLoadClip.x = 900 + rndX;
			this.currLoadClip.y = 50 + rndY;
			
			this.myPinupContainer.addChild(this.currLoadClip);
			
			this.currLoadClip.buttonMode = true;
			this.currLoadClip.addEventListener(
					MouseEvent.MOUSE_DOWN,
					startDragHandler
				);
			this.currLoadClip.addEventListener(
					MouseEvent.MOUSE_UP,
					stopDragHandler
				);
			this.currLoadClip.addEventListener(
					MouseEvent.MOUSE_OUT,
					stopDragHandler
				);
			
			if( this.myPinupURLs.length > 0 )
			{
				var pro:int = int( 
						((this.maxCounter - this.myPinupURLs.length )
							/this.maxCounter)*100 
					);
				
				Globals.myCSProgressBar.setProgressTo(
						pro,
						"loading Pinups..."
					);
				this.setupNextLoad(String(this.myPinupURLs.pop()));
			} else {

				// TODO Random rotation

				//Random z-Order
				for( var i:int = 0; i<this.myPinupContainer.numChildren; i++ )
				{
					var rndZ:int = TrueRandom.generateRangedInt(this.maxCounter-1);
					this.myPinupContainer.setChildIndex(
							this.myPinupContainer.getChildAt(i),
							rndZ
						);
				}
				Globals.myCSProgressBar.setProgressTo(100,"");
				Globals.myCSProgressBar.hide();
			}
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
        	// not used
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
			Console.getInstance().writeln(
					"IO Error while loading Pinup: ",
					DebugLevel.ERROR,
					e.toString()
				);
		}

	}
}