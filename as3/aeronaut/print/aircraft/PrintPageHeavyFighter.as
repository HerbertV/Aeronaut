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
package as3.aeronaut.print.aircraft
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import as3.aeronaut.print.CSAbstractPrintPage;
	import as3.aeronaut.print.ICSPrintPageAircraft;
	import as3.aeronaut.print.SheetAircraft;
	
	import as3.aeronaut.objects.Aircraft;
	import as3.aeronaut.objects.aircraft.Turret;
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.BaseData;
	import as3.aeronaut.objects.baseData.SpecialCharacteristic;
	
	import as3.aeronaut.CSFormatter;
	import as3.aeronaut.Globals;
	
	// =========================================================================
	// Class PrintHeavyFighter
	// =========================================================================
	// Library Symbol linked class for HeavyFighter
	//
	public class PrintPageHeavyFighter
			extends CSAbstractPrintPage
			implements ICSPrintPageAircraft
	{
		// =====================================================================
		// Variables
		// =====================================================================
		private var myObject:Aircraft;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function PrintPageHeavyFighter()
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
					+ String(obj.getBaseTarget()) 
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
			
			this.myWeapons.initFromAircraft(obj);
			
			// TODO
			/*
			this.setupPilot();
			*/
			
			this.initArmor();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initMaxSpeed
		 * ---------------------------------------------------------------------
		 */
		private function initMaxSpeed():void
		{
			if( this.myObject.getMaxSpeed() < 5 )
				this.lblMaxSpeed5.visible = false;
			
			if( this.myObject.getMaxSpeed() < 4 ) 
				this.lblMaxSpeed4.visible = false;
			
			if( this.myObject.getMaxSpeed() < 3 )
				this.lblMaxSpeed3.visible = false;
			
			if( this.myObject.getMaxSpeed() < 2 ) 
				this.lblMaxSpeed2.visible = false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initAccel
		 * ---------------------------------------------------------------------
		 */
		private function initAccel():void
		{
			if( this.myObject.getAccelRate() < 3 ) 
				this.lblMaxAccel3.visible = false;
			
			if( this.myObject.getAccelRate() < 2 )
				this.lblMaxAccel2.visible = false;
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
			var gmods:Array = Array[0,0];
			
			for( var i:int=0; i< arrSC.length; i++ ) 
			{
				specialObj = Globals.myBaseData.getSpecialCharacteristic(arrSC[i]);
				
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
		
		/**
		 * ---------------------------------------------------------------------
		 * initGs
		 * ---------------------------------------------------------------------
		 * @param leftGMod
		 * @param rightGMod
		 */
		private function initGs(
				leftGMod:int, 
				rightGMod:int
			):void
		{
			var left:int = this.myObject.getMaxGs() + leftGMod;
			var right:int = this.myObject.getMaxGs() + rightGMod;
			
			if( left < 5 ) 
				this.lblMaxGsPort5.visible = false;
			if( right < 5 )
				this.lblMaxGsStar5.visible = false;
			
			if( left < 4 )
				this.lblMaxGsPort4.visible = false;
			if( right < 4 )
				this.lblMaxGsStar4.visible = false;
			
			if( left < 3 ) 
				this.lblMaxGsPort3.visible = false;
			if( right < 3 ) 
				this.lblMaxGsStar3.visible = false;
			
			if( left < 2 )
				this.lblMaxGsPort2.visible = false;
			if( right < 2 ) 
				this.lblMaxGsStar2.visible = false;
			
			if( left < 1 ) 
				this.lblMaxGsPort1.visible = false;
			if( right < 1 ) 
				this.lblMaxGsStar1.visible = false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initArmor
		 * ---------------------------------------------------------------------
		 */
		private function initArmor():void
		{
			var usedProp:String = this.myObject.getPropType();
			var turrets:Array = this.myObject.getTurrets();
			
			var myDamageRaster:Sprite = null;
			var hasRearTurrets:Boolean = false;
			
			if( turrets.length > 0 )
			{
				for( var i:int = 0; i < turrets.length; i++ )
					if( turrets[i].direction == Turret.DIR_REAR )
					{
						hasRearTurrets = true;
						break;
					}
			}
			
			if( usedProp == "tractor" ) 
			{
				if( hasRearTurrets )
				{
					myDamageRaster = new AC2TractorWithTurret();
					SheetAircraft(this.mySheet).addArmorLines(
							this.myObject.getArmorTail(), 
							SheetAircraft.TAIL_TURRET,
							myDamageRaster
						);
					
				} else {
					myDamageRaster = new AC1TractorNoTurret();
					SheetAircraft(this.mySheet).addArmorLines(
							this.myObject.getArmorTail(), 
							SheetAircraft.TAIL,
							myDamageRaster
						);
				}
				
			} else if( usedProp == "pusher" ) {
				if( hasRearTurrets )
				{
					myDamageRaster = new AC4PusherWithTurret();
					SheetAircraft(this.mySheet).addArmorLines(
							this.myObject.getArmorTail(), 
							SheetAircraft.TAIL_TURRET,
							myDamageRaster
						);
					
				} else {
					myDamageRaster = new AC3PusherNoTurret();
					SheetAircraft(this.mySheet).addArmorLines(
							this.myObject.getArmorTail(), 
							SheetAircraft.TAIL,
							myDamageRaster
						);
				}
			}
			
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
			
			this.addChild(myDamageRaster);
		}
	}
}