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
package as3.aeronaut.module.aircraft 
{
	import flash.text.TextField;
	
	import as3.aeronaut.gui.CSPullDown;
	import as3.aeronaut.gui.CSRadioButton;
	import as3.aeronaut.gui.CSNumStepperInteger;
	
	// =========================================================================
	// Class GunRow
	// =========================================================================
	// Used to combine all display objects for a specific gun point from PageWeapon
	//
	public class GunRow 
	{
		// =====================================================================
		// Variables
		// =====================================================================
		
		public var pdGunN:CSPullDown;
		
		public var lblGunNWeight:TextField;
		
		public var rbtnGunNTurret:CSRadioButton;
		
		public var lblGunNTurret:TextField;
		
		public var numStepGunNFire:CSNumStepperInteger;
		
		public var rbtnGunNFireLinked:CSRadioButton;
		
		public var numStepGunNAmmo:CSNumStepperInteger;
		
		public var rbtnGunNAmmoLinked:CSRadioButton;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		
		/**
		 * Constructor.
		 * 
		 * @param	pdGun
		 * @param	lblWeight
		 * @param	rbtnTurret
		 * @param	lblTurret
		 * @param	numStepFire
		 * @param	rbtnFire
		 * @param	numStepAmmo
		 * @param	rbtnAmmo
		 */
		public function GunRow(
				pdGun:CSPullDown,
				lblWeight:TextField,
				rbtnTurret:CSRadioButton,
				lblTurret:TextField,
				numStepFire:CSNumStepperInteger,
				rbtnFire:CSRadioButton,
				numStepAmmo:CSNumStepperInteger,
				rbtnAmmo:CSRadioButton
			) 
		{
			this.pdGunN = pdGun;
			this.lblGunNWeight = lblWeight;
			this.rbtnGunNTurret = rbtnTurret;
			this.lblGunNTurret = lblTurret;
			this.numStepGunNFire = numStepFire;
			this.rbtnGunNFireLinked = rbtnFire;
			this.numStepGunNAmmo = numStepAmmo;
			this.rbtnGunNAmmoLinked = rbtnAmmo;
		}
		
	}

}