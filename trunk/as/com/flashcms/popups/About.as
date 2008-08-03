package com.flashcms.popups 
{
	import com.flashcms.core.Module;
	import com.flashcms.design.DynamicBG;
	import fl.controls.Button;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.flashcms.events.PopupEvent;
	/**
	* ...
	* @author David Barrios
	*/
	public class About extends Module
	{
		private var oBG:DynamicBG;
		public var btOK:Button;
		public function About() 
		{
			createBG();
		}
		
		private function createBG()
		{
			oBG = new DynamicBG(350, new left(), new center(), new right());
			addChildAt(oBG, 0);
			btOK.addEventListener(MouseEvent.CLICK, onClose);
		}
		private function onClose(e:Event)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE));
		}
	}
	
}