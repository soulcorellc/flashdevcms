﻿package com.flashcms.core {
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
			mcRoot.addChild(mcMask);
			mcMask.addEventListener(MouseEvent.CLICK, onMaskClick);
			mcMask.graphics.clear();
			mcMask.graphics.beginFill(0x000000, .5);
			mcMask.graphics.drawRect(0, 0, oStage.stageWidth, oStage.stageHeight);
			mcMask.graphics.endFill();
			mcMask.x = - (oStage.width-800)/2;
			mcMask.y = - (oStage.height-600)/2;
		}
		/**
		 * 
		 */
		public function closeAll()
		{
			mcRoot.removeChild(mcMask);
			oTweenOut= new Tween(mcHolder, "scaleX", Regular.easeIn, 1, 0, 0.3, true);
			oTweenOut.addEventListener(TweenEvent.MOTION_FINISH, onCloseModule);
			new Tween(mcHolder, "scaleY", Regular.easeIn, 1, 0, .3, true);
			
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
			closeAll();
		}
		/**
		 * 
		 */
		public function update()
		{
			mcMask.x = - (oStage.stageWidth-800)/2;
			mcMask.y = - (oStage.stageHeight-600)/2;
			
			mcMask.graphics.clear();
			mcMask.graphics.beginFill(0x000000, .5);
			mcMask.graphics.drawRect(0, 0, oStage.stageWidth, oStage.stageHeight);
			mcMask.graphics.endFill();
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
				oRequest.url = xmlPopups.(sName == name).sURL;
				oLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorWindow);
				oLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadWindow);
				oLoader.load(oRequest);
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

			var oTween:Tween = new Tween(mcHolder, "scaleX", Back.easeOut, .5, 1, 0.5, true);
			new Tween(mcHolder, "scaleY", Back.easeOut, .5, 1, .5, true);
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
					dispatchEvent(new LoginEvent(e.target.sName));
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