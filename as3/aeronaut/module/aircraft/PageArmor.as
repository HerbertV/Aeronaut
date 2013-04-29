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
 * @version: 1.1.0
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2009-2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.module.aircraft
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.CSFormatter;
	import as3.aeronaut.gui.*;
	
	import as3.aeronaut.module.CSWindowAircraft;
	import as3.aeronaut.module.ICSValidate;
	
	import as3.aeronaut.objects.Aircraft;	
	import as3.aeronaut.objects.aircraftConfigs.FrameDefinition;	
	
	/**
	 * =========================================================================
	 * Class PageArmor
	 * =========================================================================
	 * Aircraft Window Page 3 Armor 
	 */
	public class PageArmor
			extends AbstractPage 
			implements ICSValidate
	{
		// =====================================================================
		// Variables
		// =====================================================================
		private var winAircraft:CSWindowAircraft = null;
		private var isValid:Boolean = true;
		
		private var intCost:int = 0;
		private var intWeight:int = 0;
		
		private var intUnspendArmor:int = 0;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 */
		public function PageArmor()
		{
			super();
			
			this.numStepArmorComplete.setupSteps(0, 1000, 0, 10);
			
			this.numStepArmorNose.setupSteps(0, 100, 0, 10);
			this.numStepArmorPWL.setupSteps(0, 100, 0, 10);
			this.numStepArmorPWT.setupSteps(0, 100, 0, 10);
			this.numStepArmorPB.setupSteps(0, 100, 0, 10);
			this.numStepArmorPS.setupSteps(0, 100, 0, 10);
			this.numStepArmorSWL.setupSteps(0, 100, 0, 10);
			this.numStepArmorSWT.setupSteps(0, 100, 0, 10);
			this.numStepArmorSB.setupSteps(0, 100, 0, 10);
			this.numStepArmorSS.setupSteps(0, 100, 0, 10);
			this.numStepArmorTail.setupSteps(0, 100, 0, 10);
			
			this.numStepArmorComplete.setValueChangedCallback(
					armorChangedHandler
				);
			this.numStepArmorNose.setValueChangedCallback(
					armorChangedHandler
				);
			this.numStepArmorPWL.setValueChangedCallback(
					armorChangedHandler
				);
			this.numStepArmorPWT.setValueChangedCallback(
					armorChangedHandler
				);
			this.numStepArmorPB.setValueChangedCallback(
					armorChangedHandler
				);
			this.numStepArmorPS.setValueChangedCallback(
					armorChangedHandler
				);
			this.numStepArmorSWL.setValueChangedCallback(
					armorChangedHandler
				);
			this.numStepArmorSWT.setValueChangedCallback(
					armorChangedHandler
				);
			this.numStepArmorSB.setValueChangedCallback(
					armorChangedHandler
				);
			this.numStepArmorSS.setValueChangedCallback(
					armorChangedHandler
				);
			this.numStepArmorTail.setValueChangedCallback(
					armorChangedHandler
				);
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * init
		 * ---------------------------------------------------------------------
		 * this is called every time the aircraft changes (loading, new) 
		 *
		 * @param win
		 */
		public function init(win:CSWindowAircraft):void
		{
			this.winAircraft = win;
			var obj:Aircraft = Aircraft(this.winAircraft.getObject());
			var frameDef:FrameDefinition = this.winAircraft.getFrameDefinition();
			
			
			this.numStepArmorPWL.setActive(true);
			this.numStepArmorPWL.BG_white.alpha = 1.0;
			this.numStepArmorPWT.setActive(true);
			this.numStepArmorPWT.BG_white.alpha = 1.0;
			this.numStepArmorPB.setActive(true);
			this.numStepArmorPB.BG_white.alpha = 1.0;
			this.numStepArmorPS.setActive(true);
			this.numStepArmorPS.BG_white.alpha = 1.0;
			this.numStepArmorSWL.setActive(true);
			this.numStepArmorSWL.BG_white.alpha = 1.0;
			this.numStepArmorSWT.setActive(true);
			this.numStepArmorSWT.BG_white.alpha = 1.0;
			this.numStepArmorSB.setActive(true);
			this.numStepArmorSB.BG_white.alpha = 1.0;
			this.numStepArmorSS.setActive(true);
			this.numStepArmorSS.BG_white.alpha = 1.0;
	
	
			if( !frameDef.hasBows )
			{
				this.numStepArmorPB.setActive(false);
				this.numStepArmorPB.BG_white.alpha = 0.3;
				this.numStepArmorPB.setValue(0);
				this.numStepArmorPS.setActive(false);
				this.numStepArmorPS.BG_white.alpha = 0.3;
				this.numStepArmorPS.setValue(0);
				this.numStepArmorSB.setActive(false);
				this.numStepArmorSB.BG_white.alpha = 0.3;
				this.numStepArmorSB.setValue(0);
				this.numStepArmorSS.setActive(false);
				this.numStepArmorSS.BG_white.alpha = 0.3;
				this.numStepArmorSS.setValue(0);
			}
			
			if( !frameDef.hasWings )
			{
				this.numStepArmorPWL.setActive(false);
				this.numStepArmorPWL.BG_white.alpha = 0.3;
				this.numStepArmorPWL.setValue(0);
				this.numStepArmorPWT.setActive(false);
				this.numStepArmorPWT.BG_white.alpha = 0.3;
				this.numStepArmorPWT.setValue(0);
				this.numStepArmorSWL.setActive(false);
				this.numStepArmorSWL.BG_white.alpha = 0.3;
				this.numStepArmorSWL.setValue(0);
				this.numStepArmorSWT.setActive(false);
				this.numStepArmorSWT.BG_white.alpha = 0.3;
				this.numStepArmorSWT.setValue(0);
			}

			var completeA:int = obj.getArmorSWT() 
					+ obj.getArmorPB() 
					+ obj.getArmorPS() 
					+ obj.getArmorSB() 
					+ obj.getArmorSS() 
					+ obj.getArmorTail() 
					+ obj.getArmorPWT() 
					+ obj.getArmorSWL() 
					+ obj.getArmorNose() 
					+ obj.getArmorPWL();
			this.numStepArmorComplete.setValue(completeA);
			
			this.numStepArmorNose.setValue(obj.getArmorNose());
			this.numStepArmorPWL.setValue(obj.getArmorPWL());
			this.numStepArmorPWT.setValue(obj.getArmorPWT());
			this.numStepArmorPB.setValue(obj.getArmorPB());
			this.numStepArmorPS.setValue(obj.getArmorPS());
			this.numStepArmorSWL.setValue(obj.getArmorSWL());
			this.numStepArmorSWT.setValue(obj.getArmorSWT());
			this.numStepArmorSB.setValue(obj.getArmorSB());
			this.numStepArmorSS.setValue(obj.getArmorSS());
			this.numStepArmorTail.setValue(obj.getArmorTail());
			
			this.recalc();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 */
		public function dispose():void
		{
			
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * validateForm
		 * ---------------------------------------------------------------------
		 */
		public function validateForm():void
		{
			if( this.intUnspendArmor < 0 ) 
			{
				this.lblUnspentArmor.textColor = 0xFF0000;
				this.setValid(false);
			} else {
				this.lblUnspentArmor.textColor = 0xFFFFFF;
				this.setValid(true);
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * validateForm
		 * ---------------------------------------------------------------------
		 * @param v
		 */
		public function setValid(v:Boolean):void 
		{
			this.isValid = v;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * validateForm
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getIsValid():Boolean 
		{
			return this.isValid;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateObjectFromWindow
		 * ---------------------------------------------------------------------
		 * called by updateObjectFromWindow function from our window.
		 * transfers the changed values into the object.
		 *
		 * @return
		 */
		public function updateObjectFromWindow():Aircraft
		{
			var obj:Aircraft = Aircraft(this.winAircraft.getObject());
			
			obj.setArmorNose(this.numStepArmorNose.getValue());
			obj.setArmorPWL(this.numStepArmorPWL.getValue());
			obj.setArmorPWT(this.numStepArmorPWT.getValue());
			obj.setArmorPB(this.numStepArmorPB.getValue());
			obj.setArmorPS(this.numStepArmorPS.getValue());
			obj.setArmorSWL(this.numStepArmorSWL.getValue());
			obj.setArmorSWT(this.numStepArmorSWT.getValue());
			obj.setArmorSB(this.numStepArmorSB.getValue());
			obj.setArmorSS(this.numStepArmorSS.getValue());
			obj.setArmorTail(this.numStepArmorTail.getValue());
			
			return obj;
		
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getCost
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getCost():int
		{
			return this.intCost;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getWeight
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getWeight():int
		{
			return this.intWeight;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * recalc
		 * ---------------------------------------------------------------------
		 * recalcs the weight and costs
		 */
		public function recalc():void
		{
			this.intUnspendArmor = this.numStepArmorComplete.getValue()
					- this.numStepArmorNose.getValue()
					- this.numStepArmorPWL.getValue()
					- this.numStepArmorPWT.getValue()
					- this.numStepArmorPB.getValue()
					- this.numStepArmorPS.getValue()
					- this.numStepArmorSWL.getValue()
					- this.numStepArmorSWT.getValue()
					- this.numStepArmorSB.getValue()
					- this.numStepArmorSS.getValue()
					- this.numStepArmorTail.getValue();
			
			this.lblUnspentArmor.text = String(this.intUnspendArmor);
			
			this.validateForm();
			
			var frame:String = CSWindowAircraft(this.winAircraft).getFrameType();
			if( frame == FrameDefinition.FT_HEAVY_BOMBER
					|| frame == FrameDefinition.FT_HEAVY_CARGO
					|| frame == FrameDefinition.FT_LIGHT_BOMBER
					|| frame == FrameDefinition.FT_LIGHT_CARGO
				)
			{
				// Weight and cost for bombers/cargos
				this.intWeight = this.numStepArmorComplete.getValue() * 10;
				this.intCost = int(this.numStepArmorComplete.getValue() * 5);
			} else {
				// Weight and cost for normal aircrafts
				this.intWeight = this.numStepArmorComplete.getValue() * 3;
				this.intCost = int(this.numStepArmorComplete.getValue() * 2.5 );
			}
			// mod cost
			this.intCost += int( this.winAircraft.form.page1.getArmorCostMod() 
					* this.intCost 
				);
			this.winAircraft.form.lblCostArmor.text = 
					CSFormatter.formatDollar(this.intCost);
			
			this.lblArmorWeight.text =  CSFormatter.formatLbs(this.intWeight);
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * armorChangedHandler
		 * ---------------------------------------------------------------------
		 * @param e  
		 */
		private function armorChangedHandler(e:NumStepperValueChangedEvent):void
		{
			this.recalc();
			
			this.winAircraft.calcFreeWeight();
			this.winAircraft.calcCompleteCost();
			this.winAircraft.setSaved(false);
		}
		
	}
}