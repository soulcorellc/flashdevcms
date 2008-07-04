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
		public var txtMain:TextField;
		
		public function ContentHolder (type:String) {
			super();
			this.doubleClickEnabled = true;
			this.type = type;
			mcBackground = new Sprite();
			addChildAt(mcBackground, 0);
			setSize(100, 100);
			mcBackground.doubleClickEnabled = true;
			initEditor();
		}
		private function initEditor()
		{
			switch(type)
			{
				case "Text":
					txtMain = new TextField();
					txtMain.width = this.width;
					txtMain.height = this.height;
					addChild(txtMain);
					txtMain.type = TextFieldType.INPUT;
					txtMain.wordWrap = true;
				break;
			}
		}
		public function setSize(newwidth:int,newheight:int)
		{
			mcBackground.graphics.clear();
			mcBackground.graphics.beginFill(0xF9F9F9, 1);
			mcBackground.graphics.lineStyle(1, 0xCCCCCC, 1);
			mcBackground.graphics.drawRect( 0, 0, newwidth, newheight);
			mcBackground.graphics.endFill();
			if (txtMain != null)
			{
			txtMain.width = this.width;
			txtMain.height = this.height;
			}
		}
	}
	
}