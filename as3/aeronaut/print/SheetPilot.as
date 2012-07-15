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

	import flash.display.Sprite;
	
	import as3.aeronaut.print.pilot.*;
	
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.Pilot;
	import as3.aeronaut.objects.Squadron;
	
	import as3.aeronaut.Globals;
	
	// =========================================================================
	// Class SheetPilot
	// =========================================================================
	// 
	//
	public class SheetPilot
			extends CSAbstractSheet
			implements ICSSheetPilot
	{
		
		// =====================================================================
		// Constants
		// =====================================================================
		public static const FOTO_WIDTH:int = 104;
		public static const FOTO_HEIGHT:int = 128;
		
		public static const FLAG_WIDTH:int = 55;
		public static const FLAG_HEIGHT:int = 35;
		
		public static const SQUADLOGO_WIDTH:int = 35;
		public static const SQUADLOGO_HEIGHT:int = 35;
	
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		private var myObject:Pilot;
		private var squad:Squadron;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function SheetPilot()
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
		 * @see ICSSheet
		 *
		 * @param obj
		 */
		public function initFromObject(obj:ICSBaseObject):void
		{
			this.initFromPilot( Pilot(obj) );
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromPilot
		 * ---------------------------------------------------------------------
		 * @see ICSSheetPilot
		 *
		 * @param obj
		 */
		public function initFromPilot(obj:Pilot):void
		{
			this.myObject = obj;
			
			this.loadSquadron();

// TODO load images (squad logo and nation flag and foto)
			
			var page:ICSPrintPagePilot;
			
			page = new PagePilot();
			CSAbstractPrintPage(page).setSheet(this);
			page.initFromPilot(obj);
			this.pages.push(page);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * isReady
		 * ---------------------------------------------------------------------
		 * @see ICSSheet
		 *
		 * @return
		 */
		override public function isReady():Boolean
		{
			if( this.pages.length == 0 )
				return false;
				
			return true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * loadSquadron
		 * ---------------------------------------------------------------------
		 */
		private function loadSquadron():void
		{
			if( this.myObject.getSquadronID() == "") 
				return;
			
			this.squad = new Squadron();
			this.squad.loadFile(
					mdm.Application.path 
						+ Globals.PATH_DATA
						+ Globals.PATH_SQUADRON 
						+ this.myObject.getSquadronID()
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSquadron
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getSquadron():Squadron
		{
			return this.squad;
		}
		
	}
}