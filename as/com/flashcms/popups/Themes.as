package com.flashcms.popups 
{
	import com.flashcms.core.Module;
	import com.flashcms.design.DynamicBG;
	import com.flashcms.components.ButtonBar;
	import com.flashcms.editors.utils.ThemeItem;
	import fl.containers.ScrollPane;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.flashcms.events.PopupEvent;
	import com.flashcms.layout.LayoutSchema;
	/**
	* ...
	* @author David Barrios
	*/
	public class Themes extends Module
	{
		private var oBG:DynamicBG;
		private var oBar:ButtonBar;
		private var oLayout:LayoutSchema;
		public var scPanel:ScrollPane;
		private var mcHolder:MovieClip;
		public function Themes() 
		{
			createBG();
		}
		public override function init()
		{
			oLayout = new LayoutSchema(this, 3, 50, 0);
			oLayout.defaultwidth = 150;
			oLayout.bChangeWidth = false;
			oLayout.xmargin = 10;
			oLayout.ymargin = 10;
			mcHolder = new MovieClip();
			addChild(mcHolder);
			scPanel.source = mcHolder;
	
			oBar = new ButtonBar(onSave, onCancel, "Cancel", "Save");
			oBar.x = 80;
			oBar.y = 270;
			addChild(oBar);
			gotoAndStop(2);
			createItems();
		}
		private function createItems()
		{
			for (var i = 0; i <= 10;i++){
				var item = new ThemeItem("test");
				var obj = mcHolder.addChild(item);
				oLayout.addComponent(obj, "","checkbox");
			}
			scPanel.update();
			
		}
		private function createBG()
		{
			oBG = new DynamicBG(550, new left(), new center(), new right());
			addChildAt(oBG,0);
		}
		private function onSave(e:Event)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{type:"yes"}));
		}
		private function onCancel(e:Event)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{type:"no"}));
		}
	}
	
}