package com.flashcms.components {
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	* ...
	* @author Default
	*/
	public class ToolBar extends Sprite{
		public var mcHeader:Sprite;
		public var txtTitle:TextField;
		public var btMinimize:SimpleButton;
		/**
		 * 
		 */
		public function ToolBar() {
			initheader();
		}
		/**
		 * 
		 */
		function initheader()
		{
			if(mcHeader!=null){
				mcHeader.addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag);
				mcHeader.addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			}
			txtTitle.mouseEnabled = false;
			btMinimize.addEventListener(MouseEvent.CLICK, minimize);
		}
		private function minimize(e:Event)
		{
				trace("minimi");
		}
		/**
		 * 
		 * @param	e
		 */
		private function onStartDrag(e:Event)
		{
			alpha = 0.5;
			this.startDrag();
		}
		/**
		 * 
		 * @param	e
		 */
		private function onStopDrag(e:Event)
		{
			alpha = 1;
			this.stopDrag();
		}
	}
}