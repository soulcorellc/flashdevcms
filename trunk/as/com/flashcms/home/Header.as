package com.flashcms.home {
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
		public function Header() {
			super("Header");
			
		}
		/**
		 * Starts Header functionallity
		 */		
		override public function init()
		{
			oMenu = new MenuBar(this);
			oMenu.addEventListener(MenuEvent.ITEM_CLICK, onItemClick);
			oMenu.y = 60;
			oMultiLoader = new MultiLoader();
			oMultiLoader.addEventListener(LoadEvent.LOAD_EVENT, onLoadImage);
			oMultiLoader.addEventListener(LoadError.LOAD_ERROR, onError);
			oMenu.dataProvider = XML(oShell.xMenu);
			oMultiLoader.add(oShell.sLogo);
			oMultiLoader.start();
			draw();
			initUser();
		}
		private function initUser()
		{
			txtUser.text = "Welcome, " + oShell.oUser.sName;
			btProfile.addEventListener(MouseEvent.CLICK, onProfile);
			btPassword.addEventListener(MouseEvent.CLICK, onPassword);
			btLogout.addEventListener(MouseEvent.CLICK, onLogout);
		}
		/**
		 * Called when stage is resized
		 * @param	event
		 */
		override public function onResize(event:Event)
		{
			draw();	
		}
		/**
		 * 
		 */
		private function draw()
		{
			this.graphics.clear();
			this.graphics.lineStyle(1,0xCCCCCC,1);
			this.graphics.drawRect(0, 60, stage.stageWidth, 21);
			this.graphics.endFill();
		}
		private function onError(event:LoadError)
		{
			trace("Header error "+event.text);
		}
		
		private function onItemClick(event:MenuEvent):void{
			dispatchEvent(new NavigationEvent(event.item.id,event.item));
		}
		
		private function onLoadImage(event:LoadEvent)
		{
			this.addChild(event.loaderTarget.content);
		}
		
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
		private function onPassword(e:Event)
		{
			
			oForm = new FormData("password", "password");
			oShell.showPopup("edit",oForm,onEdit);
		}
		private function onLogout(e:Event)
		{
			oShell.logout();
		}
		private function onEdit(e:PopupEvent)
		{
			
		}
		public override function dispose()
		{
			removeChild(oMenu);
			oMenu = null;
		}
	}
	
}