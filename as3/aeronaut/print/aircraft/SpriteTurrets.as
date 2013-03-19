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
 * Copyright (c) 2009-2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.print.aircraft
{
	import as3.aeronaut.objects.Pilot;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import as3.aeronaut.objects.Aircraft;
	import as3.aeronaut.objects.aircraft.*;
	import as3.aeronaut.objects.Loadout;
	import as3.aeronaut.objects.loadout.*;
	import as3.aeronaut.objects.baseData.Gun;
	import as3.aeronaut.objects.baseData.Ammunition;
	
	import as3.aeronaut.Globals;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
		
	// =========================================================================
	// Class SpriteTurrets
	// =========================================================================
	// Base class bomber turret sprites
	//
	public class SpriteTurrets
			extends Sprite
	{
	
		// =====================================================================
		// Variables
		// =====================================================================
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function SpriteTurrets()
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
		 * @param gunners array of pilots
		 */
		public function init(
				aircraft:Aircraft,
				loadout:Loadout,
				gunners:Array
			):void
		{
			throw new Error("SpriteTurrets init is abstract");
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
				TextField(this.getChildByName("lblCal"+gpnum)).htmlText = "";
				TextField(this.getChildByName("lblRange"+gpnum)).text = "";
				TextField(this.getChildByName("lblAmmo"+gpnum)).text = "";
				return;
			}
			
			var currGun:Gun = Globals.myBaseData.getGun(currGP.gunID);
			var linkedtext:String = "";
			
			if( currGP.firelinkGroup > 0 )
				linkedtext = "F" + currGP.firelinkGroup;
			
			if( currGP.ammolinkGroup > 0 )
				linkedtext += " A" + currGP.ammolinkGroup;
				
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
		 * setupGun
		 * ---------------------------------------------------------------------
		 * @param gunnernum
		 * @param gunner of class pilot
		 */
		protected function setupGunner(
				gunnernum:uint,
				gunner:Pilot
			):void
		{
			if( gunner == null )
			{
				TextField(this.getChildByName("lblGunner" + gunnernum + "Name")).text = "";
				TextField(this.getChildByName("lblGunner" + gunnernum + "NT")).htmlText = "";
				TextField(this.getChildByName("lblGunner" + gunnernum + "SS")).htmlText = "";
				TextField(this.getChildByName("lblGunner" + gunnernum + "DE")).htmlText = "";
				TextField(this.getChildByName("lblGunner" + gunnernum + "SH")).htmlText = "";
				TextField(this.getChildByName("lblGunner" + gunnernum + "CO")).htmlText = "";
				TextField(this.getChildByName("lblGunner" + gunnernum + "QD")).htmlText = "";
				return;
			}
			
			TextField(this.getChildByName("lblGunner" + gunnernum + "Name")).htmlText = 
					gunner.getName();
			TextField(this.getChildByName("lblGunner" + gunnernum + "NT")).htmlText = 
					"<b>" + gunner.getNaturalTouch() + "</b>";
			TextField(this.getChildByName("lblGunner" + gunnernum + "SS")).htmlText = 
					"<b>" + gunner.getSixthSense() + "</b>";
			TextField(this.getChildByName("lblGunner" + gunnernum + "DE")).htmlText = 
					"<b>" + gunner.getDeadEye() + "</b>";
			TextField(this.getChildByName("lblGunner" + gunnernum + "SH")).htmlText = 
					"<b>" + gunner.getSteadyHand() + "</b>";
			TextField(this.getChildByName("lblGunner" + gunnernum + "CO")).htmlText = 
					"<b>" + gunner.getConstitution() + "</b>";
			
			var strQD:String = "<b>"+ gunner.getQuickDraw()[0];
			if( gunner.getQuickDraw()[1] > 0 ) 
				strQD = strQD + "." + gunner.getQuickDraw()[1];
				
			strQD = strQD + "</b>";
			TextField(this.getChildByName("lblGunner" + gunnernum + "QD")).htmlText = strQD;
		}
	}
}