package com.flashcms.components {
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	/**
	* ...
	* @author Default
	*/
	public class TextEditor {
		public var txtText:TextField;
		/**
		 * 
		 */
		public function TextEditor() {
			txtText.alwaysShowSelection = true;
			
		}
		/**
		 * 
		 * @param	e
		 */
		function onClick(e:Event)
		{
			var txtFormat:TextFormat=txtText.getTextFormat(txtText.selectionBeginIndex,txtText.selectionEndIndex);
			txtFormat.bold=!txtFormat.bold;
			txtFormat.underline=!txtFormat.bold;
			mytext.setTextFormat(txtFormat,txtText.selectionBeginIndex,txtText.selectionEndIndex);
			
			//trace(mytext.htmlText);
			//mytext.replaceSelectedText()
			//mytext.replaceSelectedText("<b>"+mytext.text.slice(mytext.selectionBeginIndex,mytext.selectionEndIndex)+"</b>")
			//trace(mytext.text.slice(mytext.selectionBeginIndex,mytext.selectionEndIndex));
			//mytext.htmlText=mytext.text;
			//trace("caretIndex:", mytext.caretIndex);
			//trace("selectionBeginIndex:", mytext.selectionBeginIndex);
			//trace("selectionEndIndex:", mytext.selectionEndIndex);

		}
		
	}
	
}