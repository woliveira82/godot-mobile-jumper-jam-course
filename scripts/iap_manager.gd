extends Node

signal unlock_new_skin


func purchase_kin():
	unlock_new_skin.emit()
