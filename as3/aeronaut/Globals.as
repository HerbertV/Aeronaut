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
package as3.aeronaut
{
	import mdm.*;
	
	import flash.text.StyleSheet;
	
	import as3.hv.components.tooltip.ITooltip;
	import as3.hv.components.progress.IProgressSymbol;

	import as3.hv.core.net.AbstractModule;
	
//TODO
/*	
	import as3.aeronaut.module.CSWindow;
	
	import as3.aeronaut.module.ICSToolbarBottom;
*/		
	import as3.aeronaut.objects.*;
	
	
	// =========================================================================
	// Class Globals
	// =========================================================================
	// static Helper class for easy access
	//
	public class Globals
	{
			
		// =====================================================================
		// Constants
		// =====================================================================
		
		// ---------------------------------------------------------------------
		// 	registry stuff
		// ---------------------------------------------------------------------
		// aeronaut file extension
		public static const AE_EXT:String = ".ae";
		// aeronaut file key
		public static const AE_REGISTRY:String = "Aeronaut.DataFile";
		// aeronaut file description
		public static const AE_DESCRIPTION:String = "Aeronaut Data";
				
		// ---------------------------------------------------------------------
		// 	pathes
		// ---------------------------------------------------------------------
		public static const PATH_MODULES:String = "modules\\";
		public static const PATH_CSS:String = "css\\";
		public static const PATH_HELP:String = "help\\";
		public static const PATH_DATA:String = "data\\";
		public static const PATH_IMAGES:String = "images\\";
		
		public static const PATH_AIRCRAFT:String = "aircrafts\\";
		public static const PATH_LOADOUT:String = "loadouts\\";
		public static const PATH_PILOT:String = "pilots\\";
		public static const PATH_SQUADRON:String = "squadrons\\";
		public static const PATH_ZEPPELIN:String = "zeppelins\\";
		
		public static const PATH_NATION:String = "nations\\";
		
		public static const PATH_BLUEPRINT:String = "blueprints\\";
		public static const PATH_NOSEART:String = "noseart\\";
		
		public static const PATH_PINUP:String = "pinups\\";
				
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		//programm version
		public static var version:String = "1.0.0";
		//Progress bar
		public static var myCSProgressBar:IProgressSymbol = null;
		// Tooltip
		public static var myTooltip:ITooltip = null;
		//Stylesheet for html help
		public static var myHTMLCSS:StyleSheet = null;

		// Menu and Toolbar
		public static var myMenuLeft:AbstractModule = null;
//TODO
/*		
		public static var myToolbarBottom:ICSToolbarBottom = null;
		
		// manager
		public static var myWindowManager:CSWindowManager = null;
		public static var myPinupManager:CSPinupManager = null;
		
		// objects
		public static var myBaseData:BaseData = null;
		public static var myRuleConfigs:RuleConfigs = null;
*/			
		public static var lastSelectedImportDir:String = "";
	
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		
		
	}
}