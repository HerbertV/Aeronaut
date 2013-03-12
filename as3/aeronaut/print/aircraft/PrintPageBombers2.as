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
	 * Class PrintPageAutogyro
	 * =========================================================================
	 * Library Symbol linked class for Bomber page 2
	 * 
	 * Page 2 includes the crew and weapons
	 */
	public class PrintPageBombers2
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
		public function PrintPageBombers2()
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
		public function initFromAircraft(obj:Aircraft):void
		{
			this.myObject = obj;
			
			var company:String = "";
			if( obj.getManufacturerID() != "" ) 
				company = Globals.myBaseData.getCompany(
						obj.getManufacturerID()
					).shortName + " ";
			
			this.lblConstructionName.htmlText = "<b>" 
					+ company 
					+ obj.getName()
					+ "</b>";
			
			this.lblBTN.htmlText = "<b>" 
					+ Globals.myAircraftConfigs.getBTNByIndex(obj.getBaseTarget()) 
					+ "</b>";
					
					
			// Frame 
			this.lblFrameType.text = "Heavy Fighter";
			//Prop
			var usedProp:String = obj.getPropType();
			if (usedProp == "tractor") {
				this.lblPropType.text = "Tractor";
			} else if (usedProp == "pusher") {
				this.lblPropType.text = "Pusher";
			} else if (usedProp == "double") {
				this.lblPropType.text = "Double";
			}
			this.lblEngineCount.text = String(obj.getEngineCount());
			this.lblCrewCount.text = String(obj.getCrewCount());
			this.lblFreightRoom.text = CSFormatter.formatLbs( obj.getFreeWeight() );
			
			var gmods:Array = this.initSpecialCharacteristics();
			this.initGs(gmods[0],gmods[1]);
			this.initMaxSpeed();
			this.initAccel();
			
			this.myWeapons.init(
					obj, 
					SheetAircraft(this.mySheet).getLoadout() 
				);
			
			this.initPilot();
			this.initArmor();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initPilot
		 * ---------------------------------------------------------------------
		 */
		private function initPilot()
		{
			var pilot:Pilot = SheetAircraft(this.mySheet).getPilot();
			
			if( pilot == null )
			{
				this.lblPilotName.text = "";
				this.lblSquadName.text = "";
				this.lblAircraftName.text = "";
				this.lblNT.htmlText = "";
				this.lblSS.htmlText = "";
				this.lblDE.htmlText = "";
				this.lblSH.htmlText = "";
				this.lblCO.htmlText = "";
				this.lblQD.htmlText = "";
				return;
			}
			
			this.lblAircraftName.text = pilot.getPlanename();
				
			this.lblNT.htmlText = "<b>" + pilot.getNaturalTouch() + "</b>";
			this.lblSS.htmlText = "<b>" + pilot.getSixthSense() + "</b>";
			this.lblDE.htmlText = "<b>" + pilot.getDeadEye() + "</b>";
			this.lblSH.htmlText = "<b>" + pilot.getSteadyHand() + "</b>";
			this.lblCO.htmlText = "<b>" + pilot.getConstitution() + "</b>";
				
			var strQD:String = "<b>"+ pilot.getQuickDraw()[0];
			if( pilot.getQuickDraw()[1] > 0 ) 
				strQD = strQD + "." + pilot.getQuickDraw()[1];
				
			strQD = strQD + "</b>";
			this.lblQD.htmlText = strQD;
			
			var gunner:Pilot = null;
			if( SheetAircraft(this.mySheet).getCrew().length > 0 )
				gunner = Pilot(SheetAircraft(this.mySheet).getCrew()[0]);
			
			this.lblPilotName.text = pilot.getName();
		
			if( gunner != null ) {
				this.lblPilotName.appendText("\nCo-pilot: " + gunner.getName());  
			} else {
				this.lblPilotName.y = 89;
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
		
		
		/**
		 * ---------------------------------------------------------------------
		 * initSpecialCharacteristics
		 * ---------------------------------------------------------------------
		 * returns the left and right g-mod if the aircraft 
		 * has a hightorque engine [0] = left [1] = right
		 *
		 * @return
		 */
		private function initSpecialCharacteristics():Array
		{
			this.lblSpecial.text = "";
			
			var arrSC:Array = this.myObject.getSpecialCharacteristics();
			var specialObj:SpecialCharacteristic = null;
			var gmods:Array = new Array(int(0),int(0));
			
			this.boxNitro.visible = false;
			
			for( var i:int=0; i< arrSC.length; i++ ) 
			{
				specialObj = Globals.myBaseData.getSpecialCharacteristic(arrSC[i]);
				
				if( specialObj.myID == BaseData.HCID_SC_NITRO5
				   		|| specialObj.myID == BaseData.HCID_SC_NITRO4 ) 
					this.boxNitro.visible = true;
				
				if( specialObj.myID == BaseData.HCID_SC_HIGHTORQUE ) 
				{
					gmods = Aircraft.calcHighTorqueMods(
							this.myObject.getBaseTarget(), 
							this.myObject.getMaxSpeed(), 
							this.myObject.getAccelRate()
						);
					this.lblSpecial.appendText(
							"- " + specialObj.myName 
								+ "(" + gmods[0] + "/" + gmods[1] + ")\n" 
						);
				
				} else {
					this.lblSpecial.appendText(
							"- " + specialObj.myName + "\n"
						);
				}
			}
			return gmods;
		}
		
		
	}
}