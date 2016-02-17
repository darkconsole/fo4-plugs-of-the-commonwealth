{
	Plugs of the Commonwealth:
	Update all ARMA and ARMO to use a different slot.
	darkconsole http://darkconsole.tumblr.com
}

Unit UserScript;
Var
	InputSlot: Integer;

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// helper functions to do the actual work.

Function DccSetBipedSlot(Form: IInterface; Slot: Integer): Integer;
Var
	Offset: Integer;
	FinalSlot: Integer;
Begin
	// Slot 54 $01000000
	// Slot 55 $02000000
	// Slot 56 $04000000
	// Slot 57 $08000000

	Offset := Slot - 30;
	FinalSlot := 1 shl Offset;

	AddMessage(
		'setting ' + IntToHex(FormID(Form),8) + ' ' + EditorID(Form) + ' ' +
		'to slot ' + IntToStr(Slot) + ' (' + IntToHex(FinalSlot,8) + ')'
	);

	SetElementNativeValues(Form,'BOD2\First Person Flags',FinalSlot);
End;

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// fo4edit entry points

Function Initialize: integer;
Var
	Input: String;
Begin
	InputQuery(
		'Enter Slot Number',
		'Suggested: 54, 55, 56, 57, or 58',
		Input
	);

	InputSlot := StrToInt(Input);
End;

Function Process(Form: IInterface): Integer;
Var
	FormType: String;
Begin
	FormType := Signature(Form);

	If((FormType = 'ARMA') OR (FormType = 'ARMO'))
	Then Begin
		DccSetBipedSlot(Form,InputSlot);
	End;
End;

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

End.