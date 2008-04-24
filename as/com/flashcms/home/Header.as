package com.flashcms.home {
	import com.flashcms.core.Module;
	import com.flashcms.data.MultiLoader;
	import com.flashcms.events.LoadError;
	import com.flashcms.events.LoadEvent;
	import flash.events.Event;
	import com.yahoo.astra.fl.controls.MenuBar;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	/**
	* ...
	* @author Default
	*/
	public class Header extends Module{
		
		public var oXML:XML;
		public var xMenu:XMLList;
		public var oMenu:MenuBar;	
		private var sMainURL:String;
		private var oRequest:URLRequest;
		private var oLoader:URLLoader;
		private var oMultiLoader:MultiLoader;
		public function Header() {
			super("Header");
			
		}
				
		override public function init()
		{
			oMenu = new MenuBar(this);
			oMenu.y = 60;
			sMainURL = this.getURL("main", "home");
			oRequest = new URLRequest(sMainURL);
			oLoader = new URLLoader(oRequest);
			oLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			oLoader.addEventListener(Event.COMPLETE, onMain);
			oMultiLoader = new MultiLoader();
			oMultiLoader.addEventListener(LoadEvent.LOAD_EVENT, onLoadImage);
			oMultiLoader.addEventListener(LoadError.LOAD_ERROR, onError);
			
		}
		private function onError(event:LoadError)
		{
			trace("Error at load::::::::::::: "+event.text);
		}
		private function onLoadImage(event:LoadEvent)
		{
			this.addChild(event.loaderTarget.content);
		}
		private function onMain(event:Event):void
		{
			oXML = XML(oLoader.data);
			oMenu.dataProvider = XML(oXML.menus);
			oMultiLoader.add(oXML.logo);
			oMultiLoader.start();
		}
		
		function ioErrorHandler(event:IOErrorEvent)
		{
			trace("ioErrorHandler: " + event.text);
			
		}
	}
	
}