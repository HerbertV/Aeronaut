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
 * Copyright (c) 2009-2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.print
{
	// MDM ZINC Lib
	import mdm.*;

	import as3.aeronaut.print.aircraft.*;
	
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.Aircraft;
	
	
	// =========================================================================
	// Class SheetAircraft
	// =========================================================================
	// 
	//
	public class SheetAircraft 
			extends CSAbstractSheet
			implements ICSSheetAircraft
	{
		
		// =====================================================================
		// Constants
		// =====================================================================
		public static const ARMORLINE_HEIGHT:int = 8;
		
		// raster offsets
		public static const OFFSET_X_PWL:Number = 39.0;
		public static const OFFSET_Y_PWL:Number = 468.5;
		
		public static const OFFSET_X_NOSE:Number = 145.0;
		public static const OFFSET_Y_NOSE:Number = 404.5;
		
		public static const OFFSET_X_SWL:Number = 250.5;
		public static const OFFSET_Y_SWL:Number = 468.5;
		
		public static const OFFSET_X_PWT:Number = 39.0;
		public static const OFFSET_Y_PWT:Number = 532.0;
		
		public static const OFFSET_X_TAIL:Number = 145.0;
		public static const OFFSET_Y_TAIL:Number = 571.5;
		
		public static const OFFSET_X_TAILTURRET:Number = 145.0;
		public static const OFFSET_Y_TAILTURRET:Number = 587.5;
		
		public static const OFFSET_X_SWT:Number = 250.5;
		public static const OFFSET_Y_SWT:Number = 532.0;
		
// TODO Bomber wing sections
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function SheetAircraft()
		{
			super();
		}

		// =====================================================================
		// Functions
		// =====================================================================
		
		
	}
}