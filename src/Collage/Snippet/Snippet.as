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
			_model = new SnippetModel();
			reposition();
			_model.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, onModelChange );
		}
		
		public function get model():SnippetModel {return _model;}

		protected function onModelChange( event:PropertyChangeEvent):void
		{
			reposition();
		}
		
		protected function reposition() : void
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