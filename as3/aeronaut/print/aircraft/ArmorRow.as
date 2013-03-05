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
package as3.aeronaut.print.aircraft 
{
	/**
	 * =========================================================================
	 * ArmorRow
	 * =========================================================================
	 * for defining armour row offset for each armour section.
	 */ 
	public class ArmorRow 
	{
		// =====================================================================
		// Constants
		// =====================================================================
		
		public static const ID_PWL:String = "pwl";
		public static const ID_NOSE:String = "nose";
		public static const ID_SWL:String = "swl";
		public static const ID_PWT:String = "pwt";
		public static const ID_TAIL:String = "tail";
		public static const ID_TAIL_TURRET:String = "tt";
		public static const ID_SWT:String = "swt";
		public static const ID_PB:String = "pb";
		public static const ID_PS:String = "ps";
		public static const ID_SB:String = "sb";
		public static const ID_SS:String = "ss";
		
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		public var id:String;
		public var isfront:Boolean;
		public var x:Number;
		public var y:Number;
		
		//alternate coords for bombers and cargos
		public var xBC:Number;
		public var yBC:Number;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 * 
		 * @param	rowid
		 * @param	front
		 * @param	xf
		 * @param	yf
		 * @param	xbc
		 * @param	ybc
		 */
		public function ArmorRow(
				rowid:String,
				front:Boolean,
				xf:Number,
				yf:Number,
				xbc:Number = 0.0,
				ybc:Number = 0.0
			) 
		{
			this.id = rowid;
			this.isfront = front;
			this.x = xf;
			this.y = yf;
			this.xBC = xbc;
			this.yBC = ybc;
		}
	}

}