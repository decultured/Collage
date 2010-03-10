package Collage.Clips.ClipSkeleton
{
	import Collage.Clip.*;
	
	public class SkeletonClip extends Clip
	{
		public function LabelClip(dataObject:Object = null)
		{
			super(dataObject);
			CreateView(new SkeletonClipView());
			CreateEditor(new SkeletonClipEditor());
		}

		public override function SaveToObject():Object
		{
			var newObject:Object = super.SaveToObject();
			newObject["type"] = "skeleton";
			return newObject;
		}
	}
}