class_name TossResultResource extends Resource

enum TOSS_OUTCOME {
	HEAD,
	TAIL,
	RIM,
}

var outcome: TOSS_OUTCOME
var value: float = 1.0

func _init(_outcome: TOSS_OUTCOME = TOSS_OUTCOME.HEAD, _value: float = 0.0) -> void:
	outcome = _outcome
	value = _value