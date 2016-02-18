{
	Plugs of the Commonwealth:
	Help speed up the process in creating a new plug.
	darkconsole http://darkconsole.tumblr.com
}

Unit
	UserScript;

Const
	TemplateArma = $800;
	TemplateArmo = $801;
	TemplateCobj = $802;

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

Function DccCreateForm(TemplateID: Integer; Plugin: IInterface): IInterface;
Var
	FormID: Integer;
Begin
	AddMessage('Load Order ' + IntToStr(GetLoadOrder(Plugin)));
	FormID := (GetLoadOrder(Plugin) shl 24) + TemplateID;

	AddMessage('Creating Form From Template: ' + IntToHex(FormID,8));

	Result := wbCopyElementToFile(
		DccGetForm(FormID),
		Plugin,
		True, True
	);
End;

Function DccGetForm(FormID: Integer): IInterface;
Begin
	Result := RecordByFormID(
		FileByLoadOrder(FormID shr 24),
		LoadOrderFormIDtoFileFormID( FileByLoadOrder(FormID shr 24), FormID ),
		True
	);
End;

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

Procedure DccSetDescription(Form: IInterface; Desc: String);
Begin
	SetElementEditValues(Form,'DESC - Description',Desc);
End;

Procedure DccSetEditorID(Form: IInterface; EditorID: String);
Begin
	SetElementEditValues(Form,'EDID - Editor ID',EditorID);
End;

Procedure DccSetFullName(Form: IInterface; FullName: String);
Begin
	SetElementEditValues(Form,'FULL - Name',FullName);
End;

Procedure DccSetValue(Form: IInterface; Price: Integer);
Begin
	SetElementEditValues(Form,'DATA - Data\Value',Price);
End;

Procedure DccSetWeight(Form: IInterface; Weight: Float);
Begin
	SetElementEditValues(Form,'DATA - Data\Weight',Weight);
End;

Procedure DccSetArmaModels(Form: IInterface; ModelName: String);
Begin
	SetElementEditValues(Form,'Male world model\MOD2',ModelName);
	SetElementEditValues(Form,'Female world model\MOD3',ModelName);
	SetElementEditValues(Form,'Male 1st Person\MOD4',ModelName);
	SetElementEditValues(Form,'Female 1st Person\MOD5',ModelName);
End;

Procedure DccSetArmoArma(Form: IInterface; Arma: IInterface);
Var
	Field: IInterface;
	Iter: Integer;
Begin
	For Iter := 0 To 1
	Do Begin
		Field := ElementByIndex(ElementByPath(Form,'Armatures'),Iter);
		SetNativeValue(ElementByPath(Field,'MODL - Armature'),FormID(Arma));
	End;
End;

Procedure DccSetArmoModels(Form: IInterface; ModelName: String);
Begin
	SetElementEditValues(Form,'Male world model\MOD2',ModelName);
	SetElementEditValues(Form,'Female world model\MOD4',ModelName);
End;

Procedure DccSetCobjCreate(Form: IInterface; Create: IInterface);
Begin
	SetElementNativeValues(Form,'CNAM - Created Object',FormID(Create));
End;

Procedure DccSetCobjComponent(Form: IInterface; Component: IInterface);
Var
	Field: IInterface;
Begin
	Field := ElementByIndex(ElementByPath(Form,'FVPA - Components'),0);
	SetNativeValue(ElementByPath(Field,'Component'),FormID(Component));
End;

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

Procedure DccCreateNewPlug(Plugin: IInterface);
Var
	PlugEditorID: String;  // input
	PlugArmaModel: String; // input
	PlugName: String;      // input
	PlugFlavour: String;   // input
	PlugCraftItem: Int;    // input
	PlugArmoModel: String; // autofill
	PlugWeight: Int;       // autofill
	PlugValue: Float;      // autofill

	TempString: String;
	FormCraftItem: IInterface;
	FormNewArma: IInterface;
	FormNewArmo: IInterface;
	FormNewCobj: IInterface;
Begin
	AddMessage('Creating a new plug in ' + Name(Plugin));

	////////
	////////

	InputQuery(
		'Enter Editor ID',
		'Value will be prefixed with "dcc_bp_Formtype" (Ex: ColaCherry)',
		PlugEditorID
	);

	InputQuery(
		'Enter Equip Model',
		'Value will be prefixed with "dcc-bp-lol" (Ex: nuka.nif)',
		PlugArmaModel
	);

	InputQuery(
		'Enter Item Name',
		'Full pretty name as presented to the user (Ex: Nuka Cola Plug)',
		PlugName
	);

	InputQuery(
		'Enter Flavour Text',
		'Funny message that shows up as a tooltip on the item.',
		PlugFlavour
	);

	InputQuery(
		'Enter Crafting ID',
		'Enter the FormID for the object this object should be made from at the chem table.',
		TempString
	);

	PlugCraftItem := StrToInt('$' + TempString);

	////////
	////////

	// get PlugArmoModel, PlugWeight, PlugValue from PlugCraftItem
	
	FormCraftItem := DccGetForm(PlugCraftItem);

	If(NOT Assigned(FormCraftItem))
	Then Begin
		AddMessage('Unable to find source form.');
		Exit;
	End;

	// should catch the world object from most form types you can pick up.
	PlugArmoModel := GetElementNativeValues(FormCraftItem,'Model\MODL');
	PlugValue := GetElementNativeValues(FormCraftItem,'DATA - Data\Value');
	PlugWeight := GetElementNativeValues(FormCraftItem,'DATA - Data\Weight');

	////////
	////////

	FormNewArma := DccCreateForm(TemplateArma,Plugin);
	DccSetEditorID( FormNewArma, ('dcc_bp_ArmaPlug' + PlugEditorID) );
	DccSetArmaModels(FormNewArma,('dcc-bp-lol\' + PlugArmaModel));
	AddMessage('Created ' + Name(FormNewArma));

	FormNewArmo := DccCreateForm(TemplateArmo,Plugin);
	DccSetEditorID(FormNewArmo,('dcc_bp_ArmoPlug' + PlugEditorID));
	DccSetFullName(FormNewArmo,PlugName);
	DccSetDescription(FormNewArmo,PlugFlavour);
	DccSetValue(FormNewArmo,PlugValue);
	DccSetWeight(FormNewArmo,PlugWeight);
	DccSetArmoArma(FormNewArmo,FormNewArma);
	DccSetArmoModels(FormNewArmo,PlugArmoModel);
	AddMessage('Created ' + Name(FormNewArmo));

	FormNewCobj := DccCreateForm(TemplateCobj,Plugin);
	DccSetEditorID(FormNewCobj,('dcc_bp_ConstPlug' + PlugEditorID));
	DccSetDescription(FormNewCobj,PlugFlavour);
	DccSetCobjCreate(FormNewCobj,FormNewArmo);
	DccSetCobjComponent(FormNewCobj,FormCraftItem);
	AddMessage('Created ' + Name(FormNewCobj));

End;

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

Function Initialize: Integer;
Var
	Iter: Integer;
	Plugin: IInterface;
Begin
	For Iter := 0 To FileCount - 1
	Do Begin
		Plugin := FileByIndex(Iter);
		AddMessage('-- ' + IntToStr(Iter) + ' ' + Name(Plugin));
		If(CompareText(GetFileName(Plugin),'dcc-bp-lol.esp') = 0)
		Then Begin
			DccCreateNewPlug(Plugin);
		End;
	End;

End;

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

End.
