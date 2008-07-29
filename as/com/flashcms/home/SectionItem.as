package com.flashcms.home {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import gs.TweenMax;
	/**
	* ...
	* @author Default
	*/
	public class SectionItem extends Sprite{
		public var mcBG:MovieClip;
		public var txtDescription:TextField;
		public var txtName:TextField;
		public function SectionItem(xSection:XML){
			txtName.text = xSection.title;
			txtDescription.text = xSection.description;
			addEventListener(MouseEvent.ROLL_OVER, setRollOver);
			addEventListener(MouseEvent.ROLL_OUT, setRollOut);
		}
		private function setRollOver(e:MouseEvent)
		{
			TweenMax.to(mcBG, 0.5, {scaleX:1.05,scaleY:1.05} );
			//mcBG.alpha = 0.5;
		}
		private function setRollOut(e:MouseEvent)
		{
			TweenMax.to(mcBG, 0.5, {scaleX:1,scaleY:1} );
			//mcBG.alpha = 1;
		}
		
		
	}
	
}