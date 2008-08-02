package com.flashcms.popups 
{
	import com.flashcms.core.Module;
	import com.flashcms.design.DynamicBG;
	/**
	* ...
	* @author David Barrios
	*/
	public class About extends Module
	{
		private var oBG:DynamicBG;
		public function About() 
		{
			createBG();
		}
		
		private function createBG()
		{
			oBG = new DynamicBG(350, new left(), new center(), new right());
			addChildAt(oBG,0);
		}
	}
	
}