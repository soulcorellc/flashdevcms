package com.flashcms.popups 
{
	import com.flashcms.core.Module;
	import com.flashcms.design.DynamicBG;
	import com.flashcms.components.ButtonBar;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.flashcms.events.PopupEvent;
	/**
	* ...
	* @author David Barrios
	*/
	public class Layout extends Module
	{
		private var oBG:DynamicBG;
		private var oBar:ButtonBar;
		public function Layout() 
		{
			createBG();
		}
		public override function init()
		{
			oBar = new ButtonBar(onSave, onCancel, "Cancel", "Save");
			oBar.x = 80;
			oBar.y = 270;
			addChild(oBar);
			gotoAndStop(2);
		}
		private function createBG()
		{
			oBG = new DynamicBG(350, new left(), new center(), new right());
			addChildAt(oBG,0);
		}
		private function onSave(e:Event)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{type:"yes"}));
		}
		private function onCancel(e:Event)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{type:"no"}));
		}
	}
	
}