import flash.display.*;
import flash.geom.*;
import flash.events.*;
import mx.events.*;

public function set Title(title:String):void { if (_ControlBar && _ControlBar.SnippetControlBarTitle) _ControlBar.SnippetControlBarTitle.text = title; _Title = title;}
public function get Title():String {return _Title;}

private var _ControlBar:SnippetControlBar = new SnippetControlBar();
private var _StatusBar:SnippetStatusBar = new SnippetStatusBar();
private var _Title:String = "Snippet";
private var _Dragging:Boolean = false;

public function Initialize():void
{
//	Title = "Collage Snippet";
//	addEventListener(MoveEvent.MOVE, Move);
	addEventListener(MouseEvent.ROLL_OVER, ShowUI);
	addEventListener(MouseEvent.ROLL_OUT, HideUI);
	
	addChild(_ControlBar);
	_ControlBar.visible = false;
	addChild(_StatusBar);
	_StatusBar.visible = false;

	Title = _Title;
}

public function ShowUI(event:Event):void
{
//	Title = _Title;
	_ControlBar.visible = true;
	_StatusBar.visible = true;
	addEventListener(MouseEvent.MOUSE_MOVE, Move);
	_ControlBar.addEventListener(MouseEvent.MOUSE_DOWN, StartDragging);
	_ControlBar.addEventListener(MouseEvent.MOUSE_UP, StopDragging);
	_ControlBar.addEventListener(SnippetControlBar.DELETE, Delete);
//	SnippetSizeGrip
}

public function HideUI(event:Event):void
{
	removeEventListener(MouseEvent.MOUSE_MOVE, Move);
	_ControlBar.removeEventListener(MouseEvent.MOUSE_DOWN, StartDragging);
	_ControlBar.removeEventListener(MouseEvent.MOUSE_UP, StopDragging);
	_ControlBar.removeEventListener(SnippetControlBar.DELETE, Delete);
	stopDrag();
  	Move(null);
	_ControlBar.visible = false;
	_StatusBar.visible = false;
}

public function Move(event:MouseEvent):void
{
	if (!parent)
		return;
		
	if (x < 0) x = 0;
	if (y < 0) y = 0;
	if (x + width > parent.width) x = parent.width - width;
	if (y + height > parent.height) y = parent.height - height;
}

public function Delete(event:Event):void
{
	parent.removeChild(this);
}

// This function is called when the mouse button is pressed.
public function StartDragging(event:MouseEvent):void
{
    startDrag();
}

// This function is called when the mouse button is released.
public function StopDragging(event:MouseEvent):void
{
   stopDrag();
}
