package com.flashcms.core {
	import com.flashcms.Shell;
	import flash.display.MovieClip;

	/**
	* ...
	* @author David Barrios
	*/
	public class Module extends MovieClip {
		public var sName:String;
		
		public function Module(name:String=null) {
			sName = name;
		}
		public function start(object)
		{
			var x:Shell = object;
			trace(x.getURL("main","home"));
		}
				
	}
	
}