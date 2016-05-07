package com.aquigorka.component{
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ComponentItemLista extends Sprite{
	
		// ------- Constructor -------
		public function ComponentItemLista(sid:String){
			// super
			super();
			// declaraciones
			id = sid;
		}
		
		//------- Properties --------
		public var id:String;
		public var index:int;
		public var callback_function_show_complete:Function;
		
		//------- Methods --------
		public function show():void{
			if(callback_function_show_complete != null){
				callback_function_show_complete(this);
			}
		}
	}
}