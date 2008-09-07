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
	import flash.text.TextField;
	/**
	* ...
	* @author Default
	*/
	public class Picker extends Module{
		private var oBG:DynamicBG;
		private var oXMLLoader:XMLLoader;
		private var oXML:XML;
		public var lbList:List;
		public var btSelect:Button;
		public var btCancel:Button;
		public var txtTitle:TextField;
		public var idfield:String;
		public function Picker() {
			createBG();	
		}
		private function createBG()
		{
			oBG = new DynamicBG(400, new left(), new center(), new right());
			addChildAt(oBG,0);
		}
		public override function init()
		{
			oXMLLoader = new XMLLoader(parameters.url, onDataLoaded)
			txtTitle.text = parameters.title;
			idfield=parameters.idfield;
		}
		private function onDataLoaded(e:Event)
		{
			oXML = XML(e.target.data);
			var myDP:DataProvider = new DataProvider( < data > { oXML[parameters.tableName] }</data>);
			lbList.dataProvider = myDP;
			lbList.labelField = parameters.labelField;
			btSelect.addEventListener(MouseEvent.CLICK, onSelect);
			btCancel.addEventListener(MouseEvent.CLICK, onCancel);
		}
		private function onSelect(e:MouseEvent)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{selected:lbList.selectedItem[idfield]}));
		}
		private function onCancel(e:MouseEvent)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{selected:null}));
		}
	}
	
}