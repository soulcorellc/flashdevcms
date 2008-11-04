package com.flashcms.components.menu 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import gs.TweenMax;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author David Barrios
	 */
	public class MenuItem extends MovieClip
	{
		public var sID:String;
		private var sLabel:String;
		private var nColor:Number;
		private var nW:Number;
		private var nH:Number;
		private var txtLabel:TextField;
		public var isOpen:Boolean=false;
		public var isLeaf:Boolean;
		public var mcArrow:MenuArrow;
		private var mcBackground:MovieClip;
		private var txtFormat:TextFormat;
		public var nLevel:Number;
		/**
		 * 
		 * @param	id
		 * @param	label
		 * @param	width
		 * @param	height
		 * @param	color
		 * @param	leaf
		 */
		public function MenuItem(id,label,width,height,color,leaf,level) 
		{
			mcBackground = new MovieClip();
			addChild(mcBackground);
			buttonMode = true;
			sID = id;
			sLabel = label;
			nW = width;
			nH = height;
			nColor = color;
			isLeaf = leaf;
			nLevel = level;
			init();
			createText();
			addEventListener(MouseEvent.ROLL_OVER, doRollOver);
			addEventListener(MouseEvent.ROLL_OUT, doRollOut);
		}
		/**
		 * 
		 * @param	e
		 */
		private function doRollOver(e:Event)
		{
			TweenMax.to(mcBackground, 0.2, { tint:0x003388 } );
		}
		/**
		 * 
		 * @param	e
		 */
		private function doRollOut(e:Event)
		{
			TweenMax.to(mcBackground, 0.2, { tint:0x00FFFF } );
		}
		/**
		 * 
		 */
		public function init()
		{
			mcBackground.graphics.beginFill(nColor, 1);
			mcBackground.graphics.drawRect(0, 0, nW, nH);
			mcBackground.graphics.endFill();
			if (!isLeaf)
			{
				mcArrow = new MenuArrow();
				mcArrow.x = 140;
				mcArrow.y = (height / 2) - (mcArrow.height/2);
				addChild(mcArrow);
			}
		}
		/**
		 * 
		 */
		public function createText()
		{
			txtFormat = new TextFormat("Verdana", 11, 0x000000);
			txtLabel = new TextField();
			txtLabel.x = 10;
			txtLabel.selectable = false;
			txtLabel.mouseEnabled = false;
			txtLabel.text = sLabel;
			txtLabel.setTextFormat(txtFormat);
			addChild(txtLabel);
		}
	}
	
}