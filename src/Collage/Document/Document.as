package Collage.Document
{
	import Collage.Clip.*;
	
	public class Document extends Clip
	{
		private var _URL:String = null;

		[Bindable]
		public function get url():String {return _URL;}
		public function set url(url:String):void
		{
			_URL = url;
		}
		
		public function Document(editable:Boolean = true)
		{
			super();
			if (editable)
				CreateEditView();
			else
				CreateView();
			CreateEditor();
		}
		
		protected function CreateEditView():void
		{
			_View = new EditDocumentView();
			_View.model = this;
		}

		protected override function CreateView():void
		{
			_View = new DocumentView();
			_View.model = this;
		}

		protected override function CreateEditor():void
		{
			_Editor = new DocumentEditor();
			_Editor.model = this;
		}

		public override function LoadFromData(data:Object):Boolean
		{
			var view:DocumentView = _View as DocumentView;
			return view.LoadFromData(data);
		}
	}
}