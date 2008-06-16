package com.flashcms.home {
	import com.flashcms.core.Module;
	import flash.events.Event;
	/**
	* ...
	* @author Default
	*/
	public class Background extends Module{
		private var bg;
		public function Background() {
			super("Background");
		}
		public override function init()
		{
			bg = new GradientBG();
			bg.width = stage.stageWidth;
			bg.height = stage.stageHeight - 180;
			addChild(bg);
		}
		override public function onResize(event:Event)
		{
			bg.width = stage.stageWidth;
			bg.height = stage.stageHeight- 180;
			
		}
		
	}
	
}