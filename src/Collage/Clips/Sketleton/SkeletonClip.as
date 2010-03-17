package Collage.Clips.ClipSkeleton
{
	import Collage.Clip.*;
	
	public class SkeletonClip extends Clip
	{
		public function LabelClip(dataObject:Object = null)
		{
			super(dataObject);
			type = "skeleton";
			CreateView(new SkeletonClipView());
			CreateEditor(new SkeletonClipEditor());
		}
	}
}