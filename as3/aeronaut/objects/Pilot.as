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
 * @version: 2.1.0
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
		
	import as3.aeronaut.objects.pilot.*;
	
	/**
	 * =========================================================================
	 * Pilot
	 * =========================================================================
	 */
	public class Pilot 
			extends CSBaseObject 
			implements ICSBaseObject
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const FILE_VERSION:String = "2.1";		
		public static const BASE_TAG:String = "pilot";
		
		// the main types
		public static const TYPE_PILOT:String = "pilot";
		public static const TYPE_CREW:String = "crew";
		public static const TYPE_NPC:String = "npc";
		
		// subtypes for pilots
		public static const SUBTYPE_ACE:String = "ace";
		public static const SUBTYPE_HERO:String = "hero";
		public static const SUBTYPE_SIDEKICK:String = "sidekick";
		public static const SUBTYPE_CUSTOM:String = "custom";
		//for zeppelins
		public static const SUBTYPE_CAPTAIN:String = "captain";
		
		// subtypes for crew
		public static const SUBTYPE_COPILOT:String = "copilot";
		public static const SUBTYPE_GUNNER:String = "gunner";
		public static const SUBTYPE_CREWCHIEF:String = "crewchief";
		public static const SUBTYPE_LOADMASTER:String = "loadmaster";
		public static const SUBTYPE_BOMBARDIER:String = "bombardier";
		// TODO check if zeppelin crew types are needed.
		// Zeppelin Bridge Crew:
		// elevatorman, wheelman, radioman
		// Zepp Mechanic
		// hangar master + personel	
		// siege gun operators 
		// security chief 
		// but also gunners and guards loadmaster
		
		// subtype for npc
		public static const SUBTYPE_NPC:String = "npc";
	
		public static const BASE_EP_ACE:int = 500;
		public static const BASE_EP_HERO:int = 450;
		public static const BASE_EP_SIDEKICK:int = 350;
	
// TODO ADJUST
		// copilot bomber/cargo SS3 CO 3 NT 3 other 1
		public static const BASE_EP_COPILOT:int = 100;
		// CO3 DE? SH ? other 1
		public static const BASE_EP_BOMBARDIER:int = 100;
		// CO3 DE3 QD ? other 1
		public static const BASE_EP_GUNNER:int = 100;
		// CO3 SH ? other 1
		public static const BASE_EP_CREWCHIEF:int = 100;
		// CO3 QD ? other 1
		public static const BASE_EP_LOADMASTER:int = 100;
			
		public static const BASE_EP_OTHER:int = 0;
		
		// xp cost for all stats sort by stat level
		public static const STAT_EPMATRIX:Array = new Array(
				10,	// level 1
				10,	// level 2
				20, // level 3
				30, // level 4
				40, // level 5
				50, // level 6
				60, // level 7
				70, // level 8
				80, // level 9
				90, // level 10
				0	// level 11 special FF5 houserule "ace of aces" feat
			);
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		// after the first save becomes a pilot file locked.
		// This means existing stats or feast can no longer delete
		// but only added or increased.
		// If the type is "npc" a file becomes never locked.
		private var isLocked:Boolean = false;
		
		/**
		 * =====================================================================
		 * Contructor
		 * =====================================================================
		 */
		public function Pilot()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getTypeLabel
		 * ---------------------------------------------------------------------
		 * @param type
		 *
		 * @return
		 */
		public static function getTypeLabel(type:String):String
		{
			if( type == TYPE_PILOT )
				return "Pilot";
			
			if( type == TYPE_CREW )
				return "Crew Member";
				
			if( type == TYPE_NPC )
				return "NPC";
			
			return "unknown type";
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSubTypeLabel
		 * ---------------------------------------------------------------------
		 * @param stype
		 *
		 * @return
		 */
		public static function getSubTypeLabel(stype:String):String
		{
			if( stype == SUBTYPE_ACE )
				return "Ace Pilot";
			
			if( stype == SUBTYPE_HERO )
				return "Hero";
			
			if( stype == SUBTYPE_SIDEKICK )
				return "Wingman";
			
			if( stype == SUBTYPE_CUSTOM )
				return "Custom Pilot";
			
			if( stype == SUBTYPE_CAPTAIN )
				return "Zeppelin Captain";
			
			if( stype == SUBTYPE_COPILOT )
				return "Co-Pilot";
			
			if( stype == SUBTYPE_GUNNER )
				return "Gunner";
			
			if( stype == SUBTYPE_CREWCHIEF )
				return "Crew Chief";
			
			if( stype == SUBTYPE_LOADMASTER )
				return "Load Master";
			
			if( stype == SUBTYPE_BOMBARDIER )
				return "Bombardier";
				
			if( stype == SUBTYPE_NPC )
				return "NPC";
			
			return "unknown subtype";
		}
		
		
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
			if( XMLProcessor.checkDoc(xmldoc)
					&& xmldoc.child(BASE_TAG).length() == 1 ) 
				return true;
			
			return false;
		}
				
		/**
		 * ---------------------------------------------------------------------
		 * createNew
		 * ---------------------------------------------------------------------
		 * creates an empty pilot xml
		 */
		public function createNew():void
		{
			myXML = new XML();
			
			myXML =
				<aeronaut XMLVersion={XMLProcessor.XMLDOCVERSION}>
					<pilot version={FILE_VERSION} type={TYPE_PILOT} subtype={SUBTYPE_HERO} linkedTo="" canLevelUp="true" useForAircrafts="true" useForZeppelins="false">
						<name>New Pilot</name>
						<stats naturalTouch="0" sixthSense="0" deadEye="0" steadyHand="0" constitution="3" quickDraw="0,0" bailOutBonus="0" />
						<appearance gender="male" height="5,11" weight="130" hairColor="" eyeColor="" srcFoto=""/>
						<country ID=""/>
						<squadron ID=""/>
						<planename>Your Planename</planename>
						<noseart src=""/>
						<description> </description>
						<equipment> </equipment>
						<languages>
						</languages>
						<feats>
						</feats>
						<logs missions="0" kills="0" craftLost="0" startEP={BASE_EP_HERO} totalEP={BASE_EP_HERO} currentEP={BASE_EP_HERO} lostConstitutionEP="0" />
					</pilot>
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
			
			if( Pilot.checkXML(loadedxml) ) 
			{
				this.myXML = loadedxml;
				this.isLocked = true;
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"loaded File was not a valid Pilot.",
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
			if( Pilot.checkXML(xmldoc) ) 
			{
				this.myXML = xmldoc;
				this.isLocked = true;
			} else {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"set XML was not a valid Pilot.",
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
			if( this.myXML.pilot.@version == FILE_VERSION )
				return false;
				
			if( Console.isConsoleAvailable() )
				Console.getInstance().writeln(
						"Updating Pilot File",
						DebugLevel.DEBUG,
						"from " + this.myXML.pilot.@version 
							+ " to " +FILE_VERSION
					);
			
			// update to 2.1
			if( this.myXML.pilot.attribute("stats").length() == 0 )
				updateVersionTo2_1();
			
			this.myXML.pilot.@version = FILE_VERSION;
			return true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateVersionTo2_1
		 * ---------------------------------------------------------------------
		 */
		private function updateVersionTo2_1():void
		{
			//split up type and subtype
			var oldType:String = myXML.pilot.@type;
			if( oldType == "hero" || oldType == "sidekick" )
			{
				this.setType(TYPE_PILOT);
				this.setSubType(oldType);
				this.setCanLevelUp(true);
				
			} else if( oldType == "copilotgunner" ) {
				this.setType(TYPE_CREW);
				this.setSubType(SUBTYPE_COPILOT);
				this.setCanLevelUp(false);
			
			} else {
				this.setType(TYPE_NPC);
				this.setSubType(SUBTYPE_NPC);
				this.setCanLevelUp(true);
			}
			this.setUsedForAircrafts(true);
			this.setUsedForZeppelins(false);
			
			// add new stats tag
			myXML.pilot.insertChildAfter(myXML.pilot.name[0], <stats />);
			// move stats to the new stats tag
			this.setNaturalTouch(int(myXML.pilot.@naturalTouch));
			this.setSixthSense(int(myXML.pilot.@sixthSense));
			this.setDeadEye(int(myXML.pilot.@deadEye));
			this.setSteadyHand(int(myXML.pilot.@steadyHand));
			this.setConstitution(int(myXML.pilot.@constitution));
			
			var qd:Array = myXML.pilot.@quickDraw.split(",");
			this.setQuickDraw(int(qd[0]),int(qd[1]));
			this.setBailOutBonus(int(myXML.pilot.@bailOutBonus));
			// remove the obsolete attributes
			delete myXML.pilot.@naturalTouch;
			delete myXML.pilot.@sixthSense;
			delete myXML.pilot.@deadEye
			delete myXML.pilot.@steadyHand;
			delete myXML.pilot.@constitution;
			delete myXML.pilot.@quickDraw;
			delete myXML.pilot.@bailOutBonus;
			
			//move xp attributes to logs
			this.setTotalEP(int(myXML.pilot.@totalXP));
			this.setCurrentEP(int(myXML.pilot.@currentXP));
			this.setLostConstitutionEP(int(myXML.pilot.@lostConstitutionEP));
			//remove the obsolete attributes
			delete myXML.pilot.@totalXP;
			delete myXML.pilot.@currentXP;
			delete myXML.pilot.@lostConstitutionEP;
			
			if( oldType == "hero" )
				this.setStartEP(BASE_EP_HERO);
			else if( oldType == "sidekick" )
				this.setStartEP(BASE_EP_SIDEKICK);
			else
				this.setStartEP(BASE_EP_OTHER);
				
			Console.getInstance().writeln(
				"XML after update:", 
				DebugLevel.INFO, 
				StringHelper.replaceHTMLbrackets(this.myXML.toString())
			);
// TODO updated pathes for Squad link (data+squad)
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getIsLocked
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getIsLocked():Boolean
		{
			return isLocked;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getName
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getName():String 
		{
			return myXML.pilot.name.text().toString();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setName
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setName(val:String) 
		{
			this.myXML.pilot.replace(
					"name", 
					<name>{StringHelper.trim(val," ")}</name>
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getType
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getType():String 
		{
			return myXML.pilot.@type;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setType
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setType(val:String)
		{
			this.myXML.pilot.@type = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSubType
		 * ---------------------------------------------------------------------
		 * @since 2.1
		 * 
		 * @return
		 */
		public function getSubType():String 
		{
			return myXML.pilot.@subtype;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setSubType
		 * ---------------------------------------------------------------------
		 * @since 2.1
		 * 
		 * @param val
		 */
		public function setSubType(val:String)
		{
			this.myXML.pilot.@subtype = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getNaturalTouch
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getNaturalTouch():int 
		{
			return int(myXML.pilot.stats.@naturalTouch);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setNaturalTouch
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setNaturalTouch(val:int)
		{
			myXML.pilot.stats.@naturalTouch = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSixthSense
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getSixthSense():int 
		{
			return int(myXML.pilot.stats.@sixthSense);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setSixthSense
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setSixthSense(val:int)
		{
			myXML.pilot.stats.@sixthSense = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getDeadEye
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getDeadEye():int 
		{
			return int(myXML.pilot.stats.@deadEye);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setDeadEye
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setDeadEye(val:int)
		{
			myXML.pilot.stats.@deadEye = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSteadyHand
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getSteadyHand():int
		{
			return int(myXML.pilot.stats.@steadyHand);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setSteadyHand
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setSteadyHand(val:int)
		{
			myXML.pilot.stats.@steadyHand = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getConstitution
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getConstitution():int 
		{
			return int(myXML.pilot.stats.@constitution);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setConstitution
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setConstitution(val:int)
		{
			myXML.pilot.stats.@constitution = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getQuickDraw
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getQuickDraw():Array 
		{
			return myXML.pilot.stats.@quickDraw.split(",");
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setQuickDraw
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setQuickDraw(val:int, subval:int)
		{
			myXML.pilot.stats.@quickDraw = String(val+","+subval);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getLostConstitutionEP
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getLostConstitutionEP():int 
		{
			if ( myXML.pilot.logs.@lostConstitutionEP ==  myXML.pilot.logs.@nonexistingattribute )
				return 0;
			
			return int(myXML.pilot.logs.@lostConstitutionEP);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setLostConstitutionEP
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setLostConstitutionEP(val:int)
		{
			myXML.pilot.logs.@lostConstitutionEP = val;
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * getStartEP
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getStartEP():int 
		{
			return int(myXML.pilot.logs.@startEP);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setStartEP
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setStartEP(val:int)
		{
			myXML.pilot.logs.@startEP = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getTotalEP
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getTotalEP():int 
		{
			return int(myXML.pilot.logs.@totalEP);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setTotalEP
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setTotalEP(val:int)
		{
			myXML.pilot.logs.@totalEP = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getCurrentEP
		 * ---------------------------------------------------------------------
		 * xp that are free to spend.
		 *
		 * @return
		 */
		public function getCurrentEP():int 
		{
			return int(myXML.pilot.logs.@currentEP);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setCurrentEP
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setCurrentEP(val:int)
		{
			myXML.pilot.logs.@currentEP = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getBailOutBonus
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getBailOutBonus():int 
		{
			return int(myXML.pilot.stats.@bailOutBonus);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setBailOutBonus
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setBailOutBonus(val:int)
		{
			myXML.pilot.stats.@bailOutBonus = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getGender
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getGender():String 
		{
			return myXML.pilot.appearance.@gender;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setGender
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setGender(val:String) 
		{
			this.myXML.pilot.appearance.@gender = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getHeight
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getHeight():Array 
		{
			return myXML..appearance.@height.split(",");
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
			myXML..appearance.@height = String(feet + "," + inch);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getWeight
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getWeight():int 
		{
			return int(myXML.pilot.appearance.@weight);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setWeight
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setWeight(val:int) 
		{
			this.myXML.pilot.appearance.@weight = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getHairColor
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getHairColor():String 
		{
			return myXML.pilot.appearance.@hairColor;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setHairColor
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setHairColor(val:String) 
		{
			this.myXML.pilot.appearance.@hairColor = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getEyeColor
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getEyeColor():String 
		{
			return myXML.pilot.appearance.@eyeColor;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setEyeColor
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setEyeColor(val:String) 
		{
			this.myXML.pilot.appearance.@eyeColor = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSrcFoto
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getSrcFoto():String 
		{
			return myXML.pilot.appearance.@srcFoto;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setSrcFoto
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setSrcFoto(val:String) 
		{
			this.myXML.pilot.appearance.@srcFoto = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getCountryID
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getCountryID():String
		{
			return myXML.pilot.country.@ID;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setCountryID
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setCountryID(val:String)
		{
			this.myXML.pilot.country.@ID = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSquadronID
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getSquadronID():String 
		{
			return myXML.pilot.squadron.@ID;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setSquadronID
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setSquadronID(val:String) 
		{
			this.myXML.pilot.squadron.@ID = val;
		}
				
		/**
		 * ---------------------------------------------------------------------
		 * getPlanename
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getPlanename():String 
		{
			return myXML.pilot.planename.text().toString();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setPlanename
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setPlanename(val:String)
		{
			this.myXML.pilot.replace(
					"planename", 
					<planename>{StringHelper.trim(val," ")}</planename>
				);
		}
				
		/**
		 * ---------------------------------------------------------------------
		 * getDescription
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getDescription():String 
		{
			return myXML.pilot.description.text().toString();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setDescription
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setDescription(val:String) 
		{
			this.myXML.pilot.replace(
					"description", 
					<description>{StringHelper.trim(val," ")}</description>
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getEquipment
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getEquipment():String 
		{
			return myXML.pilot.equipment.text().toString();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setEquipment
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setEquipment(val:String)
		{
			this.myXML.pilot.replace(
					"equipment", 
					<equipment>{StringHelper.trim(val," ")}</equipment>
				);
		}
				
		/**
		 * ---------------------------------------------------------------------
		 * getMotherTongue
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getMotherTongue():LearnedLanguage 
		{
			for each( var learnedLanguage:XML in myXML..learnedLanguage ) 
				if (learnedLanguage.@isMotherTongue == "true") 
					return new LearnedLanguage(
							learnedLanguage.@ID, 
							true
						);
			
			return null;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setMotherTongue
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setMotherTongue(val:LearnedLanguage) 
		
		{
			deleteMotherTongue();
			myXML..languages.appendChild(
					<learnedLanguage ID={val.myID} isMotherTongue="true"/>
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * deleteMotherTongue
		 * ---------------------------------------------------------------------
		 */
		public function deleteMotherTongue() 
		{
			delete(myXML..learnedLanguage.(@isMotherTongue== "true")[0]);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getLearnedLanguages
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getLearnedLanguages():Array
		{
			var arr:Array = new Array();

			for each( var learnedLanguage:XML in myXML..learnedLanguage ) 
			{
				var isMother:Boolean = false;
				if (learnedLanguage.@isMotherTongue == "true") 
					isMother = true;
				
				var obj:LearnedLanguage = new LearnedLanguage(
						learnedLanguage.@ID, 
						isMother 
					);
				arr.push(obj);
			}
			return arr;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setMotherTongue
		 * ---------------------------------------------------------------------
		 * @param arr
		 */
		public function setLearnedLanguages(arr:Array) 
		{
			var newLanguageXML:XML = <languages>
									 </languages>;
									
			for( var i:int = 0; i< arr.length; i++ )  
				newLanguageXML.appendChild(
						<learnedLanguage ID={arr[i].myID} isMotherTongue={String(arr[i].isMotherTongue)} />
					);
			
			myXML.pilot.replace(
					"languages",
					newLanguageXML
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getLearnedFeats
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getLearnedFeats():Array
		{
			var arr:Array = new Array();

			for each( var learnedFeat:XML in myXML..learnedFeat ) 
			{
				var obj:LearnedFeat = new LearnedFeat(learnedFeat.@ID);
				obj.currentLevel = learnedFeat.@currLvl;
				arr.push(obj);
			}
			return arr;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setLearnedFeats
		 * ---------------------------------------------------------------------
		 * @param arr
		 */
		public function setLearnedFeats(arr:Array) 
		{
			var newFeatXML:XML = <feats>
								 </feats>;
									
			for( var i:int = 0; i< arr.length; i++ )  
				newFeatXML.appendChild(
						<learnedFeat ID={arr[i].myID} currLvl={String(arr[i].currentLevel)} />
					);
			
			myXML.pilot.replace("feats",newFeatXML);
		}
				
		/**
		 * ---------------------------------------------------------------------
		 * getMissionCount
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getMissionCount():int 
		{
			return int(myXML.pilot.logs.@missions);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setMissionCount
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setMissionCount(val:int)
		{
			myXML.pilot.logs.@missions = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getKills
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getKills():int 
		{
			return int(myXML.pilot.logs.@kills);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setKills
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setKills(val:int)
		{
			myXML.pilot.logs.@kills = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getCraftLost
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getCraftLost():int 
		{
			return int(myXML.pilot.logs.@craftLost);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setCraftLost
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setCraftLost(val:int)
		{
			myXML.pilot.logs.@craftLost = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSrcNoseart
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getSrcNoseart():String 
		{
			return myXML.pilot.noseart.@srcFoto;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setSrcNoseart
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setSrcNoseart(val:String)
		{
			myXML.pilot.noseart.@srcFoto = val;
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * canLevelUp
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function canLevelUp():Boolean 
		{
			if( myXML.pilot.@canLevelUp == "false" )
				return false;
				
			return true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setCanLevelUp
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setCanLevelUp(val:Boolean)
		{
			myXML.pilot.@canLevelUp = val;
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * isUsedForAircrafts
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function isUsedForAircrafts():Boolean 
		{
			if( myXML.pilot.@useForAircrafts == "false" )
				return false;
				
			return true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setUsedForAircrafts
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setUsedForAircrafts(val:Boolean)
		{
			myXML.pilot.@useForAircrafts = val;
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * isUsedForZeppelins
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function isUsedForZeppelins():Boolean 
		{
			if( myXML.pilot.@useForZeppelins == "false" )
				return false;
				
			return true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setUsedForZeppelins
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setUsedForZeppelins(val:Boolean)
		{
			myXML.pilot.@useForZeppelins = val;
		}

	}
}