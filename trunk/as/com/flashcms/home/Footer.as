package com.flashcms.home {
	import com.flashcms.core.Module;
	import flash.events.Event;
	
	/**
	* ...
	* @author Default
	*/
	public class Footer extends Module{
		/**
		 * Class Constructor
		 */
		public function Footer() {
			super("Footer");
			
		}
		public override function init()
		{
			draw();
		}
		private function draw()
		{
			this.graphics.clear();
			this.graphics.beginFill(0xCCCCCC);
			this.graphics.drawRect(0, 0, stage.stageWidth, 25);
			this.graphics.endFill();
			trace(stage.stageWidth + " from footer");
		}
		public override function onResize(event:Event)
		{
			draw();
		}
		
	}
	
}