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
	// MDM ZINC Lib
	import mdm.*;

	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import as3.aeronaut.print.pilot.*;
	
	import as3.aeronaut.objects.BaseData;
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.Pilot;
	import as3.aeronaut.objects.Squadron;
	import as3.aeronaut.objects.baseData.Country;
	
	import as3.aeronaut.Globals;
	
	import as3.hv.core.net.ImageLoader;
	
	// =========================================================================
	// Class SheetPilot
	// =========================================================================
	// 
	//
	public class SheetPilot
			extends CSAbstractSheet
			implements ICSSheetPilot
	{
		
		// =====================================================================
		// Constants
		// =====================================================================
		public static const FOTO_WIDTH:int = 104;
		public static const FOTO_HEIGHT:int = 128;
		
		public static const FLAG_WIDTH:int = 100;
		public static const FLAG_HEIGHT:int = 50;
		
		public static const SQUADLOGO_WIDTH:int = 150;
		public static const SQUADLOGO_HEIGHT:int = 60;
	
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		private var myObject:Pilot;
		private var squad:Squadron;
		
		private var loader:ImageLoader;
		
		private var foto:Bitmap;
		private var squadLogo:Bitmap;
		private var flag:Bitmap;
		
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function SheetPilot()
		{
			super();
		}

		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromObject
		 * ---------------------------------------------------------------------
		 * @see ICSSheet
		 *
		 * @param obj
		 */
		public function initFromObject(obj:ICSBaseObject):void
		{
			this.initFromPilot( Pilot(obj) );
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromPilot
		 * ---------------------------------------------------------------------
		 * @see ICSSheetPilot
		 *
		 * @param obj
		 */
		public function initFromPilot(obj:Pilot):void
		{
			this.myObject = obj;
			
			this.loadSquadron();

			var l:ImageLoader;
			if( obj.getSrcFoto() != "" )
			{
				l = new ImageLoader(
						mdm.Application.path 
							+ Globals.PATH_IMAGES
							+ Globals.PATH_PILOT
							+ obj.getSrcFoto(),
						"FotoLoader"	
					);
				l.addNext(this.loader);
				this.loader = l;
			}
			
			if( obj.getCountryID() != "" )
			{
				var c:Country = Globals.myBaseData.getCountry(obj.getCountryID());
				if( c.srcFlag != "" )
				{
					l = new ImageLoader(
							mdm.Application.path 
								+ Globals.PATH_IMAGES
								+ Globals.PATH_NATION
								+ c.srcFlag,
							"FlagLoader"
						);
					l.addNext(this.loader);
					this.loader = l;
				}
			}
			
			if( this.loader != null )
			{
				this.loader.addEventListener(
						Event.COMPLETE, 
						imageLoadedHandler
					);
				this.loader.load();
			} else {
				this.initPages();
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initPages
		 * ---------------------------------------------------------------------
		 */
		private function initPages():void
		{
			var page:ICSPrintPagePilot;
			
			page = new PagePilot();
			CSAbstractPrintPage(page).setSheet(this);
			page.initFromPilot(this.myObject);
			this.pages.push(page);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * isReady
		 * ---------------------------------------------------------------------
		 * @see ICSSheet
		 *
		 * @return
		 */
		override public function isReady():Boolean
		{
			if( this.pages.length == 0 )
				return false;
			
			if( this.loader != null )
				return false;
			
			return true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * loadSquadron
		 * ---------------------------------------------------------------------
		 */
		private function loadSquadron():void
		{
			if( this.myObject.getSquadronID() == "") 
				return;
			
			this.squad = new Squadron();
			this.squad.loadFile(
					mdm.Application.path 
						+ Globals.PATH_DATA
						+ Globals.PATH_SQUADRON 
						+ this.myObject.getSquadronID()
				);
			
			if( squad.getSrcLogo() != "" )
			{
				var l:ImageLoader = new ImageLoader(
						mdm.Application.path 
							+ Globals.PATH_IMAGES
							+ Globals.PATH_SQUADRON
							+ squad.getSrcLogo(),
						"SquadLogoLoader"	
					);
				l.addNext(this.loader);
				this.loader = l;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSquadron
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getSquadron():Squadron
		{
			return this.squad;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getFoto
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getFoto():Bitmap
		{
			if( this.foto == null )
				return null;
				
			return new Bitmap(this.foto.bitmapData.clone());
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getFlag
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getFlag():Bitmap
		{
			if( this.flag == null )
				return null;
				
			return new Bitmap(this.flag.bitmapData.clone());
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSquadLogo
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getSquadLogo():Bitmap
		{
			if( this.squadLogo == null )
				return null;
				
			return new Bitmap(this.squadLogo.bitmapData.clone());
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * imageLoadedHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function imageLoadedHandler(e:Event):void
		{
			var current:ImageLoader = ImageLoader(e.currentTarget);
			var bmp:Bitmap = current.getImage();
			bmp.smoothing = true;

			if( current.getName() == "FotoLoader" )
			{
				this.foto = bmp;
			
			} else if( current.getName() == "FlagLoader" ) {
				this.flag = bmp;
			
			} else if( current.getName() == "SquadLogoLoader" ) {
				this.squadLogo = bmp;
			}
			var nl:ImageLoader = ImageLoader( current.getNext() );
			current.dispose();
			this.loader = nl;

			if( this.loader == null )
			{
				this.initPages();
				return;
			}
			this.loader.addEventListener(
					Event.COMPLETE, 
					imageLoadedHandler
				);
			
			this.loader.load();
		}
		
	}
}