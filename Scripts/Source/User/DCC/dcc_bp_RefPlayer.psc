Scriptname DCC:dcc_bp_RefPlayer extends ReferenceAlias

dcc_bp_QuestController Property Main Auto

Event OnPlayerLoadGame()

	If(Main.VersionLast != Main.GetVersion())
		Main.ResetMod()
	EndIf

	Return
EndEvent
