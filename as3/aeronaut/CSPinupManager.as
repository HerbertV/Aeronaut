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
	import flash.display.Sprite;
	import flash.display.Bitmap;
	
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import flash.filters.DropShadowFilter;
	import flash.filters.BitmapFilterQuality;
	
	import flash.events.*;
    
	import as3.hv.core.math.TrueRandom;
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	import as3.hv.core.net.ImageLoader;
	
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
		private var myPinupContainer:MovieClip;
		private var maxCounter:int = 0;
		private var loadedCounter:int = 0;
		
		private var currentLoader:ImageLoader = null;
		private var ductTape:Bitmap = null;
		
		
		// =====================================================================
		// Constructor
		// =====================================================================
		
		public function CSPinupManager(cont:MovieClip)
		{
			this.myPinupContainer = cont;
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
			Globals.myCSProgressBar.init();
				
			var path:String = mdm.Application.path 
					+ Globals.PATH_IMAGES
					+ Globals.PATH_PINUP;
			
			var tapeFile:String = mdm.Application.path 
					+ Globals.PATH_IMAGES
					+ "gui\\ducttape.png";
			
			var pinupList:Array = mdm.FileSystem.getFileList(
					path, 
					"*.png"
				);
			
			if( pinupList.length == 0 )
			{
				// no images found abort
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"No Pinups found",
							DebugLevel.WARNING
						);
				Globals.myCSProgressBar.hide();
				return;
			}
			
			// setup loader que
			for( var i:int = 0; i<pinupList.length; i++ )
			{
				var tmp:ImageLoader = this.currentLoader;
				this.currentLoader = new ImageLoader(
						path + pinupList[i]
					);
				this.currentLoader.addNext(tmp);
			}
			
			this.maxCounter = pinupList.length;
			this.loadedCounter = 0;
			
			// add ducttape image for button
			var tape:ImageLoader = new ImageLoader(tapeFile);
			tape.addNext(this.currentLoader);
			this.currentLoader = tape;
			
			this.loadNext();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setupNextLoad
		 * ---------------------------------------------------------------------
		 *
		 * @param file
		 */
		private function loadNext():void
		{
			// we are finished
			if( currentLoader == null )
			{
				shufflePinups();
				Globals.myCSProgressBar.setProgressTo(100,"");
				Globals.myCSProgressBar.hide();
				return;
			}
			// go to next
			loadedCounter++;
			var pro:int = int( 
					((this.maxCounter - loadedCounter )
						/this.maxCounter)*100 
				);
				
			Globals.myCSProgressBar.setProgressTo(
					pro,
					"loading Pinups..."
				);
			
			currentLoader.addEventListener(
					Event.COMPLETE, 
					loadCompleteHandler
				);
            currentLoader.addEventListener(
					IOErrorEvent.IO_ERROR, 
					ioErrorHandler
				);
			currentLoader.load();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * startDragHandler
		 * ---------------------------------------------------------------------
		 * for dragging a pinup
		 *
		 * @param e
		 */
		private function startDragHandler(e:MouseEvent):void
		{
			var s:Sprite = Sprite(e.currentTarget);
			// put on top
			this.myPinupContainer.setChildIndex(
					s,
					this.myPinupContainer.numChildren-1
				);
			s.startDrag(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * stopDragHandler
		 * ---------------------------------------------------------------------
		 * for dragging a pinup
		 *
		 * @param e
		 */
		private function stopDragHandler(e:MouseEvent):void
		{
			Sprite(e.currentTarget).stopDrag();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * removeHandler
		 * ---------------------------------------------------------------------
		 * for removing the pinup from desk
		 *
		 * @param e
		 */
		private function removeHandler(e:MouseEvent):void
		{
			var s:Sprite = Sprite(e.currentTarget);
			
			e.stopPropagation();
			this.myPinupContainer.removeChild(s.parent);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * rotate
		 * ---------------------------------------------------------------------
		 * random rotation around center
		 *
		 * @param s
		 */
		private function rotate(
				s:Sprite, 
				angle:int
			):void 
		{
			var m:Matrix = s.transform.matrix;
			var center:Point = new Point(
					s.x + s.width/2, 
					s.y + s.height/2
				);
			
			m.tx -= center.x;
			m.ty -= center.y;
			m.rotate( angle * (Math.PI/180) );
			m.tx += center.x;
			m.ty += center.y;
			s.transform.matrix = m;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * createRemoveButton
		 * ---------------------------------------------------------------------
		 * creates the ducttape remove button.
		 *
		 * @param posx
		 * @param posy
		 */
		private function createRemoveButton(
				posx:int,
				posy:int
			):Sprite
		{
			var s:Sprite = new Sprite();
			var bmp:Bitmap = new Bitmap(ductTape.bitmapData);
			
			bmp.smoothing = true;
			
			s.addChild(bmp);
			s.x = posx - s.width/2;
			s.y = posy - s.height/2;
			
			rotate(s, 40 + TrueRandom.generateRangedInt(5) );
			
			s.buttonMode = true;
			s.addEventListener(
					MouseEvent.MOUSE_DOWN,
					removeHandler
				);
			
			return s;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * createPinup
		 * ---------------------------------------------------------------------
		 * finalizes the pinup, 
		 * random position, rotation and the ducttape button
		 *
		 * @param bmp
		 */
		private function createPinup(bmp:Bitmap):void
		{
			var s:Sprite = new Sprite();
			//random position
			var rndX:int = TrueRandom.generateRangedInt(200);
			var rndY:int = TrueRandom.generateRangedInt(300);
			
			bmp.smoothing = true;
			
			s.addChild(bmp);
			s.addChild( createRemoveButton(s.width-5, 5) );
						
			s.x = 900 + rndX;
			s.y = 50 + rndY;
			rotate(
					s,
					TrueRandom.generateRangedInt(10) 
						* TrueRandom.generateRandomSignedMultiplier() 
				);
			
			// some little dropshadow
			var dsf:DropShadowFilter = new DropShadowFilter(
					1, //distance,
                    45, // angle,
                    0x000000, //color,
                    0.7, //alpha,
                    2, //blurX,
                    2, //blurY,
                    0.65, //strength,
                    BitmapFilterQuality.HIGH
				);
			s.filters = new Array(dsf);
			
			this.myPinupContainer.addChild(s);
			
			s.buttonMode = true;
			s.addEventListener(
					MouseEvent.MOUSE_DOWN,
					startDragHandler
				);
			s.addEventListener(
					MouseEvent.MOUSE_UP,
					stopDragHandler
				);
			s.addEventListener(
					MouseEvent.MOUSE_OUT,
					stopDragHandler
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * shufflePinups
		 * ---------------------------------------------------------------------
		 * Random z-Order
		 */
		private function shufflePinups():void
		{
			//Random z-Order
			for( var i:int = 0; i<this.myPinupContainer.numChildren; i++ )
			{
				var rndZ:int = TrueRandom.generateRangedInt(
						this.myPinupContainer.numChildren-1
					);
				this.myPinupContainer.setChildIndex(
						this.myPinupContainer.getChildAt(i),
						rndZ
					);
			}
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
			// first one is ducttape
			if( this.ductTape == null )
				this.ductTape = this.currentLoader.getImage();
			else
				createPinup(this.currentLoader.getImage());
			
			this.currentLoader = ImageLoader(this.currentLoader.getNext()); 
			this.loadNext();
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
			if( this.ductTape != null )
			{
				this.currentLoader = ImageLoader(this.currentLoader.getNext()); 
				this.loadNext();
			}
		}

	}
}