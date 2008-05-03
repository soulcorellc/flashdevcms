package com.flashcms.home {
	/**
	* ...
	* @author Default
	*/
	import com.flashcms.core.Module;
	import com.flashcms.home.SectionItem;

	public class Main extends Module{
		private var initialX:int=30;
		private var initialY:int=30;
		private var distanceY:int = 70;
		private var totalItems:int=0;
		public function Main() {
			super("Main");
		}
		override public function init()
		{
			
			for (var i in oShell.xMain)
			{
				var oSection:SectionItem = new SectionItem(oShell.xMain[i]);
				oSection.x = initialX;
				oSection.y = (distanceY* totalItems) + initialY;
				addChild(oSection);
				totalItems++;
			}
		}
	}
	
}