package com.flashcms.home {
	import flash.display.Sprite;
	
	/**
	* ...
	* @author Default
	*/
	public class SectionItem extends Sprite{
		
		public function SectionItem(xSection:XML){
			trace(xSection.title);
			draw();
		}
		private function draw()
		{
			this.graphics.lineStyle(1, 0x000000);
			this.graphics.drawRect(0, 0, 500, 60);
			this.graphics.endFill();
		}
		
	}
	
}