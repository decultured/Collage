package Collage.Clips.ClipSkeleton
{
	import Collage.Clip.*;
	
	public class SkeletonClip extends Clip
	{
		public function LabelClip(dataObject:Object = null)
		{
			super(dataObject);
			CreateView();
			CreateEditor();
		}

		public override function CreateView(newView:ClipView = null):void
		{
			if (newView)
				_View = newView;
			else {
				_View = new SkeletonClipView();
				_View.model = this;
			}
		}

		public override function CreateEditor(newEditor:ClipEditor = null):void
		{
			if (newEditor)
				_Editor = newEditor;
			else {
				_Editor = new SkeletonClipEditor();
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