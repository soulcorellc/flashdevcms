package com.flashcms.site 
{
	import flash.display.Sprite;
	
	/**
	* ...
	* @author David Barrios
	*/
	public class Background extends Sprite
	{
		public var color:uint=0xFFFFFF;
		public function Background(color:uint,w:int,h:int) 
		{
			this.color = color;
			this.graphics.beginFill(color, 1);
			this.graphics.drawRect(0, 0, w, h);
			this.graphics.endFill();
		}
		public function update(w:int,h:int)
		{
			this.graphics.clear();
			this.graphics.beginFill(color, 1);
			this.graphics.drawRect(0, 0, w, h);
			this.graphics.endFill();
		}
	}
	
}