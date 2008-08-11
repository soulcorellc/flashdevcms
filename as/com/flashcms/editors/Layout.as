package com.flashcms.editors 
{
	import com.flashcms.core.Module;
	import com.flashcms.events.PopupEvent;
	import com.yahoo.astra.fl.containers.BorderPane;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.yahoo.astra.layout.modes.BorderConstraints;
	import com.yahoo.example.views.ResizeHandle;
	import com.yahoo.example.events.DragEvent;
	import com.flashcms.layout.LayoutObject;
	/**
	* ...
	* @author David Barrios
	*/
	public class Layout extends Module
	{
		public var dragStartWidth:int;
		public var hdragStartWidth:int;
		public var mcHeader:Sprite;
		public var mcFooter:Sprite;
		public var mcMenu:Sprite;
		public var resizeHandle:ResizeHandle;
		public var hresizeHandle:ResizeHandle;
		public var config:Array;
		public var panel:BorderPane;
		public var MIN_WIDTH:int = 100;
		public var menuMode:String = "right";
		public function Layout() 
		{
			
		}
		/**
		 * 
		 */
		public override function init()
		{
			hresizeHandle = new ResizeHandle();
			hresizeHandle.direction = "horizontal";
			resizeHandle = new ResizeHandle();
			resizeHandle.direction = "vertical";
			resizeHandle.addEventListener(DragEvent.DRAG_START, resizeDragStartHandler);
			resizeHandle.addEventListener(DragEvent.DRAG_UPDATE, resizeDragUpdateHandler);
			hresizeHandle.addEventListener(DragEvent.DRAG_START, hresizeDragStartHandler);
			hresizeHandle.addEventListener(DragEvent.DRAG_UPDATE, hresizeDragUpdateHandler);
			config=[  
				{target: this.mcHeader, constraint: BorderConstraints.TOP},
				{target: this.resizeHandle, constraint: BorderConstraints.TOP },
				{target: this.mcMenu, constraint: BorderConstraints.RIGHT, maintainAspectRatio: false },
				{target: this.hresizeHandle, constraint: BorderConstraints.RIGHT},
				{target: this.mcFooter, constraint: BorderConstraints.BOTTOM}  
			];  	
			panel.configuration = config;
			panel.verticalGap = 5;
			
		}
		private function showPopup(e:Event)
		{
			oShell.showPopup("layout", null, onClosePopup);
		}
		private function onClosePopup(e:PopupEvent)
		{
		}
		function resizeDragStartHandler(event:DragEvent):void{
			dragStartWidth = mcHeader.height;
		}
		/**
		 * 
		 * @param	event
		 */
		function resizeDragUpdateHandler(event:DragEvent):void
		{
			var value = Math.min(2 * panel.height / 3, Math.max(0, dragStartWidth + event.delta));
			if(mcHeader.height> 50 || value> mcHeader.height){
				mcHeader.height = value;
				resizeHandle.y = mcHeader.height;
			}
			else
			{
				resizeHandle.y = 50;
			}
		}
		/**
		 * 
		 * @param	event
		 */
		function hresizeDragStartHandler(event:DragEvent):void{
			hdragStartWidth = mcMenu.width;
		}
		/**
		 * 
		 * @param	event
		 */
		function hresizeDragUpdateHandler(event:DragEvent):void
		{
			var value=Math.min(2 * panel.width/ 3, Math.max(0, hdragStartWidth + event.delta));
			if(mcMenu.width> MIN_WIDTH || value> mcMenu.width){
				if (menuMode == "right")
				{
					trace("value " + value);
					mcMenu.width = value;
					hresizeHandle.x = (panel.width-value) ;
				}
				else
				{
					mcMenu.width = value;
					hresizeHandle.x = mcMenu.width;
				}
			}
			else
			{
				hresizeHandle.x = MIN_WIDTH;
			
			}
		}
	}
	
}