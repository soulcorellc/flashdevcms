﻿package com.flashcms.home {
	import flash.events.Event;
	import com.yahoo.astra.fl.controls.MenuBar;
	import com.yahoo.astra.fl.events.MenuEvent;
	import com.flashcms.core.Module;
	import com.flashcms.data.MultiLoader;
	import com.flashcms.events.LoadError;
	import com.flashcms.events.LoadEvent;
	import com.flashcms.events.NavigationEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import com.flashcms.events.PopupEvent;
	import com.flashcms.forms.FormData;
	import flash.events.MouseEvent;
	import com.flashcms.design.DynamicBG;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	* ...
	* @author Default
	*/
	public class Header extends Module{
		public var oXML:XML;
		public var xMenu:XMLList;
		public var oMenu:MenuBar;	
		private var sMainURL:String;
		private var oRequest:URLRequest;
		private var oMultiLoader:MultiLoader;
		private var oForm:FormData;
		private var oBG:DynamicBG;
		public var oUserInfo;
		/**
		 * 
		 */
		public function Header() {
			super("Header");
		}
		/**
		 * Starts Header functionallity
		 */		
		override public function init()
		{
			createBG();
			oMenu = new MenuBar(this);
			var oStyle = new TextFormat("Verdana", 10, 0xFFE8C6, true, false, false, '', '', TextFormatAlign.LEFT, 0, 0, 0, 0);
			oMenu.setStyle("textFormat",oStyle)
			oMenu.y = 73;
			oMenu.x = 120;
			oMenu.addEventListener(MenuEvent.ITEM_CLICK, onItemClick);
			oMultiLoader = new MultiLoader();
			oMultiLoader.addEventListener(LoadEvent.LOAD_EVENT, onLoadImage);
			oMultiLoader.addEventListener(LoadError.LOAD_ERROR, onError);
			oMenu.dataProvider = XML(oShell.xMenu);
			oMultiLoader.add(oShell.sLogo);
			oMultiLoader.start();
			initUser();
			trace(this.height);
		}
		/**
		 * 
		 */
		private function createBG()
		{
			oBG = new DynamicBG(stage.stageWidth, new left(), new center(), new right());
			addChildAt(oBG,0);
		}
		/**
		 * 
		 */
		private function initUser()
		{
			oUserInfo.txtUser.text = "WELCOME, " + String(oShell.oUser.sName).toUpperCase();
			oUserInfo.btProfile.addEventListener(MouseEvent.CLICK, onProfile);
			oUserInfo.btPassword.addEventListener(MouseEvent.CLICK, onPassword);
			oUserInfo.btLogout.addEventListener(MouseEvent.CLICK, onLogout);
		}
		/**
		 * Called when stage is resized
		 * @param	event
		 */
		override public function onResize(event:Event)
		{
			oBG.update(stage.stageWidth);
			oUserInfo.x = stage.stageWidth - (oUserInfo.width+20);
		}
		/**
		 * 
		 * @param	event
		 */
		private function onError(event:LoadError)
		{
			trace("Header error "+event.text);
		}
		/**
		 * 
		 * @param	event
		 */
		private function onItemClick(event:MenuEvent):void{
			dispatchEvent(new NavigationEvent(event.item.id,event.item));
		}
		/**
		 * 
		 * @param	event
		 */
		private function onLoadImage(event:LoadEvent)
		{
			this.addChild(event.loaderTarget.content);
		}
		/**
		 * 
		 * @param	event
		 */
		function ioErrorHandler(event:IOErrorEvent)
		{
			trace("ioErrorHandler: " + event.text);
		}
		
		//USER
		private function onProfile(e:Event)
		{
			oForm = new FormData("users", "users");
			oShell.showPopup("edit",oForm,onEdit);
		}
		/**
		 * 
		 * @param	e
		 */
		private function onPassword(e:Event)
		{
			
			oForm = new FormData("password", "password");
			oShell.showPopup("edit",oForm,onEdit);
		}
		/**
		 * 
		 * @param	e
		 */
		private function onLogout(e:Event)
		{
			oShell.logout();
		}
		/**
		 * 
		 * @param	e
		 */
		private function onEdit(e:PopupEvent)
		{
			
		}
		/**
		 * 
		 */
		public override function dispose()
		{
			removeChild(oMenu);
			oMenu = null;
		}
	}
	
}