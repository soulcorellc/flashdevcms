package com.flashcms.components {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	/**
	* ...
	* @author David Barrios
	*/
	public class ContentHolder extends Sprite{
		private var id:int;
		public var type:String;
		private var mcBackground:Sprite;
		public var txtName:TextField;
		
		public function ContentHolder (type:String) {
			super();
			this.doubleClickEnabled = true;
			this.type = type;
			mcBackground = new Sprite();
			addChildAt(mcBackground, 0);
			txtName.text = type;
			var IconClass:Class = getDefinitionByName("Icon" + type) as Class;
			var icon:Sprite= new IconClass();
			icon.x = 6;
			icon.y = 6;
			addChild(icon);
			setSize(100, 100);
			mcBackground.doubleClickEnabled = true;
		}
	
		public function setSize(newwidth:int,newheight:int)
		{
			mcBackground.graphics.clear();
			mcBackground.graphics.beginFill(0xF9F9F9, 1);
			mcBackground.graphics.lineStyle(1, 0xCCCCCC, 1);
			mcBackground.graphics.drawRect( 0, 0, newwidth, newheight);
			mcBackground.graphics.endFill();
		}
	}
	
}