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
package as3.aeronaut.objects.aircraftConfigs
{
	// =========================================================================
	// TurretDefinition
	// =========================================================================
	// 
	public class TurretDefinition
	{
		// =====================================================================
		// Constants
		// =====================================================================
		//nose
		public static const DIR_FRONT:String = "front";
		//aft
		public static const DIR_REAR:String = "rear"; 
		//left side
		public static const DIR_LEFT:String = "left"; 
		//right side
		public static const DIR_RIGHT:String = "right"; 
		//top
		public static const DIR_DORSAL:String = "dorsal"; 
		//bottom
		public static const DIR_VENTRAL:String = "ventral"; 
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		public var direction:String = "front";
		
		public var linkedGuns:Array = new Array();
		
		public var weight:int;
		
		public var cost:int;
		
		
		// =====================================================================
		// Constructor
		// =====================================================================
		
		/**
		 * Constructor
		 * 
		 * @param dir
		 * @param linked
		 * @param w
		 * @param c
		 */
		public function TurretDefinition(
				dir:String,
				linked:Array,
				w:int,
				c:int
			)
		{
			this.direction = dir;
			this.linkedGuns = linked;
			this.weight = w;
			this.cost = c;
		}
	
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getLabelforDirection
		 * ---------------------------------------------------------------------
		 *
		 * @param dir
		 *
		 * @return label as string
		 */
		public static function getLabelforDirection(dir:String):String
		{
			if( dir == DIR_FRONT )
				return "Nose";
			
			if( dir == DIR_REAR )
				return "Aft";
			
			if( dir == DIR_LEFT )
				return "L. Side";
			
			if( dir == DIR_RIGHT )
				return "R. Side";
			
			if( dir == DIR_DORSAL )
				return "Dorsal";
			
			if( dir == DIR_VENTRAL )
				return "Ventral";
			
			return "";
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
			return "aircraftConfigs.TurretDefinition ["
				+ this.direction
				+ ", linked guns[ " + linkedGuns.toString() 
				+ "] ]";
		}
	
	}
}