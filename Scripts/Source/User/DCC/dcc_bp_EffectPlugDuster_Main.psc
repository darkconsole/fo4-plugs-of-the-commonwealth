Scriptname DCC:dcc_bp_EffectPlugDuster_Main extends ActiveMagicEffect
{play the hud graphic when sneaking.}

dcc_bp_QuestController Property Main Auto
GlobalVariable Property PlugsDustingGraphic Auto

Event OnEffectStart(Actor Target, Actor Caster)
{when we start sneaking.}

	Int Graphic = PlugsDustingGraphic.GetValueInt()

	If(Target != Game.GetPlayer())
		Return
	EndIf

	self.ShowDustingMessage(Graphic == 2 || Graphic == 3)
	self.ShowDustingGraphic(Graphic == 1 || Graphic == 3)

	Return
EndEvent

Function ShowDustingGraphic(Bool DoIt)
{show the animation.}

	If(!Doit)
		Return
	EndIf

	Game.ShowPerkVaultBoyOnHUD("dcc-potc\\dustersneak-hud.swf")
	Return
EndFunction

Function ShowDustingMessage(Bool DoIt)
{show the message..}

	If(!DoIt)
		Return
	EndIf

	Debug.Notification("Dusting For Prints...")
	Return
EndFunction
