package com.flashcms.home {
	/**
	* ...
	* @author Default
	*/
	import com.flashcms.core.Module;
	import com.flashcms.home.SectionItem;

	public class Main extends Module{
		private var initialX:int=10;
		private var initialY:int=10;
		private var distanceY:int = 85;
		private var totalItems:int=0;
		public function Main() {
			super("Main");
		}
		/**
		 * 
		 */
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