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
 * @version: 1.1.0
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2009-2013 Herbert Veitengruber 
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
	 * Class PrintHeavyFighter
	 * =========================================================================
	 * Library Symbol linked class for HeavyFighter
	 * 
	 * Normally I would subclass PrintPageFighter here.
	 * But you can't since PrintPageFighter is linked to another Movieclip
	 * than PrintPageHeavyFighter. 
	 * 
	 * Maybe I merge both MovieClips in the future.
	 */
	public class PrintPageHeavyFighter
			extends AbstractPrintPageSmallAircraft
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
		public function PrintPageHeavyFighter()
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
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initArmor
		 * ---------------------------------------------------------------------
		 */
		override protected function initArmor():void
		{
			var usedProp:String = this.myObject.getPropType();
			var turrets:Array = this.myObject.getTurrets();
			
			var myDamageRaster:Sprite = null;
			var hasRearTurrets:Boolean = false;
			
			if( turrets.length > 0 )
			{
				for( var i:int = 0; i < turrets.length; i++ )
					if( turrets[i].direction == TurretDefinition.DIR_REAR )
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