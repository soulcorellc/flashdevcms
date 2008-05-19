package com.flashcms.admin {
	import com.flashcms.core.Module;
	import com.flashcms.events.ErrorEvent;
	import com.flashcms.data.XMLLoader;
	import com.flashcms.events.PopupEvent;
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
		public var tableName:String;
		public var xmlData:XML;
	
		public function Admin() {
			super("Admin");
		}
		/**
		 * 
		 */
		public override function init()
		{
			tableName = parameters.section;
			trace("tabla : " + tableName);
			trace("URL : " + oShell.getURL("main", tableName));
			new XMLLoader(oShell.getURL("main", tableName), onXMLData,onDataError,onError);
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
					oShell.showPopup("edit",{name:tableName,data:xmlData},onEdit);
				break;
				case 2:
					oShell.showPopup("confirmation",{message:"Do you want to delete this user?"},onConfirmation);
				break;
			}
		}
		
		private function onEdit(e:PopupEvent)
		{
			trace("edit closed");
		}
		
		private function onConfirmation(e:PopupEvent)
		{
			if (e.parameters.type == "yes")
			{
				trace("DELETING");
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