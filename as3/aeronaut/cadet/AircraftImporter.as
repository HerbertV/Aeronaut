﻿/*
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
	import as3.aeronaut.objects.Aircraft;
	import as3.aeronaut.objects.aircraft.Gunpoint;
	import as3.aeronaut.objects.aircraft.Turret;
	import as3.aeronaut.objects.aircraftConfigs.FrameDefinition;
	import as3.aeronaut.objects.aircraftConfigs.TurretDefinition;
	import as3.aeronaut.objects.companies.Company;
	
	/**
	 * =========================================================================
	 * AicraftImporter
	 * =========================================================================
	 * For importing aircrafts from cadet (cdt) files.
	 */
	public class AircraftImporter
			extends AbstractCadetImporter 
	{
		
		// =====================================================================
		// Constants
		// =====================================================================
		
		private static const FRAME_TYPES:Array = new Array( 
				FrameDefinition.FT_FIGHTER, 
				FrameDefinition.FT_HEAVY_FIGHTER
			);
			
		private static const PROP_TYPES:Array = new Array(
				FrameDefinition.PT_TRACTOR,
				FrameDefinition.PT_PUSHER
			);
		
		private static const TURRET_DIR:Array = new Array(
				TurretDefinition.DIR_FRONT,
				TurretDefinition.DIR_REAR
			);
		
		private static const GUN_CAL:Array = new Array(
				"",
				"CAL_30_N",
				"CAL_40_N",
				"CAL_50_N",
				"CAL_60_N",
				"CAL_70_N"
			);
			
		private static const GUN_MOUNT:Array = new Array(
				"forward",
				"turret"
			);
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		private var aircraft:Aircraft;
		
		private var turretDir:String = "";
		
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
			if( bytes.readUTFBytes(5) != "CADET" )
				return false;
			
			if( bytes.readShort() != 1 )
				return false;
				
			if( bytes.readInt() != 2 )
				return false;
			
			aircraft.setName(this.parseString());
			this.parseManufacturer();
			
			//p.unknown.append(_read_int(f)) # appears to always be 0
			bytes.readInt();	
			
			this.parseMainStats();
			
			// skip p.ArmorRows = _read_int(f)
			// aeronaut calculates this.
			bytes.readInt();	
			
			this.parseTurret();
			this.parseSpecs();
			this.parseArmor();
			this.parseGuns();
			
			// loadouts are not used since
			// aeronauts loadouts are stored
			// in a seperate file
			
			return true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * parseManufacturer
		 * ---------------------------------------------------------------------
		 */
		private function parseManufacturer():void
		{
			var manufacturer:String = this.parseString();	
			var companies:Array = Globals.myCompanies.getCompanies();
			
			// check against longname 
			for each( var company:Company in companies )
			{
				if ( company.longName == manufacturer )
				{
					aircraft.setManufacturerID(company.myID)
					return;
				}
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * parseMainStats
		 * ---------------------------------------------------------------------
		 * all weights are skipped since aeronaut calcs everything on its
		 * own.
		 */
		private function parseMainStats():void
		{
			var ft:String = FRAME_TYPES[bytes.readInt()];
			aircraft.setFrameType(ft);
			var pt:String = PROP_TYPES[bytes.readInt()];
			aircraft.setPropType(pt);
			
			aircraft.setBaseTarget(bytes.readInt());
			
			//p.LoadedWeight = _read_int(f)
			bytes.readInt();
			//p.BaseToHitWeight = _read_int(f)
			bytes.readInt();
			
			aircraft.setMaxSpeed(bytes.readInt());
			//p.MaxSpeedWeight = _read_int(f)
			bytes.readInt();
			
			aircraft.setMaxGs(bytes.readInt());
			//p.MaxGsWeight = _read_int(f)
			bytes.readInt();
			
			aircraft.setAccelRate(bytes.readInt());
			//p.AccelerationWeight = _read_int(f)
			bytes.readInt();
			
			aircraft.setDecelRate(bytes.readInt());	
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * parseTurret
		 * ---------------------------------------------------------------------
		 */
		private function parseTurret():void
		{
			//p.TurretWeight = _read_int(f)
			bytes.readInt();
			// save for later use
			// p.TurretDirection = _turret_direction_enum[_read_int(f)]
			turretDir = TURRET_DIR[bytes.readInt()];
        }
		
		/**
		 * ---------------------------------------------------------------------
		 * parseSpecs
		 * ---------------------------------------------------------------------
		 */
		private function parseSpecs():void
		{
			aircraft.setRange(bytes.readInt());
			aircraft.setServiceCeiling(bytes.readInt() * 500);
		
			var arr:Array = CSFormatter.extractFeetInches(bytes.readInt());
			aircraft.setWingspan(arr[0], arr[1]);
			
			arr = CSFormatter.extractFeetInches(bytes.readInt());
			aircraft.setLength(arr[0], arr[1]);
			
			arr = CSFormatter.extractFeetInches(bytes.readInt());
			aircraft.setHeight(arr[0], arr[1]);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * parseArmor
		 * ---------------------------------------------------------------------
		 */
		private function parseArmor():void
		{
			aircraft.setArmorNose(bytes.readInt()*10);
			aircraft.setArmorPWL(bytes.readInt()*10);
			aircraft.setArmorPWT(bytes.readInt()*10);
			aircraft.setArmorSWL(bytes.readInt()*10);
			aircraft.setArmorSWT(bytes.readInt()*10);
			aircraft.setArmorTail(bytes.readInt()*10);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * parseGuns
		 * ---------------------------------------------------------------------
		 */
		private function parseGuns():void
		{
			// the good thing is cadet support only one turret.
			// this makes the turret import easier.
			var t:Turret = new Turret(turretDir);
			
			for( var i:int = 1; i < 9; i++ )
			{
				var cal:String = GUN_CAL[bytes.readInt()];
				var mount:String = GUN_MOUNT[bytes.readInt()];
				
				var gp:Gunpoint = new Gunpoint(i, cal);
				gp.direction = mount;
				
				if( mount == "turret")
					t.linkedGuns.push(i);
				
				aircraft.setGunpoint(gp);
			}
			
			if( t.linkedGuns.length == 0 )
				return;
			
			aircraft.setTurrets(new Array(t));
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