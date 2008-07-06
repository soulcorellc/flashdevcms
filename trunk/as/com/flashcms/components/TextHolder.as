package com.flashcms.components {
	import com.flashcms.components.ContentHolder;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.events.FocusEvent;
	/**
	* ...
	* @author Default
	*/
	public class TextHolder extends ContentHolder{
		public var txtMain:TextField;
		public function TextHolder(nwidth:int,nheight:int) {
			super("Text");
			setSize(nwidth, nheight);
			init();
			
		}
		private function init()
		{
			txtMain = new TextField();
			txtMain.text = "[Insert Text Here]";
			txtMain.width = this.width;
			txtMain.height = this.height;
			txtMain.addEventListener(FocusEvent.FOCUS_IN, onFocus);
			addChild(txtMain);
			txtMain.type = TextFieldType.INPUT;
			txtMain.wordWrap = true;
			txtMain.multiline = true;
		}
		private function onFocus(e:FocusEvent)
		{
			e.target.text = "";
			txtMain.removeEventListener(FocusEvent.FOCUS_IN, onFocus);
		}
		/**
		 * 
		 * @param	newwidth
		 * @param	newheight
		 */
		public function setSize(newwidth:int,newheight:int)
		{
			updateSize(newwidth, newheight);
			if (txtMain != null)
			{
				txtMain.width = this.width;
				txtMain.height = this.height;
			}
		}
		
		
	}
	
}