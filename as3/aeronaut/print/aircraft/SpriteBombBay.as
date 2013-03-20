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
	import as3.aeronaut.objects.baseData.Rocket;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.CSFormatter;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
		
	// =========================================================================
	// Class SpriteBombBay
	// =========================================================================
	// linked to SpriteBomberBombBays
	//
	public class SpriteBombBay
			extends Sprite
	{
	
		// =====================================================================
		// Variables
		// =====================================================================
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function SpriteBombBay()
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
		 * @param bombardier
		 */
		public function init(
				aircraft:Aircraft,
				loadout:Loadout,
				bombardier:Pilot
			):void
		{
			this.setupBombardier(bombardier);
			
			for ( var i:uint = 1; i < 9; i++ )
			{
				this.setupBomb("FL", i, loadout);
				this.setupBomb("FR", i, loadout);
				this.setupBomb("AL", i, loadout);
				this.setupBomb("AR", i, loadout);
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setupRocket
		 * ---------------------------------------------------------------------
		 * @param bay
		 * @param idx
		 * @param loadout
		 */
		protected function setupBomb(
				bay:String,
				idx:uint,
				loadout:Loadout
			):void
		{
			var lblType:TextField = 
				TextField(this.getChildByName("lbl" + bay + "Type" + idx));
			var lblWeight:TextField = 
				TextField(this.getChildByName("lbl" + bay + "Weight" + idx));
			var lblHit:TextField = 
				TextField(this.getChildByName("lbl" + bay + "toHit" + idx));
			
			lblType.text = "";
			lblWeight.text = "";
			lblHit.text = "";
			
			if( loadout == null ) 
				return;
			
			var bl:BombLoadout = loadout.getBombLoadoutByBay(bay,idx);
			if( bl == null )
				return;
			
			
			var bomb:Rocket = Globals.myBaseData.getRocket(bl.bombID);
			
			lblType.text = bomb.shortName;
			lblWeight.text = CSFormatter.formatLbs(bomb.weight);
			if( bomb.toHitMod != 0 )
				lblHit.text = String(bomb.toHitMod);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setupBombardier
		 * ---------------------------------------------------------------------
		 * @param bombardier
		 */
		protected function setupBombardier(
				bombardier:Pilot
			):void
		{
			if( bombardier == null )
			{
				TextField(this.getChildByName("lblBombardierName")).text = "";
				TextField(this.getChildByName("lblBombardierNT")).htmlText = "";
				TextField(this.getChildByName("lblBombardierSS")).htmlText = "";
				TextField(this.getChildByName("lblBombardierDE")).htmlText = "";
				TextField(this.getChildByName("lblBombardierSH")).htmlText = "";
				TextField(this.getChildByName("lblBombardierCO")).htmlText = "";
				TextField(this.getChildByName("lblBombardierQD")).htmlText = "";
				return;
			}
			
			TextField(this.getChildByName("lblBombardierName")).htmlText = 
					bombardier.getName();
			TextField(this.getChildByName("lblBombardierNT")).htmlText = 
					"<b>" + bombardier.getNaturalTouch() + "</b>";
			TextField(this.getChildByName("lblBombardierSS")).htmlText = 
					"<b>" + bombardier.getSixthSense() + "</b>";
			TextField(this.getChildByName("lblBombardierDE")).htmlText = 
					"<b>" + bombardier.getDeadEye() + "</b>";
			TextField(this.getChildByName("lblBombardierSH")).htmlText = 
					"<b>" + bombardier.getSteadyHand() + "</b>";
			TextField(this.getChildByName("lblBombardierCO")).htmlText = 
					"<b>" + bombardier.getConstitution() + "</b>";
			
			var strQD:String = "<b>"+ bombardier.getQuickDraw()[0];
			if( bombardier.getQuickDraw()[1] > 0 ) 
				strQD = strQD + "." + bombardier.getQuickDraw()[1];
				
			strQD = strQD + "</b>";
			TextField(this.getChildByName("lblBombardierQD")).htmlText = strQD;
		}
	}
}