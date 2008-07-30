package com.flashcms.editors 
{
	import com.flashcms.core.Module;
	import com.flashcms.data.XMLLoader:
	/**
	* ...
	* @author David Barrios
	*/
	public class Themes extends Module
	{
		public var lbList:List;
		public var btCreate:Button;
		public var btEdit:Button;
		public var btDelete:Button;
		public var btDefault:Button;
		private var sOption:String;
		private var sURL:String;
		private var oXMLLoader:XMLLoader;
		public function Themes() 
		{
			super("Themes");
		}
		override public function init()
		{
			oXMLLoader=new XMLLoader(sURL, onXMLData, onDataError, onError,{option:sOption});
		}
		
		
	}
	
}