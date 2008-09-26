package com.flashcms {

import flash.display.Loader;
import flash.display.MovieClip;
import flash.display.Stage;
import flash.events.IOErrorEvent;
import flash.events.Event;
import flash.display.LoaderInfo;
import flash.external.ExternalInterface;
import com.flashcms.events.ErrorEvent;
import com.flashcms.events.PopupEvent;
import com.flashcms.events.LoadEvent;
import com.flashcms.events.NavigationEvent;
import com.flashcms.data.MultiLoader;
import com.flashcms.core.User;
import com.flashcms.core.PopupManager;
import com.flashcms.core.Module;
import com.flashcms.deeplinking.Navigation;
import com.flashcms.layout.StageManager;
import com.flashcms.events.LoginEvent;
import com.flashcms.data.XMLLoader;
import gs.TweenMax;
		
public class ShellAdmin extends MovieClip {
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
		public var oMain:Module;
		//private var oBackground:Module;
		private var oParameters:Object;
		public var xMenu:XMLList;
		public var xMain:XMLList;
		public var sLogo:String;
		public var oUser:User;
		private var bHeaderLoaded:Boolean = false;
		/**
		 * 
		 */
		public function ShellAdmin(){
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
			trace("deeplinking changed " + event.sModule);
			if(!bHeaderLoaded){
				//loadModule("background");	
				loadModule("footer");
				loadModule("header");
				bHeaderLoaded = true;
			}
			switch(event.sModule)
			{
				case "":
					loadModule("main"); 
				break;
				case "site":
					trace("site");
				break;
				default:
					//TweenMax.to(oMain, 2, { x:stage.stageWidth * 2 } );
					loadModule(event.sModule,event.parameters);
				break;
			}	
			oModuleLoader.start();
		}
		private function openURL(url:String)
		{
		
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
				oUser.sID = e.parameters.sID;
				oUser.sName = e.parameters.sName;
				
				oUser.bLogged = true;
				//start navigation
				if (oNavigation == null) {
					oNavigation = new Navigation(this);
					oNavigation.addEventListener(NavigationEvent.ON_NAVIGATION, onModuleChange);
					trace("deeplinking created : " + oNavigation);
				}
				else
				{
					//onModuleChange(new NavigationEvent("/"));
					//oNavigation.reset();
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
			if (event.sModule == "about")
			{
				showPopup("about");
			}
			else
			{
				oNavigation.setURL(event.sModule, event.parameters);
			}
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
						initModule(oFooter,0);
					break;
					default:
						removeSection(oMain);
						oMain = Module(event.loaderTarget.content);
						oMain.sManager = new StageManager(oMain, 50, 54, 50, 50, true);
						initModule(oMain, 1);
						//TweenMax.to(oMain, 0, { blurFilter: { blurX:5, blurY:5, quality:2 }} );
						//TweenMax.to(oMain, 2, { x:oMain.x} );
						
					break;
				}
			}
			catch (err:Error)
			{
				trace("Shell Exception : " + err.message+ " : "+Module(event.loaderTarget.content).sName);
			}
		}
		/**
		 * 
		 */
		private function removeSection(oSection:Module)
		{
			try
			{
				if(oSection!= null){
					oSection.dispose();
					if(oSection.sManager!=null && oSection.sManager.stage!=null){
						oSection.sManager.remove();
						removeChild(oSection.sManager);
					}
					if(oSection.stage != null){
					removeChild(oSection);
					stage.removeEventListener(Event.RESIZE, oSection.onResize);
					}
					oSection.sManager = null;
					oSection = null;
				
				}
			}
			catch (e:Error)
			{
				trace("Error removing "+oSection+" : "+e.message);
			}
		}
		/**
		 * 
		 * @param	oModule
		 */
		private function initModule(oModule:Module,index:int=-1)
		{
			try
			{
				oModule.oShell = this;
				oModule.parameters = oParameters;
				if (index != -1){
					addChildAt(oModule, index);
				}
				else {
					addChild(oModule);
				}
				oModule.init();
				oModule.show();
				stage.addEventListener(Event.RESIZE, oModule.onResize);
				if (oModule.sManager != null){
					addChild(oModule.sManager);
				}
			}
			catch (error:Event)
			{
				trace("Error on INIT :" + error);
			}
		}
		/**
		 * 
		 */
		public function logout()
		{
			oUser.bLogged = false;
			oUser.sID = "";
			removeSection(oHeader);
			removeSection(oMain);
			removeSection(oFooter);
			//removeSection(oBackground);
			bHeaderLoaded = false;
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
			trace("getting " + name + " " + section); 
			var url:String=section == null? xURLs[name] : xURLs[section][name];
			var server:String = xURLs["server"];
			trace("url " + url);
			return server + url;
		}
		
		
	}
}