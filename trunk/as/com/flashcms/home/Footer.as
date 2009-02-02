package com.flashcms.home {
	import com.flashcms.core.Module;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import com.flashcms.design.DynamicBG;
	/**
	* ...
	* @author Default
	*/
	public class Footer extends Module{
		/**
		 * Class Constructor
		 */
		private var mcBackground:Sprite;
		private var oMessage;
		private var oBG:DynamicBG;
		public function Footer() {    
			super("Footer");
			
		}
		private function createBG()
		{
			oBG = new DynamicBG(stage.stageWidth, new left(), new center(), new right());
			addChildAt(oBG,0);
		}
		public override function init()
		{
			createBG();
			oMessage = new OutputMessage();
			oMessage.x = 10;
			oMessage.y = 5;
			addChild(oMessage);
		}
		public override function setData(message:String)
		{
			oMessage.message.text = message;
		}
		public function showMessage(message)
		{
			
		}
		public override function dispose()
		{
			removeChild(oBG);
			removeChild(oMessage);
			oMessage = null;
			
		}
		
		public override function onResize(event:Event)
		{
			oBG.update(stage.stageWidth);
		}
		
		
	}
	
}