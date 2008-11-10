package com.flashcms.site 
{
	import com.flashcms.layout.StageManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	* ...
	* @author David Barrios
	*/
	public class Header extends MovieClip 
	{
		public var sManager:StageManager;
		public var mcBackground:Sprite;
		public var txtTitle:TextField;
		public function Header() 
		{
			sManager = new StageManager(this, 0, 0, 0, 0, true);	
		}
		public function onResize(e:Event=null)
		{
			mcBackground.width = stage.stageWidth;	
		}
		public function setText(text:String)
		{
			txtTitle = new TextField();
			txtTitle.autoSize = TextFieldAutoSize.LEFT;
			
			txtTitle.htmlText = text;
			txtTitle.x = 100;
			txtTitle.y = 50;
			addChild(txtTitle);
		}
		
	}
	
}