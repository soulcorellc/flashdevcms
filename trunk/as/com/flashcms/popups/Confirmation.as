package com.flashcms.popups {
	import com.flashcms.core.Module;
	import com.flashcms.components.ButtonBar;
	import com.flashcms.events.PopupEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	* ...
	* @author Default
	*/
	public class Confirmation extends Module{
		private var oBar:ButtonBar;
		public function Confirmation() {
			
		}
		/**
		 * 
		 */
		public override function init()
		{
			txtMessage.text = parameters.message;
			oBar = new ButtonBar(onOK, onCancel, "Yes", "No");
			oBar.x = 75;
			oBar.y = 200;
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