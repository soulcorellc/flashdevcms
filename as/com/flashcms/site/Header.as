﻿package com.flashcms.site 
{
	import com.flashcms.layout.StageManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	* ...
	* @author David Barrios
	*/
	public class Header extends MovieClip 
	{
		public var sManager:StageManager;
		public var mcBackground:Sprite;
		public function Header() 
		{
			sManager = new StageManager(this, 0, 0, 0, 0, true);	
		}
		public function onResize(e:Event=null)
		{
			mcBackground.width = stage.stageWidth;	
		}
		
	}
	
}