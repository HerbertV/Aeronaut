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
package as3.aeronaut.print.pilot
{
	import as3.aeronaut.print.CSAbstractPrintPage;
	import as3.aeronaut.print.ICSPrintPagePilot;
		
	import as3.aeronaut.objects.Pilot;
	import as3.aeronaut.objects.ICSBaseObject;
	
	// =========================================================================
	// Class PrintPagePilot
	// =========================================================================
	// Library Symbol linked class for Pilot Page 
	//
	public class PrintPagePilot
			extends CSAbstractPrintPage
			implements ICSPrintPagePilot
	{
		// =====================================================================
		// Variables
		// =====================================================================
		private var myObject:Pilot;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function PrintPagePilot()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromObject
		 * ---------------------------------------------------------------------
		 * @see ICSPrintPage
		 *
		 * @param obj
		 */
		function initFromObject(obj:ICSBaseObject):void
		{
			this.initFromPilot(Pilot(obj));
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromPilot
		 * ---------------------------------------------------------------------
		 * @see ICSPrintPagePilot
		 *
		 * @param obj
		 */
		function initFromPilot(obj:Pilot):void
		{
			this.myObject = obj;
			
			this.lblPilotName.text = obj.getName();
			
			
			//TODO
		}
		
	}
}