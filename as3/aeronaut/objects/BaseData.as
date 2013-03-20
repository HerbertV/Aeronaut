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
 * @version: 2.0.0
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2009-2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.objects
{
	// MDM ZINC Lib
	import mdm.*;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.XMLProcessor;
		
	import as3.aeronaut.objects.baseData.*;
	
	// =========================================================================
	// BaseData
	// =========================================================================
	// object for baseData.ae
	// read only
	public class BaseData
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const FILE_VERSION:String = "2.0";
		
		// hardoded ids
		public static const HCID_SC_MULTIPLEENGINES:String = "AC_003";
		public static const HCID_SC_LINKEDAMMO:String = "AC_008";
		public static const HCID_SC_HIGHTORQUE:String = "AC_021";
		public static const HCID_SC_LINKEDFIRE:String = "AC_032";
		public static const HCID_SC_NITRO5:String = "AC_001";
		public static const HCID_SC_NITRO4:String = "AC_037";
		
		public static const HCID_F_ACEOFACES:String = "F_01";
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var ready:Boolean = false;
		private var myXML:XML = new XML();
				
		// =====================================================================
		// Constructor
		// =====================================================================
		public function BaseData()
		{
			var file:String = mdm.Application.path 
					+ Globals.PATH_DATA 
					+ "baseData" 
					+ Globals.AE_EXT;
			this.myXML = XMLProcessor.loadXML(file);
			
			if( this.myXML == null ) 
				return;
			
			if( XMLProcessor.checkDoc(this.myXML) == false ) 
				return;
			
			ready = true;
			
			if( this.myXML..preferences.@debugLevel != undefined )
			{
				DebugLevel.level = int(this.myXML..preferences.@debugLevel);
			} else {
				DebugLevel.level = 0;
			}
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * isReady
		 * ---------------------------------------------------------------------
		 *
		 * @return
		 */
		public function isReady():Boolean
		{
			return ready;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getFeats
		 * ---------------------------------------------------------------------
		 * FF5 optional rule
		 *
		 * @return Array of Feats sorted by name
		 */
		public function getFeats():Array
		{
			var arr:Array = new Array();

			if( ready )
			{
				for each( var xml:XML in myXML..feat ) 
				{
					var xp:Array =  xml.@xpCost.split(",");
					var obj:Feat = new Feat(
							xml.@ID, 
							xml.text().toString(), 
							xp,
							xml.@maxLvl
						);
					arr.push(obj);
				}
				if( arr.length > 1 )
					arr.sortOn(
							"myName",
							Array.CASEINSENSITIVE
						);
			}
			return arr;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getFeat
		 * ---------------------------------------------------------------------
		 * FF5 optional rule
		 *
		 * @param id 
		 * 
		 * @return Feat
		 */
		public function getFeat(id:String):Feat
		{
			if( !ready ) 
				return null;
				
			var obj:Feat = null;
			var xml:XMLList =  myXML..feat.(@ID == id);
			
			if( xml != null ) {
				var xp:Array =  xml.@xpCost.split(",");
				obj = new Feat(
						xml.@ID, 
						xml.text().toString(), 
						xp,
						xml.@maxLvl
					);
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"Feat with ID:"+id+" not found!",
							DebugLevel.ERROR
						);
			}
			return obj;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getLanguageXPCost
		 * ---------------------------------------------------------------------
		 * 
		 * @return xp cost
		 */
		public function getLanguageXPCost():int
		{
			if( ready )
				return int(myXML..languages.@xpCost);
			
			return 0;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getLanguages
		 * ---------------------------------------------------------------------
		 * 
		 * @return language array
		 */
		public function getLanguages():Array
		{
			var arr:Array = new Array();

			if( ready )
			{
				for each( var xml:XML in myXML..language ) 
				{
					var obj:Language = new Language(
							xml.@ID, 
							xml.text().toString()
						);
					arr.push(obj);
				}
				if( arr.length > 1 )
					arr.sortOn(
							"myName",
							Array.CASEINSENSITIVE
						);
			}
			return arr;
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * getLanguage
		 * ---------------------------------------------------------------------
		 * @param id
		 *
		 * @return language object
		 */
		public function getLanguage(id:String):Language
		{
			var obj:Language = null;
			if( ready ) 
			{
				var xml:XMLList =  myXML..language.(@ID == id);
				if( xml != null )
				{
					obj = new Language(
							xml.@ID, 
							xml.text().toString()
						);
				} else {
					if( Console.isConsoleAvailable() )
						Console.getInstance().writeln(
								"Language with ID:"+id+" not found!",
								DebugLevel.ERROR
							);
				}
			}
			return obj;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getCountries
		 * ---------------------------------------------------------------------
		 *
		 * @return country array
		 */
		public function getCountries():Array
		{
			var arr:Array = new Array();

			if( ready )
			{
				for each( var xml:XML in myXML..country ) 
				{
					var obj:Country = new Country(
							xml.@ID, 
							xml.text().toString(),
							xml.@languageID
						);
					obj.srcFlag = xml.@srcFlag;
					arr.push(obj);
				}
				if( arr.length > 1 ) 
					arr.sortOn(
							"myName",
							Array.CASEINSENSITIVE
						);
			}
			return arr;
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * getCountry
		 * ---------------------------------------------------------------------
		 * @param id
		 *
		 * @return country object
		 */
		public function getCountry(id:String):Country
		{
			var obj:Country = null;
			if( ready )
			{
				var xml:XMLList =  myXML..country.(@ID == id);
				if( xml != null )
				{
					obj = new Country(
							xml.@ID, 
							xml.text().toString(), 
							xml.@languageID
						);
					obj.srcFlag = xml.@srcFlag;
				} else {
					if( Console.isConsoleAvailable() )
						Console.getInstance().writeln(
								"Country with ID:"+id+" not found!",
								DebugLevel.ERROR
							);
				}
			}
			return obj;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getCompanies
		 * ---------------------------------------------------------------------
		 * @return company array
		 */
		public function getCompanies():Array
		{
			var arr:Array = new Array();

			if( ready )
			{
				for each( var company:XML in myXML..company ) 
				{
					var coobj:Company = new Company(
							company.@ID, 
							company.shortName.text().toString(),
							company.longName.text().toString()
						);
					arr.push(coobj);
				}
				if( arr.length > 1 )
					arr.sortOn(
							"shortName",
							Array.CASEINSENSITIVE
						);
			}
			return arr;
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * getCompany
		 * ---------------------------------------------------------------------
		 * @param id
		 *
		 * @return company object
		 */
		public function getCompany(id:String):Company
		{
			var obj:Company = null;
			if( ready )
			{
				var xml:XMLList =  myXML..company.(@ID == id);
				if( xml != null )
				{
					obj = new Company(
							xml.@ID, 
							xml.shortName.text().toString(), 
							xml.longName.text().toString()
						);
				} else {
					if( Console.isConsoleAvailable() )
						Console.getInstance().writeln(
								"Company with ID:"+id+" not found!",
								DebugLevel.ERROR
							);
				}
			}
			return obj;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSpecialCharacteristics
		 * ---------------------------------------------------------------------
		 *
		 * @return sc array
		 */
		public function getSpecialCharacteristics():Array
		{
			var arr:Array = new Array();

			if( ready ) 
			{
				for each( var sc:XML in myXML..specialCharacteristic ) 
				{
					var hcode:Boolean = false;
					if( sc.@hasHardcodedAbility == "true" ) 
						hcode = true;
					
					var limit:Boolean = false;
					if( sc.@countsToSCLimit == "true" ) 
						limit = true;

					var frames:Array = new Array();
					
					for each( var af:XML in sc.allowedFrame ) 
						frames.push(af.@type);
					
					var ctype:Array = sc.cost.@type.split(",");
					var wtype:Array = sc.weight.@type.split(",");
					
					var desc:String = "";
					if( sc.hasOwnProperty("description") )
						desc = sc.description.text().toString();
					
					var obj:SpecialCharacteristic = new SpecialCharacteristic(
							sc.@ID, 
							sc.name.text().toString(), 
							sc.@groupID, 
							frames,
							ctype, 
							Number(sc.cost.@changes),
							wtype,
							Number(sc.weight.@changes), 
							hcode,
							limit,
							desc
						);
					arr.push(obj);
				}
				if( arr.length > 1 )
					arr.sortOn(
							"myName",
							Array.CASEINSENSITIVE
						);
			}
			return arr;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSpecialCharacteristic
		 * ---------------------------------------------------------------------
		 * @param id
		 *
		 * @return sc object
		 */
		public function getSpecialCharacteristic(
				id:String
			):SpecialCharacteristic
		{
			var obj:SpecialCharacteristic = null;
			if( ready )
			{
				var xml:XMLList =  myXML..specialCharacteristic.(@ID == id);
				if( xml != null )
				{
					var hcode:Boolean = false;
					if( xml.@hasHardcodedAbility == "true" )
						hcode = true;
					
					var limit:Boolean = false;
					if( xml.@countsToSCLimit == "true" ) 
						limit = true;
					
					var frames:Array = new Array();
					for each( var af:XML in xml.allowedFrame ) 
						frames.push(af.@type);
					
					var ctype:Array = xml.cost.@type.split(",");
					var wtype:Array = xml.weight.@type.split(",");
					
					var desc:String = "";
					if( xml.hasOwnProperty("description") )
						desc = xml.description.text().toString();
					
					obj = new SpecialCharacteristic(
							xml.@ID, 
							xml.name.text().toString(), 
							xml.@groupID, 
							frames,
							ctype, 
							Number(xml.cost.@changes),
							wtype,
							Number(xml.weight.@changes), 
							hcode,
							limit,
							desc
						);
				} else {
					if( Console.isConsoleAvailable() )
						Console.getInstance().writeln(
								"SpecialCharacteristic with ID:"+id+" not found!",
								DebugLevel.ERROR
							);
				}
			}
			return obj;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getGuns
		 * ---------------------------------------------------------------------
		 *
		 * @return gun array
		 */
		public function getGuns():Array
		{
			var arr:Array = new Array();

			if( ready )
			{
				for each( var gun:XML in myXML..gun ) 
				{
					var obj:Gun = new Gun(
							gun.@ID,
							gun.shortName.text().toString(), 
							gun.longName.text().toString(), 
							gun.@cal, 
							gun.@weight, 
							gun.@price, 
							gun.@range 
						);
					arr.push(obj);
				}
			}
			return arr;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getGun
		 * ---------------------------------------------------------------------
		 * @param id
		 *
		 * @return gun object
		 */
		public function getGun(id:String):Gun
		{
			var obj:Gun = null;
			if( ready )
			{
				var xml:XMLList =  myXML..gun.(@ID == id);
				if( xml != null )
				{
					obj = new Gun(
							xml.@ID,
							xml.shortName.text().toString(), 
							xml.longName.text().toString(), 
							xml.@cal, 
							xml.@weight, 
							xml.@price, 
							xml.@range
						);
				} else {
					if( Console.isConsoleAvailable() )
						Console.getInstance().writeln(
								"Gun with ID:"+id+" not found!",
								DebugLevel.ERROR
							);
				}
			}
			return obj;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getRockets
		 * ---------------------------------------------------------------------
		 *
		 * @return rocket array
		 */
		public function getRockets():Array
		{
			var arr:Array = new Array();

			if( ready ) 
			{
				for each( var rocket:XML in myXML..rocket ) 
				{
					var w:int = 0;
					if( rocket.hasOwnProperty("@weight") )
						w = rocket.@weight;
						
					var hit:int = 0;
					if( rocket.hasOwnProperty("@toHitMod") )
						hit = rocket.@toHitMod;
						
					var obj:Rocket = new Rocket(
							rocket.@ID,
							rocket.shortName.text().toString(), 
							rocket.longName.text().toString(), 
							rocket.@type, 
							rocket.@slots, 
							rocket.@usesPerSlot, 
							rocket.@range, 
							rocket.@price,
							w,
							hit
						);
					arr.push(obj);
				}
			}
			return arr;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getRocket
		 * ---------------------------------------------------------------------
		 * @param id
		 *
		 * @return rocket object
		 */
		public function getRocket(id:String):Rocket
		{
			var obj:Rocket = null;
			if( ready )
			{
				var xml:XMLList =  myXML..rocket.(@ID == id);
				if( xml != null )
				{
					var w:int = 0;
					if( xml.hasOwnProperty("@weight") )
						w = xml.@weight;
						
					var hit:int = 0;
					if( xml.hasOwnProperty("@toHitMod") )
						hit = xml.@toHitMod;
						
					obj = new Rocket(
							xml.@ID,
							xml.shortName.text().toString(), 
							xml.longName.text().toString(), 
							xml.@type, 
							xml.@slots, 
							xml.@usesPerSlot, 
							xml.@range, 
							xml.@price,
							w, 
							hit
						);
				} else {
					if( Console.isConsoleAvailable() )
						Console.getInstance().writeln(
								"Rocket with ID:"+id+" not found!",
								DebugLevel.ERROR
							);
				}
			}
			return obj;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getAmmunitionByCaliber
		 * ---------------------------------------------------------------------
		 * @param cal
		 *
		 * @return ammunition array
		 */
		public function getAmmunitionByCaliber(cal:int):Array
		{
			var arr:Array = new Array();

			if( ready )
			{
				for each( var ammunition:XML in myXML..ammunition ) 
				{
					if( ammunition.@cal == cal )
					{
						var obj:Ammunition = new Ammunition(
								ammunition.@ID,
								ammunition.shortName.text().toString(), 
								ammunition.longName.text().toString(), 
								ammunition.@cal, 
								ammunition.@price 
							);
						arr.push(obj);
					}
				}
			}
			return arr;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getAmmunition
		 * ---------------------------------------------------------------------
		 * @param id
		 *
		 * @return ammunition object
		 */
		public function getAmmunition(id:String):Ammunition
		{
			var obj:Ammunition = null;
			if( ready )
			{
				var xml:XMLList =  myXML..ammunition.(@ID == id);
				if( xml != null )
				{
					obj = new Ammunition(
							xml.@ID,
							xml.shortName.text().toString(), 
							xml.longName.text().toString(), 
							xml.@cal, 
							xml.@price 
						);
				} else {
					if( Console.isConsoleAvailable() )
						Console.getInstance().writeln(
								"Ammunition with ID:"+id+" not found!",
								DebugLevel.ERROR
							);
				}
			}
			return obj;
		}
		
// TODO: accessing squadron objects		
// TODO: needs new object classes.
		
	}
}