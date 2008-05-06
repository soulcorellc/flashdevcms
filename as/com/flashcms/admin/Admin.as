package com.flashcms.admin {
	import com.flashcms.core.Module;
	import com.flashcms.utils.XMLLoader;
	import fl.controls.DataGrid;
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
		public function Admin() {
			super("Admin");
		}
		public override function init()
		{
			new XMLLoader(oShell.getURL("main", "users"), onXMLData,onError);
		}
		private function onXMLData(event:Event)
		{
			var myDP:DataProvider = new DataProvider(XML(event.target.data));
			dgMain.dataProvider = myDP;
			dgMain.getColumnAt(1).width= 300;
			dgMain.getColumnAt(2).cellRenderer = ButtonRenderer;
			dgMain.getColumnAt(3).cellRenderer = ButtonRenderer;
			dgMain.getColumnAt(0).visible = false;
		}
		private function onError(event:IOErrorEvent)
		{
			trace("ioErrorHandler: " + event.text);
		}
		
	}
	
}