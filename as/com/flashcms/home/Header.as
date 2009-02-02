package com.flashcms.home {
	import com.yahoo.astra.fl.controls.Menu;
	import flash.display.Sprite;
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
	import flash.text.Font;
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
		private var oBG:DynamicBG;
		public var oUserInfo:UserInfo;
		private var oFont:Font;
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
			oFont = new Gotham();
			
			oMenu = new MenuBar(this);
			
			var oStyle = new TextFormat("Verdana", 9, 0x333333, true, false, false, '', '', TextFormatAlign.LEFT, 0, 0, 0, 0);
			//oMenu.setStyle("embedFonts", true);
			oMenu.setStyle("textFormat", oStyle);
			
			oMenu.width = 800;
			oMenu.autoSizeButtonsToTextWidth = false;
			oMenu.y = 36;
			oMenu.x = 170;
			oMenu.addEventListener(MenuEvent.ITEM_CLICK, onItemClick);
			oMenu.dataProvider = XML(oShell.xMenu);
			
			for each(var tempmenu:Menu in oMenu.menus)
			{
				tempmenu.setRendererStyle("textFormat", oStyle);
				tempmenu.drawNow();
				tempmenu.invalidate();
			}
			
			oMenu.drawNow();
			oMenu.invalidate();
			
			initUser();
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
			oUserInfo.txtUser.text = "Welcome, " + String(oShell.oUser.sName);
			oUserInfo.btProfile.addEventListener(MouseEvent.CLICK, onProfile);
			//oUserInfo.btPassword.addEventListener(MouseEvent.CLICK, onPassword);
			oUserInfo.btLogout.addEventListener(MouseEvent.CLICK, onLogout);
			oUserInfo.x = stage.stageWidth - (oUserInfo.width+200);
		}
		/**
		 * Called when stage is resized
		 * @param	event
		 */
		override public function onResize(event:Event)
		{
			oBG.update(stage.stageWidth);
			oUserInfo.x = stage.stageWidth - (oUserInfo.width+200);
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
		function ioErrorHandler(event:IOErrorEvent)
		{
			trace("ioErrorHandler: " + event.text);
		}
		
		//USER
		private function onProfile(e:Event)
		{
			//oShell.showPopup("edit", { table:"users", section:"users" }, onEdit);
			trace("onprofile");
			oShell.showPopup("edit", {table:"user",section:"userprofile",requiredata:true,create:false,option:"edituser",id:oShell.oUser.sID}, onEdit);
		
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
			//removeChild(oMenu);
			oMenu.dataProvider = new XML();
			oMenu.removeEventListener(MenuEvent.ITEM_CLICK, onItemClick);
			oMenu = null;
		}
	}
	
}