﻿/*******************************************************************************STAGE LAYOUT MANAGER CLASS********************************************************************************Simple class that repositions objects passed to it when a stage resize event occurs.Sample useage:StageManager(target:InteractiveObject, xpos:int, ypos:int, displaceX:int, displaceY:int, useClipRegPoint:Boolean )var stageTest:StageManager = new StageManager(Black, 30, 100, 0, 90, true)Instance Vars - Via constructortarget:Instance of an interactive object you want to positionxpos:  X Postion on the stage as a PERCENTAGE of the stage where you want your object to sit - 0=hard left, 100 = full right etc. ypos:  Y Position on the stage as a PERCENTAGE of the stage Height where you want your object to sit - 0 = Top, 100  = full bottomdisplaceX: An offset value, as a PERCENTAGE of your clips Width. For instance, if you want your clip to sit at right of stage, minus its width, then this would be 100displaceY: An offset value, as a PERCENTAGE of your clips Height. For instance, if you want your clip to sit at bottom of stage, minus its width, then this would be 100useClipRegPoint:Boolean. TRUE means clip is positioned off its reg point, FALSE means its natural center (height/width) is used.Static Vars - Set via ClassuseMinStageSize: Boolean, for using the min size parameters. Use this if you want to stop responding to RESIZE events at a certain stage sizeXminSize: Integer, set if using useMinStageSizeYminSize: Integer, set if using useMinStageSizePass a value of 0 to both displacement vars if you want your clip to have no displacement. If no displacement is provided, then the clip is placed at centered on the desired xpos and ypos values. You can pass displacement values greater that 100%. Clips are positioned using a subtraction. So, if wanted a clip to sit off say the bottom of theusestage, then you would pass it a displacement Y value of 120 etc.Example Middle Stage Positionvar stageTest2:StageManager = new StageManager(Pink, 50, 50, 0,0, true)Example Bottom Middle Minus Clip Height Positionvar stageTest:StageManager = new StageManager(Black, 50, 100, 0, 100, false)Version 1.2; 04 March, 2008. Updated to take into account pensamente (off actionScript.orgs forums) suggestions. Some adjustments to script for performance.Addition of new variable for basing instance position off either regpoint or clips natural center.Added in a fix from user Freddy**************************************************************************************Made in 2008 by noponieshttp://www.blog.noponies.comTerms of usehttp://www.blog.noponies.com/terms-and-conditions**************************************************************************************/package com.flashcms.layout{	import flash.display.*;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	import flash.events.Event;	public class StageManager extends Sprite {		private var managedObject:InteractiveObject;		private var xAxis:int;		private var yAxis:int;		private var offSetX:int;		private var offSetY:int;		//set minimum size at which point elements stop being repositioned. This is a global setting!		private static  var XminSize:int = 400;		private static  var YminSize:int = 400;		private static  var useMinStageSize:Boolean = false;		private var yAmount:int;		private var xAmount:int;		private var useClipRegPoint:Boolean;				private var sName:String;		//constructor function		public function StageManager(target:InteractiveObject, xpos:int, ypos:int, displaceX:int, displaceY:int, useClipRegPoint:Boolean ) {			sName = target.name;			managedObject = target;			xAxis = xpos;			yAxis = ypos;			offSetX = displaceX;			offSetY = displaceY;			this.useClipRegPoint = useClipRegPoint;			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);//add listener for adding to stage, then we can access its properties		}		//set initial positions of clips		//if we are basing our clips pos off either its reg point or its natural center point derived by finding center of clip from width/height		//Here we calc stage dimensions as a %, if we are using an offset, it will be included here		//also this is a public function, call this function if your clip changes dimensions		public function setUpLayOut():void {						if (useClipRegPoint) {				yAmount = offSetY!=0 ? (managedObject.height*.01)*offSetY : 0;				xAmount = offSetX!=0 ? (managedObject.width*.01)*offSetX : 0;				setLayout();			} else {				yAmount = offSetY!=0 ? (managedObject.height*.01)*offSetY : managedObject.height*.5;				xAmount = offSetX!=0 ? (managedObject.width*.01)*offSetX : managedObject.width*.5;				setLayout();			}		}		//function reflows the cip if a resize event occurs		private function setLayout():void {			if (useMinStageSize) {				if (stage.stageWidth >= XminSize) {					managedObject.x = (stage.stageWidth * .01) * xAxis - xAmount;				}				if (stage.stageHeight >= YminSize) {					managedObject.y = (stage.stageHeight * .01) * yAxis - yAmount;				}				return;			}			//set the position of our objects			managedObject.x = Math.round(((stage.stageWidth*.01)*xAxis - xAmount));			managedObject.y = Math.round(((stage.stageHeight*.01) * yAxis - yAmount));		}		//resize listener		private function resizeListener(e:Event):void {			try{				setLayout();			}			catch (e:Error)			{				trace("resizeListener Error : " +e.message +" sName "+sName); 			}					}		//added to stage handler		private function addedToStageHandler(e:Event):void {			stage.scaleMode = StageScaleMode.NO_SCALE;			stage.align = StageAlign.TOP_LEFT;			stage.addEventListener(Event.RESIZE, resizeListener);			//call set up layout function			setUpLayOut();		}		public function remove()		{			stage.removeEventListener(Event.RESIZE, resizeListener);		}	}}