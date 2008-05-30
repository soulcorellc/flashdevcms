package com.flashcms.home {
	import com.flashcms.core.Module;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
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
		public function Footer() {
			super("Footer");
			mcBackground = new Sprite();
			oMessage = new OutputMessage();
			oMessage.x = 10;
			oMessage.y = 2;
		}
		public override function init()
		{
			draw();
			addChild(mcBackground);
			addChild(oMessage);
		}
		public override function setData(message:String)
		{
			oMessage.message.text = message;
		}
		private function draw()
		{
			mcBackground.graphics.clear();
			mcBackground.graphics.beginFill(0xCCCCCC);
			mcBackground.graphics.drawRect(0, 0, stage.stageWidth, 20);
			mcBackground.graphics.endFill();
			
		}
		public override function onResize(event:Event)
		{
			draw();
		}
		
	}
	
}