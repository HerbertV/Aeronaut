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
	import as3.aeronaut.objects.aircraftConfigs.FrameDefinition;
	
	
	import as3.aeronaut.CSFormatter;
	import as3.aeronaut.Globals;
	
	import as3.hv.core.utils.BitmapHelper;
	
	/**
	 * =========================================================================
	 * Class PrintPageCargo1
	 * =========================================================================
	 * Library Symbol linked class for Cargo page 1
	 * 
	 * Page 1 has:
	 *  - myDamageRaster
	 *  - boxPerformance
	 *  - lblBTN
	 *  - lblFrameType
	 *  - lblPropType
	 *  - lblSpecial
	 */
	public class PrintPageCargo1
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
		public function PrintPageCargo1()
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
			
			this.lblBTN.htmlText = "<b>" 
					+ Globals.myAircraftConfigs.getBTNByIndex(obj.getBaseTarget()) 
					+ "</b>";
					
					
			// Frame 
			if( obj.getFrameType() == FrameDefinition.FT_HEAVY_CARGO )
			{
				this.lblFrameType.text = "Heavy Cargo";
				
			} else if( obj.getFrameType() == FrameDefinition.FT_LIGHT_CARGO ) {
				this.lblFrameType.text = "Light Cargo";
			} 
			
			//Prop
			var usedProp:String = obj.getPropType();
			if( usedProp == "tractor" ) {
				this.lblPropType.text = "Tractor";
			} else if (usedProp == "pusher") {
				this.lblPropType.text = "Pusher";
			} else if (usedProp == "double") {
				this.lblPropType.text = "Double";
			}
			this.lblEngineCount.text = String(obj.getEngineCount());
			this.lblCrewCount.text = String(obj.getCrewCount());
			this.lblFreightRoom.text = CSFormatter.formatLbs( obj.getFreeWeight() );
			
			this.initSpecialCharacteristics();
			this.initGs();
			this.initMaxSpeed();
			this.initAccel();
			
			this.initPilot();
			this.initCoPilot();
			
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
				this.lblPilotNT.htmlText = "";
				this.lblPilotSS.htmlText = "";
				this.lblPilotDE.htmlText = "";
				this.lblPilotSH.htmlText = "";
				this.lblPilotCO.htmlText = "";
				this.lblPilotQD.htmlText = "";
				return;
			}
			
			this.lblPilotNT.htmlText = "<b>" + pilot.getNaturalTouch() + "</b>";
			this.lblPilotSS.htmlText = "<b>" + pilot.getSixthSense() + "</b>";
			this.lblPilotDE.htmlText = "<b>" + pilot.getDeadEye() + "</b>";
			this.lblPilotSH.htmlText = "<b>" + pilot.getSteadyHand() + "</b>";
			this.lblPilotCO.htmlText = "<b>" + pilot.getConstitution() + "</b>";
				
			var strQD:String = "<b>"+ pilot.getQuickDraw()[0];
			if( pilot.getQuickDraw()[1] > 0 ) 
				strQD = strQD + "." + pilot.getQuickDraw()[1];
				
			strQD = strQD + "</b>";
			this.lblPilotQD.htmlText = strQD;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initCoPilot
		 * ---------------------------------------------------------------------
		 */
		private function initCoPilot()
		{
			// TODO load copilot
			//var pilot:Pilot = SheetAircraft(this.mySheet).getPilot();
			
			//if( pilot == null )
			//{
				this.lblCoPilotName.text = "";
				this.lblCoPilotNT.htmlText = "";
				this.lblCoPilotSS.htmlText = "";
				this.lblCoPilotDE.htmlText = "";
				this.lblCoPilotSH.htmlText = "";
				this.lblCoPilotCO.htmlText = "";
				this.lblCoPilotQD.htmlText = "";
			//	return;
			//}
			/*
			this.lblCoPilotNT.htmlText = "<b>" + pilot.getNaturalTouch() + "</b>";
			this.lblCoPilotSS.htmlText = "<b>" + pilot.getSixthSense() + "</b>";
			this.lblCoPilotDE.htmlText = "<b>" + pilot.getDeadEye() + "</b>";
			this.lblCoPilotSH.htmlText = "<b>" + pilot.getSteadyHand() + "</b>";
			this.lblCoPilotCO.htmlText = "<b>" + pilot.getConstitution() + "</b>";
				
			var strQD:String = "<b>"+ pilot.getQuickDraw()[0];
			if( pilot.getQuickDraw()[1] > 0 ) 
				strQD = strQD + "." + pilot.getQuickDraw()[1];
				
			strQD = strQD + "</b>";
			this.lblCoPilotQD.htmlText = strQD;
			*/
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initMaxSpeed
		 * ---------------------------------------------------------------------
		 */
		private function initMaxSpeed():void
		{
			if( this.myObject.getMaxSpeed() < 5 )
				this.boxPerformance.lblMaxSpeed5.visible = false;
			
			if( this.myObject.getMaxSpeed() < 4 ) 
				this.boxPerformance.lblMaxSpeed4.visible = false;
			
			if( this.myObject.getMaxSpeed() < 3 )
				this.boxPerformance.lblMaxSpeed3.visible = false;
			
			if( this.myObject.getMaxSpeed() < 2 ) 
				this.boxPerformance.lblMaxSpeed2.visible = false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initAccel
		 * ---------------------------------------------------------------------
		 */
		private function initAccel():void
		{
			if( this.myObject.getAccelRate() < 3 ) 
				this.boxPerformance.lblMaxAccel3.visible = false;
			
			if( this.myObject.getAccelRate() < 2 )
				this.boxPerformance.lblMaxAccel2.visible = false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initSpecialCharacteristics
		 * ---------------------------------------------------------------------
		 */
		private function initSpecialCharacteristics()
		{
			this.lblSpecial.text = "";
			
			var arrSC:Array = this.myObject.getSpecialCharacteristics();
			var specialObj:SpecialCharacteristic = null;
			var gmods:Array = new Array(int(0),int(0));
			
			for( var i:int=0; i< arrSC.length; i++ ) 
			{
				specialObj = Globals.myBaseData.getSpecialCharacteristic(arrSC[i]);
				this.lblSpecial.appendText(
						"- " + specialObj.myName + "\n"
					);
			}
			return gmods;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initGs
		 * ---------------------------------------------------------------------
		 */
		private function initGs():void
		{
			var gs:int = this.myObject.getMaxGs();
			
			if( gs < 5 ) 
			{
				this.boxPerformance.lblMaxGsPort5.visible = false;
				this.boxPerformance.lblMaxGsStar5.visible = false;
			}
			if( gs < 4 )
			{
				this.boxPerformance.lblMaxGsPort4.visible = false;
				this.boxPerformance.lblMaxGsStar4.visible = false;
			}
			if( gs < 3 ) 
			{
				this.boxPerformance.lblMaxGsPort3.visible = false;
				this.boxPerformance.lblMaxGsStar3.visible = false;
			}
			if( gs < 2 )
			{
				this.boxPerformance.lblMaxGsPort2.visible = false;
				this.boxPerformance.lblMaxGsStar2.visible = false;
			}
			if( gs < 1 ) 
			{
				this.boxPerformance.lblMaxGsPort1.visible = false;
				this.boxPerformance.lblMaxGsStar1.visible = false;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initArmor
		 * ---------------------------------------------------------------------
		 */
		private function initArmor():void
		{
			var myDamageRaster:Sprite =  new AC8Cargo();
						
			SheetAircraft(this.mySheet).addArmorLines(
					this.myObject.getArmorNose(), 
					SheetAircraft.NOSE,
					myDamageRaster
				);
			SheetAircraft(this.mySheet).addArmorLines(
					this.myObject.getArmorPWL(), 
					SheetAircraft.PWL,
					myDamageRaster
				);
			SheetAircraft(this.mySheet).addArmorLines(
					this.myObject.getArmorSWL(), 
					SheetAircraft.SWL,
					myDamageRaster
				);
			SheetAircraft(this.mySheet).addArmorLines(
					this.myObject.getArmorPWT(), 
					SheetAircraft.PWT,
					myDamageRaster
				);
			SheetAircraft(this.mySheet).addArmorLines(
					this.myObject.getArmorSWT(), 
					SheetAircraft.SWT,
					myDamageRaster
				);
			SheetAircraft(this.mySheet).addArmorLines(
					this.myObject.getArmorTail(), 
					SheetAircraft.TAIL,
					myDamageRaster
				);	
			SheetAircraft(this.mySheet).addArmorLines(
					this.myObject.getArmorPB(), 
					SheetAircraft.PB,
					myDamageRaster
				);	
			SheetAircraft(this.mySheet).addArmorLines(
					this.myObject.getArmorPS(), 
					SheetAircraft.PS,
					myDamageRaster
				);	
			SheetAircraft(this.mySheet).addArmorLines(
					this.myObject.getArmorSB(), 
					SheetAircraft.SB,
					myDamageRaster
				);	
			SheetAircraft(this.mySheet).addArmorLines(
					this.myObject.getArmorSS(), 
					SheetAircraft.SS,
					myDamageRaster
				);	
			
			this.addChild(myDamageRaster);
		}
	}
}