package com.flashcms.forms {
	
	/**
	* ...
	* @author Default
	*/
	public class FormData {
		public var id:String = "";
		public var table:String;
		public var section:String;
		public var data:XML;
		public var requiredata:Boolean;
		/**
		 * 
		 * @param	table name of the table on returned XML data
		 * @param	section name of the section on configuration.xml
		 * @param	requiredata if the form require schema and data
		 * @param	data additional data
		 */
		public function FormData(table:String,section:String=null,requiredata:Boolean=false,data:XML=null) {
			this.table = table;
			this.section = section;
			this.requiredata = requiredata;
			this.data = data;
			
		}
		
	}
	
}