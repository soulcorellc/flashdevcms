package com.flashcms.home {
	import com.flashcms.core.Module;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import com.flashcms.design.DynamicBG;
	import flash.utils.Timer;
	import gs.TweenMax;
	import flash.events.TimerEvent;
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
		private var mcWindow:MovieClip;
		private var oTimer:Timer;
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
		public function showMessage(message:String,duration:int=3000)
		{
			oTimer = new Timer(duration,1);
			oTimer.addEventListener(TimerEvent.TIMER, hideWindow);
			oTimer.start();
			mcWindow = new Window();
			mcWindow.y = -115;
			mcWindow.x = stage.stageWidth - 285;
			mcWindow.alpha = 0;
			addChild(mcWindow);
			TweenMax.to(mcWindow, 0.5, { alpha:1 } );
			mcWindow.txtTitle.htmlText= message;
		}
		public function hideWindow(e:TimerEvent)
		{
			TweenMax.to(mcWindow, 0.5, { alpha:0 } );
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