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
	
	import as3.aeronaut.Globals;
	import as3.aeronaut.XMLProcessor;
		
	import as3.aeronaut.objects.companies.*;
	
	/**
	 * =========================================================================
	 * Companies
	 * =========================================================================
	 * object for companies.ae - read only
	 * and customCompanies.ae - read and write
	 */
	public class Companies
	{
		// =====================================================================
		// Constants
		// =====================================================================
		public static const FILE_VERSION:String = "1.0";
		
		public static const CUSTOM_ID_PREFIX:String = "CC_";
		
		// =====================================================================
		// Variables
		// =====================================================================
		private var ready:Boolean = false;
		private var myXML:XML = new XML();
		
		private var myCustomXML:XML;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 */
		public function Companies()
		{
			var file:String = mdm.Application.path 
					+ Globals.PATH_DATA 
					+ "companies" 
					+ Globals.AE_EXT;
			this.myXML = XMLProcessor.loadXML(file);
			
			if( this.myXML == null ) 
				return;
			
			if( XMLProcessor.checkDoc(this.myXML) == false ) 
				return;
			
			ready = true;
			
			createCustom();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * isReady
		 * ---------------------------------------------------------------------
		 *
		 * @return
		 */
		public function isReady():Boolean
		{
			return ready;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * createCustom
		 * ---------------------------------------------------------------------
		 * creates an empty companies xml
		 */
		public function createCustom():void
		{
			myCustomXML = new XML();
			myCustomXML =
				<aeronaut XMLVersion={XMLProcessor.XMLDOCVERSION}>
					<companies version={FILE_VERSION}>
					</companies>
				</aeronaut>;
		}
		
		// TODO loadCustom
		// TODO saveCustom
		// TODO addCustom
		
		
		/**
		 * ---------------------------------------------------------------------
		 * getCompanies
		 * ---------------------------------------------------------------------
		 * @return company array
		 */
		public function getCompanies():Array
		{
			var arr:Array = new Array();

			if( ready )
			{
				for each( var company:XML in myXML..company ) 
				{
					var coobj:Company = new Company(
							company.@ID, 
							company.shortName.text().toString(),
							company.longName.text().toString()
						);
					arr.push(coobj);
				}
				// TODO add customs
				if( arr.length > 1 )
					arr.sortOn(
							"shortName",
							Array.CASEINSENSITIVE
						);
			}
			return arr;
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * getCompany
		 * ---------------------------------------------------------------------
		 * @param id
		 *
		 * @return company object
		 */
		public function getCompany(id:String):Company
		{
			var obj:Company = null;
			if( ready )
			{
				var xml:XMLList =  myXML..company.(@ID == id);
				// TODO look into custom
				if( xml != null )
				{
					obj = new Company(
							xml.@ID, 
							xml.shortName.text().toString(), 
							xml.longName.text().toString()
						);
				} else {
					if( Console.isConsoleAvailable() )
						Console.getInstance().writeln(
								"Company with ID:"+id+" not found!",
								DebugLevel.ERROR
							);
				}
			}
			return obj;
		}
		
	}
}