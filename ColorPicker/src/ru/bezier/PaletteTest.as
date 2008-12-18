package ru.bezier {
	import flash.display.StageAlign;	
	import flash.display.StageScaleMode;	
	import flash.text.TextFieldType;	
	import flash.text.TextField;	
	
	import ru.bezier.ui.ColorPicker;
	import ru.bezier.ui.PaletteColor;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;		

	public class PaletteTest extends Sprite {

		private var gradientPalette : ColorPicker;
		private var safePalette : ColorPicker;
		private var targetBox : Sprite;
		private var sampleBox : Sprite;
		private var safePaletteTxt : TextField;
		private var gradientPaletteTxt : TextField;

		public function PaletteTest() {
			initStage();
			initInstance();
		}
		
		private function initStage() : void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}

		private function initInstance() : void {
			initGradientPalette();
			initSafePalette();
			initTargetBoxes();
		}

		private function initGradientPalette() : void {
			gradientPalette = new ColorPicker();
			gradientPalette.x = 10;
			gradientPalette.y = 30;
			
			addChild(gradientPalette);
			
			gradientPalette.addEventListener(MouseEvent.MOUSE_MOVE, onGradientPaletteMouseMove);
			gradientPalette.addEventListener(MouseEvent.MOUSE_UP, onGradientPaletteMouseUp);
			gradientPalette.height = 255;
			gradientPalette.width = 255;
			
			gradientPaletteTxt = createInput();
			gradientPaletteTxt.x = gradientPalette.x; 
			gradientPaletteTxt.y = 5;
			gradientPaletteTxt.text = gradientPalette.color.toString();
		}
		
		private function initSafePalette() : void {
			safePalette = new ColorPicker(true);
			safePalette.x = 280;
			safePalette.y = 30;
			
			addChild(safePalette);
			
			safePalette.addEventListener(MouseEvent.MOUSE_MOVE, onSafePaletteMouseMove);
			safePalette.addEventListener(MouseEvent.MOUSE_UP, onSafePaletteMouseUp);
			safePalette.width = 255;
			safePalette.keepAspectRatio = true;
			
			safePaletteTxt = createInput();
			safePaletteTxt.x = safePalette.x;
			safePaletteTxt.y = 5;
			safePaletteTxt.text = safePalette.color.toString(); 
		}
		
		private function onGradientPaletteMouseMove(event : MouseEvent) : void {
			setColor(targetBox, gradientPalette.color);
		}
		
		private function onSafePaletteMouseMove(event : MouseEvent) : void {
			setColor(targetBox, safePalette.color);
		}
		
		private function onGradientPaletteMouseUp(event : MouseEvent) : void {
			setColor(sampleBox, gradientPalette.color);
			gradientPaletteTxt.text = gradientPalette.color.toString();
			safePalette.outlineColor = gradientPalette.color.rgb;
		}

		private function onSafePaletteMouseUp(event : MouseEvent) : void {
			setColor(sampleBox, safePalette.color);
			safePaletteTxt.text = safePalette.color.toString();
		}
		
		private function setColor(target : Sprite, color : PaletteColor) : void {
			if (target != null && color != null) {
				target.transform.colorTransform = new ColorTransform(0, 0, 0, 0, color.red, color.green, color.blue, 255);
			}
		}

		private function createInput(handler:Function = null) : TextField {
			var outTxt : TextField = new TextField();
			outTxt.border = true;
			outTxt.type = TextFieldType.INPUT;
			outTxt.multiline = false;
			outTxt.height = 20;
			addChild(outTxt);
			if (handler != null) {
				// outTxt.addEventListener(Event., listener)
			}
			return outTxt;
		}
		
		private function initTargetBoxes() : void {
			sampleBox = new Sprite();
			sampleBox.graphics.beginFill(0, 1);
			sampleBox.graphics.drawRect(0, 0, 50, 100);
			sampleBox.x = 200;
			sampleBox.y = 300;
			
			targetBox = new Sprite();
			targetBox.graphics.beginFill(0, 1);
			targetBox.graphics.drawRect(0, 0, 50, 100);
			targetBox.x = 250;
			targetBox.y = 300;
			
			addChild(sampleBox);
			addChild(targetBox);
		}
	}
}
