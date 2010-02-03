package Collage.Document
{
	import Collage.Clip.*;
	
	public class Document extends Clip
	{
		private var _URL:String = null;
		private var _BackgroundColor:Number = 0xFFFFFF;

		[Bindable]
		public function get url():String {return _URL;}
		public function set url(url:String):void {_URL = url;}

		[Bindable]
		public function get backgroundColor():Number {return _BackgroundColor;}
		public function set backgroundColor(bgColor:Number):void {_BackgroundColor = bgColor;}
		
		public function Document()
		{
			super();
			height = 768;
			width = 1024;
			CreateEditor();
		}
		
		public function CreateEditView(newView:ClipView = null):void
		{
			if (newView)
				_View = newView;
			else {
				_View = new EditDocumentView();
				_View.model = this;
			}
		}

		public override function CreateView(newView:ClipView = null):void
		{
			if (newView)
				_View = newView;
			else {
				_View = new DocumentView();
				_View.model = this;
			}
		}

		public override function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new DocumentEditor();
				_Editor.model = this;
			}
		}

		public override function LoadFromData(data:Object):Boolean
		{
			var view:DocumentView = _View as DocumentView;
			return view.LoadFromData(data);
		}
	}
}