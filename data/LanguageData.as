package com.aquigorka.data{
	
	import com.aquigorka.interfaces.InterfaceBusinessLogic;
	import logic.BusinessLogic;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public final class LanguageData{
		
		// ------- Constructor -------
		public function LanguageData(ref_obl:InterfaceBusinessLogic, str_folder:String){
			language_data = [];
			aux_str = '';
			referencia_obl = ref_obl;
			string_folder = str_folder;
		}

		// ------- Properties -------
		private var language_data:Array;
		private var string_folder:String;
		private var aux_str:String;
		private var referencia_obl:InterfaceBusinessLogic;
		private var loader:URLLoader;
		
		// ------- Methods -------
		// Public
		public function get_language_data(string_seccion:String):Array{
			if(language_data[string_seccion] != undefined){
				return language_data[string_seccion];
			}
			return ([]);
		}
		
		public function get_language_data_seccion(string_seccion:String):Array{
			if(language_data[string_seccion] != undefined && language_data[string_seccion]['seccion'] != undefined){
				return language_data[string_seccion]['seccion'];
			}
			return ([]);
		}
		
		public function load_data(str_idioma:String):void{
			language_data = [];
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, init,false,0,true);
			loader.load(new URLRequest(string_folder + str_idioma + '.xml'));
		}
		
		// Private
		private function init(event:Event):void{
			loader.removeEventListener(Event.COMPLETE, init);
			loader = null;
            language_data = parse(new XMLList(event.target.data), []);
			referencia_obl.init();
        }
		
		private function parse(xml_list:XMLList,arreglo:Array):Array{
			for each (var xml_item:XML in xml_list.children()){
				if (xml_item.children().length() > 0 && xml_item.children().children().length() > 0){
					aux_str = '' + xml_item.name();
					aux_str = aux_str.replace('Indice_', '');
					arreglo[aux_str] = [];
					parse(XMLList(xml_item), arreglo[aux_str]);
				} else{
					aux_str = replace_strings(xml_item.valueOf());
					arreglo[xml_item.name()] = aux_str;
				}
			}
			return arreglo;
		}
		
		private function replace_strings(str_inicial:String):String{
			var aux_str:String = str_inicial;
			while(aux_str.indexOf('_ampersand_') > -1){
				aux_str = aux_str.replace('_ampersand_', '&');
			}
			while(aux_str.indexOf('_abre_bold_') > -1){
				aux_str = aux_str.replace('_abre_bold_', '<b>');
			}
			while(aux_str.indexOf('_cierra_bold_') > -1){
				aux_str = aux_str.replace('_cierra_bold_', '</b>');
			}
			while(aux_str.indexOf('_salto') > -1){
				aux_str = aux_str.replace('_salto_', '\n');
			}
			return aux_str;
		}
	}
}