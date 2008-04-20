package com.flashcms.home {
	import com.flashcms.core.Module;
	import com.flashcms.data.MultiLoader;
	/**
	* ...
	* @author Default
	*/
	public class Header extends Module{
		
		private var oLoader:MultiLoader;
		public function Header() {
			super("Header");
			trace("Header called");
		}
		
		public function init(){
			oLoader = new MultiLoader();
		}
	}
	
}