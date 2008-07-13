package com.flashcms.components {
	import fl.controls.Button;
	import fl.controls.TextInput;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	* ...
	* @author Default
	*/
	public class ImageBar extends ToolBar{
		private var sURL:String;
		public var txtURL:TextInput;
		public var btChange:Button;
		public var btSelect:Button;
		public var component;
		/**
		 * 
		 * @param	url
		 */
	public function ImageBar(component:Object) {
			this.component=component
			sURL = component["sURL"];
			init();
			
		}
		public function init()
		{
			txtURL.text = sURL;
			trace(btChange);
			btChange.addEventListener(MouseEvent.CLICK, onChange);
		}
		private function onChange(e:MouseEvent)
		{
			component.sURL = txtURL.text;
			component.update();
		}
		
	}
	
}