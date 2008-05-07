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
	import com.flashcms.events.NavigationEvent;
	import com.flashcms.deeplinking.Navigation;
	import com.flashcms.layout.StageManager;
	import com.flashcms.core.User;
	import com.flashcms.events.LoginEvent;
	import com.flashcms.utils.XMLLoader;
	
public class Shell extends MovieClip {
		private var oXML:XML;
		private var xModules:XMLList;
		private var xURLs:XMLList;
		private var sConfigurationURL:String;
		private var oXMLLoader:XMLLoader;
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
		public var oUser:User;
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
			sConfigurationURL = "./xml/configuration.xml";
			oXMLLoader=new XMLLoader(sConfigurationURL, onConfiguration, ioErrorHandler);
			
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
		public function onModuleChange(event:NavigationEvent)
		{
			trace("module changed " + event.sModule);
			switch(event.sModule)
			{
			case "/":
				loadModule("user");
				loadModule("main"); 
				loadModule("footer");
				loadModule("header");
			break;
			case "/users":
			case "/groups":
				loadModule("admin");
			break;
			
			default:
				trace("loading: " + event.sModule + " parameters : " + event.oParameters);
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
			trace("onloadmodule " + name);
			var url = xModules.(sName == name).sURL;
			trace("onloadmodule url " + url);
			oModuleLoader.add(url);
		}
		/**
		 * 
		 * @param	event
		 */
		private function onConfiguration(event:Event):void
		{
			oXML = XML(event.target.data);
			xModules = oXML.modules;
			xURLs = oXML.urls;
			oPopupManager = new PopupManager(this, this, oXML.popups, stage);
			oPopupManager.addEventListener(LoginEvent.LOGIN_EVENT, onLogin);
			oXMLLoader.remove();
			loadMain();
		}
		/**
		 * 
		 * @param	e
		 */
		private function onLogin(e:LoginEvent)
		{
			oUser.sName = e.sName;
			oUser.bLogged = true;
			oPopupManager.closeAll();
			//start navigation
			oNavigation = new Navigation(this);
			oNavigation.addEventListener(NavigationEvent.ON_NAVIGATION, onModuleChange);
		}
		
		public function setModule(event:NavigationEvent)
		{
			trace("setting navigation to " + event.sModule);
			oNavigation.setURL(event.sModule,event.oParameters)
		}
		/**
		 * 
		 */
		private function loadMain()
		{
			oXMLLoader=new XMLLoader(getURL("main", "home"), onMainData, ioErrorHandler);
		}
		/**
		 * 
		 * @param	event
		 */
		private function onMainData(event:Event)
		{
			oXML = new XML();
			oXML = XML(event.target.data);
			xMenu = oXML.menus;
			xMain = oXML.main;
			sLogo = oXML.logo;
			oXMLLoader.remove();
			oPopupManager.show("login");
		}
		
		public function showPopup(name:String)
		{
			oPopupManager.show(name);
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
						oHeader.addEventListener(NavigationEvent.ON_NAVIGATION, setModule);
						oHeader.sManager = new StageManager(oHeader, 0, 0, 0, 0, true)
						initModule(oHeader);
					break;
					case "Footer":
						oFooter = Module(event.loaderTarget.content);
						oFooter.sManager = new StageManager(oFooter, 0, 100, 0, 100, true)
						initModule(oFooter);
					break;
					case "User":
						oUserModule = Module(event.loaderTarget.content);
						oUserModule.sManager=new StageManager(oUserModule, 0, 20, 0, 0, true)
						initModule(oUserModule);
					break;
					default:
						removeMainSection();
						oMain = Module(event.loaderTarget.content);
						oMain.sManager = new StageManager(oMain, 25, 20, 0, 0, true);
						initModule(oMain);
					break;
				}
			}
			catch (err:Error)
			{
				trace("Shell Exception : " + err.message);
			}
		}
		
		private function removeMainSection()
		{
			try{
				removeChildAt(getChildIndex(oMain));
				removeChildAt(getChildIndex(oMain.sManager));
				stage.removeEventListener(Event.RESIZE, oMain.onResize);
				oMain = null;
			}
			catch (e:Error)
			{
			//trace("Error unloading!!!!!!!!!! ");
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
			addChild(oModule.sManager);
			oModule.init();
			oModule.show();
			stage.addEventListener(Event.RESIZE, oModule.onResize);
		}
		private function unloadModule()
		{
		
		}
		/**
		 * 
		 * @param	event
		 */
		function ioErrorHandler(event:IOErrorEvent)
		{
			trace("ioErrorHandler: " + event.text);
			oXMLLoader.remove();
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