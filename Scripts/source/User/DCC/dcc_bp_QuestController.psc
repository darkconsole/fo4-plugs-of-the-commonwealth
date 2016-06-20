Scriptname DCC:dcc_bp_QuestController extends Quest

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int Function GetVersion()
{define the current version.}

	Return 111
EndFunction

Int Property VersionLast = 0 Auto Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FormList Property do_ModMenuSlotKeywordList Auto
Keyword Property dcc_bp_KeywordAttachSpecial Auto
Perk Property dcc_bp_PerkFusionCoreLife Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnInit()
{hello world.}

	self.ResetMod_Values()
	self.ResetMod_LeveledLists()

	Debug.Notification("Plugs of the Commonwealth has updated.")

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function ResetMod()
{handle flushing the quest.}

	self.Reset()
	Utility.Wait(0.25)
	self.Stop()
	Utility.Wait(0.25)
	self.Start()

	Return
EndFunction

Function ResetMod_Values()
{reset mod settings and values.}

	self.VersionLast = self.GetVersion()

	Return
EndFunction

Function ResetMod_LeveledLists()
{reset mod formlist entries.}

	;; make our plug upgrade slots available at the workbench.
	do_ModMenuSlotKeywordList.AddForm(dcc_bp_KeywordAttachSpecial)

	Return
EndFunction
