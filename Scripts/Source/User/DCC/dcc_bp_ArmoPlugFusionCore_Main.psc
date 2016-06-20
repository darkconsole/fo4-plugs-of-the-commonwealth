Scriptname DCC:dcc_bp_ArmoPlugFusionCore_Main extends ObjectReference
{because power armor removes all your armor effects, and even sends
the OnUnequipped event out when it does this, this script is designed
to detect and reapply the perk when getting into power armor.}

dcc_bp_QuestController Property Main Auto
GlobalVariable Property PlugsDualCoreGraphic Auto

Event OnEquipped(Actor Who)
	If(Who != Game.GetPlayer())
		Return
	EndIf

	;;Debug.Notification("Fusion Core Equipped.")
	Who.AddPerk(Main.dcc_bp_PerkFusionCoreLife)
	Return
EndEvent

Event OnUnequipped(Actor Who)
	Int Graphic = PlugsDualCoreGraphic.GetValueInt()

	If(Who != Game.GetPlayer())
		Return
	EndIf

	If(Who.IsInPowerArmor() == FALSE)
		;;Debug.Notification("Fusion Core Unequipped.")
		Who.RemovePerk(Main.dcc_bp_PerkFusionCoreLife)
	Else
		;;Utility.Wait(1.0)
		Who.AddPerk(Main.dcc_bp_PerkFusionCoreLife)
		self.ShowDualCoreMessage(Graphic == 2 || Graphic == 3)
		self.ShowDualCoreGraphic(Graphic == 1 || Graphic == 3)
	EndIf

	Return
EndEvent

Function ShowDualCoreGraphic(Bool DoIt)
{show the animation when getting into power armor.}

	If(!Doit)
		Return
	EndIf

	Game.ShowPerkVaultBoyOnHUD("dcc-potc\\fusioncorelife-hud.swf")
	Return
EndFunction

Function ShowDualCoreMessage(Bool DoIt)
{show the message when getting into power armor.}

	If(!DoIt)
		Return
	EndIf

	Debug.Notification("DUAL CORE!")
	Return
EndFunction
