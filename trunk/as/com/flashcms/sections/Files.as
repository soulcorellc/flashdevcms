package com.flashcms.sections {
	import com.flashcms.core.Module;
	import com.flashcms.data.XMLLoader;
	import com.flashcms.events.ErrorEvent;
	import com.yahoo.astra.fl.controls.Tree;
	import fl.controls.List;
	import flash.net.FileFilter;
	import flash.net.FileReferenceList;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.FileReference;
	import fl.controls.Button;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;
	import com.flashcms.utils.FileUtil;
	import flash.text.TextField;
	import com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider;
	
	/**
	* ...
	* @author Default
	*/
	public class Files extends Module{
		public var btUpload:Button;
		public var lsOutput:List;
		private var fileRefList:FileReferenceList = new FileReferenceList();  
		private var aFileTypes:Array = new Array();
		public var treeFiles:Tree;
		public var btDelete:Button;
		public var btClear:Button;
		public var btUpdate:Button;
		public var txtSalida:TextField;
		public var oXMLLoader:XMLLoader;
		public var oXML:XML;
		public function Files() {
			//delete init 
			init();	
		}
		/**
		 * 
		 */
		public override function init()
		{
			aFileTypes.push(new FileFilter("Images", "*.jpg;*.gif;*.png"));
			aFileTypes.push(new FileFilter("Videos", "*.flv"));
			treeFiles.setRendererStyle("closedBranchIcon", folderClosedIcon);
			treeFiles.setRendererStyle("openBranchIcon", folderOpenIcon);
			treeFiles.setRendererStyle("leafIcon", fileIcon);
			
			fileRefList.addEventListener(Event.SELECT, selectHandler); 
			fileRefList.addEventListener(IOErrorEvent.IO_ERROR, onError); 
			btUpload.addEventListener(MouseEvent.CLICK, browseFiles); 
			btDelete.addEventListener(MouseEvent.CLICK, deleteFile);
			btUpdate.addEventListener(MouseEvent.CLICK, update);
			btClear.addEventListener(MouseEvent.CLICK, clearOutput); 
			lsOutput.iconField = "icon";
			update();
		}
		/**
		 * 
		 * @param	e
		 */
		private function onFiles(e:Event)
		{
			oXML = XML(e.target.data);
			var treeXML:XML = new XML(<node><node label='images'/><node label='videos'/></node>);
			
			for each(var oItem:XML in oXML.images)
			{
				treeXML.node[0].node += <node id ={oItem.size} label = {oItem.name} tipo='images'/> ;
			}
			
			for each(var oItemVideo:XML in oXML.videos)
			{
				treeXML.node[1].node += <node id ={oItemVideo.size} label = {oItemVideo.name} tipo='videos' /> ;
			}
			treeFiles.dataProvider = new TreeDataProvider(treeXML);
			treeFiles.openAllNodes();
		}
		/**
		 * 
		 * @param	e
		 */
		private function onErrorFiles(e:ErrorEvent)
		{
			trace(e.message);
		}
		/**
		 * 
		 * @param	e
		 */
		private function browseFiles(e:Event)
		{
			fileRefList.browse(aFileTypes);
			
		}
		private function deleteFile(e:Event)
		{
			
			if (treeFiles.selectedItem.tipo)
			{
				trace(treeFiles.selectedItem.tipo);	
				oXMLLoader = new XMLLoader("http://localhost:51511/files.ashx?action=delete&tipo="+treeFiles.selectedItem.tipo+"&filename="+treeFiles.selectedItem.label, onDelete,onErrorFiles);
			}
			
		}
		private function onDelete(e:Event)
		{
			update();
		}
		
		
		/**
		 * 
		 * @param	e
		 */
		private function update(e:Event=null)
		{
			oXMLLoader = new XMLLoader("http://localhost:51511/files.ashx?action=getall", onFiles,onErrorFiles);
		}
		private function clearOutput(e:Event)
		{
			//fileRefList.browse(aFileTypes);
			lsOutput.removeAll();
			
			
		}
		/**
		 * 
		 * @param	event
		 */
		function selectHandler(event:Event):void  
		{  
			
			//var request:URLRequest = new URLRequest("http://richboxcms.com/upload/uploader.ashx?action=get&tipo=images");  
			var file:FileReference;  
			var files:FileReferenceList = FileReferenceList(event.target);  
			var selectedFileArray:Array = files.fileList;  
			for (var i:uint = 0; i < selectedFileArray.length; i++)  
			{  
				file = FileReference(selectedFileArray[i]); 
				file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				file.addEventListener(Event.COMPLETE, completeHandler); 
				file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				file.addEventListener(IOErrorEvent.IO_ERROR, onError); 
				
				var type:String = FileUtil.getFileType(file.type);
				try  
				{  
					txtSalida.text = "Uploading " + file.name;
					file.upload(new URLRequest("http://localhost:51511/uploader.ashx?tipo="+type));  
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
		function completeHandler(e:Event):void  
		{  
			trace("loaded "+e.target);
			lsOutput.addItemAt( { label:"Uploaded : " + e.target.name, icon:"iconSuccess" }, 0);
			
		}  
		function onError(e:IOErrorEvent)
		{
			lsOutput.addItemAt({label:"Error uploading : "+e.target.name,icon:"iconError"},0);
		}
		function securityErrorHandler(e:SecurityErrorEvent){
			trace("securityErrorHandler "+e.text);
		}
		private function progressHandler(event:ProgressEvent):void {
            var file:FileReference = FileReference(event.target);
			var sLoaded:String = String(Math.round((event.bytesLoaded / event.bytesTotal)*100));
            //trace("progressHandler name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
			txtSalida.text = "Uploading " + file.name + " "+sLoaded+" %";
			//lsOutput.addItemAt({label:file.name +" : "+ event.bytesLoaded},0);
        }

	}
}