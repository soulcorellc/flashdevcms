package com.flashcms.core {
	import com.flashcms.events.LoginEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent
	import flash.net.URLVariables;
	import com.flashcms.Shell;
	import com.flashcms.login.Login;
	import flash.display.LoaderInfo;
	import com.flashcms.layout.StageManager;
	/**
	* ...
	* @author David Barrios
	*/
	public class PopupManager extends Sprite {
		private var mcMask:Sprite;
		private var mcHolder:MovieClip;
		private var oStage:Stage;
		private var xmlPopups:XMLList;
		private var oLoader:Loader;
		private var oRequest:URLRequest;
		private var oShell:Shell;
		private var oTweenOut:Tween;
		private var oModule:Module;
		private var oManager:StageManager;
		private var oManagerCenter:StageManager;
		private var nextevent:Event;
		/**
		 * 
		 * @param	root
		 * @param	shell
		 * @param	popups
		 * @param	stageref
		 */
		public function PopupManager(shell:Shell , popups:XMLList, stageref:Stage) {
			trace("popupmanager");
			oStage = stageref;
			xmlPopups = popups;
			oShell = shell;
			init();
		}
		/**
		 * initialize class members
		 */
		private function init() {
			
			mcMask = new Sprite();
			mcHolder = new MovieClip();
			oRequest = new URLRequest();
			oLoader = new Loader();
			addChild(mcMask);
			
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
			oModule.removeEventListener("closepopup", onWindowEvent);
			oStage.removeEventListener(Event.RESIZE, onResize);
			oManager.remove();
			oManagerCenter.remove();
			removeChild(mcHolder);
			removeChild(oManagerCenter);
			removeChild(oManager);
			oShell.removeChild(this);
			
			executeEvent();
			
		}
		/**
		 * Disptach the right event from the window
		 */
		private function executeEvent()
		{
			switch(nextevent.target.sName)
			{
				case "Login":
					dispatchEvent(new LoginEvent(nextevent.target.sUserName));
				break;
				default:
				break;
			}
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
		public function show(name:String,parameters:Object=null)
		{
			try {
				createMask();
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
			oLoader = new Loader();
			oRequest.url = xmlPopups.(sName == name).sURL;
			oLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorWindow);
			oLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadWindow);
			oLoader.load(oRequest);
		}
		/**
		 * 
		 * @param	oEvent
		 */
		private function onLoadWindow(oEvent:Event)
		{
			addChild(mcHolder);
			oModule = Module(oEvent.target.content);
			mcHolder.addChild(oModule);
			oModule.x-= oModule.width / 2
			oModule.y-= oModule.height/ 2;
			oModule.init();
			oModule.addEventListener("closepopup", onWindowEvent);
			showWindow(mcHolder);
		}
		/**
		 * 
		 * @param	mcClip clip to be displayed
		 */
		private function showWindow(mcClip:Sprite)
		{
			var oTween:Tween = new Tween(mcClip, "scaleX", Back.easeOut, .5, 1, 0.5, true);
			new Tween(mcClip, "scaleY", Back.easeOut, .5, 1, .5, true);
		}
		private function hideWindow(mcClip:Sprite)
		{
			oTweenOut = new Tween(mcClip, "scaleX", Regular.easeIn, 1, 0, 0.3, true);
			oTweenOut.addEventListener(TweenEvent.MOTION_FINISH, onCloseModule);
			new Tween(mcClip, "scaleY", Regular.easeIn, 1, 0, .3, true);
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
		private function onErrorWindow(oEvent:IOErrorEvent)
		{
			trace("Window :"+oEvent);
		}
	}
	
}