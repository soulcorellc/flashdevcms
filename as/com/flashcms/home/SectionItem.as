package com.flashcms.home {
	import flash.display.Sprite;
	
	/**
	* ...
	* @author Default
	*/
	public class SectionItem extends Sprite{
		
		private var mcBackground:Sprite;
		public function SectionItem(xSection:XML){
			
			draw();
		}
		private function draw()
		{
			mcBackground = new Sprite();
			mcBackground.graphics.lineStyle(1, 0x000000);
			mcBackground.graphics.drawRect(0, 0, 500, 60);
			mcBackground.graphics.endFill();
		}
		
	}
	
}