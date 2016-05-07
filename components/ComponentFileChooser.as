package com.aquigorka.component{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	public class ComponentFileChooser extends EventDispatcher{
	
		// ------- Constructor -------
		public function ComponentFileChooser(cf_choose:Function, str:String = ''){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// declaraciones
			callback_function_choose = cf_choose;
			file_selected = false;
			str_titulo = str;
			file_filter = new FileFilter('*', '*');
		}
		
		//------- Properties --------
		public var file_filter:FileFilter;
		public var file_selected:Boolean;
		public var final_file:File;
		private var callback_function_choose:Function;
		private var str_titulo:String;
		
		// ------- Methods -------
		// Public
		public function choose_file():void {
			final_file = new File();
			try{final_file.browseForOpen(str_titulo, [file_filter]);final_file.addEventListener(Event.SELECT, handler_selected);final_file.addEventListener(Event.CANCEL, handler_canceled);
			}catch (error:Error){handler_canceled(new Event('cancelado'));}
		}
		
		// Private
		private function destroy(e:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function handler_canceled(event:Event):void{
			final_file.removeEventListener(Event.SELECT, handler_selected);
			final_file.removeEventListener(Event.CANCEL, handler_canceled);
			file_selected = false;
			final_file = null;
			callback_function_choose();
		}
		
		private function handler_selected(event:Event):void{
			final_file.removeEventListener(Event.SELECT, handler_selected);
			final_file.removeEventListener(Event.CANCEL, handler_canceled);
			file_selected = true;
			final_file = event.target as File;
			callback_function_choose();
		}
	}
}