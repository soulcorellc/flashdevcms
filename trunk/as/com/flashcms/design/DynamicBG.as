package com.flashcms.design {
	import flash.display.Sprite;
	
	/**
	* ...
	* @author David Barrios
	*/
	public class DynamicBG extends Sprite{
		
		private var leftasset:Sprite;
		private var centerasset:Sprite;
		private var rightasset:Sprite;
		public function DynamicBG(size:int,leftasset:Sprite,centerasset:Sprite,rightasset:Sprite) {
			
			this.leftasset = leftasset;
			this.centerasset = centerasset;
			this.rightasset = rightasset;
			addChild(leftasset);
			addChild(centerasset);
			addChild(rightasset);
			rightasset.x = size - rightasset.width;
			centerasset.x = leftasset.width;
			centerasset.width = size - (leftasset.width + rightasset.width);
		}
		public function update(size:int)
		{
			rightasset.x = size - rightasset.width;
			centerasset.x = leftasset.width;
			centerasset.width = size - (leftasset.width + rightasset.width);
		}
		
	}
	
}