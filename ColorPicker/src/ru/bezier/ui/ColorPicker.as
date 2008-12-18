package ru.bezier.ui {
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;	

	public class ColorPicker extends Sprite {

		//*****************************************************
		//			STATIC
		//*****************************************************

		private static const FIRST_COLUMN_COLORS : Array = [0, 0x333333, 0x666666, 0x999999, 0xCCCCCC, 0xFFFFFF, 0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0x00FFFF, 0xFF00FF];

		private static const RGB_COLORS : Array = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000];
		private static const RGB_ALPHAS : Array = [100, 100, 100, 100, 100, 100, 100];
		private static const RGB_RATIOS : Array = [0xFF / 6 * 0, 0xFF / 6 * 1, 0xFF / 6 * 2, 0xFF / 6 * 3, 0xFF / 6 * 4, 0xFF / 6 * 5, 0xFF / 6 * 6];

		private static const WHITE_BLACK_COLORS : Array = [0xFFFFFF, 0xFFFFFF, 0, 0];
		private static const WHITE_BLACK_ALPHAS : Array = [100, 0, 0, 100];
		private static const WHITE_BLACK_RATIOS : Array = [0, 0xFF / 2, 0xFF / 2, 0xFF];

		private static const GRADIENT_FILL_MATRIX : Matrix = function ():Matrix { 
			const matrix : Matrix = new Matrix();
			matrix.createGradientBox(0xFF, 0xFF / 2);
			return matrix;
		}();

		private static var WHITE_BLACK_FILL_MATRIX : Matrix = function ():Matrix { 
			const matrix : Matrix = new Matrix();
			matrix.createGradientBox(0xFF, 0xFF, 90 * Math.PI / 180);
			return matrix;
		}();

		//*****************************************************
		//			INSTANCE
		//*****************************************************

		private var highlighter : Highlighter;

		private var __keepAspectRatio : Boolean = false;
		private var __outlineColor : Number = 0x000000;

		//*****************************************************
		//			CONSTRUCTOR
		//*****************************************************
		
		/** 
		 * Creates object instance
		 * @param isSafe:Boolean - type of Palette instance
		 */
		public function ColorPicker(isSafe : Boolean = false) {
			safe = isSafe;
		}

		//*****************************************************
		//			PUBLIC
		//*****************************************************

		/** 
		 * Display mode
		 * true - web safe palette
		 * false - full color palette
		 */

		public function get safe() : Boolean {
			return highlighter != null;
		}

		public function set safe(value : Boolean) : void {
			const tempWidth : Number = super.width || Highlighter.PALETTE_WIDTH; 
			const tempHeight : Number = super.height || Highlighter.PALETTE_HEIGHT;
			if (value) {
				drawSafePalette();
			} else {
				drawGradientPalette();
			}
			super.width = tempWidth;
			super.height = tempHeight;
		}

		/**
		 * Palette color in current mouse position
		 */
		public function get color() : PaletteColor {
			const xMouse : Number = mouseX * scaleX;
			const yMouse : Number = mouseY * scaleY;

			if (xMouse < 0 || xMouse > width || yMouse < 0 || yMouse > height) {
				return new PaletteColor();
			}
			return safe ? getSafeColor() : getGradientColor();
		}

		/**
		 * If true keeps default aspect ratio 
		 */
		public function get keepAspectRatio() : Boolean {
			return __keepAspectRatio;
		}

		public function set keepAspectRatio(value : Boolean) : void {
			__keepAspectRatio = value;
			width = width;
		}

		/**
		 * Border lines color
		 */
		public function get outlineColor() : Number {
			return __outlineColor;
		}

		public function set outlineColor(value : Number) : void {
			__outlineColor = value;
			safe = safe;
		}

		override public function get width() : Number {
			return super.width;
		}

		override public function set width(value : Number) : void {
			super.width = value;
			if (__keepAspectRatio) {
				super.height = value * Highlighter.PALETTE_HEIGHT / Highlighter.PALETTE_WIDTH;
			}
		}

		override public function get height() : Number {
			return super.width;
		}

		override public function set height(value : Number) : void {
			super.height = value;
			if (__keepAspectRatio) {
				super.width = value * Highlighter.PALETTE_WIDTH / Highlighter.PALETTE_HEIGHT;
			}
		}

		//*****************************************************
		//			PRIVATE
		//*****************************************************

		private function getGradientColor() : PaletteColor {
			var redComponent : Number = 0;
			var greenComponent : Number = 0;
			var blueComponent : Number = 0;
			
			const positionX : Number = mouseX * (6 / 0xFF);
			const shiftX : Number = positionX - Math.floor(positionX);
			
			if (positionX < 1) {
				redComponent = 0xFF;
				greenComponent = 0xFF * shiftX;
				blueComponent = 0;
			}else if (positionX < 2) {
				redComponent = 0xFF * (1 - shiftX);
				greenComponent = 0xFF;
				blueComponent = 0;
			} else if (positionX < 3) {
				redComponent = 0; 
				greenComponent = 0xFF;
				blueComponent = 0xFF * shiftX;
			} else if (positionX < 4) {
				redComponent = 0;
				greenComponent = 0xFF * (1 - shiftX);
				blueComponent = 0xFF;
			} else if (positionX < 5) {
				redComponent = 0xFF * shiftX;
				greenComponent = 0;
				blueComponent = 0xFF;
			} else if (positionX < 6) {
				redComponent = 0xFF;
				greenComponent = 0;
				blueComponent = 0xFF * (1 - shiftX);
			}
			
			const positionY : Number = (0xFF / 2 - mouseY) / 0xFF * 2;
			if (positionY > 0) {
				redComponent += (0xFF - redComponent) * positionY;
				greenComponent += (0xFF - greenComponent) * positionY;
				blueComponent += (0xFF - blueComponent) * positionY;
			} else if (positionY < 0) {
				redComponent += redComponent * positionY;
				greenComponent += greenComponent * positionY;
				blueComponent += blueComponent * positionY;
			}
			return new PaletteColor(redComponent, greenComponent, blueComponent);
		}

		private function getSafeColor() : PaletteColor {
			var positionX : Number = Math.round((mouseX - Highlighter.ITEM_SIDE / 2) / Highlighter.ITEM_SIDE);
			var positionY : Number = Math.round((mouseY - Highlighter.ITEM_SIDE / 2) / Highlighter.ITEM_SIDE);
			if (positionX == 0) {
				const color : PaletteColor = new PaletteColor();
				color.rgb = FIRST_COLUMN_COLORS[positionY];
				return color;
			} else if (positionX == 20 || positionX == 1) {
				return new PaletteColor(0, 0, 0);
			}
			if (positionY < 6) {
				positionX -= 2;
			} else {
				positionX += 16;
				positionY -= 6;
			}
			const redComponent : int = (Math.floor(positionX / 6) * 0x33);
			const greenComponent : int = positionX % 6 * 0x33;
			const blueComponent : int = positionY * 0x33;
			
			return new PaletteColor(redComponent, greenComponent, blueComponent);
		}

		private function  drawGradientPalette() : void {
			if (highlighter != null) {
				removeChild(highlighter);
				highlighter = null;
			}
			
			graphics.clear();
			graphics.beginGradientFill(GradientType.LINEAR, RGB_COLORS, RGB_ALPHAS, RGB_RATIOS, GRADIENT_FILL_MATRIX);
			graphics.drawRect(0, 0, 255, 255);
			graphics.beginGradientFill(GradientType.LINEAR, WHITE_BLACK_COLORS, WHITE_BLACK_ALPHAS, WHITE_BLACK_RATIOS, WHITE_BLACK_FILL_MATRIX);
			graphics.drawRect(0, 0, 255, 255);
		}

		private function drawSafePalette() : void {
			if (highlighter == null) {
				highlighter = new Highlighter();
				addChild(highlighter);
			}

			graphics.clear();
			graphics.lineStyle(0, __outlineColor, 1);
			
			var positionX : Number = 0;
			var positionY : Number = 0; 
			for (var i : Number = 0;i < 12; i++) {
				positionY = i * Highlighter.ITEM_SIDE;
				graphics.beginFill(FIRST_COLUMN_COLORS[i]);
				graphics.drawRect(0, positionY, Highlighter.ITEM_SIDE, Highlighter.ITEM_SIDE);
			}
			
			const color : PaletteColor = new PaletteColor();
			for (i = 0;i < 12; i++) {
				for (var j : int = 0;j < 18; j++) {
					if (i > 5) {
						positionX = j + 18;
						positionY = i - 6;
					} else {
						positionX = j; 
						positionY = i;
					}

					color.red = Math.floor(positionX / 6) * 0x33;
					color.green = positionX % 6 * 0x33;
					color.blue = positionY * 0x33;
					graphics.beginFill(color.rgb);
					
					positionX = j * Highlighter.ITEM_SIDE; 
					positionY = i * Highlighter.ITEM_SIDE;
					graphics.drawRect(positionX + Highlighter.ITEM_SIDE * 2, positionY, Highlighter.ITEM_SIDE, Highlighter.ITEM_SIDE);
				}
			}
			graphics.beginFill(0x000000);
			for (i = 0;i < 12; i++) {
				graphics.drawRect(Highlighter.ITEM_SIDE, Highlighter.ITEM_SIDE * i, Highlighter.ITEM_SIDE, Highlighter.ITEM_SIDE);
			}
			for (i = 0;i < 12; i++) {
				graphics.drawRect(Highlighter.ITEM_SIDE * 20, Highlighter.ITEM_SIDE * i, Highlighter.ITEM_SIDE, Highlighter.ITEM_SIDE);
			}
		}
	}
}

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

class Highlighter extends Sprite {

	public static const ITEM_SIDE : uint = 10;
	public static const PALETTE_WIDTH : Number = ITEM_SIDE * 21;
	public static const PALETTE_HEIGHT : Number = ITEM_SIDE * 12;

	public function Highlighter() {
		initInstance();
	}

	private function initInstance() : void {
		graphics.lineStyle(0, 0xFFFFFF, 1);
		graphics.drawRect(0, 0, Highlighter.ITEM_SIDE, Highlighter.ITEM_SIDE);
		
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
	}

	
	private function onAddedToStage(event : Event) : void {
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		visible = false;
	}

	private function onRemovedFromStage(event : Event) : void {
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	}

	private function onMouseMove(event : MouseEvent) : void {
		if (parent.mouseX < 0 || parent.mouseY < 0 || parent.mouseX > (PALETTE_WIDTH - .01) || parent.mouseY > (PALETTE_HEIGHT - .01)) {
			visible = false;
			x = 0;
			y = 0;
			return; 
		}
		visible = true;
		x = Math.round((parent.mouseX - Highlighter.ITEM_SIDE / 2) / Highlighter.ITEM_SIDE) * Highlighter.ITEM_SIDE;
		y = Math.round((parent.mouseY - Highlighter.ITEM_SIDE / 2) / Highlighter.ITEM_SIDE) * Highlighter.ITEM_SIDE;
		event.updateAfterEvent();
	}
}
