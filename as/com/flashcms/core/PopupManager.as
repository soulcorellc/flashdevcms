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
		private var mcRoot:MovieClip;
		private var mcMask:Sprite;
		private var mcHolder:MovieClip;
		private var bVisible:Boolean;
		private var oStage:Stage;
		private var aWindows:Array;
		private var xmlPopups:XMLList;
		private var oLoader:Loader;
		private var oRequest:URLRequest;
		private var oShell:Shell;
		private var oTweenOut:Tween;
		private var oModule:Module;
		private var oManager:StageManager;
		/**
		 * 
		 * @param	root
		 * @param	shell
		 * @param	popups
		 * @param	stageref
		 */
		public function PopupManager(root:MovieClip, shell:Shell , popups:XMLList, stageref:Stage) {
			trace("popupmanager");
			mcRoot = root;
			oStage = stageref;
			xmlPopups = popups;
			oShell = shell;
			init();
		}
		/**
		 * initialize class members
		 */
		private function init() {
			bVisible = false;
			aWindows = new Array();
			mcMask = new Sprite();
			mcHolder = new MovieClip();
			oRequest = new URLRequest();
			oLoader = new Loader();
		}
		/**
		 * 
		 */
		private function createMask()
		{
			oManager = new StageManager(mcMask, 0, 0, 0, 0, true,true);
			mcRoot.addChild(mcMask);
			mcRoot.addChild(oManager);
			mcMask.addEventListener(MouseEvent.CLICK, onMaskClick);
			mcMask.graphics.clear();
			mcMask.graphics.beginFill(0x000000, .5);
			mcMask.graphics.drawRect(0, 0, oStage.stageWidth, oStage.stageHeight);
			mcMask.graphics.endFill();
			
		}
		/**
		 * 
		 */
		public function closeAll()
		{
			mcRoot.removeChild(mcMask);
			hideWindow(mcHolder);
			//mcRoot.removeChild(oManager);
			//oManager.remove();
			
		}
		/**
		 * 
		 * @param	event
		 */
		private function onCloseModule(event:TweenEvent)
		{
			oModule.removeEventListener("closepopup", onWindowEvent);
			mcRoot.removeChild(mcHolder);
		}
		/**
		 * 
		 * @param	oEvent
		 */
		private function onMaskClick(oEvent:MouseEvent) {
			//closeAll();
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
				oLoader = new Loader();
				oRequest.url = xmlPopups.(sName == name).sURL;
				oLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorWindow);
				oLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadWindow);
				trace("before load");
				oLoader.load(oRequest);
				trace("after load");
			}
			catch (e:Error){
				trace("PopupManager exception : " + e);
			}
		}
		/**
		 * 
		 * @param	oEvent
		 */
		private function onLoadWindow(oEvent:Event)
		{
			mcHolder.addChild(oLoader.content);
			mcRoot.addChild(mcHolder);
			oLoader.content.x-= oLoader.content.width / 2
			oLoader.content.y-= oLoader.content.height / 2;
			mcHolder.x = (800/2) ;
			mcHolder.y = (600/2);
			
			oModule = Module(oEvent.target.content);
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
			switch(e.target.sName)
			{
				case "Login":
					dispatchEvent(new LoginEvent(e.target.sUserName));
				break;
				default:
				break;
			}
		}
		/**
		 * 
		 * @param	oEvent
		 */
		private function onErrorWindow(oEvent:IOErrorEvent)
		{
			trace("Window :"+oEvent);
		}
	}
	
}