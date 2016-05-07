package com.aquigorka.component{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class ComponentTextoBoton extends ComponentBoton{
	
		// ------- Constructor -------
		public function ComponentTextoBoton(col:Number, str:String, w:Number, h:Number, frm:TextFormat=null){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super(col);
			// declaraciones
			var t_format:TextFormat = new TextFormat();
			t_format.size = 14;
			t_format.color = 0x777777;
			if(frm){
				t_format = frm;
			}
			// instancias
			// texto
			texto = new TextField();
			texto.text = str;
			texto.wordWrap = true;
			texto.multiline = true;
			texto.width = w;
			texto.selectable = false;
			texto.setTextFormat(t_format);
			texto.defaultTextFormat = t_format;
			texto.height = texto.textHeight + 6;
			texto.y = h - texto.height - 2;
			// agregamos
			addChild(texto);
		}
		
		//------- Properties --------
		private var texto:TextField;
		
		// ------- Methods -------
		// Private
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			// stage
			removeChild(texto);
			// referencias
			texto = null;
		}
	}
}