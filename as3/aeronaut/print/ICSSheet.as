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
	import as3.aeronaut.objects.ICSBaseObject;
	
	// =========================================================================
	// ICSSheet
	// =========================================================================
	// @see CSAbstractSheet
	//
	// Base interface for all CSAbstractSheets's.
	// Your subclass needs to extend CSAbstractSheets and implement a sub-interface 
	// of ICSSheet.
	// 
	public interface ICSSheet
	{
		/**
		 * ---------------------------------------------------------------------
		 * initFromObject
		 * ---------------------------------------------------------------------
		 * set the object.
		 *
		 * @param obj
		 */
		function initFromObject(obj:ICSBaseObject):void;
		
		/**
		 * ---------------------------------------------------------------------
		 * isReady
		 * ---------------------------------------------------------------------
		 * returns true if the object was fully parsed and 
		 * all additional data was loaded.
		 *
		 * @return
		 */
		function isReady():Boolean;
	}
}