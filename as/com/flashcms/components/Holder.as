﻿package com.flashcms.components {
	import com.yahoo.astra.fl.accessibility.EventTypes;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	import flash.events.Event;
	/**
	* ...
	* @author Default
	*/
	public class Holder extends Sprite{
		public var id:int;
		public var type:String;
		public var txtName:TextField;
		private var mcResize:Sprite;
		private var mcBackground:Sprite; 
		private var mcGuide:Sprite;
		private var isDraggable:Boolean;
		public function Holder(type:String,isDraggable:Boolean=false) {
			
			mcGuide = new Sprite();
			mcBackground = new Sprite();
			setSize(100, 100);
			addChildAt(mcBackground,0);
			this.type = type;
			txtName.text = type;
			var IconClass:Class = getDefinitionByName("Icon" + type) as Class;
			var icon:Sprite= new IconClass();
			icon.x = 6;
			icon.y = 6;
			addChild(icon);
			this.isDraggable = isDraggable;
			if(isDraggable){
				addChild(mcGuide);
				createResize();
			}
			else {
			
			}
			
		}
		public function setSize(newwidth:int,newheight:int)
		{
			mcBackground.graphics.clear();
			mcBackground.graphics.beginFill(0xF9F9F9, 1);
			mcBackground.graphics.lineStyle(1, 0xCCCCCC, 1);
			mcBackground.graphics.drawRect( 0, 0, newwidth, newheight);
			mcBackground.graphics.endFill();
			if (isDraggable){
				mcResize.x = this.width;
				mcResize.y = this.height;
			}
		}
		public function setDragable()
		{
			mcBackground.addEventListener(MouseEvent.MOUSE_DOWN, onTake);
		}
		
		private function onTake(e:MouseEvent)
		{
			dispatchEvent(new Event("Select"));
			this.startDrag();
			mcBackground.removeEventListener(MouseEvent.MOUSE_DOWN, onTake);
			mcBackground.addEventListener(MouseEvent.MOUSE_UP, onClick);
		}
		private function onClick(e:MouseEvent)
		{
			this.stopDrag();
			mcBackground.removeEventListener(MouseEvent.MOUSE_UP, onClick);
			setDragable();
			dispatchEvent(new Event("Resize"));
		}
		private function createResize()
		{
			mcResize = new Sprite();
			mcResize.graphics.clear();
			mcResize.graphics.beginFill(0x000000, 1);
			mcResize.graphics.lineStyle(1, 0x000000, 1);
			mcResize.graphics.drawRect( 0, 0, 4, 4);
			mcResize.graphics.endFill();
			mcResize.buttonMode = true;
			mcResize.useHandCursor= true;
			mcResize.x = 100;
			mcResize.y = 100
			mcResize.addEventListener(MouseEvent.MOUSE_DOWN, onResize);
			addChild(mcResize);
			
		}
		private function onResize(e:MouseEvent)
		{
			mcGuide.graphics.clear();
			mcGuide.graphics.lineStyle(0, 0x000000, 0.3);
			mcGuide.graphics.beginFill(0x000000, 0);
			mcGuide.graphics.drawRect( 0, 0, mcResize.x, mcResize.y);
			mcGuide.graphics.endFill();
		
			mcResize.startDrag();
			mcResize.addEventListener(Event.ENTER_FRAME, updateResize);
			mcResize.removeEventListener(MouseEvent.MOUSE_DOWN, onResize);
			mcResize.addEventListener(MouseEvent.MOUSE_UP, onStopResize);
		}
		private function onStopResize(e:MouseEvent)
		{
			mcGuide.graphics.clear();
			setSize(mcResize.x,mcResize.y);
			mcResize.stopDrag();
			mcResize.removeEventListener(MouseEvent.MOUSE_UP, onStopResize);
			mcResize.addEventListener(MouseEvent.MOUSE_DOWN, onResize);
			mcResize.removeEventListener(Event.ENTER_FRAME, updateResize);
			dispatchEvent(new Event("Resize"));
		}
		private function updateResize(e:Event)
		{
			mcGuide.width = mcResize.x;
			mcGuide.height = mcResize.y;
		}
		
		public function get realwidth()
		{
			return mcBackground.width;
		}
		public function get realheight()
		{
			return mcBackground.height;
		}
		
		
	}
	
}