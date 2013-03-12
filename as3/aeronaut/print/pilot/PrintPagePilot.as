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
package as3.aeronaut.print.pilot
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.text.TextField;
	
	import as3.aeronaut.print.CSAbstractPrintPage;
	import as3.aeronaut.print.ICSPrintPagePilot;
	import as3.aeronaut.print.SheetPilot;
	
	import as3.aeronaut.objects.Pilot;
	import as3.aeronaut.objects.Squadron;
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.baseData.Feat;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.CSFormatter;
	
	import as3.hv.core.utils.BitmapHelper;
	
	
	/**
	 * =========================================================================
	 * Class PrintPagePilot
	 * =========================================================================
	 * Library Symbol linked class for Pilot Page 
	 */
	public class PrintPagePilot
			extends CSAbstractPrintPage
			implements ICSPrintPagePilot
	{
		// =====================================================================
		// Variables
		// =====================================================================
		private var myObject:Pilot;
		
		/**
		 * =====================================================================
		 * Contructor
		 * =====================================================================
		 */
		public function PrintPagePilot()
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromObject
		 * ---------------------------------------------------------------------
		 * @see ICSPrintPage
		 *
		 * @param obj
		 */
		public function initFromObject(obj:ICSBaseObject):void
		{
			this.initFromPilot(Pilot(obj));
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromPilot
		 * ---------------------------------------------------------------------
		 * @see ICSPrintPagePilot
		 *
		 * @param obj
		 */
		public function initFromPilot(obj:Pilot):void
		{
			super.init();
			this.myObject = obj;
			
			this.lblPilotName.text = obj.getName();
			var squad:Squadron =  SheetPilot(this.mySheet).getSquadron();
			if( squad != null )
			{
				this.lblSquadName.text = squad.getName();
				if( SheetPilot(this.mySheet).getSquadLogo() != null )
				{
					var logo:Bitmap = SheetPilot(this.mySheet).getSquadLogo();
					logo = BitmapHelper.resizeBitmap(
							logo, 
							SheetPilot.SQUADLOGO_WIDTH, 
							SheetPilot.SQUADLOGO_HEIGHT, 
							false
						);
					
					logo.x -= logo.width/2;
					logo.y -= logo.height/2;
					this.movPrintLogoContainer.addChild(logo);
				}
			} else {
				this.lblSquadName.text = "";
			}
			
			this.lblNationality.text = Globals.myBaseData.getCountry(obj.getCountryID()).myName;
			
			if( SheetPilot(this.mySheet).getFlag() != null )
			{
				var flag:Bitmap = SheetPilot(this.mySheet).getFlag();
				flag = BitmapHelper.resizeBitmap(
						flag, 
						SheetPilot.FLAG_WIDTH, 
						SheetPilot.FLAG_HEIGHT, 
						false
					);
				flag.x -= flag.width/2;
				flag.y -= flag.height/2;
				this.movPrintFlagContainer.addChild(flag);
			}
			
			if( SheetPilot(this.mySheet).getFoto() != null )
			{
				var foto:Bitmap = SheetPilot(this.mySheet).getFoto();
				foto = BitmapHelper.resizeBitmap(
						foto, 
						SheetPilot.FOTO_WIDTH, 
						SheetPilot.FOTO_HEIGHT, 
						true
					);
				this.movPrintFotoContainer.addChild(foto);
			}
				
			if( obj.getType() != Pilot.TYPE_GUNNER ) 
			{
				this.lblNT.htmlText = "<b>"+obj.getNaturalTouch()+"</b>";
				this.lblSS.htmlText = "<b>"+obj.getSixthSense()+"</b>";
				this.lblDE.htmlText = "<b>"+obj.getDeadEye()+"</b>";
				this.lblSH.htmlText = "<b>"+obj.getSteadyHand()+"</b>";
				this.lblCO.htmlText = "<b>"+obj.getConstitution()+"</b>";
				
				var strQD:String = "<b>"+ obj.getQuickDraw()[0];
				if (obj.getQuickDraw()[1] > 0) {
					strQD = strQD + "." + obj.getQuickDraw()[1];
				}
				strQD = strQD + "</b>";
				this.lblQD.htmlText = strQD;
			} else {
// TODO get value from linked to (-1)
				this.lblNT.htmlText = "";
				this.lblSS.htmlText = "";
				this.lblDE.htmlText = "";
				this.lblSH.htmlText = "";
				this.lblCO.htmlText = "";
				this.lblQD.htmlText = "";
			}
			
			if( obj.getType() == Pilot.TYPE_HERO )
			{
				this.lblType.text = "Hero";
			} else if( obj.getType() == Pilot.TYPE_SIDEKICK ) {
				this.lblType.text = "Sidekick";
			} else if( obj.getType() == Pilot.TYPE_GUNNER ) {
				this.lblType.text = "Co-Pilot/Gunner";
			} else if( obj.getType() == Pilot.TYPE_NPC ) {
				this.lblType.text = "NPC";
			}
			
			this.lblGender.text = obj.getGender();
			this.lblHeight.text = CSFormatter.formatFeetInch(
					obj.getHeight()[0],
					obj.getHeight()[1]
				);
			this.lblWeight.text = CSFormatter.formatLbs(obj.getWeight());
			this.lblEyeColor.text = obj.getEyeColor();
			this.lblHairColor.text = obj.getHairColor();
			
			this.lblEquipment.text = obj.getEquipment();
			this.lblDescription.text = obj.getDescription();
			
			if( obj.getType() != Pilot.TYPE_GUNNER ) 
			{
				this.lblKills.text = String(obj.getKills());
				this.lblMissions.text = String(obj.getMissionCount());
				this.lblCraftsLost.text = String(obj.getCraftLost());
				
				this.lblBailout.text = String(obj.getBailOutBonus());
				
				var i:int = 0;
				var arrLF:Array = obj.getLearnedFeats();
				var feat:Feat = null;
				var strFeats:String = "";
				for( i = 0; i < arrLF.length; i++ ) 
				{
					feat = Globals.myBaseData.getFeat(arrLF[i].myID);
					strFeats += feat.myName;
					if( feat.maxLevel > 0 )
						strFeats += " ["+arrLF[i].currentLevel+"]";
					
					strFeats += "\n";
				}
				this.lblFeats.text = strFeats;
				
				var strLanguages:String = "";
				var arrLL:Array = obj.getLearnedLanguages();
				for( i=0; i< arrLL.length; i++ )
				{
					strLanguages += " - "+Globals.myBaseData.getLanguage(arrLL[i].myID).myName;
					if( arrLL[i].isMotherTongue )
						strLanguages += " (M)";
					
					strLanguages += "\n";
				}
				this.lblLanguages.text = strLanguages;
			
				this.lblTotalXP.text = String(obj.getTotalEP());
				this.lblCurrentXP.text = String(obj.getCurrentEP());
			
			} else {
				this.lblKills.text = "";
				this.lblMissions.text = "";
				this.lblCraftsLost.text = "";
				this.lblFeats.text = "";
				this.lblLanguages.text = "";
				this.lblTotalXP.text = "";
				this.lblCurrentXP.text = "";
			}
		}
		
	}
}