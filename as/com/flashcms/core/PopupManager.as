package com.flashcms.core {
	
	import com.flashcms.data.MultiLoader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	import flash.display.Loader;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	
	import com.flashcms.ShellAdmin;
	import com.flashcms.login.Login;
	import com.flashcms.layout.StageManager;
	import com.flashcms.events.PopupEvent;
	import com.flashcms.events.LoginEvent;
	import com.flashcms.events.LoadEvent;
	import com.flashcms.events.LoadError;
	
	/**
	* ...
	* @author David Barrios
	*/
	public class PopupManager extends Sprite {
		private var mcMask:Sprite;
		private var mcHolder:MovieClip;
		private var oStage:Stage;
		private var xmlPopups:XMLList;
		private var oShell:ShellAdmin;
		private var oTweenOut:Tween;
		private var oTween:Tween;
		private var oTweenY:Tween;
		private var oTweenMask:Tween;
		private var oMultiLoader:MultiLoader;
		private var oModule:Module;
		private var oManager:StageManager;
		private var oManagerCenter:StageManager;
		private var nextevent:Event;
		private var nextparameters:Object;
		private var callback:Function;
		private var preloader:CubeLoader;
		private var preloaderManager:StageManager;
		private var lastpopup:String;
		/**
		 * 
		 * @param	root
		 * @param	shell
		 * @param	popups
		 * @param	stageref
		 */
		public function PopupManager(shell:ShellAdmin , popups:XMLList, stageref:Stage) {
			
			oStage = stageref;
			xmlPopups = popups;
			oShell = shell;
			init();
		}
		/**
		 * initialize class members
		 */
		private function init() {
			
			oMultiLoader = new MultiLoader();
			oMultiLoader.addEventListener(LoadEvent.LOAD_EVENT, onLoadWindow);
			oMultiLoader.addEventListener(LoadError.LOAD_ERROR, onErrorWindow);
			mcMask = new Sprite();
			mcHolder = new MovieClip();
			addChild(mcMask);
			preloader = new CubeLoader();
			preloader.scaleX = .25;
			preloader.scaleY = .25;
			preloaderManager = new StageManager(preloader, 50, 50, 50, 50, true);
		}
		/**
		 * create black mask under the window
		 */
		private function createMask()
		{
			oManager = new StageManager(mcMask, 0, 0, 0, 0, true);
			oManagerCenter = new StageManager(mcHolder, 50, 50, 0, 0, true);
			addChild(oManager);
			addChild(oManagerCenter);
			oStage.addEventListener(Event.RESIZE, onResize);
			mcMask.addEventListener(MouseEvent.CLICK, onMaskClick);
			onResize();
		}
		/**
		 * 
		 * @param	e
		 */
		private function onResize(e:Event=null)
		{
			mcMask.graphics.clear();
			mcMask.graphics.beginFill(0x000000, .5);
			mcMask.graphics.drawRect(0, 0, oStage.stageWidth, oStage.stageHeight);
			mcMask.graphics.endFill();
		}
		/**
		 * 
		 * @param	event
		 */
		public function onCloseModule(event:TweenEvent=null)
		{
			oModule.removeEventListener(PopupEvent.CLOSE, onWindowEvent);
			oStage.removeEventListener(Event.RESIZE, onResize);
			oManager.remove();
			oManagerCenter.remove();
			removeChild(mcHolder);
			mcHolder.removeChild(oModule);
			removeChild(oManagerCenter);
			removeChild(oManager);
			oManager = null;
			oShell.removeChild(this);
			executeEvent();
			
		}
		/**
		 * Disptach the right event from the window
		 */
		private function executeEvent()
		{
			if(callback != null)
			callback.call(this, nextevent);
		}
		/**
		 * 
		 * @param	oEvent
		 */
		private function onMaskClick(oEvent:MouseEvent) {
			
		}
		/**
		 * 
		 * @param	name
		 * @param	parameters
		 */
		public function show(name:String,parameters:Object=null,callback:Function=null)
		{
			try {
				lastpopup = name;
				this.callback = callback;
				createMask();
				showPreloader();
				oTweenMask=new Tween(mcMask, "alpha", Regular.easeIn, 0, 1, .2, true);
				loadModule(name,parameters);
			}
			catch (e:Error){
				trace("PopupManager exception : " + e);
			}
		}
		
		/**
		 * 
		 * @param	name
		 * @param	parameters
		 */
		private function loadModule(name:String,parameters:Object)
		{
			
			var url = xmlPopups.(sName == name).sURL;
			nextparameters = parameters;
			//trace("nextparameters : "+nextparameters.name);
			oMultiLoader.add(url);
			oMultiLoader.start();
		}
		/**
		 * 
		 * @param	oEvent
		 */
		private function onLoadWindow(oEvent:LoadEvent)
		{
			addChild(mcHolder);
			oModule = Module(oEvent.loaderTarget.content);
			oModule.oShell = oShell;
			oModule.oLoader = oEvent.loaderTarget as LoaderInfo;
			oModule.parameters = nextparameters;
			mcHolder.addChild(oModule);
			oModule.x-= oModule.width / 2
			oModule.y-= oModule.height/ 2;
			oModule.addEventListener(PopupEvent.CLOSE, onWindowEvent);
			showWindow(mcHolder);
		}
		/**
		 * 
		 * @param	mcClip clip to be displayed
		 */
		private function showWindow(mcClip:Sprite)
		{
			oTween = new Tween(mcClip, "scaleX", Back.easeOut, .5, 1, 0.5, true);
			oTween.addEventListener(TweenEvent.MOTION_FINISH, onModuleDisplayed);
			oTweenY=new Tween(mcClip, "scaleY", Back.easeOut, .5, 1, .5, true);
		}
		private function onModuleDisplayed(event:TweenEvent)
		{
			hidePreloader();
			oModule.init();
		}
		/**
		 * 
		 * @param	mcClip
		 */
		private function hideWindow(mcClip:Sprite)
		{
			oTweenOut = new Tween(mcClip, "scaleX", Regular.easeIn, 1, 0.6, 0.2, true);
			oTweenOut.addEventListener(TweenEvent.MOTION_FINISH, onCloseModule);
			oTweenY = new Tween(mcClip, "scaleY", Regular.easeIn, 1, 0.6, .2, true);
			oTweenMask=new Tween(mcMask, "alpha", Regular.easeIn, 1, 0, .2, true);
		}
		/**
		 * 
		 * @param	e
		 */
		public function onWindowEvent(e:Event)
		{
			nextevent = e;
			hideWindow(mcHolder);
		}
		/**
		 * Handle IO Error for loaded windows
		 * @param	oEvent
		 */
		private function onErrorWindow(oEvent:LoadError)
		{
			trace("Error loading popup :"+lastpopup);
		}
		private function showPreloader()
		{
			addChild(preloaderManager);
			addChild(preloader);
			
		}
		private function hidePreloader()
		{
			removeChild(preloaderManager);
			removeChild(preloader);
			
		}
	}
	
}