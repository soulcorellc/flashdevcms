package com.flashcms.home {
	import com.flashcms.core.Module;
	import flash.display.Sprite;
	import com.flashcms.data.MultiLoader;
	/**
	* ...
	* @author Default
	*/
	public class Header extends Module{
		
		private var oLoader:MultiLoader;
		public function Header() {
			super("Header");
		}
		
		public function init(){
			oLoader = new MultiLoader();
			
		}
	}
	
}