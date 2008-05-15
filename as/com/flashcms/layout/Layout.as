package com.flashcms.layout{
	
	public class Layout{
		public var columns:int;
		public var yspacing:int;
		public var xspacing:int;
		public var total:int = 0;
		function Layout(columns:int,yspacing:int,xspacing:int)
		{
			this.columns = columns;
			this.yspacing = yspacing;
			this.xspacing = xspacing;
		}
		
		/**
		 * 
		 * @param	component
		 */
		public function addComponent(component)
		{
			
		}
	}
}