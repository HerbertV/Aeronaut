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
 * @version: 1.2.0
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2009-2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.module
{
	import mdm.*;
	
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.FocusEvent;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	import as3.hv.core.utils.BitmapHelper;
	import as3.hv.core.utils.StringHelper;
	import as3.hv.core.net.ImageLoader;
	import as3.hv.core.net.BinaryLoader;
	import as3.hv.zinc.z3.xml.XMLFileList;
	import as3.hv.zinc.z3.xml.XMLFileListElement;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.CSWindowManager;
	import as3.aeronaut.CSDialogs;
	
	import as3.aeronaut.gui.*;
	
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.Pilot;
	import as3.aeronaut.objects.pilot.*;
	import as3.aeronaut.module.pilot.*;
	
	import as3.aeronaut.objects.Squadron;	
	import as3.aeronaut.objects.BaseData;
	import as3.aeronaut.objects.baseData.Country;
	import as3.aeronaut.objects.baseData.Feat;
	import as3.aeronaut.objects.baseData.Language;
	
	import as3.aeronaut.print.IPrintable;
	
	import as3.aeronaut.cadet.PilotImporter;
	import as3.aeronaut.cadet.AbstractCadetImporter;
	
	/**
	 * =========================================================================
	 * CSWindowPilot
	 * =========================================================================
	 * This class is a linked document class for "winPilot.swf"
	 * @see as3.aeronaut.objects.Pilot
	 *
	 * Window for crating/editing Pilot.
	 */
	public class CSWindowPilot 
			extends CSWindow 
			implements ICSWindowPilot, ICSValidate, IPrintable
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const FOTO_WIDTH:int = 150;
		public static const FOTO_HEIGHT:int = 160;
		
		public static const FLAG_WIDTH:int = 100;
		public static const FLAG_HEIGHT:int = 66;
		
		public static const SQUADLOGO_WIDTH:int = 82;
		public static const SQUADLOGO_HEIGHT:int = 76;
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var isValid:Boolean = true;
		private var isSaved:Boolean = true;
		private var myObject:Pilot = null;
		
		private var lastSelectedType:String = "";
		private var lastSelectedSubType:String = "";
		
		// radiobutton groups
		private var rbgGender:CSRadioButtonGroup = null;

		private var imgLoader:ImageLoader = null;
		private var srcFoto:String ="";
		private var srcFlag:String ="";
		private var srcSquadLogo:String ="";
		
		private var lastSelectedNation:String = "";
		private var lastSelectedSquadron:String = "";
		
		private var intMissionCount:int = 0;
		private var intKillCount:int = 0;
		private var intCraftLostCount:int = 0;
		
		// experience 
		private var intTotalEP:int = 0;
		private var intCurrentEP:int = 0; // free ep
		private var intStatEP:int = 0;
		private var intFeatEP:int = 0;
		private var intLanguageEP:int = 0;
		
		// becomes true if file was updated after loading
		private var fileWasUpdated:Boolean = false;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 */
		public function CSWindowPilot()
		{
			super();
			
			// positions
			this.posStartX = 160;
			this.posStartY = -700;
			
			this.posOpenX = 160;
			this.posOpenY = 30;
			
			this.posMinimizedX = 1247;
			
			this.x = this.posStartX;
			this.y = this.posStartY;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * init
		 * ---------------------------------------------------------------------
		 * @see AbstractModule
		 */
		override public function init():void
		{
			super.init();
			
			this.setValid(true);
			this.setSaved(true);
			this.setStyle(CSStyle.BLACK);
			
			//nation
			this.form.pdNation.setEmptySelectionText("",true);
			var arr:Array = Globals.myBaseData.getCountries();
			for( var i:int = 0; i < arr.length; i++ ) 
				this.form.pdNation.addSelectionItem(
						arr[i].myName, 
						arr[i].myID
					);
			this.form.pdNation.addEventListener(
					MouseEvent.MOUSE_DOWN,
					changeNationHandler
				);
			
			//squadron
			this.form.pdSquadron.addEventListener(
					MouseEvent.MOUSE_DOWN,
					changeSquadHandler
				);
			
			//Type and subtype
			this.form.pdType.setEmptySelectionText("", false);
			this.form.pdType.addSelectionItem(
						Pilot.getTypeLabel(Pilot.TYPE_PILOT), 
						Pilot.TYPE_PILOT
					);
			this.form.pdType.addSelectionItem(
						Pilot.getTypeLabel(Pilot.TYPE_CREW), 
						Pilot.TYPE_CREW
					);
			this.form.pdType.addSelectionItem(
						Pilot.getTypeLabel(Pilot.TYPE_NPC), 
						Pilot.TYPE_NPC
					);
			this.form.pdType.addEventListener(
					MouseEvent.MOUSE_DOWN,
					typeChangedHandler
				);
			this.form.pdSubType.setEmptySelectionText("", false);
			this.form.pdSubType.addEventListener(
					MouseEvent.MOUSE_DOWN,
					typeChangedHandler
				);	
				
			this.form.rbtnCanLevelUp.addEventListener(
					MouseEvent.MOUSE_DOWN,
					canLevelHandler
				);
		
			this.form.txtStartEP.restrict = "0-9";
			this.form.txtStartEP.addEventListener(
					TextEvent.TEXT_INPUT, 
					startEPInputHandler
				);	
			this.form.txtStartEP.addEventListener(
					FocusEvent.FOCUS_OUT, 
					startEPFocusHandler
				);	
			
			//gender
			this.rbgGender = new CSRadioButtonGroup();
			rbgGender.addMember(this.form.rbtnGenderMale,"male");
			rbgGender.addMember(this.form.rbtnGenderFemale,"female");
			
			//appearance
			this.form.numStepHeight.setupSteps(1, 7, 5, 11);
			this.form.numStepHeight.setupTooltip(Globals.myTooltip,"");
			this.form.numStepWeight.setupSteps(1, 300, 176, 1);
			this.form.numStepWeight.setupTooltip(Globals.myTooltip,"");
			this.form.txtAircraftName.text = "";
			this.form.txtEyeColor.text = "";
			this.form.txtHairColor.text = "";
			
			this.form.btnAddEP.setupTooltip(
					Globals.myTooltip,
					"Add EP and Update Mission Log"
				);
			this.form.btnAddEP.addEventListener(
					MouseEvent.MOUSE_DOWN,
					clickAddEPHandler
				);
			
			//foto
			this.form.btnPilotFoto.buttonMode = true;
			this.form.btnPilotFoto.tabEnabled = false;
			this.form.btnPilotFoto.addEventListener(
					MouseEvent.MOUSE_DOWN,
					clickFotoButtonHandler
				);
			
			this.form.pdLinkedTo.setEmptySelectionText("not linked", true);
// TODO this.form.pdLinkedTo

			this.form.btnImportCadet.setupTooltip(
					Globals.myTooltip,
					"Import CADET Pilot"
				);
			this.form.btnImportCadet.addEventListener(
					MouseEvent.MOUSE_DOWN,
					importCadetHandler
				);
				
			//dirlists
			this.updateDirLists();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 * @see AbstractModule
		 */
		override public function dispose():void
		{
			this.form.pdNation.removeEventListener(
					MouseEvent.MOUSE_DOWN,
					changeNationHandler
				);
			this.form.btnPilotFoto.removeEventListener(
					MouseEvent.MOUSE_DOWN,
					clickFotoButtonHandler
				);
			this.form.pdSquadron.removeEventListener(
					MouseEvent.MOUSE_DOWN,
					changeSquadHandler
				);
			this.form.btnAddEP.removeEventListener(
					MouseEvent.MOUSE_DOWN,
					clickAddEPHandler
				);
			
			this.form.pdType.removeEventListener(
					MouseEvent.MOUSE_DOWN,
					typeChangedHandler
				);
			this.form.pdSubType.removeEventListener(
					MouseEvent.MOUSE_DOWN,
					typeChangedHandler
				);	
				
			this.form.rbtnCanLevelUp.removeEventListener(
					MouseEvent.MOUSE_DOWN,
					canLevelHandler
				);	
			this.form.btnImportCadet.removeEventListener(
					MouseEvent.MOUSE_DOWN,
					importCadetHandler
				);	
				
			this.form.myStatsBar.dispose();
			this.form.myFeatBox.dispose();
			this.form.myLanguageBox.dispose();
			this.form.myDescriptionBox.dispose();
			this.form.myEquipmentBox.dispose();
			
			this.form.txtStartEP.removeEventListener(
					TextEvent.TEXT_INPUT, 
					startEPInputHandler
				);	
			this.form.txtStartEP.removeEventListener(
					FocusEvent.FOCUS_OUT, 
					startEPFocusHandler
				);
				
			super.dispose();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * loadObject
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @param fn
		 */
		public function loadObject(fn:String):void
		{
			var obj:Pilot = new Pilot();
			obj.loadFile(fn);
			this.fileWasUpdated = obj.updateVersion();
			this.initFromPilot(obj);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * saveObject
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @param fn
		 */
		public function saveObject(fn:String):void
		{
			if( this.myObject.saveFile(fn) )				
				this.setSaved(true);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initNewObject
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 */
		public function initNewObject():void
		{
			var obj:Pilot = new Pilot();
			obj.createNew();
			this.fileWasUpdated = false;
			this.initFromPilot(obj);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromObject
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @param obj
		 */
		public function initFromObject(obj:ICSBaseObject):void
		{
			if( obj is Pilot )
				this.initFromPilot( Pilot(obj) );
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromPilot
		 * ---------------------------------------------------------------------
		 * @see ICSWindowPilot
		 * @param obj
		 */
		public function initFromPilot(obj:Pilot):void
		{
			this.setValid(true);
			this.setSaved(true);
			if( this.fileWasUpdated )
				this.setSaved(false);
			
			this.setTextFieldValid(this.form.lblCurrentEP, true);
			
			this.myObject = obj;
			
			this.form.txtName.text = this.myObject.getName();
			
			this.form.pdType.setActiveSelectionItem(this.myObject.getType());
			this.lastSelectedType = this.myObject.getType();
			this.updateGUIByType();
			this.form.pdSubType.setActiveSelectionItem(this.myObject.getSubType());
			this.lastSelectedSubType = this.myObject.getSubType();
			this.updateGUIBySubType();
			this.form.rbtnCanLevelUp.setSelected(this.myObject.canLevelUp());
			
			this.form.lblBailOutBonus.text = String(
					this.myObject.getBailOutBonus()
				);
			
			this.rbgGender.setValue(this.myObject.getGender());
			var arr:Array = this.myObject.getHeight();
			this.form.numStepHeight.setValue(arr[0], arr[1]);
			this.form.numStepWeight.setValue(this.myObject.getWeight());
			this.form.txtEyeColor.text = this.myObject.getEyeColor();
			this.form.txtHairColor.text = this.myObject.getHairColor();
			
			this.srcFoto = this.myObject.getSrcFoto();
			
			this.lastSelectedNation = this.myObject.getCountryID();
			if( this.lastSelectedNation != "" )
			{
				this.form.pdNation.setActiveSelectionItem(
						this.lastSelectedNation
					);
				var selCountry:Country = Globals.myBaseData.getCountry(
						this.lastSelectedNation
					);
				if( selCountry.srcFlag != "" && selCountry.srcFlag != null ) 
				{
					this.srcFlag = selCountry.srcFlag;
				} else {
					this.srcFlag = "";
				}
			}
			
			this.lastSelectedSquadron = this.myObject.getSquadronID();
			if( this.lastSelectedSquadron != "" )
			{
				this.form.pdSquadron.setActiveSelectionItem(
						this.lastSelectedSquadron
					);
				var squad:Squadron = new Squadron();
				squad.loadFile(
						mdm.Application.path
							+ this.lastSelectedSquadron
					);
				if( squad.getSrcLogo() != "" && squad.getSrcLogo() != null )
				{
					this.srcSquadLogo = squad.getSrcLogo();
				} else {
					this.srcSquadLogo = "";
				}
			}
		
			this.form.txtAircraftName.text = this.myObject.getPlanename();
			this.form.myDescriptionBox.init(this);
			this.form.myEquipmentBox.init(this);
			
			
			// locked gui elements that are no
			// longer changeable
			if( this.myObject.getIsLocked() )
			{
				this.form.pdType.setActive(false);
				this.form.pdSubType.setActive(false);
				this.form.rbtnCanLevelUp.setActive(false);
				this.form.txtStartEP.text = this.myObject.getStartEP();
				this.form.txtStartEP.selectable = false;
				this.form.txtStartEP.type = TextFieldType.DYNAMIC;
				
				this.form.rbtnGenderMale.setActive(false);
				this.form.rbtnGenderFemale.setActive(false);
			}
			
// TODO this.form.pdLinkedTo
			this.form.rbtnUsedForAircrafts.setSelected(
					this.myObject.isUsedForAircrafts()
				);
			this.form.rbtnUsedForZeppelins.setSelected(
					this.myObject.isUsedForZeppelins()
				);

			this.intMissionCount = this.myObject.getMissionCount();
			this.intKillCount = this.myObject.getKills();
			this.intCraftLostCount = this.myObject.getCraftLost();
		
			this.intTotalEP = this.myObject.getTotalEP();
			this.intCurrentEP = this.myObject.getCurrentEP();
						
			this.form.myFeatBox.calcEP();
			this.form.myLanguageBox.calcEP();
			this.form.myStatsBar.calcEP();
			this.calcEP();
			
			this.prepareSquadLogo();
			this.prepareFlag();
			this.prepareFoto();
			
			if( this.imgLoader != null )
				this.imgLoader.load();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateNewEPAndMissionStuff
		 * ---------------------------------------------------------------------
		 * called from toolbar to update the changes.
		 *
		 * @see ICSWindowPilot
		 *		 
		 * @param newEP gained expirence
		 * @param coLost constitution loss
		 * @param mission 
		 * @param kills
		 * @param positiveBailout
		 * @param craftLost
		 */
		public function updateNewEPAndMissionStuff(
				newEP:int, 
				coLost:int, 
				mission:int, 
				kills:int, 
				positiveBailout:Boolean, 
				craftLost:Boolean
			):void
		{
			//Experience
			intTotalEP += newEP;
			intCurrentEP += newEP;
			
			// CO update
			if( coLost > 0 )
			{
				this.form.myStatsBar.updateCOLost( coLost );
				var co:int = this.myObject.getConstitution()
				var lostep:int = 0;
				var from:int = co - coLost;
				var to:int = co;
				
				for( var i:int = from; i < to; i++ ) 
					lostep += Pilot.STAT_EPMATRIX[i];
				
				this.myObject.setLostConstitutionEP(
						this.myObject.getLostConstitutionEP() 
							+ lostep 
					);
				this.myObject.setConstitution(co-coLost);
			}
			this.calcEP();
			
			this.intMissionCount = mission;
			this.intKillCount += kills;
			
			if( craftLost ) 
				this.intCraftLostCount++;
			
			if( positiveBailout ) 
				this.form.lblBailOutBonus.text = String(
						int(this.form.lblBailOutBonus.text) +1 
					);
			
			this.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateObjectFromWindow
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 */
		public function updateObjectFromWindow():void
		{
			this.myObject.setName(this.form.txtName.text);
	
			this.myObject.setType(this.form.pdType.getIDForCurrentSelection());
			this.myObject.setSubType(this.form.pdSubType.getIDForCurrentSelection());
			this.myObject.setStartEP(int(this.form.txtStartEP.text));
			this.myObject.setCanLevelUp(this.form.rbtnCanLevelUp.getIsSelected());
			
			this.myObject.setGender(this.rbgGender.getValue());
			this.myObject.setHeight(
					this.form.numStepHeight.getFeet(), 
					this.form.numStepHeight.getInch()
				);
			this.myObject.setWeight(this.form.numStepWeight.getValue());
			this.myObject.setEyeColor(this.form.txtEyeColor.text);
			this.myObject.setHairColor(this.form.txtHairColor.text);
			this.myObject.setSrcFoto(this.srcFoto);
			
			if( this.form.pdNation.getIDForCurrentSelection() 
					== CSPullDown.ID_EMPTYSELECTION ) 
			{
				this.myObject.setCountryID("");
			} else {
				this.myObject.setCountryID(
						this.form.pdNation.getIDForCurrentSelection()
					);
			}

			if (this.form.pdSquadron.getIDForCurrentSelection() 
					== CSPullDown.ID_EMPTYSELECTION ) 
			{
				this.myObject.setSquadronID("");
			} else {
				this.myObject.setSquadronID(
						this.form.pdSquadron.getIDForCurrentSelection()
					);
			}
			
			this.myObject.setPlanename(this.form.txtAircraftName.text);
			
			this.myObject.setBailOutBonus(int(this.form.lblBailOutBonus.text));
			
			this.myObject.setMissionCount(this.intMissionCount);
			this.myObject.setKills(this.intKillCount);
			this.myObject.setCraftLost(this.intCraftLostCount);
			
			this.myObject.setTotalEP(this.intTotalEP);
			this.myObject.setCurrentEP(
					intCurrentEP 
						- intStatEP 
						- intFeatEP 
						- intLanguageEP
				);
			
			this.myObject = this.form.myStatsBar.updateObjectFromWindow();
			this.myObject = this.form.myFeatBox.updateObjectFromWindow();
			this.myObject = this.form.myLanguageBox.updateObjectFromWindow();
			
			this.myObject.setDescription(
					this.form.myDescriptionBox.txtDescription.text
				);
			this.myObject.setEquipment(
					this.form.myEquipmentBox.txtEquipment.text
				);
				
			this.myObject.setUsedForAircrafts(
					this.form.rbtnUsedForAircrafts.getIsSelected()
				);	
			this.myObject.setUsedForZeppelins(
					this.form.rbtnUsedForZeppelins.getIsSelected()
				);	
				
// TODO this.form.pdLinkedTo
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateDirLists
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 */
		public function updateDirLists():void
		{
			this.form.pdSquadron.clearSelectionItemList();
			this.form.pdSquadron.setEmptySelectionText("",true);

			var fl:XMLFileList = new XMLFileList(Globals.AE_EXT, "name");
					
			var arrFLSquad:Array = fl.generate( 
					mdm.Application.path, 
					Globals.PATH_DATA 
						+ Globals.PATH_SQUADRON,
					Squadron.BASE_TAG
				);	
			
			fl.sort(arrFLSquad);
			
			for( var i:int=0; i< arrFLSquad.length; i++ )
				this.form.pdSquadron.addSelectionItem(
						XMLFileListElement(arrFLSquad[i]).viewname,
						XMLFileListElement(arrFLSquad[i]).filename
					); 
			
			// TODO add new filtering (subtype, used for aircraft canLevel)
			/*
			if( this.rbgType.getValue() == Pilot.TYPE_GUNNER )
			{
				this.form.pdLinkedTo
			}
			*/
			
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setSaved
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @param v
		 */
		public function setSaved(v:Boolean):void
		{
			this.isSaved = v;
			this.stampUnsavedData.visible = !v;			
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getIsSaved
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @return
		 */
		public function getIsSaved():Boolean 
		{
			return this.isSaved;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getObject
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @return
		 */
		public function getObject():ICSBaseObject
		{
			return this.myObject;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getFilename
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @return
		 */
		public function getFilename():String 
		{
			return this.myObject.getFilename();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getTitle
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @return
		 */
		public function getTitle():String
		{
			return "Pilot";
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getWindowType
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @return
		 */
		public function getWindowType():int
		{
			return CSWindowManager.WND_PILOT;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getSubPath
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 * @return
		 */
		public function getSubPath():String
		{
			return Globals.PATH_PILOT;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * printMe
		 * ---------------------------------------------------------------------
		 * @see IPrintable
		 */
		public function printMe():void 
		{
			this.updateObjectFromWindow();
			
			Globals.myPrintManager.addSheet("printPilot.swf",this.myObject);
			Globals.myPrintManager.printNow();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * validateForm
		 * ---------------------------------------------------------------------
		 * @see ICSValidate
		 */
		public function validateForm():void
		{
			var valid:Boolean = true;
			if( (intCurrentEP - intStatEP - intFeatEP - intLanguageEP) < 0 ) 
				valid = false;
			
			this.setTextFieldValid(this.form.lblCurrentEP, valid);
			
			if( Globals.myRuleConfigs.getIsPilotFeatsActive() )
			{
				// the eleven checks
				if( this.form.myStatsBar.hasElevenStat() 
						&& !this.form.myFeatBox.hasAceOfAces() )
					valid = false;
				
				if( this.form.myStatsBar.hasToMuchElevenStats() )
					valid = false;
			}
			
			this.setValid(valid);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setValid
		 * ---------------------------------------------------------------------
		 * @see ICSValidate
		 * @param v
		 */
		public function setValid(v:Boolean):void
		{
			this.isValid = v;
			this.stampInvalidData.visible = !v;			
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getIsValid
		 * ---------------------------------------------------------------------
		 * @see ICSValidate
		 * @return
		 */
		public function getIsValid():Boolean 
		{
			return this.isValid;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getPilotType
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getPilotType():String
		{
			return this.form.pdType.getIDForCurrentSelection();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getPilotSubType
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getPilotSubType():String
		{
			return this.form.pdSubType.getIDForCurrentSelection();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * canPilotLevelUp
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function canPilotLevelUp():Boolean
		{
			return this.form.rbtnCanLevelUp.getIsSelected();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setStatsEP
		 * ---------------------------------------------------------------------
		 * used by StatsBar to update the stats ep
		 * @param ep
		 */
		public function setStatsEP(ep:int):void
		{
			this.intStatEP = ep;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setFeatEP
		 * ---------------------------------------------------------------------
		 * used by FeatBox to update the feats ep
		 * @param ep
		 */
		public function setFeatEP(ep:int):void
		{
			this.intFeatEP = ep;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setLanguageEP
		 * ---------------------------------------------------------------------
		 * used by LanguageBox to update the language ep
		 * @param ep
		 */
		public function setLanguageEP(ep:int):void
		{
			this.intLanguageEP = ep;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * calcEP
		 * ---------------------------------------------------------------------
		 * sums up all EPs
		 */
		public function calcEP():void
		{
			this.form.lblTotalEP.text = String(intTotalEP);
			// intCurrentEP is only updated after a reload.
			this.form.lblCurrentEP.text = String(
					intCurrentEP 
						- intStatEP 
						- intFeatEP 
						- intLanguageEP
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateGUIByType
		 * ---------------------------------------------------------------------
		 */
		private function updateGUIByType()
		{
			this.form.pdSubType.clearSelectionItemList();
			this.form.pdSubType.setEmptySelectionText("", false);
			this.form.rbtnCanLevelUp.setSelected(false);
			this.form.rbtnCanLevelUp.setActive(true);
			this.form.pdLinkedTo.clearSelection();
			this.form.pdLinkedTo.setActive(false);
			
			if( this.lastSelectedType == Pilot.TYPE_PILOT )
			{
				this.form.pdSubType.addSelectionItem(
						Pilot.getSubTypeLabel(Pilot.SUBTYPE_ACE), 
						Pilot.SUBTYPE_ACE
					);
				this.form.pdSubType.addSelectionItem(
						Pilot.getSubTypeLabel(Pilot.SUBTYPE_HERO), 
						Pilot.SUBTYPE_HERO
					);
				this.form.pdSubType.addSelectionItem(
						Pilot.getSubTypeLabel(Pilot.SUBTYPE_SIDEKICK), 
						Pilot.SUBTYPE_SIDEKICK
					);
				this.form.pdSubType.addSelectionItem(
						Pilot.getSubTypeLabel(Pilot.SUBTYPE_CUSTOM), 
						Pilot.SUBTYPE_CUSTOM
					);
				this.form.pdSubType.addSelectionItem(
						Pilot.getSubTypeLabel(Pilot.SUBTYPE_CAPTAIN), 
						Pilot.SUBTYPE_CAPTAIN
					);
				this.form.pdSubType.setActiveSelectionItem(Pilot.SUBTYPE_HERO);
				this.form.rbtnCanLevelUp.setSelected(true);
				this.form.rbtnCanLevelUp.setActive(false);
				
			} else if( this.lastSelectedType == Pilot.TYPE_CREW ) {
				this.form.pdSubType.addSelectionItem(
						Pilot.getSubTypeLabel(Pilot.SUBTYPE_COPILOT), 
						Pilot.SUBTYPE_COPILOT
					);
				this.form.pdSubType.addSelectionItem(
						Pilot.getSubTypeLabel(Pilot.SUBTYPE_GUNNER), 
						Pilot.SUBTYPE_GUNNER
					);
				this.form.pdSubType.addSelectionItem(
						Pilot.getSubTypeLabel(Pilot.SUBTYPE_BOMBARDIER), 
						Pilot.SUBTYPE_BOMBARDIER
					);
				this.form.pdSubType.addSelectionItem(
						Pilot.getSubTypeLabel(Pilot.SUBTYPE_CREWCHIEF), 
						Pilot.SUBTYPE_CREWCHIEF
					);
				this.form.pdSubType.addSelectionItem(
						Pilot.getSubTypeLabel(Pilot.SUBTYPE_LOADMASTER), 
						Pilot.SUBTYPE_LOADMASTER
					);
				
				this.form.pdSubType.setActiveSelectionItem(Pilot.SUBTYPE_COPILOT);
				
			} else if( this.lastSelectedType == Pilot.TYPE_NPC ) {
				this.form.pdSubType.addSelectionItem(
						Pilot.getSubTypeLabel(Pilot.SUBTYPE_NPC), 
						Pilot.SUBTYPE_NPC
					);
				this.form.pdSubType.setActiveSelectionItem(Pilot.SUBTYPE_NPC);
				this.form.rbtnCanLevelUp.setActive(false);
			} 
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateGUIBySubType
		 * ---------------------------------------------------------------------
		 */
		private function updateGUIBySubType()
		{
			this.form.pdLinkedTo.clearSelection();
			this.form.pdLinkedTo.setActive(false);
			
			this.intTotalEP = Pilot.BASE_EP_OTHER;
			this.intCurrentEP = Pilot.BASE_EP_OTHER;
			this.form.txtStartEP.selectable = false;
			this.form.txtStartEP.type = TextFieldType.DYNAMIC;
			this.form.txtStartEP.text = String(Pilot.BASE_EP_OTHER);
			this.form.btnAddEP.setActive(true);
			this.intMissionCount = 0;
			
			if( this.lastSelectedSubType == Pilot.SUBTYPE_ACE ) 
			{
				this.intTotalEP = Pilot.BASE_EP_ACE;
				this.intCurrentEP = Pilot.BASE_EP_ACE;
				this.form.txtStartEP.text = String(Pilot.BASE_EP_ACE);
				this.intMissionCount = 5;
				
			} else if( this.lastSelectedSubType == Pilot.SUBTYPE_HERO ) {
				this.intTotalEP = Pilot.BASE_EP_HERO;
				this.intCurrentEP = Pilot.BASE_EP_HERO;
				this.form.txtStartEP.text = String(Pilot.BASE_EP_HERO);
				
			} else if( this.lastSelectedSubType == Pilot.SUBTYPE_SIDEKICK ) {
				this.intTotalEP = Pilot.BASE_EP_SIDEKICK;
				this.intCurrentEP = Pilot.BASE_EP_SIDEKICK;
				this.form.txtStartEP.text = String(Pilot.BASE_EP_SIDEKICK);
				
			} else if( this.lastSelectedSubType == Pilot.SUBTYPE_CUSTOM ) {
				this.form.txtStartEP.selectable = true;
				this.form.txtStartEP.type = TextFieldType.INPUT;
				
			} else if( this.lastSelectedSubType == Pilot.SUBTYPE_CAPTAIN ) {
				//captain starting EP left over CP from Zeppelin so we use the custom Start EP
				this.form.txtStartEP.selectable = true;
				this.form.txtStartEP.type = TextFieldType.INPUT;
// TODO FF5 houserule CAPTAIN gets Zeppelin Pilot level 1 for free
// TODO set use in Zeppelin Checkbox
			
			} else if( this.lastSelectedSubType == Pilot.SUBTYPE_BOMBARDIER ) {
				this.form.rbtnCanLevelUp.setSelected(true);
				this.form.rbtnCanLevelUp.setActive(false);
				
				this.intTotalEP = Pilot.BASE_EP_BOMBARDIER;
				this.intCurrentEP = Pilot.BASE_EP_BOMBARDIER;
				this.form.txtStartEP.text = String(Pilot.BASE_EP_BOMBARDIER);
				
			} else if( this.lastSelectedSubType == Pilot.SUBTYPE_CREWCHIEF ) {
				this.form.rbtnCanLevelUp.setSelected(true);
				this.form.rbtnCanLevelUp.setActive(false);
				
				this.intTotalEP = Pilot.BASE_EP_CREWCHIEF;
				this.intCurrentEP = Pilot.BASE_EP_CREWCHIEF;
				this.form.txtStartEP.text = String(Pilot.BASE_EP_CREWCHIEF);
				
			} else if( this.lastSelectedSubType == Pilot.SUBTYPE_LOADMASTER ) {
				this.form.rbtnCanLevelUp.setSelected(true);
				this.form.rbtnCanLevelUp.setActive(false);
				
				this.intTotalEP = Pilot.BASE_EP_LOADMASTER;
				this.intCurrentEP = Pilot.BASE_EP_LOADMASTER;
				this.form.txtStartEP.text = String(Pilot.BASE_EP_LOADMASTER);
				
			} else if( this.lastSelectedSubType == Pilot.SUBTYPE_COPILOT ) {
				// there are 2 types of co-pilots 
				// the one from cargos/bombes who can level
				// and the other from heavy fighters who is linked to 
				// its pilot
				this.form.rbtnCanLevelUp.setSelected(true);
				this.form.rbtnCanLevelUp.setActive(true);
				
				this.intTotalEP = Pilot.BASE_EP_COPILOT;
				this.intCurrentEP = Pilot.BASE_EP_COPILOT;
				this.form.txtStartEP.text = String(Pilot.BASE_EP_COPILOT);
				
			} else if( this.lastSelectedSubType == Pilot.SUBTYPE_GUNNER ) {
				// same is with gunners the nose gunner of a bomber
				// can level but all other gunners cannot level
				this.form.rbtnCanLevelUp.setSelected(true);
				this.form.rbtnCanLevelUp.setActive(true);	
				
				this.intTotalEP = Pilot.BASE_EP_GUNNER;
				this.intCurrentEP = Pilot.BASE_EP_GUNNER;
				this.form.txtStartEP.text = String(Pilot.BASE_EP_GUNNER);
			}
			
			this.form.myStatsBar.init(this);
			this.form.myFeatBox.init(this);
			this.form.myLanguageBox.init(this);			
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * prepareImageLoader
		 * ---------------------------------------------------------------------
		 * if you prepare more than one image you have to wait until the
		 * loading chain is complete. then call this.imgLoader.load();
		 *
		 * @param l
		 */
		private function prepareImageLoader(l:ImageLoader):void
		{
			l.addEventListener(
					Event.COMPLETE, 
					imageLoadedHandler
				);
				
			if( this.imgLoader != null )
				l.addNext(this.imgLoader);

			this.imgLoader = l;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * prepareFoto
		 * ---------------------------------------------------------------------
		 */
		private function prepareFoto():void
		{
			//clean container
			while( this.form.movContainerFoto.numChildren > 0 ) 
				this.form.movContainerFoto.removeChildAt(0);

			if( this.srcFoto != "" ) 
				this.prepareImageLoader( 
						new ImageLoader( 
								mdm.Application.path
									+ Globals.PATH_IMAGES
									+ Globals.PATH_PILOT
									+ this.srcFoto,
								"FotoLoader"
							)
					);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * prepareFlag
		 * ---------------------------------------------------------------------
		 */
		private function prepareFlag():void
		{
			//clean container
			while( this.form.movContainerFlagNation.numChildren > 0 ) 
				this.form.movContainerFlagNation.removeChildAt(0);
			
			if( this.srcFlag != "" ) 
				this.prepareImageLoader( 
						new ImageLoader( 
								mdm.Application.path
									+ Globals.PATH_IMAGES
									+ Globals.PATH_NATION
									+ this.srcFlag, 
								"FlagLoader"
							)
					);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * prepareSquadLogo
		 * ---------------------------------------------------------------------
		 */
		private function prepareSquadLogo():void
		{
			//clean container
			while( this.form.movContainerFlagSquad.numChildren > 0 )
				this.form.movContainerFlagSquad.removeChildAt(0);
			
			if( this.srcSquadLogo != "" ) 
				this.prepareImageLoader( 
						new ImageLoader( 
								mdm.Application.path
									+ Globals.PATH_IMAGES
									+ Globals.PATH_SQUADRON
									+ this.srcSquadLogo, 
								"SquadLoader"
							)
					);
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * clickAddEPHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickAddEPHandler(e:MouseEvent):void
		{
			if( !this.form.btnAddEP.getIsActive() ) 
				return;
				
			Globals.myToolbarBottom.updateEPInfosFromPilot(
					this, 
					this.intMissionCount, 
					this.form.myStatsBar.numStepCO.getValue()
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * changeSquadHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function changeSquadHandler(e:MouseEvent):void
		{
			var filename:String = this.form.pdSquadron.getIDForCurrentSelection();
			
			if( this.lastSelectedSquadron == filename ) 
				return;
				
			if( filename == CSPullDown.ID_EMPTYSELECTION ) 
			{
				this.lastSelectedSquadron = "";
				this.srcSquadLogo = "";
			} else {
				var squad:Squadron = new Squadron();
				squad.loadFile(
						mdm.Application.path
							+ filename
					);
				
				if( squad.getSrcLogo() != "" 
						&& squad.getSrcLogo() != null ) 
				{
					this.srcSquadLogo = squad.getSrcLogo();
				} else {
					this.srcSquadLogo = "";
				}
				this.lastSelectedSquadron = filename;
			}
			this.prepareSquadLogo();
			if( this.imgLoader != null )
				this.imgLoader.load();
				
			this.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * typeChangedHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function typeChangedHandler(e:MouseEvent):void
		{
			var pd:CSPullDown = CSPullDown(e.currentTarget);
			if( !pd.getIsActive() )
				return;
			
			if( pd == this.form.pdType )
			{
				if( lastSelectedType == pd.getIDForCurrentSelection() )
					return;
				this.lastSelectedType =  pd.getIDForCurrentSelection();
				this.updateGUIByType();
				// update subtyp as well
				this.lastSelectedSubType =  pd.getIDForCurrentSelection();
			}
			if( pd == this.form.pdSubType )
			{
				if( lastSelectedSubType == pd.getIDForCurrentSelection() )
					return;
					
				this.lastSelectedSubType =  pd.getIDForCurrentSelection();
			}
			this.updateGUIBySubType();
				
			this.form.myStatsBar.calcEP();
			this.calcEP();
				
			this.validateForm();
			this.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * canLevelHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function canLevelHandler(e:MouseEvent):void
		{
			this.form.btnAddEP.setActive(
					this.form.rbtnCanLevelUp.getIsSelected()
				);
			
			this.form.pdLinkedTo.clearSelection();	
			this.form.pdLinkedTo.setActive(
					!this.form.rbtnCanLevelUp.getIsSelected()
				);
				
			if( this.lastSelectedSubType == Pilot.SUBTYPE_COPILOT )
			{
				if( this.form.rbtnCanLevelUp.getIsSelected() )
				{	
					this.intTotalEP = Pilot.BASE_EP_COPILOT;
					this.intCurrentEP = Pilot.BASE_EP_COPILOT;
					this.form.txtStartEP.text = String(Pilot.BASE_EP_COPILOT);
				} else {
					this.intTotalEP = Pilot.BASE_EP_OTHER;
					this.intCurrentEP = Pilot.BASE_EP_OTHER;
					this.form.txtStartEP.text = String(Pilot.BASE_EP_OTHER);
				}
				
			} else if( this.lastSelectedSubType == Pilot.SUBTYPE_GUNNER ) {
				if( this.form.rbtnCanLevelUp.getIsSelected() )
				{	
					this.intTotalEP = Pilot.BASE_EP_GUNNER;
					this.intCurrentEP = Pilot.BASE_EP_GUNNER;
					this.form.txtStartEP.text = String(Pilot.BASE_EP_GUNNER);
				} else {
					this.intTotalEP = Pilot.BASE_EP_OTHER;
					this.intCurrentEP = Pilot.BASE_EP_OTHER;
					this.form.txtStartEP.text = String(Pilot.BASE_EP_OTHER);
				}
			}
			
			this.calcEP();
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * importCadetHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function importCadetHandler(e:MouseEvent):void
		{
			// abort import if window contains unsaved data 
			// and the user wants to discard it.
			if( !this.getIsSaved() )
				if( !CSDialogs.changesNotSaved() )
					return;
			
			var file:String = AbstractCadetImporter.selectImportCadetFile(
					"Pilot",
					"cdp"
				);
				
			if( file == "false" )
				return;
				
			var loader:BinaryLoader = new BinaryLoader(file);
			loader.addEventListener(
					Event.COMPLETE, 
					cadetLoadedHandler
				); 
			loader.load();	
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * cadetLoadedHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function cadetLoadedHandler(e:Event):void
		{
			var loader:BinaryLoader = BinaryLoader(e.currentTarget);
			var importer:PilotImporter = new PilotImporter(loader.getBytes());
			
			if ( !importer.parseBytes() )
			{
				AbstractCadetImporter.invalidFile(loader.getFilename());
				return;
			}
			this.fileWasUpdated = false;
			this.initFromPilot(importer.getPilot());
			// every import is unsaved.
			this.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * changeNationHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function changeNationHandler(e:MouseEvent):void
		{
			var id:String = this.form.pdNation.getIDForCurrentSelection();
						
			if( this.lastSelectedNation == id )
				return;
			
			if( this.lastSelectedNation != "" 
					&& this.lastSelectedNation != null )
			{
				this.form.myLanguageBox.removeLanguageItem(
						Globals.myBaseData.getCountry(
								this.lastSelectedNation
							).languageID
					);
				this.myObject.deleteMotherTongue();
			}
				
			if (id == CSPullDown.ID_EMPTYSELECTION) 
			{
				this.lastSelectedNation = "";
				this.srcFlag = "";
			} else {
				var selCountry:Country = Globals.myBaseData.getCountry(id);
				var mother:Language = Globals.myBaseData.getLanguage(
						selCountry.languageID
					);
				if (selCountry.srcFlag != "" && selCountry.srcFlag != null) {
					this.srcFlag = selCountry.srcFlag;
				} else {
					this.srcFlag = "";
				}

				if( selCountry.languageID != "" ) 
				{
					this.myObject.setMotherTongue(
							new LearnedLanguage(selCountry.languageID, true) 
						);
					this.form.myLanguageBox.createLanguageItem(
							selCountry.languageID,
							mother.myName + " (M)",
							false,
							true
						);
				}
				this.lastSelectedNation = id;
			}
			this.prepareFlag();
			if( this.imgLoader != null )
				this.imgLoader.load();
				
			this.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clickFotoButtonHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function clickFotoButtonHandler(e:MouseEvent):void
		{
			var selectedFile:String = CSDialogs.selectImportImage("Pilot Foto");
			
			if( selectedFile == "false" ) 
				return;
				
			var srcDir = selectedFile.substring(
					0,
					selectedFile.lastIndexOf("\\")
				);
			var filename = selectedFile.substring(
					selectedFile.lastIndexOf("\\") + 1,
					selectedFile.length
				);
			
			var destDir = mdm.Application.path 
					+ Globals.PATH_IMAGES
					+ Globals.PATH_PILOT;
			var destFile = destDir + filename;
			
			if( Console.isConsoleAvailable() )
			{
				if( DebugLevel.check(DebugLevel.DEBUG) )
				{									   
					Console.getInstance().writeln(
							"Importing Pilot Foto:",
							DebugLevel.INFO
						);
					Console.getInstance().writeln(
							"selectedFile: " +selectedFile,
							DebugLevel.DEBUG
						);
					Console.getInstance().writeln(
							"srDir: " +srcDir,
							DebugLevel.DEBUG
						);
					Console.getInstance().writeln(
							"filename: " +filename,
							DebugLevel.DEBUG
						);
					Console.getInstance().writeln(
							"destDir: " +destDir,
							DebugLevel.DEBUG
						);
				}
			}
			Globals.lastSelectedImportDir = srcDir;
			
			if( !CSDialogs.fileExitsNotOrOverwrite(destFile) )  
				return;
			
			//final fail save to prevent deadlock
			if( selectedFile == destFile )
				return;
			
			mdm.FileSystem.copyFile(selectedFile, destFile);
			this.srcFoto = filename;
			
			this.prepareFoto();
			if( this.imgLoader != null )
				this.imgLoader.load();
							
			this.setSaved(false);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * imageLoadedHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function imageLoadedHandler(e:Event):void
		{
			var current:ImageLoader = ImageLoader(e.currentTarget);
			var bmp:Bitmap = current.getImage();
			bmp.smoothing = true;

			if( current.getName() == "FotoLoader" )
			{
				bmp = BitmapHelper.resizeBitmap(
						bmp, 
						FOTO_WIDTH, 
						FOTO_HEIGHT, 
						true
					);
				this.form.movContainerFoto.addChild(bmp);
				
			} else if( current.getName() == "FlagLoader" ) {
				bmp = BitmapHelper.resizeBitmap(
						bmp, 
						FLAG_WIDTH, 
						FLAG_HEIGHT, 
						false
					);
				this.form.movContainerFlagNation.addChild(bmp);
				
			} else if( current.getName() == "SquadLoader" ) {
				bmp = BitmapHelper.resizeBitmap(
						bmp, 
						SQUADLOGO_WIDTH, 
						SQUADLOGO_HEIGHT, 
						false
					);
				this.form.movContainerFlagSquad.addChild(bmp);
			}
			var nl:ImageLoader = ImageLoader( current.getNext() );
			current.dispose();
			imgLoader = null;
			
			if( nl == null )
				return;
			
			nl.load();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * startEPInputHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function startEPInputHandler(e:TextEvent):void
		{
			var numExp:RegExp = /[0-9]/;
            // default handling gets the new digit after
			// updateNewEp was called so we need to handle 
			// the complete input by our selfs.
			e.preventDefault();  

			var targetField:TextField = (e.target as TextField);
			
			if( !numExp.test(e.text) )
				return;
				
			if( targetField.text.length >= 3 )
			{
				targetField.text = targetField.text.substring(0,3); 
				return;
			}
			if( targetField.text == "0" )
			{
				targetField.text = e.text;
			} else {
				var lastcaret:int = targetField.caretIndex;
				var txtlen:int = targetField.text.length;
				var beforeCaret:String = targetField.text.substring(0,lastcaret);
				var afterCaret:String = targetField.text.substring(lastcaret,txtlen);
				
				targetField.text = beforeCaret + e.text + afterCaret;
				targetField.setSelection(lastcaret+1,lastcaret+1);
			}
			
			this.intTotalEP = int(targetField.text);
			this.intCurrentEP = this.intTotalEP;
			this.calcEP();
			this.validateForm();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * startEPFocusHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function startEPFocusHandler(e:FocusEvent):void
		{
			this.intTotalEP = int((e.target as TextField).text);
			this.intCurrentEP = this.intTotalEP;
			this.calcEP();
			this.validateForm();
		}

	}
}