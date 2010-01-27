package Collage.Snippet
{
	import mx.containers.Canvas;
	import mx.events.PropertyChangeEvent;
	import mx.controls.Alert;

	public class Snippet extends Canvas
	{
		protected var _model:SnippetModel;
		
		public function Snippet()
		{
			super();
			CreateModel();
			_model.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, onModelChange );
			Reposition();
		}
		
		public function get model():SnippetModel {return _model;}

		protected function CreateModel():void
		{
			_model = new SnippetModel();
		}

		protected function onModelChange( event:PropertyChangeEvent):void
		{
			Reposition();
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
	}
}