package com.flashcms.layout{
	import fl.controls.Label;
	import com.flashcms.forms.ComponentTypes;
	import flash.display.Sprite;
	
	public class Layout{
		public var controller:Sprite;
		public var xmargin:int=40;
		public var ymargin:int=85;
		public var columns:int;
		public var yspacing:int;
		public var xspacing:int;
		public var total:int = 0;
		private var col:int = 0;
		private var row:int = 0;
		private var defaultwidth = 200;
		/**
		 * 
		 * @param	controller
		 * @param	columns
		 * @param	yspacing
		 * @param	xspacing
		 */
		
		function Layout(controller:Sprite,columns:int,yspacing:int,xspacing:int)
		{
			this.controller = controller;
			this.columns = columns;
			this.yspacing = yspacing;
			this.xspacing = xspacing;
		}
		
		/**
		 * 
		 * @param	component
		 */
		public function addComponent(component,title:String,type:String)
		{
			
			component.x = xmargin+(col*defaultwidth)+(xspacing*col);
			component.y = ymargin + (yspacing * row);
			if (requireLabel(type))
			createLabel(title,component.x,component.y-20);
			component.width = defaultwidth;
			
			if (col == columns -1)
			{
				col = 0;
				row++;
			}
			else
			{
				col++;
			}
		}
		/**
		 * 
		 * @param	title
		 * @param	xpos
		 * @param	ypos
		 */
		private function createLabel(title:String,xpos:Number,ypos:Number)
		{
			var oLabel:Label = new Label();
			oLabel.text = title;
			oLabel.x = xpos;
			oLabel.y = ypos;
			controller.addChild(oLabel);
		}
		/**
		 * 
		 * @param	type
		 */
		private function requireLabel(type:String)
		{
			switch(type)
			{
				case ComponentTypes.CheckBox:
					return false;
				break;
				default:
					return true;
				break;
			}
		}
	}
}