package com.flashcms {
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
    import flash.net.URLRequest;
	import flash.display.LoaderInfo;	
	import flash.system.ApplicationDomain;
	import com.flashcms.data.MultiLoader;
	import com.flashcms.core.PopupManager;
	import com.flashcms.core.Module;
	import com.flashcms.events.LoadEvent;
	import com.flashcms.deeplinking.Navigation;
	import com.flashcms.layout.StageManager;
	import com.flashcms.core.User;
	import com.flashcms.events.LoginEvent;
	
	
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
		private var oHeader:Module;
		private var oFooter:Module;
		private var oMain:Module;
		private var oUserModule:Module;
		public var xMenu:XMLList;
		public var xMain:XMLList;
		public var sLogo:String;
		private var oUser:User;
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
			oUser = new User();
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
				loadModule("user");
				loadModule("main"); 
				loadModule("footer");
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
			oXML = XML(oLoader.data);
			xModules = oXML.modules;
			xURLs = oXML.urls;
			oLoader.removeEventListener(Event.COMPLETE, onConfiguration);
			oPopupManager = new PopupManager(this, this, oXML.popups, stage);
			oPopupManager.addEventListener(LoginEvent.LOGIN_EVENT, onLogin);
			loadMain();
		}
		private function onLogin(e:LoginEvent)
		{
			oUser.sName = e.sName;
			oUser.bLogged = true;
			oPopupManager.closeAll();
			//start navigation
			oNavigation = new Navigation(this);
		}
		private function loadMain()
		{
			oRequest = new URLRequest(getURL("main", "home"));
			oLoader = new URLLoader(oRequest);
			oLoader.addEventListener(Event.COMPLETE, onMainData);
		}
		private function onMainData(event:Event)
		{
			oXML = new XML();
			oXML = XML(oLoader.data);
			xMenu = oXML.menus;
			xMain = oXML.main;
			sLogo = oXML.logo;
			oPopupManager.show("login");
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
			try{
				
				switch(Module(event.loaderTarget.content).sName)
				{
					case "Header":
						oHeader = Module(event.loaderTarget.content);
						initModule(oHeader);
						addChild(new StageManager(oHeader, 0, 0, 0, 0, true));
					break;
					case "Footer":
						oFooter = Module(event.loaderTarget.content);
						initModule(oFooter);
						addChild(new StageManager(oFooter, 0, 100, 0, 100, true));
					break;
					case "User":
						oUserModule = Module(event.loaderTarget.content);
						initModule(oUserModule);
						addChild(new StageManager(oUserModule, 0, 20, 0, 0, true));
					break;
					default:
						oMain = Module(event.loaderTarget.content);
						initModule(oMain);
						addChild(new StageManager(oMain, 25, 20, 0, 0, true));
					break;
				}
			}
			catch (err:Error)
			{
				trace("Shell Exception : " + err.message);
			}
		}
		/**
		 * 
		 * @param	oModule
		 */
		private function initModule(oModule:Module)
		{
			oModule.oShell = this;
			addChild(oModule);
			oModule.init();
			stage.addEventListener(Event.RESIZE, oModule.onResize);
		}
		private function unloadModule()
		{}
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
			oPopupManager.update();
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