package com.flashcms.layout{
	import fl.controls.Label;
	import com.flashcms.forms.ComponentTypes;
	import flash.display.Sprite;
	
	public class LayoutSchema{
		public var controller:Sprite;
		public var xmargin:int=40;
		public var ymargin:int=85;
		public var columns:int;
		public var yspacing:int;
		public var xspacing:int;
		public var total:int = 0;
		private var col:int = 0;
		private var row:int = 0;
		public var defaultwidth = 200;
		public var bChangeWidth:Boolean=true;
		private var aComponents:Array;
		/**
		 * 
		 * @param	controller
		 * @param	columns
		 * @param	yspacing
		 * @param	xspacing
		 */
		
		function LayoutSchema(controller:Sprite,columns:int,yspacing:int,xspacing:int)
		{
			this.controller = controller;
			this.columns = columns;
			this.yspacing = yspacing;
			this.xspacing = xspacing;
			aComponents = new Array();
		}
		
		/**
		 * 
		 * @param	component
		 */
		public function addComponent(component,title:String,type:String,datafield:String=null,required:String=null)
		{
			aComponents.push({object:component,type:type,datafield:datafield,required:required,title:title});
			component.x = xmargin+(col*defaultwidth)+(xspacing*col);
			component.y = ymargin + (yspacing * row);
			if (requireLabel(type))
			{
				createLabel(title, component.x, component.y - 20);	
			}
			else
			{
				component.label = title;
			}
			if (bChangeWidth)
			{
				component.width = defaultwidth;
			}
			if (col == columns -1)
			{
				col = 0;
				row++;
			}
			else
			{
				col++;
			}
		}
		/**
		 * 
		 * @return
		 */
		public function getIsValid():Boolean
		{
			var valid:Boolean=true;
			for (var i in aComponents)
			{
				
				if (aComponents[i].required == "true")
				{
					
					switch (aComponents[i].type)
					{
						case ComponentTypes.Textfield:
						if(aComponents[i].object.text==""){
							aComponents[i].object.textField.border = true;	
							aComponents[i].object.textField.borderColor = 0x800101;
							valid = false;
						}
						else
						{
							aComponents[i].object.textField.border = false;	
						}
						break;
					}		
				}
			}
			return valid;
		}
		/**
		 * 
		 * @param	title
		 * @param	xpos
		 * @param	ypos
		 */
		private function createLabel(title:String,xpos:Number,ypos:Number)
		{
			var oLabel:Label = new Label();
			oLabel.text = title;
			oLabel.x = xpos;
			oLabel.y = ypos;
			controller.addChild(oLabel);
		}
		/**
		 * 
		 * @param	type
		 */
		private function requireLabel(type:String)
		{
			switch(type)
			{
				case ComponentTypes.CheckBox:
				case ComponentTypes.Theme:
					return false;
				break;
				default:
					return true;
				break;
			}
		}
		/**
		 * 
		 * @return
		 */
		public function getFormObject():Object
		{
			var formobj:Object = new Object();
			for (var i in aComponents)
			{
				var name=aComponents[i].object.name;
				switch (aComponents[i].type)
				{
					case ComponentTypes.Textfield:
						formobj[name] = aComponents[i].object.text;
					break;
					case ComponentTypes.CheckBox:
						formobj[aComponents[i].object.name] =  aComponents[i].object.selected? 1 : 0;
					break;
					case ComponentTypes.ComboBox:
						formobj[aComponents[i].object.name] =  aComponents[i].object.selectedItem[aComponents[i].datafield];
					break;
					case ComponentTypes.Theme:
						formobj[aComponents[i].object.name] = aComponents[i].object.cPicker.selectedColor;
					break;
						
				}
			}
			return formobj;
		}
		public function getFormArray():Array
		{
			var formobj:Array = new Array();
			for (var i in aComponents)
			{
				var name=aComponents[i].object.name;
				switch (aComponents[i].type)
				{
					case ComponentTypes.CheckBox:
					if (aComponents[i].object.selected)
					{
						formobj.push(aComponents[i].object.name);
					}
					break;	
				}
			}
			return formobj;
		}
		/**
		 * 
		 * @param	aValues
		 */
		public function setValues(aValues:Array)
		{
			for (var i in aValues)
			{
				getComponent(aValues[i]).selected = true;
			}
		}
		/**
		 * 
		 * @param	name
		 */
		public function getComponent(name:String)
		{
			for (var x in aComponents)
			{
				if (aComponents[x].object.name == name)
				{
						return aComponents[x].object;
				}
			}
			return null;
		}
	}
}