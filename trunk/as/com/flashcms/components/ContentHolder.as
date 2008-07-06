package com.flashcms.components {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	/**
	* ...
	* @author David Barrios
	*/
	public class ContentHolder extends Sprite{
		private var id:int;
		public var type:String;
		private var mcBackground:Sprite;
		
		
		public function ContentHolder (type:String) {
			super();
			this.type = type;
			mcBackground = new Sprite();
			addChildAt(mcBackground, 0);
			updateSize(100, 100);
			mcBackground.doubleClickEnabled = true;	
		}
		/**
		 * 
		 * @param	newwidth
		 * @param	newheight
		 */
		public function updateSize(newwidth:int,newheight:int)
		{
			mcBackground.graphics.clear();
			mcBackground.graphics.beginFill(0xF9F9F9, 1);
			mcBackground.graphics.lineStyle(1, 0xCCCCCC, 1);
			mcBackground.graphics.drawRect( 0, 0, newwidth, newheight);
			mcBackground.graphics.endFill();
		
		}
	}
	
}