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
		private var xURLs:XMLList;
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
			var url = xModules.(sName == name).sURL;
			oModuleLoader.add(url);
		}
		private function onConfiguration(event:Event):void
		{
			oXML = XML(oLoader.data);
			xModules = oXML.modules;
			xURLs = oXML.urls;
			
			trace("geturl: "+getURL("main","home"));
			
			oPopupManager = new PopupManager(mcRoot, this,oXML.popups,stage);
			oPopupManager.show("login");
		}
		
		function onModuleError(event:IOErrorEvent)
		{
			trace("Error loading : "+event);
		}
		
		function onModuleLoaded(event:LoadEvent)
		{
			var oModule:Module= Module(event.loaderTarget.content);
			
			switch(oModule.sName)
			{
				case "Header":
					mcRoot.addChild(oModule);
				break;
				case "Footer":
					Module(oModule).y = 250;	
					mcRoot.addChild(oModule);	
				break;
				default:
					mcRoot.addChild(oModule);
				break;
			}
			
			oModule.start(this);
			
		}
		
		function ioErrorHandler(event:IOErrorEvent)
		{
			trace("ioErrorHandler: " + event.text);
			
		}
		function onStageChange(oEvent:Event) {
			oPopupManager.update();
		}
		
		public function getURL(name:String,section:String=null)
		{
			if (section == null)
			{
				return xURLs[name];
			}
			else
			{
				return xURLs[section][name];
			}
		}
	}
}