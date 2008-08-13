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
		public var menuMode:String = "left";
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
				{target: this.mcMenu, constraint: BorderConstraints.LEFT, maintainAspectRatio: false },
				{target: this.hresizeHandle, constraint: BorderConstraints.LEFT},
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
			value = Math.max(MIN_WIDTH, value);
			mcHeader.height = value;
			resizeHandle.y = mcHeader.height;
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
			var value;
			if (menuMode == "right")
			{
				
				event.delta *= -1;
				value = Math.round(Math.min(2 * panel.width / 3, Math.max(0, hdragStartWidth + event.delta)));
				mcMenu.width = value;
				hresizeHandle.x = panel.width-value;
			}
			else
			{
				value= Math.min(2 * panel.width / 3, Math.max(0, hdragStartWidth + event.delta));
				value = Math.max(MIN_WIDTH, value);
				mcMenu.width = value;
				hresizeHandle.x = mcMenu.width;
			}
		}
	}
	
}