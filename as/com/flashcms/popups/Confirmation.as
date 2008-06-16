package com.flashcms.popups {
	import com.flashcms.core.Module;
	import com.flashcms.components.ButtonBar;
	import com.flashcms.events.PopupEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import com.flashcms.design.DynamicBG;
	/**
	* ...
	* @author Default
	*/
	public class Confirmation extends Module{
		private var oBar:ButtonBar;
		private var oBG:DynamicBG;
		public function Confirmation() {
			createBG();
		}
		/**
		 * 
		 */
		private function createBG()
		{
			oBG = new DynamicBG(350, new left(), new center(), new right());
			addChildAt(oBG,0);
		}
		public override function init()
		{
			txtMessage.text = parameters.message;
			oBar = new ButtonBar(onOK, onCancel, "Yes", "No");
			oBar.x = 75;
			oBar.y = 250;
			addChild(oBar);
			
		}
		private function onOK(e:MouseEvent)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{type:"yes"}));
		}
		/**
		 * 
		 */
		private function onCancel(e:MouseEvent)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{type:"no"}));
		}
		
	}
	
}