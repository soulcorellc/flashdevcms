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
		public var sIDContent:String;
		public var isOpen:Boolean=false;
		public var isLeaf:Boolean;
		public var mcArrow:MenuArrow;
		public var nLevel:Number;
		public var sLabel:String;
		private var nColor:Number;
		private var nW:Number;
		private var nH:Number;
		private var txtLabel:TextField;
		private var mcBackground:MovieClip;
		private var txtFormat:TextFormat;
		private var xmlColors:XML;
		private var colormenuup:int;
		private var colormenuover:int;
		private var colormenutextup:int;
		private var colormenutextover:int;
		
		/**
		 * 
		 * @param	id
		 * @param	label
		 * @param	width
		 * @param	height
		 * @param	color
		 * @param	leaf
		 */
		public function MenuItem(id,idcontent,label,width,height,leaf,level,colors) 
		{
			
			mcBackground = new MovieClip();
			addChild(mcBackground);
			buttonMode = true;
			sID = id;
			sIDContent = idcontent;
			sLabel = label;
			nW = width;
			nH = height;
			xmlColors= colors;
			isLeaf = leaf;
			nLevel = level;
			setColors();
			init();
			createText();
			addEventListener(MouseEvent.ROLL_OVER, doRollOver);
			addEventListener(MouseEvent.ROLL_OUT, doRollOut);
		}
		private function setColors()
		{
			colormenuup = nLevel == 0? xmlColors.menu_up:xmlColors.submenu_up;
			colormenuover = nLevel == 0? xmlColors.menu_over:xmlColors.submenu_over;
			colormenutextup = nLevel == 0? xmlColors.menu_uptext:xmlColors.submenu_textup;
			colormenutextover= nLevel == 0? xmlColors.menu_overtext:xmlColors.submenu_textover;
			
		}
		/**
		 * 
		 * @param	e
		 */
		private function doRollOver(e:Event)
		{
			TweenMax.to(mcBackground, 0.2, { tint:colormenuover} );
			txtFormat.color = colormenutextover;
			txtLabel.setTextFormat(txtFormat);
		}
		/**
		 * 
		 * @param	e
		 */
		private function doRollOut(e:Event)
		{
			TweenMax.to(mcBackground, 0.2, { tint:colormenuup} );
			txtFormat.color = colormenutextup;
			txtLabel.setTextFormat(txtFormat);
		}
		/**
		 * 
		 */
		public function init()
		{
			mcBackground.graphics.beginFill(colormenuup, 1);
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
			txtFormat = new TextFormat(new fVerdana().fontName, 10, colormenutextup);
			txtLabel = new TextField();
			txtLabel.x = 10;
			txtLabel.selectable = false;
			txtLabel.mouseEnabled = false;
			txtLabel.text = sLabel;
			txtLabel.setTextFormat(txtFormat);
			txtLabel.embedFonts = true;
			addChild(txtLabel);
		}
	}
	
}