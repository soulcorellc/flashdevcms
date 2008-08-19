package com.flashcms.editors.utils
{
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	/**
	* ...
	* @author David Barrios
	*/
	public class Bar extends Sprite 
	{
		public var cbMenu:ComboBox;
		public var menuType:int;
		public var btSave:Button;
		public function Bar() 
		{
			init();
		}
		private function init()
		{
			cbMenu.addEventListener(Event.CHANGE, onMenuChange);
			btSave.addEventListener(MouseEvent.CLICK, onSave);
		}
		public function setMenu(data:int)
		{
			cbMenu.selectedIndex = data;
		}
		private function onMenuChange(e:Event)
		{
			menuType = cbMenu.selectedItem.data;
			dispatchEvent(new Event(Event.CHANGE));
		}
		private function onSave(e:Event)
		{
			dispatchEvent(new Event("save"));
		}
		
	}
	
}