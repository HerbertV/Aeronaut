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
	import mdm.*;
	
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.text.TextField;
	
	import flash.events.*;
	
	import as3.hv.core.net.ImageLoader;
	import as3.hv.core.utils.BitmapHelper;
		
	import as3.aeronaut.Globals;
	import as3.aeronaut.CSWindowManager;
	import as3.aeronaut.CSDialogs;
	import as3.aeronaut.objects.ICSBaseObject;
	import as3.aeronaut.objects.Squadron;	
	import as3.aeronaut.gui.CSStyle;
	
	// =========================================================================
	// CSWindowSquad
	// =========================================================================
	// This class is a linked document class for "winSquad.swf"
	// @see as3.aeronaut.objects.Squadron
	//
	// Window for crating/editing Squadrons.
	//
	public class CSWindowSquad 
			extends CSWindow 
			implements ICSWindowSquad
	{
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var isSaved:Boolean = true;
		private var myObject:Squadron = null;
		private var myLoader:ImageLoader = null;
		
		// =====================================================================
		// CSWindowSquad
		// =====================================================================
		public function CSWindowSquad()
		{
			super();
			
			// positions
			this.posStartX = 385;
			this.posStartY = -610;
			
			this.posOpenX = 385;
			this.posOpenY = 80;
			
			this.posMinimizedX = 1245;
			
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
			
			this.myLoader = new ImageLoader();
			this.setSaved(true);
			this.setStyle(CSStyle.BLACK);
			
			this.form.btnImportImage.setupTooltip(
					Globals.myTooltip,
					"Import a squadron logo"
				);
			this.form.btnImportImage.addEventListener(
					MouseEvent.MOUSE_DOWN,
					importHandler
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 * @see AbstractModule
		 */
		override public function dispose():void
		{
			this.myLoader.dispose();
			
			while( this.form.movLogoContainer.numChildren > 0 ) 
				this.form.movLogoContainer.removeChildAt(0);
			
			this.form.btnImportImage.removeEventListener(
					MouseEvent.MOUSE_DOWN,
					importHandler
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
			var obj:Squadron = new Squadron();
			obj.loadFile(fn);
			this.initFromSquadron(obj);
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
			this.myObject.saveFile(fn);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initNewObject
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 */
		public function initNewObject():void
		{
			var obj:Squadron = new Squadron();
			obj.createNew();
			this.initFromSquadron(obj);
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
			if( obj is Squadron )
				this.initFromSquadron( Squadron(obj) );
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initFromSquadron
		 * ---------------------------------------------------------------------
		 * @see ICSWindowSquad
		 * @param obj
		 */
		public function initFromSquadron(obj:Squadron):void
		{
			this.setSaved(true);
			
			this.myObject = obj;
			
			this.form.txtName.text = this.myObject.getName();
			this.form.lblLogo.text = this.myObject.getSrcLogo();
			
			this.loadLogo();
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
			this.myObject.setSrcLogo(this.form.lblLogo.text);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateDirLists
		 * ---------------------------------------------------------------------
		 * @see ICSWindow
		 */
		public function updateDirLists():void
		{
			//Not needed 
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
			return "Squadron";
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
			return CSWindowManager.WND_SQUAD;
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
			return Globals.PATH_SQUADRON;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * loadLogo
		 * ---------------------------------------------------------------------
		 */
		private function loadLogo():void
		{
			// remove previous images
			while( this.form.movLogoContainer.numChildren > 0 ) 
				this.form.movLogoContainer.removeChildAt(0);
						
			if( this.form.lblLogo.text == "" )
				return;
			
			myLoader.loadFile(
					mdm.Application.path 
						+ Globals.PATH_IMAGES 
						+ Globals.PATH_SQUADRON 
						+ this.form.lblLogo.text 
				);
			
			myLoader.addEventListener(
					Event.COMPLETE, 
					loadedHandler
				); 
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * importHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function importHandler(e:MouseEvent):void
		{
			var selectedFile = CSDialogs.selectImportImage(this.getTitle());
			
			if( selectedFile == "false" )
				return;
			
			var srcDir = selectedFile.substring(
					0,
					selectedFile.lastIndexOf("\\")
				);
			var filename = selectedFile.substring(
					selectedFile.lastIndexOf("\\")+1,
					selectedFile.length
				);
			var destDir = mdm.Application.path 
					+ Globals.PATH_IMAGES 
					+ Globals.PATH_SQUADRON;
			var destFile = destDir + filename;
				
			Globals.lastSelectedImportDir = srcDir;
				
			var exists:Boolean = mdm.FileSystem.fileExists(destFile);
				
			if( !CSDialogs.fileExitsNotOrOverwrite(destFile) )  
				return;
			
			//final fail save to prevent deadlock
			if( selectedFile == destFile )
				return;
			
			mdm.FileSystem.copyFile(selectedFile, destFile);
			this.form.lblLogo.text = filename;
			this.loadLogo();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * loadedHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function loadedHandler(e:Event):void
		{
			var bmp:Bitmap = this.myLoader.getImage();
			bmp = BitmapHelper.resizeBitmap(bmp, 120, 120, true);
			this.form.movLogoContainer.addChild(bmp);
		}
		
	}
}