package com.flashcms.admin {
	import com.flashcms.core.Module;
	import com.flashcms.events.ErrorEvent;
	import com.flashcms.utils.XMLLoader;
	import fl.controls.DataGrid;
	import fl.events.ListEvent;
	import fl.controls.dataGridClasses.DataGridColumn;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import fl.data.DataProvider;
	import com.flashcms.cellrender.ButtonRenderer;
	/**
	* ...
	* @author Default
	*/
	public class Admin extends Module{
		public var dgMain:DataGrid;
		public var tableName:String = "user";
		public var xmlData:XML;
	
		public function Admin() {
			super("Admin");
		}
		/**
		 * 
		 */
		public override function init()
		{
			new XMLLoader(oShell.getURL("main", "users"), onXMLData,onDataError,onError);
		}
		/**
		 * 
		 * 
		 * 
		 * @param	event
		 */
		private function onXMLData(event:Event)
		{
			xmlData = XML(event.target.data);
			var myDP:DataProvider = new DataProvider(<data>{xmlData[tableName]}</data>);
			
			var col1:DataGridColumn = new DataGridColumn("name");
			col1.headerText = "Name";
			col1.width = 300;
			
			var col2:DataGridColumn = new DataGridColumn("edit");
			col2.headerText = "";
			col2.cellRenderer = ButtonRenderer;
			
			var col3:DataGridColumn = new DataGridColumn("delete");
			col3.headerText= "";
			col3.cellRenderer = ButtonRenderer;
			
			dgMain.addColumn(col1);
			dgMain.addColumn(col2);
			dgMain.addColumn(col3);
			
			dgMain.dataProvider = myDP;
			dgMain.addEventListener(ListEvent.ITEM_CLICK , onClickItem);
			
		}
		/**
		 * 
		 * @param	e
		 */
		private function onDataError(e:ErrorEvent)
		{
			trace("Admin Error : " + e.message);
		}
		/**
		 * 
		 * 
		 * 
		 * @param	event
		 */
		private function onClickItem(event:ListEvent)
		{
			switch(event.columnIndex)
			{
				case 1:
					oShell.showPopup("edit",{name:tableName,data:xmlData});
				break;
				case 2:
					trace("2 "+event.item.id);
				break;
			}
		}
		/**
		 * 
		 * 
		 * 
		 * @param	event
		 */
		private function onError(event:IOErrorEvent)
		{
			trace("ioErrorHandler: " + event.text);
		}
		
	}
	
}