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
package as3.aeronaut.objects
{
	// MDM ZINC Lib
	import mdm.*;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.XMLProcessor;
		
	import as3.aeronaut.objects.baseData.*;
	
	// =========================================================================
	// AircraftConfigs
	// =========================================================================
	// object for aircraftConfigs.ae
	// read only
	public class AircraftConfigs
	{
		// =====================================================================
		// Constants
		// =====================================================================
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var ready:Boolean = false;
		private var myXML:XML = new XML();
				
		// =====================================================================
		// Constructor
		// =====================================================================
		public function AircraftConfigs()
		{
			var file:String = mdm.Application.path 
					+ Globals.PATH_DATA 
					+ "aircraftConfigs" 
					+ Globals.AE_EXT;
			this.myXML = XMLProcessor.loadXML(file);
			
			if( this.myXML == null ) 
				return;
			
			if( XMLProcessor.checkDoc(this.myXML) == false ) 
				return;
			
			ready = true;
			
			
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * isReady
		 * ---------------------------------------------------------------------
		 *
		 * @return
		 */
		public function isReady():Boolean
		{
			return ready;
		}
		
		
		
	}
}