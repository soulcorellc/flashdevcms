package com.flashcms.popups {
	import com.flashcms.forms.FormData;
	import flash.events.Event;	
	import flash.display.DisplayObject;
	import com.flashcms.core.Module;
	import com.flashcms.events.ErrorEvent;
	import com.flashcms.layout.LayoutSchema;
	import com.flashcms.data.XMLLoader;
	import com.flashcms.forms.ComponentFactory;
	import com.flashcms.forms.ComponentData;
	import com.flashcms.components.ButtonBar;
	import com.flashcms.events.PopupEvent;
	import com.flashcms.forms.Validator;
	import com.flashcms.design.DynamicBG;
	import flash.text.TextField;
	/**
	* ...
	* @author Default
	*/
	public class Edit extends Module{
		private var oXMLLoader:XMLLoader;
		private var oXML:XML;
		private var oXMLSchema:XML;
		private var oLayout:LayoutSchema;
		private var oBar:ButtonBar;
		private var oForm:FormData;
		private var id:String;
		private var create:Boolean;
		private var option:String;
		private var oBG:DynamicBG;
		private var optiondata:String;
		private var idcolumn:String;
		private var datatable:String;
		//private var txtMessage:TextField;
		
		/**
		 * 
		 */
		public function Edit() {
			createBG();	
			oLayout = new LayoutSchema(this,2, 50, 70);
		}
		private function createBG()
		{
			oBG = new DynamicBG(550, new left(), new center(), new right());
			addChildAt(oBG,0);
		}
		/**
		 * 
		 */
		public override function init()
		{
			oForm = new FormData(parameters.table, parameters.section, parameters.requiredata, parameters.data);
			id = parameters.id;
			create = parameters.create;
			option = parameters.option;
			
			
			var urlschema:String = oShell.getURL("schema", oForm.section);
			new XMLLoader(urlschema, onXMLSchema, onErrorData, onError);
			
			oBar = new ButtonBar(send,close,"Save","Cancel");
			oBar.x = 40;
			oBar.y = 270;
			addChild(oBar);
		}
		/**
		 * 
		 * @param	event
		 */
		private function onXMLSchema(event:Event)
		{
			oXMLSchema = XML(event.target.data);
			
			optiondata = oXMLSchema.options.optiondata;
			idcolumn = oXMLSchema.options.idcolumn;
			datatable= oXMLSchema.options.datatable;
			
			if (oForm.requiredata)
			{
				var urldata = oShell.getURL("data", oForm.section);
				var objdata:Object = new Object();
				objdata.option = optiondata;
				objdata[idcolumn] = id;
				new XMLLoader(urldata, onXMLData, onErrorData, onError, objdata );
			}
			else
			{
				createForm();
			}
		}
		/**
		 * 
		 * @param	event
		 */
		private function onXMLData(event:Event)
		{
			oXML = (XML(event.target.data));
			
			createForm();
		}
		/**
		 * 
		 * @param	event
		 */
		private function onErrorData(event:ErrorEvent)
		{
			trace("ok xml but error");
		}
		/**
		 * 
		 */
		private function createForm()
		{
			
			for each(var component:XML in oXMLSchema[datatable].children())
			{
				var obj = addChild(ComponentFactory.getComponent(component));
				oLayout.addComponent(obj, component.@title, component.@type,component.@datafield,component.@required);
				
				if(oForm.requiredata && component.@ignoredata!="true"){
					ComponentData.setData(obj, component, XML(oXML[datatable][component.name()]) , oForm.data);
				}
				else
				{
					if (component.@type.toString()=="combobox")
					{
						
						ComponentData.setCombo(obj, oForm.data[component.@provider], "name");
					}
				}
			}
			
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function onError(e:Event)
		{
			trace("error loading xml file");
		}
		/**
		 * 
		 * @param	e
		 */
		private function send(e:Event)
		{
			if (oLayout.getIsValid())
			{
				txtMessage.text="Sending Form.."
				var formobject = oLayout.getFormObject();
				formobject.option = option;
				var urldata = oShell.getURL("data", oForm.section);
				
				new XMLLoader(urldata, onSaveData, onSaveError, onError, formobject);
			}
			else
			{
				txtMessage.text="Please correct the errors"
			}
		}
		private function onSaveData(e:Event)
		{
			close();
		}
		private function onSaveError(e:Event)
		{
			txtMessage.text="Error Saving." 
		}
		/**
		 * 
		 * @param	e
		 */
		private function close(e:Event=null)
		{
			dispatchEvent(new PopupEvent(PopupEvent.CLOSE));
		}
		
	}
	
}