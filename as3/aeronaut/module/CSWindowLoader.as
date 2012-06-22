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
 * Copyright (c) 2010-2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.module
{
	import flash.display.MovieClip;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import as3.hv.core.net.ModuleLoader;
	import as3.hv.components.progress.IProgressSymbol;
	
	import as3.aeronaut.Globals;
	
	// =========================================================================
	// CSWindowLoader
	// =========================================================================
	// A loader for CSWindow Modules that shows our ProgressSymbol
	public class CSWindowLoader
			extends ModuleLoader
	{
		
		// =====================================================================
		// Constructors
		// =====================================================================
		
		/**
		 * Constructor		
		 *
		 * @param file
		 * @param target
		 */
		public function CSWindowLoader(
				file:String,
				target:MovieClip
			)
		{
			// all window's need to be compiled with the same version
			// as our root fla, we simply use the Globals.version 
			// application version) to enshure this.
			super(
				  	file,
					target,
					Globals.version,
					"CSWindowLoader"
				);
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * load
		 * ---------------------------------------------------------------------
		 * overridden to init the progressbar 
		 *
		 * @param file filename with relative/absolute path
		 */
		override public function load():void
		{
			super.load();
			
			Globals.myCSProgressBar.init();
		}
		
		// =====================================================================
		// Eventhandler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * completeHandler
		 * ---------------------------------------------------------------------
		 * overridden for progressbar handling
		 *
		 * @param e	Complete Event
		 */
		override protected function completeHandler(e:Event):void 
		{
			super.completeHandler(e);
		
			Globals.myCSProgressBar.setProgressTo(100,"loading finished");
			Globals.myCSProgressBar.hide();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * progressHandler
		 * ---------------------------------------------------------------------
		 * overridden for progressbar handling
		 *
		 * @param e	Progress Event
		 */
		override protected function progressHandler(e:ProgressEvent):void 
		{
			super.progressHandler(e);
		
			Globals.myCSProgressBar.setProgressTo(
					this.getPercentLoaded(),
					"loading ..."
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * ioErrorHandler
		 * ---------------------------------------------------------------------
		 * overridden for progressbar handling
		 *
		 * @param e	IOErrorEvent
		 */
		override protected function ioErrorHandler(e:IOErrorEvent):void 
		{
        	super.ioErrorHandler(e);
			
			Globals.myCSProgressBar.hide();
		}
		
	}
}