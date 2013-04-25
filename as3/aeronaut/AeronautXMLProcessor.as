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
 * Copyright (c) 2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.aeronaut 
{
	import as3.hv.core.xml.AbstractXMLProcessor;
	import as3.hv.zinc.z3.xml.XMLProcessorRW;
	
	/**
	 * =========================================================================
	 * Class AeronautXMLProcessor
	 * =========================================================================
	 */ 
	public class AeronautXMLProcessor
			extends XMLProcessorRW 
	{
		
		/**
		 * =====================================================================
		 * Contructor
		 * =====================================================================
		 * 
		 * @param loadEventBased
		 */
		public function AeronautXMLProcessor(loadEventBased:Boolean=false) 
		{
			super(loadEventBased);
			
			AbstractXMLProcessor.XMLDOCVERSION = "1.0";
			AbstractXMLProcessor.XMLROOTTAG = "aeronaut";
		}
		
	}

}