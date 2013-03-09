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
package as3.aeronaut.objects
{
	// MDM ZINC Lib
	import mdm.*;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	import as3.hv.core.utils.StringHelper;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.XMLProcessor;
		
	import as3.aeronaut.objects.aircraft.*;
	
	/**
	 * =========================================================================
	 * Aircraft
	 * =========================================================================
	 */
	public class Aircraft 
			extends CSBaseObject 
			implements ICSBaseObject
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const BASE_TAG:String = "aircraft";
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var myLoadoutFile:String = "";
		private var myPilotFile:String = "";
// TODO new handling for additional crew 
		private var myGunnerFile:String = "";
		private var freeWeight:int = 0;
				
		/**
		 * =====================================================================
		 * Contructor
		 * =====================================================================
		 */
		public function Aircraft()
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
			if (XMLProcessor.checkDoc(xmldoc)
					&& xmldoc.child(BASE_TAG).length() == 1 ) 
				return true;
			
			return false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * createNew
		 * ---------------------------------------------------------------------
		 * creates an empty aircraft xml
		 */
		public function createNew():void
		{
//TODO bombbays and cargo
			myXML = new XML();
			myXML =
				<aeronaut XMLVersion={XMLProcessor.XMLDOCVERSION}>
					<aircraft frameType='fighter' PropType="tractor" baseTarget="5" accelRate="1" maxSpeed="1" maxGs="1" decelRate="2" engineCount="1" crewCount="1" srcFoto="">
						<name>New Plane</name>
						<manufacturer ID=""/>
						<specs height="10,6" length="20,0" range="75" serviceCeiling="5000" wingspan="25,0"/>
						<specialCharacteristics>
						</specialCharacteristics>
						<gunpoints>
							<gunpoint pointNumber="1"  gunID="" firelinkGroup="0" ammolinkGroup="0" direction="forward"/>
							<gunpoint pointNumber="2"  gunID="" firelinkGroup="0" ammolinkGroup="0" direction="forward"/>
							<gunpoint pointNumber="3"  gunID="" firelinkGroup="0" ammolinkGroup="0" direction="forward"/>
							<gunpoint pointNumber="4"  gunID="" firelinkGroup="0" ammolinkGroup="0" direction="forward"/>
							<gunpoint pointNumber="5"  gunID="" firelinkGroup="0" ammolinkGroup="0" direction="forward"/>
							<gunpoint pointNumber="6"  gunID="" firelinkGroup="0" ammolinkGroup="0" direction="forward"/>
							<gunpoint pointNumber="7"  gunID="" firelinkGroup="0" ammolinkGroup="0" direction="forward"/>
							<gunpoint pointNumber="8"  gunID="" firelinkGroup="0" ammolinkGroup="0" direction="forward"/>
							<gunpoint pointNumber="9"  gunID="" firelinkGroup="0" ammolinkGroup="0" direction="forward"/>
							<gunpoint pointNumber="10"  gunID="" firelinkGroup="0" ammolinkGroup="0" direction="forward"/>
						</gunpoints>
						<rocketslots count="6"/>
						<turrets>
						</turrets>
						<armor starboardwingTrailing="0" tail="0" portwingTrailing="0" starboardwingLeading="0" nose="0" portwingLeading="0"/>
					</aircraft>
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
			var loadedxml:XML = XMLProcessor.loadXML(filename);
			
			if( Aircraft.checkXML(loadedxml) ) 
			{
				this.myXML = loadedxml;
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"loaded File  was not a valid Aircraft.",
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
			if( Aircraft.checkXML(xmldoc) ) 
			{
				this.myXML = xmldoc;
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"set XML was not a valid Aircraft.",
							DebugLevel.ERROR
						);
				this.createNew();
			}
		}
				
		/**
		 * ---------------------------------------------------------------------
		 * getLoadoutFile
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getLoadoutFile():String 
		{
			return myLoadoutFile;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setLoadoutFile
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setLoadoutFile(val:String) 
		{
			myLoadoutFile = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getPilotFile
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getPilotFile():String 
		{
			return myPilotFile;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setPilotFile
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setPilotFile(val:String) 
		{
			myPilotFile = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getGunnerFile
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getGunnerFile():String 
		{
			return myGunnerFile;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setGunnerFile
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setGunnerFile(val:String) 
		{
			myGunnerFile = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getFreeWeight
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getFreeWeight():int 
		{
			return freeWeight;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setFreeWeight
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setFreeWeight(val:int)
		{
			freeWeight = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getName
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getName():String 
		{
			return myXML.aircraft.name.text().toString();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setName
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setName(val:String) 
		{
			this.myXML.aircraft.replace(
					"name", 
					<name>{StringHelper.trim(val," ")}</name>
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getFrameType
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getFrameType():String
		{
			return myXML.aircraft.@frameType;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setFrameType
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setFrameType(val:String)
		{
			this.myXML.aircraft.@frameType = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getPropType
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getPropType():String 
		{
			return myXML.aircraft.@PropType;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setPropType
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setPropType(val:String)
		{
			this.myXML.aircraft.@PropType = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getBaseTarget
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getBaseTarget():int 
		{
			return int(myXML.aircraft.@baseTarget);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setBaseTarget
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setBaseTarget(val:int)
		{
			myXML.aircraft.@baseTarget = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getAccelRate
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getAccelRate():int 
		{
			return int(myXML.aircraft.@accelRate);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setAccelRate
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setAccelRate(val:int)
		{
			myXML.aircraft.@accelRate = val;
		}
				
		/**
		 * ---------------------------------------------------------------------
		 * getMaxSpeed
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getMaxSpeed():int 
		{
			return int(myXML.aircraft.@maxSpeed);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setMaxSpeed
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setMaxSpeed(val:int)
		{
			myXML.aircraft.@maxSpeed = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getMaxGs
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getMaxGs():int 
		{
			return int(myXML.aircraft.@maxGs);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setMaxGs
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setMaxGs(val:int)
		{
			myXML.aircraft.@maxGs = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getDecelRate
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getDecelRate():int 
		{
			return int(myXML.aircraft.@decelRate);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setDecelRate
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setDecelRate(val:int)
		{
			myXML.aircraft.@decelRate = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getEngineCount
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getEngineCount():int 
		{
			return int(myXML.aircraft.@engineCount);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setEngineCount
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setEngineCount(val:int)
		{
			myXML.aircraft.@engineCount = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getCrewCount
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getCrewCount():int 
		{
			return int(myXML.aircraft.@crewCount);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setCrewCount
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setCrewCount(val:int)
		{
			myXML.aircraft.@crewCount = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getHeight
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getHeight():Array
		{
			return myXML..specs.@height.split(",");
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setHeight
		 * ---------------------------------------------------------------------
		 * @param feet
		 * @param inch
		 */
		public function setHeight(feet:int, inch:int)
		{
			myXML..specs.@height = String(feet+","+inch);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getLength
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getLength():Array 
		{
			return myXML..specs.@length.split(",");
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setLength
		 * ---------------------------------------------------------------------
		 * @param feet
		 * @param inch
		 */
		public function setLength(feet:int, inch:int) 
		{
			myXML..specs.@length = String(feet+","+inch);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getWingspan
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getWingspan():Array 
		{
			return myXML..specs.@wingspan.split(",");
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setWingspan
		 * ---------------------------------------------------------------------
		 * @param feet
		 * @param inch
		 */
		public function setWingspan(feet:int, inch:int) 
		{
			myXML..specs.@wingspan = String(feet+","+inch);
		}
				
		/**
		 * ---------------------------------------------------------------------
		 * getRange
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getRange():int 
		{
			return int(myXML..specs.@range);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setRange
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setRange(val:int)
		{
			myXML..specs.@range = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getServiceCeiling
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getServiceCeiling():int
		{
			return int(myXML..specs.@serviceCeiling);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setServiceCeiling
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setServiceCeiling(val:int)
		{
			myXML..specs.@serviceCeiling = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getRocketSlotCount
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getRocketSlotCount():int
		{
			return int(myXML..rocketslots.@count);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setRocketSlotCount
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setRocketSlotCount(val:int)
		{
			myXML..rocketslots.@count = val;
		}
				
		/**
		 * ---------------------------------------------------------------------
		 * getArmorSWT
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getArmorSWT():int 
		{
			return int(myXML..armor.@starboardwingTrailing);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setArmorSWT
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setArmorSWT(val:int)
		{
			myXML..armor.@starboardwingTrailing = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getArmorTail
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getArmorTail():int 
		{
			return int(myXML..armor.@tail);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setArmorTail
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setArmorTail(val:int)
		{
			myXML..armor.@tail = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getArmorPWT
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getArmorPWT():int 
		{
			return int(myXML..armor.@portwingTrailing);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setArmorPWT
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setArmorPWT(val:int)
		{
			myXML..armor.@portwingTrailing = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getArmorSWL
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getArmorSWL():int 
		{
			return int(myXML..armor.@starboardwingLeading);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setArmorSWL
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setArmorSWL(val:int)
		{
			myXML..armor.@starboardwingLeading = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getArmorNose
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getArmorNose():int 
		{
			return int(myXML..armor.@nose);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setArmorNose
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setArmorNose(val:int)
		{
			myXML..armor.@nose = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getArmorPWL
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getArmorPWL():int 
		{
			return int(myXML..armor.@portwingLeading);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setArmorPWL
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setArmorPWL(val:int)
		{
			myXML..armor.@portwingLeading = val;
		}
				
		/**
		 * ---------------------------------------------------------------------
		 * getArmorPB
		 * ---------------------------------------------------------------------
		 * bombers and cargoplanes only
		 * @return
		 */
		public function getArmorPB():int 
		{
			if( myXML..armor.@portBow != null ) 
				return int(myXML..armor.@portBow);
			return 0;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setArmorPB
		 * ---------------------------------------------------------------------
		 * bombers and cargoplanes only
		 * @param val
		 */
		public function setArmorPB(val:int)
		{
			myXML..armor.@portBow = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getArmorPS
		 * ---------------------------------------------------------------------
		 * bombers and cargoplanes only
		 * @return
		 */
		public function getArmorPS():int 
		{
			if( myXML..armor.@portStern != null ) 
				return int(myXML..armor.@portStern);
			return 0;
		}
				
		/**
		 * ---------------------------------------------------------------------
		 * setArmorPS
		 * ---------------------------------------------------------------------
		 * bombers and cargoplanes only
		 * @param val
		 */
		public function setArmorPS(val:int)
		{
			myXML..armor.@portStern = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getArmorSB
		 * ---------------------------------------------------------------------
		 * bombers and cargoplanes only
		 * @return
		 */
		public function getArmorSB():int 
		{
			if( myXML..armor.@starboardBow != null ) 
				return int(myXML..armor.@starboardBow);
			return 0;
		}
				
		/**
		 * ---------------------------------------------------------------------
		 * setArmorSB
		 * ---------------------------------------------------------------------
		 * bombers and cargoplanes only
		 * @param val
		 */
		public function setArmorSB(val:int)
		{
			myXML..armor.@starboardBow = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getArmorSS
		 * ---------------------------------------------------------------------
		 * bombers and cargoplanes only
		 * @return
		 */
		public function getArmorSS():int 
		{
			if( myXML..armor.@starboardStern != null ) 
				return int(myXML..armor.@starboardStern);
			return 0;
		}
				
		/**
		 * ---------------------------------------------------------------------
		 * setArmorSS
		 * ---------------------------------------------------------------------
		 * bombers and cargoplanes only
		 * @param val
		 */
		public function setArmorSS(val:int)
		{
			myXML..armor.@starboardStern = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getManufacturerID
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getManufacturerID():String 
		{
			if( myXML..manufacturer != null ) 
				return myXML..manufacturer.@ID;
			 
			return "";
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setManufacturerID
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setManufacturerID(val:String)
		{
			myXML..manufacturer.@ID = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getGunpoint
		 * ---------------------------------------------------------------------
		 * @param pnum
		 * 
		 * @return
		 */
		public function getGunpoint(pnum:int):Gunpoint 
		{
			var xml:XMLList =  myXML..gunpoint.(@pointNumber == pnum);
			var gp:Gunpoint = new Gunpoint(
					xml.@pointNumber, 
					xml.@gunID
				);
			gp.firelinkGroup = xml.@firelinkGroup;
			gp.ammolinkGroup = xml.@ammolinkGroup;
			gp.direction = xml.@direction;
			
			return gp;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setGunpoint
		 * ---------------------------------------------------------------------
		 * @param gp
		 */
		public function setGunpoint(gp:Gunpoint) 
		{
			var xml:XMLList =  myXML..gunpoint.(@pointNumber == gp.pointNumber);
			xml.@gunID = gp.gunID;
			xml.@firelinkGroup = gp.firelinkGroup;
			xml.@ammolinkGroup = gp.ammolinkGroup;
			xml.@direction = gp.direction;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getTurrets
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getTurrets():Array 
		{
			var arr:Array = new Array();

			for each( var turret:XML in myXML..turret ) 
			{
				var obj:Turret = new Turret( turret.@direction );
				var linked:Array = new Array();
				if (turret.@linkedGuns != "")
					linked = turret.@linkedGuns.split(",");
				
				obj.linkedGuns = linked;
				arr.push(obj);
			}
			return arr;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setTurrets
		 * ---------------------------------------------------------------------
		 * @param arr
		 */
		public function setTurrets(arr:Array) 
		{
			var newTurretXML:XML = <turrets>
								   </turrets>;
									
			for( var i:int = 0; i< arr.length; i++ )  
			{
				var linked:String = "";
				for( var j:int = 0; j<arr[i].linkedGuns.length; j++ )
				{
					linked = linked + arr[i].linkedGuns[j];
					if (j+1 < arr[i].linkedGuns.length)
						linked = linked + ",";
				}
				newTurretXML.appendChild(
						<turret direction={arr[i].direction} linkedGuns={linked} />
					);
			}
			myXML.aircraft.replace(
					"turrets",
					newTurretXML
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSpecialCharacteristics
		 * ---------------------------------------------------------------------
		 * there is no object class since we need only to store the id 
		 *
		 * @return
		 */
		public function getSpecialCharacteristics():Array
		{
			var arr:Array = new Array();

			for each( var sc:XML in myXML..specialCharacteristic ) 
				arr.push(sc.@ID);
			
			return arr;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setSpecialCharacteristics
		 * ---------------------------------------------------------------------
		 * there is no object class since we need only to store the id 
		 *
		 * @param arr
		 */
		public function setSpecialCharacteristics(arr:Array)
		{
			var newScXML:XML = <specialCharacteristics>
							   </specialCharacteristics>;
									
			for( var i:int = 0; i< arr.length; i++ )  
				newScXML.appendChild(
						<specialCharacteristic ID={arr[i]} />
					);
			
			myXML.aircraft.replace(
					"specialCharacteristics",
					newScXML
				);
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * getSrcFoto
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getSrcFoto():String 
		{
			return myXML.aircraft.@srcFoto;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setSrcFoto
		 * ---------------------------------------------------------------------
		 *
		 * @param val
		 */
		public function setSrcFoto(val:String)
		{
			myXML.aircraft.@srcFoto = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcHighTorqueMods
		 * ---------------------------------------------------------------------
		 * @param btn
		 * @param speed
		 * @param accel
		 *
		 * @param return [0] = left [1] = right
		 */
		static public function calcHighTorqueMods(
				btn:int, 
				speed:int, 
				accel:int
			):Array
		{
			var arr:Array = new Array(int(0),int(0));
			var engineWeight:int = 
					Globals.myAircraftConfigs.getMaxSpeedWeight(btn,speed);
			engineWeight += 
					Globals.myAircraftConfigs.getMaxAccelWeight(btn,accel);
			
			var payload:int = 
					Globals.myAircraftConfigs.getBTNPayloadByIndex(btn);
			// engineWeight >= 0.25 * payload => leftGMod = 1;
			// engineWeight >= 0.33 * payload => leftGMod = 1 and rightGmod = -1;
			if( engineWeight >= int(payload/3) ) 
			{
				arr[0] = 1;
				arr[1] = -1;
			} else if( engineWeight >= int(payload/4) ) {
				arr[0] = 1;
			}
			return arr;
		}
		
	}
}