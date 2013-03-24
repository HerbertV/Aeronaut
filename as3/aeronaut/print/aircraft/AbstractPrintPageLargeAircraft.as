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
	
	import as3.aeronaut.CSFormatter;
	import as3.aeronaut.Globals;
	
	import as3.hv.core.utils.BitmapHelper;
	
	/**
	 * =========================================================================
	 * Class AbstractPrintPageLargeAircraft
	 * =========================================================================
	 * Abtract Class for printing one page aircraft sheets 
	 * for Fighter, Heavy Fighters and Autogyros.
	 * 
	 * must contain all repeating header infos:
	 * - containerSquadLogo
	 * - lblConstructionName
	 * - lblSquadName
	 * - lblAircraftName
	 */
	dynamic public class AbstractPrintPageLargeAircraft
			extends CSAbstractPrintPage
			implements ICSPrintPageAircraft
	{
		// =====================================================================
		// Variables
		// =====================================================================
		protected var myObject:Aircraft;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 */
		public function AbstractPrintPageLargeAircraft()
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
		public function initFromObject(obj:ICSBaseObject):void
		{
			this.initFromAircraft(Aircraft(obj));
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromAircraft
		 * ---------------------------------------------------------------------
		 * @see ICSPrintPageAircraft
		 *
		 * @param obj
		 */
		public function initFromAircraft(obj:Aircraft):void
		{
			super.init();
			this.myObject = obj;
			
			var company:String = "";
			if( obj.getManufacturerID() != "" ) 
				company = Globals.myCompanies.getCompany(
						obj.getManufacturerID()
					).shortName + " ";
			
			this.lblConstructionName.htmlText = "<b>" 
					+ company 
					+ obj.getName()
					+ "</b>";
			
			var pilot:Pilot = SheetAircraft(this.mySheet).getPilot();
			
			if ( pilot == null )
			{
				this.lblPilotName.text = "";
				this.lblAircraftName.text = "";
				
			} else {
				this.lblAircraftName.text = pilot.getPlanename();
				this.lblPilotName.text = pilot.getName();
			}
			
			var squad:Squadron = SheetAircraft(this.mySheet).getSquadron();
			if( squad != null ) 
			{
				this.lblSquadName.text = squad.getName();
				
				if( SheetAircraft(this.mySheet).getSquadLogo() != null )
				{
					var logo:Bitmap = SheetAircraft(this.mySheet).getSquadLogo();
					logo = BitmapHelper.resizeBitmap(
							logo, 
							SheetAircraft.SQUADLOGO_WIDTH, 
							SheetAircraft.SQUADLOGO_HEIGHT, 
							false
						);
					
					logo.x -= logo.width/2;
					logo.y -= logo.height/2;
					this.containerSquadLogo.addChild(logo);
				}
			} else {
				this.lblSquadName.text = "";
			}
		}
		
	}
}