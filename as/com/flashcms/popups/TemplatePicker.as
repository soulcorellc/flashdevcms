package com.flashcms.popups {
	import com.flashcms.core.Module;
	import com.flashcms.data.XMLLoader;
	import com.flashcms.design.DynamicBG;
	import fl.controls.List;
	import fl.data.DataProvider;
	import flash.events.Event;
	import fl.controls.Button;
	import flash.events.MouseEvent;
	import com.flashcms.events.PopupEvent;
	/**
	* ...
	* @author Default
	*/
	public class TemplatePicker extends Module{
		private var oBG:DynamicBG;
		private var oXMLLoader:XMLLoader;
		private var oXML:XML;
		public var lbList:List;
		public var btSelect:Button;
		public function TemplatePicker() {
			createBG();	
		}
		private function createBG()
		{
			oBG = new DynamicBG(400, new left(), new center(), new right());
			addChildAt(oBG,0);
		}
		public override function init()
		{
			var url = oShell.getURL("main","templates");
			oXMLLoader=new XMLLoader(url,onDataLoaded)
		}
		private function onDataLoaded(e:Event)
		{
			oXML = XML(e.target.data);
			var myDP:DataProvider = new DataProvider(<data>{oXML.templates}</data>);
			lbList.dataProvider = myDP;
			lbList.labelField = "name";
			btSelect.addEventListener(MouseEvent.CLICK, onSelect);
		}
		private function onSelect(e:MouseEvent)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{selected:lbList.selectedItem.id}));
		}
	}
	
}