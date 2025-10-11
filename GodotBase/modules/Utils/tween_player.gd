class_name TweenPlayer
extends Node

@export var target: Node
@export var animation: TweenAnimation
@export var duration: float = 0.2
@export var magnitude: float = 1.1
@export var override_pivot_offset: Vector2 = Vector2(0.5, 0.5)
@export var ease_: Tween.EaseType = Tween.EASE_IN_OUT
@export var transition: Tween.TransitionType = Tween.TRANS_LINEAR

enum TweenAnimation
{
	NONE,
	BUMP,
	SHAKE,
}


func play () -> Tween:
	if not target or animation == TweenAnimation.NONE:
		return null
	if target is Control:
		var control = target as Control
		control.pivot_offset = Vector2(control.size.x * override_pivot_offset.x, control.size.y * override_pivot_offset.y)
	match animation:
		TweenAnimation.BUMP:
			var tween = Utils.bounce_scale(target, Vector3.ONE * magnitude, duration)
			tween.set_trans(transition)
			tween.set_ease(ease_)
			return tween
	return null
