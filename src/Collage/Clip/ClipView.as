package Collage.Clip
{
	import mx.core.*;  
	import mx.containers.Box;
	import mx.containers.Canvas;
	import mx.managers.*;
	import mx.events.PropertyChangeEvent;
	import flash.events.*;
	import mx.controls.Alert;

	public class ClipView extends Canvas
	{
		protected var _Model:Clip;
		protected var _BorderBox:Canvas;
		
		public function get model():Clip {return _Model;}
		public function set model(clip:Clip):void
		{
			_Model = clip;
			if (_Model) {
				_Model.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onModelChange);
				Reposition();
			}
			
			addEventListener(MouseEvent.CLICK, OnClick);
		}
		
		public function OnClick(event:MouseEvent):void {
			event.stopPropagation();
			event.stopImmediatePropagation();
		}
		
		public function ClipView()
		{
			super();
			_BorderBox = new Canvas();
			_BorderBox.setStyle("top", 0);
			_BorderBox.setStyle("left", 0);
			_BorderBox.setStyle("bottom", 0);
			_BorderBox.setStyle("right", 0);
			_BorderBox.setStyle("borderThickness", 1);
			_BorderBox.setStyle("borderColor", 0x0CCE60);
			_BorderBox.setStyle("borderStyle", "solid");
			_BorderBox.setStyle("borderAlpha", 0.3);
			_BorderBox.visible = false;
			addChild(_BorderBox);
		}
		
		protected function onModelChange(event:PropertyChangeEvent):void
		{
			Reposition();
			
			if (event && event.property == "selected")
			{
				if (_Model.selected) {
					if (getChildIndex(_BorderBox) < numChildren - 1)
						setChildIndex(_BorderBox, numChildren - 1);
					_BorderBox.visible = true;
				} else
					_BorderBox.visible = false;
			}
		}

		protected function Reposition():void
		{
			drawFocus(false);
			x = _Model.x;
			y = _Model.y;
			width = _Model.width;
			height = _Model.height;
			rotation = _Model.rotation;
		}
				
		public function LoadFromData(data:Object):Boolean
		{
			return false;
		}
		
		public function LoadFromXML():Boolean
		{
			return false;
		}
	}
}