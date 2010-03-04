package Collage.Clips.GoogleMaps
{
	import Collage.Clip.*;
	
	public class GoogleMapsClip extends Clip
	{
		public function GoogleMapsClip(dataObject:Object = null)
		{
			moveFromCenter = true;
			super(dataObject);
			CreateView();
			CreateEditor();
		}

		public override function CreateView(newView:ClipView = null):void
		{
			if (newView)
				_View = newView;
			else {
				_View = new GoogleMapsClipView();
				_View.model = this;
			}
		}

		public override function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new GoogleMapsClipEditor();
				_Editor.model = this;
			}
		}
		
		public override function Resized():void
		{
		}

		public override function SaveToObject():Object
		{
			var newObject:Object = super.SaveToObject();

			newObject["type"] = "skeleton";

			return newObject;
		}

	}
}