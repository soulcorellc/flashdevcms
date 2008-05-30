package com.flashcms.sections {
	import com.flashcms.core.Module;
	import flash.net.FileReferenceList;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.FileReference;
	/**
	* ...
	* @author Default
	*/
	public class Files extends Module{
		var fileRefList:FileReferenceList = new FileReferenceList();  
		public function Files() {
			init();
		}
		/**
		 * 
		 */
		public override function init()
		{
			fileRefList.addEventListener(Event.SELECT, selectHandler); 
			fileRefList.addEventListener(IOErrorEvent.IO_ERROR, onError); 
			//fileRefList.browse();  
		}
		/**
		 * 
		 * @param	event
		 */
		function selectHandler(event:Event):void  
		{  
			var request:URLRequest = new URLRequest("http://www.[yourdomain].com/upload/");  
			var file:FileReference;  
			var files:FileReferenceList = FileReferenceList(event.target);  
			var selectedFileArray:Array = files.fileList;  
			for (var i:uint = 0; i < selectedFileArray.length; i++)  
			{  
				file = FileReference(selectedFileArray[i]);  
				file.addEventListener(Event.COMPLETE, completeHandler); 
				file.addEventListener(IOErrorEvent.IO_ERROR, onError); 
				try  
				{  
				   file.upload(request);  
				}  
				catch (error:Error)  
				{  
					trace("Unable to upload files.");  
				}  
			}  
		}
		/**
		 * 
		 * @param	event
		 */
		function completeHandler(event:Event):void  
		{  
			trace("uploaded");  
		}  
		function onError(e:IOErrorEvent)
		{
			trace(e);
		}
	}
}