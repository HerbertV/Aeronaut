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
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import as3.aeronaut.objects.Aircraft;
	import as3.aeronaut.objects.aircraft.*;
	import as3.aeronaut.objects.Loadout;
	import as3.aeronaut.objects.loadout.*;
	import as3.aeronaut.objects.baseData.Gun;
	import as3.aeronaut.objects.baseData.Ammunition;
	import as3.aeronaut.objects.baseData.Rocket;
	
	import as3.aeronaut.Globals;
		
	// =========================================================================
	// Class SpriteWeapons
	// =========================================================================
	// Base classe for Guns, Rockets and Bombs Loadout
	//
	public class SpriteWeapons
			extends Sprite
	{
	
		// =====================================================================
		// Variables
		// =====================================================================
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function SpriteWeapons()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * init
		 * ---------------------------------------------------------------------
		 * @param aircraft
		 * @param loadout
		 */
		public function init(
				aircraft:Aircraft,
				loadout:Loadout
			):void
		{
			throw new Error("SpriteWeapons init is abstract");
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setupGun
		 * ---------------------------------------------------------------------
		 * @param gpnum
		 * @param aircraft
		 * @param loadout
		 */
		protected function setupGun(
				gpnum:uint,
				aircraft:Aircraft,
				loadout:Loadout
			):void
		{
			var currGP:Gunpoint = aircraft.getGunpoint(gpnum);
			
			if( currGP.gunID == "" ) 
			{
				TextField(this.getChildByName("lblLinked"+gpnum)).text = "";
				TextField(this.getChildByName("lblTurret"+gpnum)).text = "";
				TextField(this.getChildByName("lblCal"+gpnum)).htmlText = "";
				TextField(this.getChildByName("lblRange"+gpnum)).text = "";
				TextField(this.getChildByName("lblAmmo"+gpnum)).text = "";
				return;
			}
			
			var currGun:Gun = Globals.myBaseData.getGun(currGP.gunID);
			var linkedtext:String = "";
			

			if( currGP.direction == Gunpoint.DIR_TURRET )
			{
// TODO changes for bombers
				TextField(this.getChildByName("lblTurret"+gpnum)).text = "T";
			} else {
				TextField(this.getChildByName("lblTurret"+gpnum)).text = "";
			}
			if( currGP.firelinkGroup > 0 )
				linkedtext = "F"+currGP.firelinkGroup;
			
			if( currGP.ammolinkGroup > 0 )
				linkedtext += " A"+currGP.ammolinkGroup;
			
			TextField(this.getChildByName("lblLinked"+gpnum)).text = linkedtext;
			TextField(this.getChildByName("lblCal"+gpnum)).htmlText = 
					"<b>" + currGun.shortName + "</b>";
			TextField(this.getChildByName("lblRange"+gpnum)).text = 
					String(currGun.range);
			
			if( loadout == null 
					|| loadout.getGunAmmo(gpnum) == null )
			{
				TextField(this.getChildByName("lblAmmo"+gpnum)).text = "";
				return;
			}
			
			var currAmmo:Ammunition = Globals.myBaseData.getAmmunition(
					loadout.getGunAmmo(gpnum).ammoID
				);
			
			TextField(this.getChildByName("lblAmmo"+gpnum)).text = 
					currAmmo.shortName;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setupRocket
		 * ---------------------------------------------------------------------
		 * @param slotnum
		 * @param loadout
		 */
		protected function setupRocket(
				slotnum:uint,
				loadout:Loadout
			):void
		{
			var lblType:TextField = 
				TextField(this.getChildByName("lblSlot" + slotnum + "Type"));
			var lblRange:TextField = 
				TextField(this.getChildByName("lblSlot" + slotnum + "Range"));
				
			lblType.htmlText = "";
			lblRange.htmlText = "";
			
			if( loadout == null ) 
				return;
			
			var arrRL:Array = loadout.getRocketLoadoutsBySlot(slotnum);
			if( arrRL.length == 0 )
				return;
			
			// vertical center
			if( arrRL.length < 3 )
				lblType.y = lblType.y + 4;
			
			var currRocket:Rocket = null;
			var typeText:String = "";
			var rangeText:String = "";
			var maxCharsPerLine:int = 8;
			var charCounter = 0;
			
			for( var i:int = 0; i < arrRL.length; i++ )
			{
				currRocket = Globals.myBaseData.getRocket(arrRL[i].rocketID);
				charCounter += currRocket.shortName.length;
				if( i==1 || i==3 )
				{
					for( var j:int = 0; j < (maxCharsPerLine-charCounter); j++ ) 
						typeText += " ";
					
					rangeText = rangeText + "      ";
					charCounter = 0;
					
				} else if( i==2 ) {
					typeText = typeText+ "<br/>";
					rangeText = rangeText + "<br/>";
				}
				typeText += currRocket.shortName;
				rangeText += String(currRocket.range);
			}
			
			lblType.htmlText = "<b>"+typeText+"</b>";
			lblRange.htmlText = "<b>"+rangeText+"</b>";
		}
		
	}
}