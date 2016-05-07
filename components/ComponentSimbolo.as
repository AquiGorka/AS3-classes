package com.aquigorka.component{
	
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public final class ComponentSimbolo extends TextField{
	
		// ------- Constructor -------
		public function ComponentSimbolo(str:String='G',col:Number=0xFFFFFF,num_size:Number=20){
			// http://www.dncompute.com/blog/2008/07/17/graphicsutil-a-utility-class-for-drawing-arrows.html
			// este era el de las flechas, que es bueno pero este es mejor para lo que lo estaba usando
			// flechas - UXVW
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			font_pulsarjs = new Font_PulsarJS();
			formato = new TextFormat();
			selectable = false;
			embedFonts = true;
			antiAliasType = AntiAliasType.ADVANCED;
			formato.font = font_pulsarjs.fontName;
			formato.color = col;
			formato.size = num_size;
			defaultTextFormat = formato;
			text = str;
			width = num_size+5;
			height = num_size+5;
		}
		
		// ------- Properties -------
		private var font_pulsarjs:Font_PulsarJS;
		private var formato:TextFormat;
		
		// ------- Methods -------
		// Private
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			// referencias
			font_pulsarjs = null;
			formato = null;
		}
	}
}