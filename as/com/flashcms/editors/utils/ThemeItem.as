package com.flashcms.editors.utils 
{
	import fl.controls.ColorPicker;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	* ...
	* @author David Barrios
	*/
	public class ThemeItem extends MovieClip
	{
		public var cPicker:ColorPicker;
		public var txtName:TextField;
		public var label:String;
		public function ThemeItem(text:String) 
		{
			txtName.text = text;
		}
		
	}
	
}