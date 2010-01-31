package Collage.Snippet
{
	import mx.core.*;  
	import mx.containers.Box;
	import mx.containers.Canvas;
	import mx.managers.*;
	import mx.events.PropertyChangeEvent;
	import mx.controls.Alert;

	public class Snippet extends Canvas
	{
		protected var _model:SnippetModel;
		protected var _Editor:SnippetEditor;
		private var _BorderBox:Canvas;
		
		public function get editor():SnippetEditor {return _Editor;}
		public function get model():SnippetModel {return _model;}
		
		public function Snippet()
		{
			super();
			CreateModel();
			CreateEditor();
			_model.snippet = this;
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
		
		protected function CreateModel():void
		{
			_model = new SnippetModel();
		}

		protected function CreateEditor():void
		{
//			_Editor = new SnippetEditor();
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
		
		public function ShowEditor(parent:UIComponent):void
		{
			if (!_Editor || !parent)
				return;
			for (var i:uint = 0; i < parent.numChildren; i++)
				parent.removeChildAt(0);
				
			parent.addChild(_Editor);
		}
		
		public function HideEditor():void
		{
			
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