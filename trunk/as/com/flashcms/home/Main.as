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
		private var distanceY:int = 30;
		private var distanceX:int = 20;
		private var totalItems:int = 0;
		private var columns = 3;
		public function Main() {
			super("Main");
		}
		/**
		 * 
		 */
		override public function init()
		{
			trace("init main");
			for (var i in oShell.xMain)
			{
				var index:int = totalItems%columns;
				var oSection:SectionItem = new SectionItem(oShell.xMain[i]);
				oSection.x = initialX +((oSection.width+distanceX)*index);
				oSection.y = totalItems<columns? initialY : initialY+oSection.height+distanceY;
				addChild(oSection);
				totalItems++;
			}
		}
	}
	
}