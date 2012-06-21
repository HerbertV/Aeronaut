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
	
	// =========================================================================
	// Pilot
	// =========================================================================
	public class Pilot 
			extends CSBaseObject 
			implements ICSBaseObject
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const BASE_TAG:String = "pilot";
		
		public static const TYPE_HERO:String = "hero";
		public static const TYPE_SIDEKICK:String = "sidekick";
		public static const TYPE_GUNNER:String = "copilotgunner";
		public static const TYPE_NPC:String = "npc";
		
		public static const BASE_EP_HERO:int = 450;
		public static const BASE_EP_SIDEKICK:int = 350;
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
		
		// =====================================================================
		// Contructor
		// =====================================================================
		public function Pilot()
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
		 * creates an empty pilot xml
		 */
		public function createNew():void
		{
			myXML = new XML();
			myXML =
				<aeronaut XMLVersion={XMLProcessor.XMLDOCVERSION}>
					<pilot type={TYPE_HERO} naturalTouch="0" sixthSense="0" deadEye="0" steadyHand="0" constitution="3" quickDraw="0,0" totalXP={BASE_EP_HERO} currentXP={BASE_EP_HERO} bailOutBonus="0" linkedTo="">
						<name>New Pilot</name>
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
						<logs missions="0" kills="0" craftLost="0"/>
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
		 * getNaturalTouch
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getNaturalTouch():int 
		{
			return int(myXML.pilot.@naturalTouch);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setNaturalTouch
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setNaturalTouch(val:int)
		{
			myXML.pilot.@naturalTouch = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSixthSense
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getSixthSense():int 
		{
			return int(myXML.pilot.@sixthSense);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setSixthSense
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setSixthSense(val:int)
		{
			myXML.pilot.@sixthSense = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getDeadEye
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getDeadEye():int 
		{
			return int(myXML.pilot.@deadEye);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setDeadEye
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setDeadEye(val:int)
		{
			myXML.pilot.@deadEye = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSteadyHand
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getSteadyHand():int
		{
			return int(myXML.pilot.@steadyHand);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setSteadyHand
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setSteadyHand(val:int)
		{
			myXML.pilot.@steadyHand = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getConstitution
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getConstitution():int 
		{
			return int(myXML.pilot.@constitution);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setConstitution
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setConstitution(val:int)
		{
			myXML.pilot.@constitution = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getQuickDraw
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getQuickDraw():Array 
		{
			return myXML.pilot.@quickDraw.split(",");
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setQuickDraw
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setQuickDraw(val:int, subval:int)
		{
			myXML.pilot.@quickDraw = String(val+","+subval);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getTotalEP
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getTotalEP():int 
		{
			return int(myXML.pilot.@totalXP);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setTotalEP
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setTotalEP(val:int)
		{
			myXML.pilot.@totalXP = val;
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
			return int(myXML.pilot.@currentXP);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setCurrentEP
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setCurrentEP(val:int)
		{
			myXML.pilot.@currentXP = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getBailOutBonus
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getBailOutBonus():int 
		{
			return int(myXML.pilot.@bailOutBonus);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setBailOutBonus
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setBailOutBonus(val:int)
		{
			myXML.pilot.@bailOutBonus = val;
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
			return myXML.aircraft.noseart.@srcFoto;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setSrcNoseart
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setSrcNoseart(val:String)
		{
			myXML.aircraft.noseart.@srcFoto = val;
		}
	
	}
}