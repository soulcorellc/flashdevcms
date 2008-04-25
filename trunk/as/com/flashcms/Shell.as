package com.flashcms{
	//import com.flashcms.header.Header;
	import com.flashcms.data.MultiLoader;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Stage;
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
	import com.flashcms.layout.StageManager;
	
public class Shell extends MovieClip {
		private var oXML:XML;
		private var xModules:XMLList;
		private var xURLs:XMLList;
		private var sConfigurationURL:String;
		private var oRequest:URLRequest;
		private var oLoader:URLLoader;
		private var oModuleLoader:MultiLoader;
		private var oPopupManager:PopupManager;
		private var mcRoot:MovieClip;
		private var oNavigation:Navigation;
			
		public function Shell(){
			super();
			init();
			
		}
		/**
		 * Initializes class members
		 */
		private function init()
		{
			oXML= new XML();
			sConfigurationURL="./xml/configuration.xml";
			oRequest = new URLRequest(sConfigurationURL);
			oLoader=new URLLoader(oRequest);
			oLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			oLoader.addEventListener(Event.COMPLETE, onConfiguration);
			stage.addEventListener(Event.RESIZE, onStageChange);
			oModuleLoader = new MultiLoader();
			oModuleLoader.addEventListener(LoadEvent.LOAD_EVENT, onModuleLoaded);
			
		}
		/**
		 * 
		 */
		public function startApplication()
		{
			
			//oPopupManager = new PopupManager(mcRoot, this,oXML.popups,stage);
			//oPopupManager.show("login");
			
		}
		/**
		 * 
		 * @param	module name of the module to be loaded
		 * @param	parameters additional parameters to be set on the module
		 */
		public function setModule(module:String,parameters:Object=null)
		{
			switch(module)
			{
			case "/":
				loadModule("header");
				loadModule("footer");
				loadModule("main"); //add parameters to load login if not loaded
			break;
			
			default:
				trace("loading " + module + "parameters : " + parameters);
			break;
			}	
			oModuleLoader.start();
		}
		/**
		 * Add a SWF file to multiloader
		 * @param	name
		 */
		private function loadModule(name:String)
		{
			var url = xModules.(sName == name).sURL;
			oModuleLoader.add(url);
		}
		/**
		 * 
		 * @param	event
		 */
		private function onConfiguration(event:Event):void
		{
			oNavigation = new Navigation(this);
			oXML = XML(oLoader.data);
			xModules = oXML.modules;
			xURLs = oXML.urls;
		}
		/**
		 * 
		 * @param	event
		 */
		function onModuleError(event:IOErrorEvent)
		{
			trace("Error loading : "+event);
		}
		/**
		 * 
		 * @param	event
		 */
		function onModuleLoaded(event:LoadEvent)
		{
			var oModule:Module = Module(event.loaderTarget.content);
			oModule.oShell = this;
			switch(oModule.sName)
			{
				case "Header":
					addChild(oModule);
					addChild(new StageManager(oModule, 0, 0, 0, 0, true));
				break;
				case "Footer":
					addChild(oModule);	
					addChild(new StageManager(oModule, 0, 100, 0, 100, true));
				break;
				case "Main":
					addChild(oModule);
					addChild(new StageManager(oModule, 25, 25, 0, 0, true));
				default:
				
				break;
			}
			oModule.init();	
		}
		/**
		 * 
		 * @param	event
		 */
		function ioErrorHandler(event:IOErrorEvent)
		{
			trace("ioErrorHandler: " + event.text);
			
		}
		/**
		 * 
		 * @param	oEvent
		 */
		function onStageChange(oEvent:Event) {
			//oPopupManager.update();
			
		}
		/**
		 * 
		 * @param	name
		 * @param	section
		 * @return
		 */
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