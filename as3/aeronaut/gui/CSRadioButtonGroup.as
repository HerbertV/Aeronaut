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
package as3.aeronaut.gui
{
	import flash.events.MouseEvent;
	
	// =========================================================================
	// CSRadioButtonGroup
	// =========================================================================
	// for making radio button groups
	public class CSRadioButtonGroup
	{
		// =====================================================================
		// Variables
		// =====================================================================
		private var myMembers:Array = new Array();
		private var myMemberValues:Array = new Array();
		private var currentValue:String = "";
	
		// =====================================================================
		// Contructor
		// =====================================================================
		public function CSRadioButtonGroup()
		{
			
		}
	
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getValue
		 * ---------------------------------------------------------------------
		 * returns the value of the current selected radio button.
		 * or "" if nothing is selected.
		 * @return
		 */
		public function getValue():String 
		{
			return this.currentValue;
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * setValue
		 * ---------------------------------------------------------------------
		 * @param val
		 */
		public function setValue(val:String):void
		{
			var idx:int = this.myMemberValues.indexOf(val);
			
			if( idx == -1 ) 
				return;
			
			for( var i:int=0; i<this.myMembers.length; i++ )
			{
				if( i != idx )
				{
					this.myMembers[i].setSelected(false);
				} else {
					this.myMembers[i].setSelected(true);
					this.currentValue = this.myMemberValues[i];
				}
			}
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * addMember
		 * ---------------------------------------------------------------------
		 * adds a new button to the group.
		 *
		 * @param btn
		 * @param val
		 */
		public function addMember(
				btn:CSRadioButton,
				val:String
			):void
		{
			btn.setGroup(this);
			btn.addEventListener(MouseEvent.MOUSE_DOWN,clickHandler);
			
			this.myMembers.push(btn);
			this.myMemberValues.push(val);
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * clickHandler
		 * ---------------------------------------------------------------------
		 * @param e 
		 */
		private function clickHandler(e:MouseEvent):void
		{
			var currentRBtn:CSRadioButton = CSRadioButton(e.currentTarget);
			
			if( !currentRBtn.getIsActive() )
				return;

			for( var i:int=0; i<this.myMembers.length; i++ ) 
			{
				if (this.myMembers[i] != currentRBtn) 
				{
					this.myMembers[i].setSelected(false);
				} else {
					this.myMembers[i].setSelected(true);
					this.currentValue = this.myMemberValues[i];
				}
			}
		}
	
	}
}