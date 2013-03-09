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
 * Copyright (c) 2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.cadet 
{
	import flash.utils.ByteArray;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	import as3.aeronaut.objects.Aircraft;
	
	/**
	 * =========================================================================
	 * AicraftImporter
	 * =========================================================================
	 * For importing aircrafts from cadet files.
	 * 
	 */
	public class AircraftImporter
			extends AbstractCadetImporter 
	{
		
		private var aircraft:Aircraft;
		
		/**
		 * =====================================================================
		 * Contructor
		 * =====================================================================
		 * 
		 * @param b
		 */
		public function AircraftImporter(b:ByteArray) 
		{
			super(b);
		
			this.aircraft = new Aircraft();
			this.aircraft.createNew();
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * parseBytes
		 * ---------------------------------------------------------------------
		 * @see AbstractCadetImporter
		 */
		override public function parseBytes():Boolean
		{
			return true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getAircraft
		 * ---------------------------------------------------------------------
		 * 
		 * @return
		 */
		public function getAircraft():Aircraft
		{
			return aircraft;
		}
	}

}