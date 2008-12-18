package ru.bezier.ui {

	public class PaletteColor {

		public static function parse(value : String) : PaletteColor {
			var color : PaletteColor = new PaletteColor();
			var rgbNumber : Number = Number(value);
			
			if (value.substr(0, 2) == "0x") {
				if (!isNaN(rgbNumber)) {
					color.rgb = rgbNumber;
					return color;
				}
			}
			
			if (value.substr(0, 1) == "#") {
				rgbNumber = parseInt("0x" + value.substr(1));
				if (!isNaN(rgbNumber)) {
					color.rgb = rgbNumber;
					return color;
				}
			}
			
			rgbNumber = parseInt("0x"+value);
			if (!isNaN(rgbNumber)) {
				color.rgb = rgbNumber;
				return color;
			}
			
			rgbNumber = parseInt(value);
			if (!isNaN(rgbNumber)) {
				color.rgb = rgbNumber;
				return color;
			}
			return color;
		}

		private var redComponent : int = 0;
		private var greenComponent : int = 0;
		private var blueComponent : int = 0;

		public function PaletteColor(red : int = 0, green : int = 0, blue : int = 0) {
			redComponent = red;
			greenComponent = green;
			blueComponent = blue;
		}

		public function set rgb(value : int) : void {
			redComponent = value >> 16;
			greenComponent = (value ^ (redComponent << 16)) >> 8;
			blueComponent = (value ^ (redComponent << 16)) ^ (greenComponent << 8);
		}

		public function get rgb() : int {
			return redComponent << 16 | greenComponent << 8 | blueComponent;
		}

		public function get red() : int {
			return redComponent;
		}

		public function set red(value : int) : void {
			redComponent = value;
		}

		public function get green() : int {
			return greenComponent;
		}

		public function set green(value : int) : void {
			greenComponent = value;
		}

		public function get blue() : int {
			return blueComponent;
		}

		public function set blue(value : int) : void {
			blueComponent = value;
		}

		public function toString() : String {
			return "0x" + componentToString(red)+componentToString(green)+componentToString(blue);
		}

		private function componentToString(value:int) : String {
			var component:String = "00"+value.toString(16).toUpperCase();
			return component.substr(-2);
		}
	}
}
