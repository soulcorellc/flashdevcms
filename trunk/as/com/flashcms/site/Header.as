package com.flashcms.site 
{
	import com.flashcms.data.MultiLoader;
	import com.flashcms.layout.StageManager;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import com.flashcms.events.LoadError;
	import com.flashcms.events.LoadEvent;
	import flash.display.LoaderInfo;
	/**
	* ...
	* @author David Barrios
	*/
	public class Header extends MovieClip 
	{
		public var sManager:StageManager;
		public var mcBackground:Sprite;
		public var txtTitle:TextField;
		private var oLogoLoader:MultiLoader;
		private var mcLogo:Bitmap;
		public function Header() 
		{
			sManager = new StageManager(this, 0, 0, 0, 0, true);
			oLogoLoader = new MultiLoader();
			oLogoLoader.addEventListener(LoadEvent.LOAD_EVENT, onLoadLogo);
			oLogoLoader.addEventListener(LoadError.LOAD_ERROR, onErrorLogo);
		}
		public function onLoadLogo(e:LoadEvent)
		{
			mcLogo = Bitmap(LoaderInfo(e.loaderTarget).loader.content);
			mcLogo.x = 10;
			mcLogo.y = 10;
			addChild(mcLogo);
		}
		public function onErrorLogo(e:LoadEvent)
		{
			
		}
		public function onResize(e:Event=null)
		{
			mcBackground.width = stage.stageWidth;	
		}
		public function setText(text:String)
		{
			txtTitle = new TextField();
			txtTitle.autoSize = TextFieldAutoSize.LEFT;
			
			txtTitle.htmlText = text;
			txtTitle.x = 100;
			txtTitle.y = 50;
			addChild(txtTitle);
		}
		public function setImage(url:String)
		{
			oLogoLoader.add(url);
			oLogoLoader.start();
		}
		
	}
	
}