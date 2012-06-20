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
 * Copyright (c) 2009-2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut.module
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.CSWindowManager;
	import as3.aeronaut.gui.CSStyle;
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.Zeppelin;	
	
	import as3.aeronaut.print.IPrintable;
	
	// =========================================================================
	// CSWindowZeppelin
	// =========================================================================
	// This class is a linked document class for "winZeppelin.swf"
	// @see as3.aeronaut.objects.Zeppelin
	//
	// Window for crating/editing Zeppelin.

// TODO
	public class CSWindowZeppelin 
			extends CSWindow 
			implements ICSWindowZeppelin, ICSValidate, IPrintable
	{
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var isValid:Boolean = true;
		private var isSaved:Boolean = true;
		private var myObject:Zeppelin = null;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function CSWindowZeppelin()
		{
			super();
			
			// positions
			this.posStartX = 120;
			this.posStartY = -690;
			
			this.posOpenX = 120;
			this.posOpenY = 70;
			
			this.posMinimizedX = 1238;
			
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
			this.setStyle(CSStyle.WHITE);
// TODO
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 * @see AbstractModule
		 */
		override public function dispose():void
		{
// TODO
				
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
			var obj:Zeppelin = new Zeppelin();
			obj.loadFile(fn);
			this.initFromZeppelin(obj);
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
			var obj:Zeppelin = new Zeppelin();
			obj.createNew();
			this.initFromZeppelin(obj);
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
			if( obj is Zeppelin )
				this.initFromZeppelin( Zeppelin(obj) );
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromZeppelin
		 * ---------------------------------------------------------------------
		 * @see ICSWindowZeppelin
		 * @param obj
		 */
		public function initFromZeppelin(obj:Zeppelin):void
		{
			this.setValid(true);
			this.setSaved(true);
			
//TODO
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateObjectFromWindow
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 */
		public function updateObjectFromWindow():void
		{
//TODO
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateDirLists
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 */
		public function updateDirLists():void
		{
//TODO
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
			return "Zeppelin";
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
			return CSWindowManager.WND_ZEPPELIN;
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
			return Globals.PATH_ZEPPELIN;
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
/*
TODO
			var printSheet:SheetAircraft = new SheetAircraft();
			printSheet.initFromObject(this.myObject);
			
			// first add outside the visible area 
			// afterwards remove it again
			// otherwise printing does not work
			printSheet.x = -600;
			this.stage.addChild(printSheet);
			printSheet.printNow();
			this.stage.removeChild(printSheet);
			printSheet = null;
*/
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * validateForm
		 * ---------------------------------------------------------------------
		 * @see ICSValidate
		 */
		public function validateForm():void
		{
//TODO
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

	}
}