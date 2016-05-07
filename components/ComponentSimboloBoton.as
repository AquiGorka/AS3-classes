package com.aquigorka.component{

	import com.aquigorka.component.ComponentBoton;
	import com.aquigorka.component.ComponentSimbolo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class ComponentSimboloBoton extends ComponentBoton{

		// ------- Constructor -------
		public function ComponentSimboloBoton(str_texto:String = '', col_select:Number = 0xFFFFFF, col_normal:Number = 0x000000, col_glow:Number=0x000000, w:Number=90, h:Number=40, hitareacolor:Number=0xEEEEEE, hitareaalpha:Number=.1, simbolsize:Number=35){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super(col_glow);
			// declaraciones
			color_selected = col_select;
			color_unselected = col_normal;
			// instancias
			// hitarea
			graphics.beginFill(hitareacolor, hitareaalpha);
			graphics.drawRoundRect(0, 0, w, h,20);
			graphics.endFill();
			// boton
			icon = new ComponentSimbolo(str_texto, color_unselected, simbolsize);
			icon.width = w;
			icon.y = -1 + (h - simbolsize) / 2;
			formato = icon.defaultTextFormat;
			formato.align = TextFormatAlign.CENTER;
			icon.setTextFormat(formato);
			// agregamos
			addChild(icon);
		}

		// ------- Properties -------
		private var icon:ComponentSimbolo;
		private var color_selected:Number;
		private var color_unselected:Number;
		private var formato:TextFormat;
		
		// ------- Methods -------
		// Public
		public function select():void{
			formato.color = color_selected;
			icon.setTextFormat(formato);
		}
		
		public function unselect():void {
			formato.color = color_unselected;
			icon.setTextFormat(formato);
		}
		
		// Private
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			// graphics
			graphics.clear();
			// stage
			removeChild(icon);
			// referencias
			icon = null;
		}
	}
}