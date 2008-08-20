package com.flashcms.site 
{
	import com.flashcms.layout.StageManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	* ...
	* @author David Barrios
	*/
	public class Footer extends MovieClip 
	{
		public var sManager:StageManager;
		public var mcBackground:Sprite;
		public function Footer() 
		{
			sManager = new StageManager(this, 0, 100, 0, 100, true)	
		}
		public function onResize(e:Event=null)
		{
			mcBackground.width = stage.stageWidth;
		}
	}
	
}