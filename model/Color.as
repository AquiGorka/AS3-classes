package com.aquigorka.model{
	
	public final class Color{
	
		// ------- Constructor -------
		public function Color(col:Number, bri:Number){
			// declaraciones
			num_color = col;
			num_brillo = bri;
		}
		
		//------- Properties --------
		private var num_color:Number;
		private var num_brillo:Number;
		
		// ------- Methods -------
		// Public
		public function convert_to_two_digit_hex_code_from_decimal(decimal:Number):String{
			var code = Math.round(decimal).toString(16);
			(code.length > 1) || (code = '0' + code);
			return code;
		}
		
		public function get_brightness_color():Number{
			var r:Number = extract_red(num_color);
			var g:Number = extract_green(num_color);
			var b:Number = extract_blue(num_color);
			var HSL:Array = rgb_to_hsl(r, g, b);
			var RGB:Array = hsl_to_rgb(HSL[0], HSL[1], num_brillo / 100);
			var rgbcode:String = '0x' + convert_to_two_digit_hex_code_from_decimal(RGB[0]) + convert_to_two_digit_hex_code_from_decimal(RGB[1]) + convert_to_two_digit_hex_code_from_decimal(RGB[2]);
			return Number(rgbcode);
		}
		
		public function get_brillo():Number{
			return num_brillo;
		}
		
		public function get_color():Number{
			return num_color;
		}
		
		public function get_color_16():String{
			return '0x'+num_color.toString(16).toUpperCase();
		}
		
		public function set_brillo(num:Number):void{
			num_brillo = num;
		}
		
		public function set_color(num:Number):void{
			num_color = num;
		}
		
		// Private
		private function extract_red(c:Number):Number{
			return ((c >> 16) & 0xFF);
		}

		private function extract_green(c:Number):Number{
			return ( (c >> 8) & 0xFF);
		}

		private function extract_blue(c:Number):Number{
			return (c & 0xFF);
		}
		
		function hsl_to_rgb(h:Number, s:Number, l:Number):Array{
			var r:Number, g:Number, b:Number;
			if(s == 0){
				r = g = b = l; // achromatic
			}else{
				var q:Number = l < 0.5 ? l * (1 + s) : l + s - l * s;
				var p:Number = 2 * l - q;
				r = hue_to_rgb(p, q, h + 1 / 3);
				g = hue_to_rgb(p, q, h);
				b = hue_to_rgb(p, q, h - 1 / 3);
			}
			return [r * 255, g * 255, b * 255];
		}
		
		private function hue_to_rgb(p:Number, q:Number, t:Number):Number{
			if(t < 0) t += 1;
			if(t > 1) t -= 1;
			if(t < 1/6) return p + (q - p) * 6 * t;
			if(t < 1/2) return q;
			if(t < 2/3) return p + (q - p) * (2/3 - t) * 6;
			return p;
		}
		
		private function rgb_to_hsl(r:Number, g:Number, b:Number):Array{
			r /= 255;
			g /= 255;
			b /= 255;
			var max:Number = Math.max(r, g, b);
			var min:Number = Math.min(r, g, b);
			var h:Number, s:Number, l:Number = (max + min) / 2;
			if(max == min){
				h = s = 0; // achromatic
			}else{
				var d:Number = max - min;
				s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
				switch(max){
					case r:
						h = (g - b) / d + (g < b ? 6 : 0);
						break;
					case g:
						h = (b - r) / d + 2;
						break;
					case b:
						h = (r - g) / d + 4;
						break;
				}
				h /= 6;
			}
			return [h, s, l];
		}
	}
}