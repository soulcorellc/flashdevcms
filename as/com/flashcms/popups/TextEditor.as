package com.flashcms.popups {
	import com.flashcms.components.TextBar;
	import com.flashcms.core.Module;
	import fl.controls.Button;
	import flash.text.TextField;
	import com.flashcms.design.DynamicBG;
	import flash.events.MouseEvent;
	import com.flashcms.events.PopupEvent;
	/**
	* ...
	* @author Default
	*/
	public class TextEditor extends Module {
		public var txtTitle:TextField;
		public var mcEditor:TextBar;
		public var btSave:Button;
		public var btCancel:Button;
		private var oBG:DynamicBG;
		public function TextEditor() {
			createBG();	
		}
		private function createBG()
		{
			oBG = new DynamicBG(400, new left(), new center(), new right());
			addChildAt(oBG,0);
		}
		public override function init()
		{
			
			txtTitle.htmlText= parameters.text;
			mcEditor.txtText = txtTitle;
			mcEditor.init();
			btSave.addEventListener(MouseEvent.CLICK, onSave);
			btCancel.addEventListener(MouseEvent.CLICK, onCancel);
		}
		private function onSave(e:MouseEvent)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{saved:true,text:txtTitle.htmlText}));
		}
		private function onCancel(e:MouseEvent)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE,{saved:false}));
		}
		
	}
	
}