package com.flashcms.home {
	import com.flashcms.core.Module;
	import flash.events.Event;
	/**
	* ...
	* @author Default
	*/
	public class Header extends Module{
		
		public var oXML:XML;
		
		
		public function Header() {
			super("Header");
			
		}
				
		override public function init()
		{
			var sURL = this.getURL("main", "home");
			trace("main url of header: "+sURL);
		}
	}
	
}