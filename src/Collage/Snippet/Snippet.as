package Collage.Snippet
{
	import mx.containers.Box;
	import mx.containers.Canvas;
	import mx.events.PropertyChangeEvent;
	import mx.controls.Alert;

	public class Snippet extends Canvas
	{
		protected var _model:SnippetModel;
		private var _BorderBox:Canvas;
		
		public function Snippet()
		{
			super();
			CreateModel();
			_model.owner = this;
			_model.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, onModelChange );
			Reposition();
			_BorderBox = new Canvas();
			_BorderBox.setStyle("top", 0);
			_BorderBox.setStyle("left", 0);
			_BorderBox.setStyle("bottom", 0);
			_BorderBox.setStyle("right", 0);
			_BorderBox.setStyle("borderThickness", 2);
			_BorderBox.setStyle("borderColor", 0xff6600);
			_BorderBox.setStyle("borderStyle", "solid");
			_BorderBox.setStyle("borderAlpha", 0.3);
			_BorderBox.visible = false;
			addChild(_BorderBox);
		}
		
		public function get model():SnippetModel {return _model;}

		protected function CreateModel():void
		{
			_model = new SnippetModel();
		}

		protected function onModelChange( event:PropertyChangeEvent):void
		{
			Reposition();
			
			if (event && event.property == "selected")
			{
				if (_model.selected)
					_BorderBox.visible = true;
				else
					_BorderBox.visible = false;
			}
		}
		
		protected function Reposition() : void
		{
			drawFocus(false);
			x = _model.x;
			y = _model.y;
			width = _model.width;
			height = _model.height;
			rotation = _model.rotation;
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