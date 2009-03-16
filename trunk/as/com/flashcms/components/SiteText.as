package com.flashcms.components 
{
	import flash.display.MovieClip;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author David Barrios
	 */
	public class SiteText extends MovieClip
	{
		public var txtText:TextField;
		public var id:String;
		public function SiteText(nwidth:int,nheight:int,text:String) 
		{
			txtText = new TextField();
			txtText.width = nwidth;
			txtText.height = nheight;
			txtText.multiline = true;
			txtText.wordWrap = true;
			txtText.autoSize = TextFieldAutoSize.NONE;
			txtText.htmlText = text;
			addChild(txtText);
		}
		
	}
	
}