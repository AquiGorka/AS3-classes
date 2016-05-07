package com.aquigorka.component{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class ComponentItemComboBox extends ComponentItemListaBoton{
	
		// ------- Constructor -------
		public function ComponentItemComboBox(sid:String, str:String, i:int, col:Number=0xFFFFFF){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super(sid,col);
			// declaraciones
			index = i;
			string = str;
			// instancias
			// label
			label = new TextField();
			label.text = str;
			label.selectable = false;
			label.height = label.textHeight + 4;
			// agregamos
			addChild(label);
		}
		
		//------- Properties --------
		public var string:String;
		public var label:TextField;
		public var index:int;
		
		// ------- Methods -------
		// Private
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			// stage
			removeChild(label);
			// referencias
			label = null;
		}
	}
}