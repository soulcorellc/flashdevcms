﻿package com.flashcms.components {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	* ...
	* @author Default
	*/
	public class ToolBar extends Sprite{
		public var mcHeader:Sprite;
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