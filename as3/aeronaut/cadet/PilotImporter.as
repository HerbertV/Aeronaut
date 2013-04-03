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
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.CSFormatter;
	import as3.aeronaut.objects.Pilot;
	
	/**
	 * =========================================================================
	 * PilotImporter
	 * =========================================================================
	 * For importing aircrafts from cadet (cdt) files.
	 */
	public class PilotImporter
			extends AbstractCadetImporter 
	{
		
		// =====================================================================
		// Constants
		// =====================================================================
		private static const PTYPE:Array = new Array( 
				"hero", 
				"sidekick"
			);
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		private var pilot:Pilot;
		
		/**
		 * =====================================================================
		 * Contructor
		 * =====================================================================
		 * 
		 * @param b
		 */
		public function PilotImporter(b:ByteArray) 
		{
			super(b);
		
			this.pilot = new Pilot();
			this.pilot.createNew();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * parseBytes
		 * ---------------------------------------------------------------------
		 * @see AbstractCadetImporter
		 * @see https://bitbucket.org/neilh/cadetparser.py/src/c718f72dc9816a9c0e65843c8f5ead59cddf870d/parse.py?at=default
		 */
		override public function parseBytes():Boolean
		{
			// first check if it is a cadet file
			if( bytes.readUTFBytes(5) != "PILOT" )
				return false;
			
			// the next 2 entries seem liked the plane file some 
			// kind of version numbers
			if( bytes.readUnsignedInt() != 1 )
				return false;
				
			if( bytes.readUnsignedInt() != 1 )
				return false;
			
			pilot.setName(parseString());
			// squadname is skipped
			parseString();
			pilot.setPlanename(parseString());
			// hero or sidekick
			pilot.setType(Pilot.TYPE_PILOT);
			pilot.setSubType(PTYPE[bytes.readByte()]);
			
			this.parseSkills();
			
			pilot.setMissionCount(bytes.readInt());
			pilot.setKills(bytes.readInt());
			pilot.setCraftLost(bytes.readInt());
			pilot.setCurrentEP(bytes.readInt());
			pilot.setTotalEP(bytes.readInt());
	
			return true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * parseSkils
		 * ---------------------------------------------------------------------
		 */
		private function parseSkills():void
		{
			var statsHex:String = bytes.readInt().toString(16)
			
			pilot.setNaturalTouch( uint("0x"+statsHex.charAt(5)) );
			pilot.setSixthSense( uint("0x"+statsHex.charAt(4)) );
			pilot.setDeadEye( uint("0x"+statsHex.charAt(3)) );
			pilot.setSteadyHand( uint("0x"+statsHex.charAt(2)) );
			pilot.setConstitution( uint("0x"+statsHex.charAt(1)) );
			pilot.setQuickDraw( uint("0x"+statsHex.charAt(0)) );	
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getPilot
		 * ---------------------------------------------------------------------
		 * 
		 * @return
		 */
		public function getPilot():Pilot
		{
			return pilot;
		}
	}

}