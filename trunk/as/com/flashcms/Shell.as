package com.flashcms{
	//import com.flashcms.header.Header;
	import com.flashcms.data.MultiLoader;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
    import flash.net.URLRequest;
	import com.flashcms.core.PopupManager;
	import com.flashcms.core.Module;
	import com.flashcms.core.TopMenu;
	import flash.display.LoaderInfo;	
	import flash.system.ApplicationDomain;
	import com.flashcms.events.LoadEvent;
public class Shell extends MovieClip {
		private var oXML:XML;
		private var xModules:XMLList;
		private var sConfigurationURL:String;
		private var oRequest:URLRequest;
		private var oLoader:URLLoader;
		private var oModuleLoader:MultiLoader;
		private var oPopupManager:PopupManager;
		private var oTopMenu:TopMenu;
		private var mcRoot:MovieClip;
		public function Shell(){
			super();
			init();
		}
		private function init()
		{
			mcRoot = new MovieClip();
			stage.addChild(mcRoot);
			oXML= new XML();
			sConfigurationURL="./xml/configuration.xml";
			oRequest = new URLRequest(sConfigurationURL);
			oLoader=new URLLoader(oRequest);
			oLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			oLoader.addEventListener(Event.COMPLETE, onConfiguration);
			stage.addEventListener(Event.RESIZE, onStageChange);
			oTopMenu = new TopMenu();
			oModuleLoader = new MultiLoader();
			oModuleLoader.addEventListener(LoadEvent.LOAD_EVENT, onModuleLoaded);
			
			
		}
		public function startApplication()
		{
			loadModule("header");
			loadModule("footer");
			oModuleLoader.start();
		}
		
		private function loadModule(name:String)
		{
			trace("loadModule : " + name);
			
			var url = xModules.(sName == name).sURL;
			oModuleLoader.add(url);
			//oRequest.url = xModules.(sName == name).sURL;
			/*oModuleLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onModuleError);
			oModuleLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onModuleLoaded);
			oModuleLoader.load(oRequest);
			*/
		}
		private function onConfiguration(event:Event):void
		{
			oXML = XML(oLoader.data);
			xModules = oXML.modules;
			oPopupManager = new PopupManager(mcRoot, this,oXML.popups,stage);
			oPopupManager.show("login");
		}
		
		function onModuleError(event:IOErrorEvent)
		{
			trace("Error loading : "+event);
		}
		function onModuleLoaded(event:LoadEvent)
		{
			trace("onModuleLoaded: " + event.loaderTarget);
			//var loaderInfo:LoaderInfo = event.as LoaderInfo;
            //trace(" loaderinfo : "+loaderInfo);
			//event.loaderTarget.
			var oModule= event.loaderTarget.content;
			           
			switch(oModule.sName)
			{
				case "Header":
					mcRoot.addChild(Module(oModule));
				break;
				case "Footer":
					Module(oModule).y = 250;	
					mcRoot.addChild(Module(oModule));	
				break;
				default:
					mcRoot.addChild(Module(oModule));
				break;
			}
			
			
		}
		
		function ioErrorHandler(event:IOErrorEvent)
		{
			trace("ioErrorHandler: " + event.text);
			
		}
		function onStageChange(oEvent:Event) {
			oPopupManager.update();
			
		}
		public function getInfo()
		{
			trace("YOUR INFO");
		}
	}
}