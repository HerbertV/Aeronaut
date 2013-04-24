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
package as3.aeronaut.print.aircraft
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.text.TextField;
	
	import as3.aeronaut.print.CSAbstractPrintPage;
	import as3.aeronaut.print.ICSPrintPageAircraft;
	import as3.aeronaut.print.SheetAircraft;
	
	import as3.aeronaut.objects.Aircraft;
	import as3.aeronaut.objects.aircraft.Turret;
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.BaseData;
	import as3.aeronaut.objects.baseData.SpecialCharacteristic;
	import as3.aeronaut.objects.Pilot;
	import as3.aeronaut.objects.Squadron;
	import as3.aeronaut.objects.aircraftConfigs.TurretDefinition;
	
	import as3.aeronaut.Globals;
	
	import as3.hv.core.utils.BitmapHelper;
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	/**
	 * =========================================================================
	 * Class PrintPageCargo2
	 * =========================================================================
	 * Library Symbol linked class for Cargo page 2
	 * 
	 * Page 2 includes the crew and weapons
	 */
	public class PrintPageCargo2
			extends AbstractPrintPageLargeAircraft
			implements ICSPrintPageAircraft
	{
		// =====================================================================
		// Variables
		// =====================================================================
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 */
		public function PrintPageCargo2()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromAircraft
		 * ---------------------------------------------------------------------
		 * @see ICSPrintPageAircraft
		 *
		 * @param obj
		 */
		override public function initFromAircraft(obj:Aircraft):void
		{
			super.initFromAircraft(obj);
			
			setupCrew("", "Chief", SheetAircraft(this.mySheet).getCrewChief());
			setupCrew("", "Master", SheetAircraft(this.mySheet).getLoadMaster());
			
			var i:int;
			var arr:Array = SheetAircraft(this.mySheet).getCrewLoaders();
			for( i = 1; i < 9; i++ )
				setupCrew(String(i), "Loader", arr[i-1]);
			
			arr = SheetAircraft(this.mySheet).getGuards();
			for( i = 1; i < 7; i++ )
				setupCrew(String(i), "Guard", arr[i-1]);
			
			// TODO fill cargo if cargo page is done
			for ( i = 1; i < 3; i++ )
			{
				setupCargo("FL", i, null);
				setupCargo("AL", i, null);
				setupCargo("FR", i, null);
				setupCargo("AR", i, null);
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setupCrew
		 * ---------------------------------------------------------------------
		 * @param num can be "" or a number
		 * @param crewtype Loader, Guard, Chief or Master
		 * @param crew of class pilot
		 */
		protected function setupCrew(
				num:String,
				crewtype:String,
				crew:Pilot
			):void
		{
			if( crew == null )
			{
				TextField(this.myCrew.getChildByName("lbl"+ crewtype + num + "Name")).text = "";
				TextField(this.myCrew.getChildByName("lbl"+ crewtype + num + "NT")).htmlText = "";
				TextField(this.myCrew.getChildByName("lbl"+ crewtype + num + "SS")).htmlText = "";
				TextField(this.myCrew.getChildByName("lbl"+ crewtype + num + "DE")).htmlText = "";
				TextField(this.myCrew.getChildByName("lbl"+ crewtype + num + "SH")).htmlText = "";
				TextField(this.myCrew.getChildByName("lbl"+ crewtype + num + "CO")).htmlText = "";
				TextField(this.myCrew.getChildByName("lbl"+ crewtype + num + "QD")).htmlText = "";
				return;
			}
			
			TextField(this.myCrew.getChildByName("lbl"+ crewtype + num + "Name")).htmlText = 
					crew.getName();
			TextField(this.myCrew.getChildByName("lbl"+ crewtype + num + "NT")).htmlText = 
					"<b>" + crew.getNaturalTouch() + "</b>";
			TextField(this.myCrew.getChildByName("lbl"+ crewtype + num + "SS")).htmlText = 
					"<b>" + crew.getSixthSense() + "</b>";
			TextField(this.myCrew.getChildByName("lbl"+ crewtype + num + "DE")).htmlText = 
					"<b>" + crew.getDeadEye() + "</b>";
			TextField(this.myCrew.getChildByName("lbl"+ crewtype + num + "SH")).htmlText = 
					"<b>" + crew.getSteadyHand() + "</b>";
			TextField(this.myCrew.getChildByName("lbl"+ crewtype + num + "CO")).htmlText = 
					"<b>" + crew.getConstitution() + "</b>";
			
			var strQD:String = "<b>"+ crew.getQuickDraw()[0];
			if( crew.getQuickDraw()[1] > 0 ) 
				strQD = strQD + "." + crew.getQuickDraw()[1];
				
			strQD = strQD + "</b>";
			TextField(this.myCrew.getChildByName("lbl"+ crewtype + num + "QD")).htmlText = strQD;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setupRocket
		 * ---------------------------------------------------------------------
		 * @param bay
		 * @param idx
		 * @param loadout
		 */
		protected function setupCargo(
				bay:String,
				idx:uint,
				cargo:String
			):void
		{
			var lblCargo:TextField = 
				TextField(this.myCargo.getChildByName("lbl" + bay + "Cargo" + idx));
			
			lblCargo.text = "";	
			if( cargo == null ) 
				return;
			
			lblCargo.text = cargo;
		}
		
	}
}