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
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.AeronautXMLProcessor;
	
	import as3.aeronaut.objects.loadout.*;
	
	import as3.hv.core.xml.AbstractXMLProcessor;
	
	import as3.hv.core.utils.StringHelper;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	/**
	 * =========================================================================
	 * Loadout
	 * =========================================================================
	 */
	public class Loadout 
			extends CSBaseObject 
			implements ICSBaseObject
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const FILE_VERSION:String = "2.1";
		public static const BASE_TAG:String = "loadout";
		
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		
		/**
		 * =====================================================================
		 * Contructor
		 * =====================================================================
		 */
		public function Loadout()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * checkXML
		 * ---------------------------------------------------------------------
		 * @param xmldoc
		 *
		 * @return
		 */
		public static function checkXML(xmldoc:XML):Boolean
		{
			if( AbstractXMLProcessor.checkDoc(xmldoc)
					&& xmldoc.child(BASE_TAG).length() == 1 ) 
				return true;
			
			return false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * createNew
		 * ---------------------------------------------------------------------
		 * Creates the emtpy loadout xml 
		 */
		public function createNew():void
		{
			myXML = new XML();
			myXML =
				<aeronaut XMLVersion={AbstractXMLProcessor.XMLDOCVERSION}>
					<loadout version={Loadout.FILE_VERSION} srcAircraft="">
						<name>New Loadout</name>
						<gunAmmos>
						</gunAmmos>
						<rockets>
						</rockets>
						<bombs>
						</bombs>
					</loadout>
				</aeronaut>;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * loadFile
		 * ---------------------------------------------------------------------
		 * @param filename
		 */
		public function loadFile(filename:String):void
		{
			this.myFilename = filename;
			
			var aexml:AeronautXMLProcessor = new AeronautXMLProcessor();
			aexml.loadXML(filename);
			var loadedxml:XML = aexml.getXML();
			
			if( Loadout.checkXML(loadedxml) ) 
			{
				this.myXML = loadedxml;
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"loaded File was not a valid Loadout.",
							DebugLevel.ERROR,
							filename
						);
				this.createNew();
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setXML
		 * ---------------------------------------------------------------------
		 * @param xmldoc
		 */
		public function setXML(xmldoc:XML):void 
		{
			if( Loadout.checkXML(xmldoc) == true ) 
			{
				this.myXML = xmldoc;
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"set XML was not a valid Loadout.",
							DebugLevel.ERROR
						);
				this.createNew();
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateVersion
		 * ---------------------------------------------------------------------
		 */
		public function updateVersion():Boolean
		{
			if( this.myXML.loadout.@version == Loadout.FILE_VERSION )
				return false;
				
			if( Console.isConsoleAvailable() )
				Console.getInstance().writeln(
						"Updating Loadout File",
						DebugLevel.DEBUG,
						"from " + this.myXML.loadout.@version 
							+ " to " + Loadout.FILE_VERSION
					);
			
			
			// update from 1.0 to 2.0
			// add bombs
			if( this.myXML.loadout.child("bombs").length() == 0 )
				this.myXML.loadout.appendChild(<bombs />);
			
			//update to 2.1
			//adjust pathe to aircraft
			//update pathes for squadlinks
			if ( this.getSrcAircraft() != "" )
			{
				if( this.getSrcAircraft().indexOf(Globals.PATH_DATA) == -1 )
					this.setSrcAircraft(
							Globals.PATH_DATA 
								+ Globals.PATH_AIRCRAFT
								+ this.getSrcAircraft()
						);
			}	
			// finaly update version
			this.myXML.loadout.@version = Loadout.FILE_VERSION;
			
			return true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getName
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getName():String 
		{
			return myXML.loadout.name.text().toString();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setName
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setName(val:String) 
		{
			this.myXML.loadout.replace(
					"name", 
					<name>{StringHelper.trim(val," ")}</name>
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSrcAircraft
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getSrcAircraft():String 
		{
			return myXML.loadout.@srcAircraft;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setSrcAircraft
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setSrcAircraft(val:String)
		{
			this.myXML.loadout.@srcAircraft = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getGunAmmos
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getGunAmmos():Array 
		{
			var arr:Array = new Array();

			for each( var ga:XML in myXML..gunAmmo ) 
			{
				var obj:GunAmmo = new GunAmmo(
						ga.@gunPointNumber, 
						ga.@ammoID 
					);
				arr.push(obj);
			}
			return arr;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getGunAmmo
		 * ---------------------------------------------------------------------
		 * @param pnum
		 * @return
		 */
		public function getGunAmmo(pnum:int):GunAmmo
		{
			var xml:XMLList =  myXML..gunAmmo.(@gunPointNumber == pnum);
			var obj:GunAmmo = new GunAmmo(
					xml.@gunPointNumber, 
					xml.@ammoID 
				);
			return obj;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setGunAmmos
		 * ---------------------------------------------------------------------
		 * @param arr
		 */
		public function setGunAmmos(arr:Array) 
		{
			var newGunAmmoXML:XML = <gunAmmos>
									</gunAmmos>;
									
			for( var i:int = 0; i< arr.length; i++ )  
			{
				newGunAmmoXML.appendChild(
						<gunAmmo gunPointNumber={arr[i].gunPointNumber} ammoID={arr[i].ammoID} />
					);
			}
			myXML.loadout.replace(
					"gunAmmos",
					newGunAmmoXML
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getRocketLoadouts
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getRocketLoadouts():Array 
		{
			var arr:Array = new Array();

			for each( var rl:XML in myXML..rocketLoadout ) 
			{
				var obj:RocketLoadout = new RocketLoadout(
						rl.@slotNumber, 
						rl.@subSlot, 
						rl.@rocketID 
					);
				arr.push(obj);
			}
			return arr;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getRocketLoadoutsBySlot
		 * ---------------------------------------------------------------------
		 * @param snum
		 *
		 * @return
		 */
		public function getRocketLoadoutsBySlot(snum:int):Array 
		{
			var arr:Array = new Array();

			for each( var rl:XML in myXML..rocketLoadout ) 
			{
				if( rl.@slotNumber == snum ) 
				{
					var obj:RocketLoadout = new RocketLoadout(
							rl.@slotNumber, 
							rl.@subSlot, 
							rl.@rocketID 
						);
					arr.push(obj);
				}
			}
			return arr;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setRocketLoadouts
		 * ---------------------------------------------------------------------
		 * @param arr
		 */
		public function setRocketLoadouts(arr:Array) 
		{
			var newRocketsXML:XML = <rockets>
									</rockets>;
									
			for( var i:int = 0; i< arr.length; i++ )  
			{
				newRocketsXML.appendChild(
						<rocketLoadout slotNumber={arr[i].slotNumber} subSlot={arr[i].subSlot} rocketID={arr[i].rocketID} />
					);
			}
			myXML.loadout.replace(
					"rockets",
					newRocketsXML
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getBombLoadouts
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getBombLoadouts():Array 
		{
			var arr:Array = new Array();

			for each( var bl:XML in myXML..bombLoadout ) 
			{
				var obj:BombLoadout = new BombLoadout(
						bl.@bay,
						bl.@idx, 
						bl.@bombID 
					);
				arr.push(obj);
			}
			return arr;
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * getBombLoadoutByBay
		 * ---------------------------------------------------------------------
		 * @param bay
		 * @param idx
		 *
		 * @return
		 */
		public function getBombLoadoutByBay(
				bay:String,
				idx:int
			):BombLoadout 
		{
			for each( var bl:XML in myXML..bombLoadout ) 
			{
				if( bl.@bay == bay && bl.@idx == idx ) 
				{
					return new BombLoadout(
							bl.@bay, 
							bl.@idx, 
							bl.@bombID 
						);
				}
			}
			return null;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setBombLoadouts
		 * ---------------------------------------------------------------------
		 * @param arr
		 */
		public function setBombLoadouts(arr:Array) 
		{
			var newBombsXML:XML = <bombs>
									</bombs>;
									
			for( var i:int = 0; i< arr.length; i++ )  
			{
				newBombsXML.appendChild(
						<bombLoadout bay={arr[i].bay} idx={arr[i].index} bombID={arr[i].bombID} />
					);
			}
			myXML.loadout.replace(
					"bombs",
					newBombsXML
				);
		}
		
	}
}