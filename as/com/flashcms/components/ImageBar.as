package com.flashcms.components {
	import fl.controls.Button;
	import fl.controls.TextInput;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.flashcms.components.FileExplorer;
	
	/**
	* ...
	* @author Default
	*/
	public class ImageBar extends ToolBar{
		private var sURL:String;
		public var txtURL:TextInput;
		public var btChange:Button;
		public var btSelect:Button;
		public var component;
		private var sURLFiles:String;
		private var sURLMedia:String;
		private var mcFileExplorer:FileExplorer;
		/**
		 * 
		 * @param	url
		 */
		public function ImageBar(component:Object,url:String,mediaurl:String) {
			sURLFiles = url;
			sURLMedia = mediaurl;
			this.component=component
			sURL = component["sURL"];
			init();
			
		}
		/**
		 * 
		 */
		public function init()
		{
			mcFileExplorer = new FileExplorer(sURLFiles, sURLMedia);
			mcFileExplorer.addEventListener(Event.CHANGE, onChangeImage);
			addChild(mcFileExplorer);
			mcFileExplorer.x = 14;
			mcFileExplorer.y = 85;
			mcFileExplorer.init(350,162);
			txtURL.text = sURL;
			trace(mcFileExplorer);
			btChange.addEventListener(MouseEvent.CLICK, onChange);
		} 
		public function onChangeImage(e:Event)
		{
			txtURL.text= FileExplorer(e.target).getSelectedURL();
		}
		private function onChange(e:MouseEvent)
		{
			component.sURL = txtURL.text;
			component.update();
		}
		
	}
	
}