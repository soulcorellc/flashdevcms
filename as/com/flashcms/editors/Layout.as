package com.flashcms.editors 
{
	import com.flashcms.core.Module;
	import com.flashcms.events.PopupEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	* ...
	* @author David Barrios
	*/
	public class Layout extends Module
	{
		public var mcHeader:Sprite;
		public var mcFooter:Sprite;
		public var mcMenu:Sprite;
		public function Layout() 
		{
			
		}
		/**
		 * 
		 */
		public override function init()
		{
			mcHeader.addEventListener(MouseEvent.CLICK, showPopup);
			mcMenu.addEventListener(MouseEvent.CLICK, showPopup);
			mcFooter.addEventListener(MouseEvent.CLICK, showPopup);
		}
		private function showPopup(e:Event)
		{
			oShell.showPopup("layout", null, onClosePopup);
		}
		private function onClosePopup(e:PopupEvent)
		{
		}
	}
	
}