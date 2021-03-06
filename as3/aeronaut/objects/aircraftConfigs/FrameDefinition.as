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
 * Copyright (c) 2009-2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.objects.aircraftConfigs
{
	/**
	 * =========================================================================
	 * FrameDefinition
	 * =========================================================================
	 */ 
	public class FrameDefinition
	{
		// =====================================================================
		// Constants
		// =====================================================================
		// Frame types
		public static const FT_FIGHTER:String = "fighter";
		public static const FT_HEAVY_FIGHTER:String = "heavyFighter";
		public static const FT_AUTOGYRO:String = "hoplite";
		public static const FT_HEAVY_BOMBER:String = "heavyBomber";
		public static const FT_LIGHT_BOMBER:String = "lightBomber";
		public static const FT_HEAVY_CARGO:String = "heavyCargo";
		public static const FT_LIGHT_CARGO:String = "lightCargo";
		
		// Prop types
		public static const PT_PUSHER:String = "pusher";
		public static const PT_TRACTOR:String = "tractor";
		public static const PT_AUTOGYRO:String = "hoplite";
		public static const PT_DOUBLE:String = "double";
		
		// turret setups
		public static const TURRET_NO:int = 0;
		public static const TURRET_MAYHAVE:int = 1;
		public static const TURRET_ONLY:int = 2;
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		// similiar to an id
		public var frameType:String;
		
		public var allowedProps:Array;
		
		public var minBaseTarget:int;
		public var maxBaseTarget:int;
		
		public var minSpeed:int;
		public var maxSpeed:int;
		
		public var minGs:int;
		public var maxGs:int;
		
		public var minAccel:int;
		public var maxAccel:int;
		
		public var minDecel:int;
		public var maxDecel:int;
		
		public var hasWings:Boolean = false;
		public var hasBows:Boolean = false;
		
		public var maxGuns:int;
		
		public var allowsTurrets:int;
		
		public var turretDefs:Array;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 * 
		 * @param frame	frame type
		 * @param props
		 * @param minbtn	
		 * @param maxbtn	
		 * @param mins
		 * @param maxs	
		 * @param ming	
		 * @param maxg	
		 * @param mina	
		 * @param maxa	
		 * @param mind
		 * @param maxd	
		 * @param wings	
		 * @param bows	
		 * @param guns	
		 * @param ta
		 * @param td
		 */
		public function FrameDefinition(
				frame:String,
				props:Array,
				minbtn:int,
				maxbtn:int,
				mins:int,
				maxs:int,
				ming:int,
				maxg:int,
				mina:int,
				maxa:int,
				mind:int,
				maxd:int,
				wings:Boolean,
				bows:Boolean,
				guns:int,
				ta:int,
				td:Array
			)
		{
			frameType = frame;
			allowedProps = props;
			
			minBaseTarget = minbtn;
			maxBaseTarget = maxbtn;
		
			minSpeed = mins;
			maxSpeed = maxs;
		
			minGs = ming;
			maxGs = maxg;
		
			minAccel = mina;
			maxAccel = maxa;
		
			minDecel = mind;
			maxDecel = maxd;
		
			hasWings = wings;
			hasBows = bows;
		
			maxGuns = guns;
		
			allowsTurrets = ta;
			turretDefs = td;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getTurretDirectionForGunPoint
		 * ---------------------------------------------------------------------
		 *
		 * @param gp gunpoint number 1-10
		 *
		 * @return direction as string
		 */
		public function getTurretDirectionForGunPoint(gp:int):String
		{
			if( turretDefs == null || turretDefs.length == 0 ) 
				return "";
			
			for each( var td:TurretDefinition in turretDefs )
				if( td.linkedGuns.indexOf(String(gp)) > -1 )
					return td.direction;
					
			return "";		
		}	
		
		/**
		 * ---------------------------------------------------------------------
		 * getTurretDirectionForGunPoint
		 * ---------------------------------------------------------------------
		 *
		 * @param dir
		 *
		 * @return TurretDefiniton
		 */
		public function getTurretDefinitionForDirection(dir:String):TurretDefinition
		{
			for each( var td:TurretDefinition in turretDefs )
				if( td.direction == dir )
					return td;
			
			return null;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * toString
		 * ---------------------------------------------------------------------
		 *
		 * @return Object as string
		 */
		public function toString():String
		{
			return "aircraftConfigs.FrameDefinition ["
				+ frameType 
				+ ", btn: " + minBaseTarget + "-" + maxBaseTarget 
				+ ", speed: " + minSpeed + "-" + maxSpeed 
				+ ", Gs: " + minGs + "-" + maxGs 
				+ ", accel: " + minAccel + "-" + maxAccel 
				+ ", decel: " + minDecel + "-" + maxDecel 
				+ "]";
		}
	
	}
}