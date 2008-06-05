package com.flashcms.home {
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	* ...
	* @author Default
	*/
	public class SectionItem extends Sprite{
		
		public var txtDescription:TextField;
		public var txtName:TextField;
		public function SectionItem(xSection:XML){
			txtName.text = xSection.title;
			txtDescription.text = xSection.description;
		}
		
		
	}
	
}