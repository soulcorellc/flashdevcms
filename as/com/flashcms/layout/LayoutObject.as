package com.flashcms.layout 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	* ...
	* @author David Barrios
	*/
	public class LayoutObject extends MovieClip
	{
		public var txtName:TextField;
		public var txtSize:TextField;
		public var mcBack:MovieClip;
		public function LayoutObject() 
		{
			
		}
		public function update(value:int,type:String)
		{
			if(type=="vertical")
			{
				mcBack.height = value;
			}
			else
			{
				mcBack.width = value;
			}
			
			txtSize.text = Math.round(value) + " px";
		}
		
	
	}
	
}