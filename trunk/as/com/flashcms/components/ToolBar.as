package com.flashcms.components {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	* ...
	* @author Default
	*/
	public class ToolBar extends Sprite{
		public var mcHeader:Sprite;
		public function ToolBar() {
			initheader();
		}
		/**
		 * 
		 */
		function initheader()
		{
			mcHeader.addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag);
			mcHeader.addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
		}
		private function onStartDrag(e:Event)
		{
			alpha = 0.5;
			this.startDrag();
		}
		private function onStopDrag(e:Event)
		{
			alpha = 1;
			this.stopDrag();
		}
	}
	
}