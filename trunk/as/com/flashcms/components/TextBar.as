package com.flashcms.components {
	import fl.accessibility.ComboBoxAccImpl;
	import fl.controls.ColorPicker;
	import fl.controls.ComboBox;
	import fl.controls.NumericStepper;
	import flash.display.Shape;
	import fl.controls.Button;
	import com.yahoo.astra.fl.containers.HBoxPane;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.yahoo.astra.layout.modes.*;
	import fl.events.ColorPickerEvent;
	import flash.text.Font;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	/**
	* ...
	* @author Default
	*/
	public class TextBar extends Sprite{
		public var controlsPanel:HBoxPane;
		public var txtText:TextField;
		public var oFormat:TextFormat;
		public var colorpicker:ColorPicker;
		public var cbSize:NumericStepper;
		public var cbFonts:ComboBox;
		public var xmlControls:XML =
		<data>
			<controls>
				<type>Bold</type>
				<icon>IconBold</icon>
			</controls>
			<controls>
				<type>Italic</type>
				<icon>IconItalic</icon>
			</controls>
			<controls>
				<type>Underline</type>
				<icon>IconUnderline</icon>
			</controls>
			<controls>
				<type>AlignLeft</type>
				<icon>IconAlignLeft</icon>
			</controls>
			<controls>
				<type>AlignCenter</type>
				<icon>IconAlignCenter</icon>
			</controls>
			<controls>
				<type>AlignRight</type>
				<icon>IconAlignRight</icon>
			</controls>
		</data>
		;
		/**
		 * 
		 */
		public function TextBar(field:TextField) {
			txtText = field;
			init();
			
		}
		private function init()
		{
			oFormat = new TextFormat();
			txtText.alwaysShowSelection = true;
			setToolBar(xmlControls.controls, controlsPanel, onClick);
		}
		/**
		 * 
		 * @param	e
		 */
		function onClick(e:Event)
		{
		
			switch(e.target.name)
			{
				case "Bold":
					oFormat.bold = !txtText.getTextFormat(txtText.selectionBeginIndex, txtText.selectionEndIndex).bold;
				break;
				case "Underline":
					oFormat.underline= !txtText.getTextFormat(txtText.selectionBeginIndex, txtText.selectionEndIndex).underline;
				break;
				case "Italic":
					oFormat.italic= !txtText.getTextFormat(txtText.selectionBeginIndex, txtText.selectionEndIndex).italic;
				break;
				case "AlignLeft":
					oFormat.align= TextFormatAlign.LEFT;
				break;
				case "AlignCenter":
					oFormat.align= TextFormatAlign.CENTER;
				break;
				case "AlignRight":
					oFormat.align= TextFormatAlign.RIGHT;
				break;
				case "Color":
					oFormat.color=ColorPickerEvent(e).color;
				break;
				case "Size":
					oFormat.size=e.target.value;
				break;
				case "Font":
					oFormat.font=cbFonts.selectedItem.data;
				break;
			}
			
			try
			{
				txtText.setTextFormat(oFormat, txtText.selectionBeginIndex, txtText.selectionEndIndex);
			}
			catch(e:Event)
			{
			
			}
			//trace(mytext.htmlText);
			//mytext.replaceSelectedText()
			//mytext.replaceSelectedText("<b>"+mytext.text.slice(mytext.selectionBeginIndex,mytext.selectionEndIndex)+"</b>")
			//trace(mytext.text.slice(mytext.selectionBeginIndex,mytext.selectionEndIndex));
			//mytext.htmlText=mytext.text;
			//trace("caretIndex:", mytext.caretIndex);
			//trace("selectionBeginIndex:", mytext.selectionBeginIndex);
			//trace("selectionEndIndex:", mytext.selectionEndIndex);
		}
		/**
		 * 
		 * @param	data
		 * @param	toolbar
		 * @param	callback
		 */
		private function setToolBar(data:XMLList,toolbar:HBoxPane,callback:Function)
		{
			for each(var component:XML in data)
			{
				var oButton:Button = new Button();
				oButton.useHandCursor = true;
				oButton.addEventListener(MouseEvent.MOUSE_DOWN, callback);
				oButton.width = 32;
				oButton.label = "";
				oButton.name = component.type;
				oButton.setStyle("upSkin", Shape);
				oButton.setStyle("icon", component.icon);
				toolbar.addChild(oButton);
			}
			toolbar.setStyle( "skin", "ToolbarSkin" ); 
			toolbar.horizontalAlign = HorizontalAlignment.CENTER;
			toolbar.verticalAlign = VerticalAlignment.MIDDLE;
			toolbar.verticalGap = 10;
			toolbar.horizontalGap = 10;
			colorpicker = new ColorPicker();
			colorpicker.setSize(18, 18);
			colorpicker.name = "Color";
			colorpicker.addEventListener(Event.CHANGE, onClick);
			toolbar.addChild(colorpicker);
			cbSize = new NumericStepper();
			cbSize.name = "Size";
			cbSize.maximum = 90;
			cbSize.minimum = 1;
			cbSize.stepSize = 0.5;
			cbSize.value = 12;
			cbSize.addEventListener(Event.CHANGE, onClick);
			toolbar.addChild(cbSize);
			cbFonts = new ComboBox();
			cbFonts.name = "Font";
			cbFonts.width = 200;
			var allFonts:Array = Font.enumerateFonts(true);
			var fontsArray:Array=new Array();
			allFonts.sortOn("fontName", Array.CASEINSENSITIVE);
			for (var i:int = 0; i < allFonts.length; i++)
			{
			    fontsArray.push(new String(allFonts[i].fontName));
			}
			cbFonts.dataProvider = new DataProvider(fontsArray);
			cbFonts.addEventListener(ListEvent.ITEM_CLICK, onClick);
			toolbar.addChild(cbFonts);
		}
		
		
		
	}
	
}