package com.flashcms {

	import com.flashcms.events.ErrorEvent;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import com.flashcms.events.PopupEvent;
	import flash.display.LoaderInfo;	
	
	import com.flashcms.data.MultiLoader;
	import com.flashcms.core.PopupManager;
	import com.flashcms.core.Module;
	import com.flashcms.events.LoadEvent;
	import com.flashcms.events.NavigationEvent;
	import com.flashcms.deeplinking.Navigation;
	import com.flashcms.layout.StageManager;
	import com.flashcms.core.User;
	import com.flashcms.events.LoginEvent;
	import com.flashcms.data.XMLLoader;
	
		
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
		private var oParameters:Object;
		public var xMenu:XMLList;
		public var xMain:XMLList;
		public var sLogo:String;
		public var oUser:User;
		private var mainindex:int=-1;
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
			oXMLLoader=new XMLLoader(sConfigurationURL, onConfiguration,onDataError, ioErrorHandler);
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
			trace("Module " + event.sModule+" Params :"+event.parameters);
			switch(event.sModule)
			{
				case "/":
					loadModule("main"); 
					loadModule("footer");
					loadModule("header");
				break;
				case "/admin":
					loadModule("admin",event.parameters);
				break;
				case "/sections":
					loadModule("sections");
				break;
				case "/templates":
					loadModule("templates");
				break;
				case "/files":
					loadModule("files");
				break;
				default:
					trace("loading: " + event.sModule + " parameters : " + event.parameters);
				break;
			}	
			oModuleLoader.start();
		}
		/**
		 * Add a SWF file to multiloader
		 * @param	name
		 */
		private function loadModule(name:String,parameters:Object=null)
		{
			oParameters = parameters;
			var url = xModules.(sName == name).sURL;
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
			oPopupManager = new PopupManager( this, oXML.popups, stage);
			oXMLLoader.remove();
			loadMain();
		}
		/**
		 * 
		 * @param	e
		 */
		private function onClose(e:PopupEvent)
		{
			try {
				oUser.sName = e.parameters.sName;
				oUser.bLogged = true;
				//start navigation
				if (oNavigation == null) {
					oNavigation = new Navigation(this);
					oNavigation.addEventListener(NavigationEvent.ON_NAVIGATION, onModuleChange);
				}
				else
				{
					onModuleChange(new NavigationEvent("/"));
					oNavigation.reset();
				}
			}
			catch (e:Error)
			{
				trace("ONLOGIN exception " + e);
			}
		}
		/**
		 * 
		 * 
		 * @param	event
		 */
		public function setModule(event:NavigationEvent)
		{
			oNavigation.setURL(event.sModule, event.parameters);
		}
		/**
		 * 
		 */
		private function loadMain()
		{
			oXMLLoader=new XMLLoader(getURL("main", "home"), onMainData, onDataError, ioErrorHandler);
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
			showPopup("login",null,onClose);
		}
		/**
		 * 
		 * @param	e
		 */
		private function onDataError(e:ErrorEvent)
		{
			trace("DATAERROR : "+e.message);
		}
		/**
		 * 
		 * @param	name
		 * @param	parameters
		 */
		public function showPopup(name:String,parameters:Object=null,callback:Function=null)
		{
			addChild(oPopupManager);
			oPopupManager.show(name,parameters,callback);
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
				trace("load: "+Module(event.loaderTarget.content).sName);
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
						oFooter.sManager = new StageManager(oFooter, 0, 100, 0, 100, false)
						initModule(oFooter);
					break;
					default:
						removeSection(oMain);
						oMain = Module(event.loaderTarget.content);
						oMain.sManager = new StageManager(oMain, 2, 20, 0, 0, true);
						initModule(oMain,mainindex);
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
		 */
		private function removeSection(oSection:Module)
		{
			try{
				if(oSection!= null){
					oSection.sManager.remove();
					mainindex = this.getChildIndex(oSection);
					oSection.dispose();
					removeChild(oSection.sManager);
					trace("removing section!");
					removeChild(oSection);
					stage.removeEventListener(Event.RESIZE, oSection.onResize);
					oSection = null;
				}
			}
			catch (e:Error)
			{
				trace("Error removing "+oSection);
			}
		}
		/**
		 * 
		 * @param	oModule
		 */
		private function initModule(oModule:Module,mainindex:int=-1)
		{
			oModule.oShell = this;
			oModule.parameters = oParameters;
			if (mainindex != -1)
			{
				addChildAt(oModule, mainindex);
			}
			else 
			{
				addChild(oModule);
			}
			addChild(oModule.sManager);
			oModule.init();
			oModule.show();
			stage.addEventListener(Event.RESIZE, oModule.onResize);
		}
		/**
		 * 
		 */
		public function logout()
		{
			oUser.bLogged = false;
			oUser.sName = "";
			removeSection(oMain);
			removeSection(oFooter);
			
			removeSection(oHeader);
			showPopup("login", null, onClose);
			
		}
		public function setStatusMessage(message:String)
		{
			oFooter.setData(message);
		}
		/**
		 * 
		 */
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
		 * @param	name
		 * @param	section
		 * @return
		 */
		public function getURL(name:String,section:String=null):String
		{
			return section == null? xURLs[name] : xURLs[section][name];
		}
		
	}
}