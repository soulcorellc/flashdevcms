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
	import com.flashcms.deeplinking.Navigation;
	
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
		private var oNavigation:Navigation;
		
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
			
			//oPopupManager = new PopupManager(mcRoot, this,oXML.popups,stage);
			//oPopupManager.show("login");
			
		}
		public function setModule(module:String,parameters:Object=null)
		{
			switch(module)
			{
			case "/":
				loadModule("header");
				loadModule("footer");
				loadModule("home"); //add parameters to load login if not loaded
			break;
			
			default:
				trace("loading " + module + "parameters : " + parameters);
			break;
			}	
			oModuleLoader.start();
		}
		private function loadModule(name:String)
		{
			var url = xModules.(sName == name).sURL;
			oModuleLoader.add(url);
		}
		private function onConfiguration(event:Event):void
		{
			oNavigation = new Navigation(this);
			oXML = XML(oLoader.data);
			xModules = oXML.modules;
			xURLs = oXML.urls;
		}
		
		function onModuleError(event:IOErrorEvent)
		{
			trace("Error loading : "+event);
		}
		
		function onModuleLoaded(event:LoadEvent)
		{
			var oModule:Module = Module(event.loaderTarget.content);
			oModule.oShell = this;
			switch(oModule.sName)
			{
				case "Header":
					mcRoot.addChild(oModule);
				break;
				case "Footer":
					oModule.y = 250;	
					mcRoot.addChild(oModule);	
				break;
				default:
					mcRoot.addChild(oModule);
				break;
			}
			oModule.init();
		}
		
		function ioErrorHandler(event:IOErrorEvent)
		{
			trace("ioErrorHandler: " + event.text);
			
		}
		
		function onStageChange(oEvent:Event) {
			oPopupManager.update();
		}
		
		public function getURL(name:String,section:String=null):String
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