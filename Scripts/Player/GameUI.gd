extends Control

var healthArray = []
var arrowArray = []

func _ready():
	
	for n in $HealthBar.get_child_count():
		healthArray.push_back($HealthBar.get_node("Heart" + str(n + 1)))
	
	for n in $MagicBar.get_child_count():
		arrowArray.push_back($MagicBar.get_node("Magic" + str(n + 1)))

func UpdateHealth (num : int) -> void:
	
	for elem in healthArray:
		elem.hide()
	
	for n in num:
		healthArray[n].show()

func UpdateArrows (num : int) -> void:
	
	for elem in arrowArray:
		elem.hide()
	
	for n in num:
		arrowArray[n].show()

func HideDodge () -> void:
	$DodgeBar/Wind1.hide()

func ShowDodge () -> void:
	$DodgeBar/Wind1.show()
