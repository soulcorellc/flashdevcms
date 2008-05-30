package com.flashcms.core {
	import com.flashcms.layout.StageManager;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.events.MouseEvent;
	/**
	* ...
	* @author David Barrios
	*/
	public class Module extends MovieClip {
		private var _oShell;
		private var oXML:XML; 
		public var sName:String;
		public var sManager:StageManager;
		public var parameters:Object;
		public var oLoader:LoaderInfo;
		
		public function Module(name:String=null) {
			sName = name;
		}
				
		public function getURL(name:String, section:String = null):String
		{
			return oShell.getURL(name, section);
			
		}
		
		public function init()
		{
			
		}
		
		public function onResize(event:Event)
		{
			
		}
		public function get oShell() {
			return _oShell; 
		};
		
		public function set oShell(value):void {
			_oShell = value;
		}
		public function show()
		{
			//var oTween:Tween = new Tween(this, "scaleX", Back.easeOut, .5, 1, 0.5, true);
			//new Tween(this, "scaleY", Back.easeOut, .5, 1, .5, true);
		
		}
		public function setData(data:String)
		{
		}

	}
	
}