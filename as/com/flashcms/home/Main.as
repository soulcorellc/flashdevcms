package com.flashcms.home {
	/**
	* ...
	* @author Default
	*/
	import com.flashcms.core.Module;
	import com.flashcms.home.SectionItem;
	public class Main extends Module{
		
		public function Main() {
			super("Main");
		}
		override public function init()
		{
			for(var i in oShell.xMain){
				trace("Item :" + oShell.xMain[i].title);
			}
		}
	}
	
}