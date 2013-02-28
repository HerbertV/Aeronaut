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
		
		/**
		 * ---------------------------------------------------------------------
		 * getBTNList
		 * ---------------------------------------------------------------------
		 * from baseTargetMatrix
		 *
		 * @return Array of BTN strings
		 */
		public function getBTNList():Array
		{
			var arr:Array = new Array();

			if( ready )
			{
				for each( var xml:XML in myXML..baseTarget ) 
				{
					var btn:String = xml.@BTN;
					arr.push(btn);
				}
			}
			return arr;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getBTNLoadedWeightByIndex
		 * ---------------------------------------------------------------------
		 * from baseTargetMatrix
		 *
		 * @param id indexID 
		 * 
		 * @return int loaded weight in lbs
		 */
		public function getBTNLoadedWeightByIndex(id:int):int
		{
			if( !ready ) 
				return 0;
			
			var xml:XMLList =  myXML..baseTarget.(@indexID == id);
			
			if( xml != null ) 
			{
				return xml.@loadedWeight
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"getBTNLoadedWeightByIndex:"+id+" not found!",
							DebugLevel.ERROR
						);
			}
			return 0;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getBTNPayloadByIndex
		 * ---------------------------------------------------------------------
		 * from baseTargetMatrix
		 *
		 * @param id indexID 
		 * 
		 * @return int payload in lbs
		 */
		public function getBTNPayloadByIndex(id:int):int
		{
			if( !ready ) 
				return 0;
			
			var xml:XMLList =  myXML..baseTarget.(@indexID == id);
			
			if( xml != null ) 
			{
				return xml.@payload
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"getBTNPayloadByIndex:"+id+" not found!",
							DebugLevel.ERROR
						);
			}
			return 0;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getBTNCostByIndex
		 * ---------------------------------------------------------------------
		 * from baseTargetMatrix
		 *
		 * @param id indexID 
		 * 
		 * @return int cost in dollar
		 */
		public function getBTNCostByIndex(id:int):int
		{
			if( !ready ) 
				return 0;
			
			var xml:XMLList =  myXML..baseTarget.(@indexID == id);
			
			if( xml != null ) 
			{
				return xml.@cost
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"getBTNCostByIndex:"+id+" not found!",
							DebugLevel.ERROR
						);
			}
			return 0;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getBTNmaxSCByIndex
		 * ---------------------------------------------------------------------
		 * from baseTargetMatrix
		 *
		 * @param id indexID 
		 * 
		 * @return int the max special characterisics
		 */
		public function getBTNmaxSCByIndex(id:int):int
		{
			if( !ready ) 
				return 0;
			
			var xml:XMLList =  myXML..baseTarget.(@indexID == id);
			
			if( xml != null ) 
			{
				return xml.@maxSC
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"getBTNmaxSCByIndex:"+id+" not found!",
							DebugLevel.ERROR
						);
			}
			return 0;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getMaxSpeedWeight
		 * ---------------------------------------------------------------------
		 * from maxSpeedMatrix
		 *
		 * @param id indexID 
		 * @param speed 
		 * 
		 * @return int weight in lbs
		 */
		public function getMaxSpeedWeight(id:int, speed:int):int
		{
			if( !ready ) 
				return 0;
			
			var xml:XMLList =  myXML..maxSpeed.(@btnID == id && @speed == speed);
			if( xml != null ) 
			{
				return xml.@weight
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"getMaxSpeedWeight:"+id+" and speed:"+speed+" not found!",
							DebugLevel.ERROR
						);
			}
			return 0;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getMaxSpeedCost
		 * ---------------------------------------------------------------------
		 * from maxSpeedMatrix
		 *
		 * @param id indexID 
		 * @param speed 
		 * 
		 * @return int cost in dollar
		 */
		public function getMaxSpeedCost(id:int, speed:int):int
		{
			if( !ready ) 
				return 0;
			
			var xml:XMLList =  myXML..maxSpeed.(@btnID == id && @speed == speed);
			if( xml != null ) 
			{
				return xml.@cost
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"getMaxSpeedCost:"+id+" and speed:"+speed+" not found!",
							DebugLevel.ERROR
						);
			}
			return 0;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getMaxGWeight
		 * ---------------------------------------------------------------------
		 * from maxGMatrix
		 *
		 * @param id indexID 
		 * @param gs 
		 * 
		 * @return int weight in lbs
		 */
		public function getMaxGWeight(id:int, gs:int):int
		{
			if( !ready ) 
				return 0;
			
			var xml:XMLList =  myXML..maxGForce.(@btnID == id && @g == gs);
			if( xml != null ) 
			{
				return xml.@weight
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"getMaxGWeight:"+id+" and Gs:"+gs+" not found!",
							DebugLevel.ERROR
						);
			}
			return 0;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getMaxGCost
		 * ---------------------------------------------------------------------
		 * from maxGMatrix
		 *
		 * @param id indexID 
		 * @param gs 
		 * 
		 * @return int cost in dollar
		 */
		public function getMaxGCost(id:int, gs:int):int
		{
			if( !ready ) 
				return 0;
			
			var xml:XMLList =  myXML..maxGForce.(@btnID == id && @g == gs);
			if( xml != null ) 
			{
				return xml.@cost
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"getMaxGCost:"+id+" and Gs:"+gs+" not found!",
							DebugLevel.ERROR
						);
			}
			return 0;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getMaxAccelWeight
		 * ---------------------------------------------------------------------
		 * from maxAccelerationMatrix
		 *
		 * @param id indexID 
		 * @param accel 
		 * 
		 * @return int weight in lbs
		 */
		public function getMaxAccelWeight(id:int, accel:int):int
		{
			if( !ready ) 
				return 0;
			
			var xml:XMLList =  myXML..maxAcceleration.(@btnID == id && @accel == accel);
			if( xml != null ) 
			{
				return xml.@weight
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"getMaxAccelWeight:"+id+" and accel:"+accel+" not found!",
							DebugLevel.ERROR
						);
			}
			return 0;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getMaxAccelCost
		 * ---------------------------------------------------------------------
		 * from maxAccelerationMatrix
		 *
		 * @param id indexID 
		 * @param accel 
		 * 
		 * @return int cost in dollar
		 */
		public function getMaxAccelCost(id:int, accel:int):int
		{
			if( !ready ) 
				return 0;
			
			var xml:XMLList =  myXML..maxAcceleration.(@btnID == id && @accel == accel);
			if( xml != null ) 
			{
				return xml.@cost
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"getMaxAccelCost:"+id+" and accel:"+accel+" not found!",
							DebugLevel.ERROR
						);
			}
			return 0;
		}
		
		
	}
}