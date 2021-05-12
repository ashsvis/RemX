unit XmlConfigUnit;

interface

uses Classes, SysUtils, xmldom, XMLIntf, msxmldom, XMLDoc;

type
  TXmlIniFile = class(TObject)
  private
    RootNodeName: string;
    FFileName: DOMString;
    FXMLDoc: TXMLDocument;
    procedure SetXMLDoc(const Value: TXMLDocument);
  public
    constructor Create(const AFileName, ARootNodeName: DOMString);
    function ReadString(const Section, Ident, Default: string): string;
    procedure ReadStringList(const Section, Ident: string; Values: TStrings);
    function ReadInteger(const Section, Ident: string;
                         const Default: integer): integer;
    function ReadBool(const Section, Ident: string;
                      const Default: boolean): boolean;
    procedure WriteString(const Section, Ident, Value: string);
    procedure WriteStringList(const Section, Ident: string; Values: TStrings);
    procedure WriteInteger(const Section, Ident: string; const Value: integer);
    procedure WriteBool(const Section, Ident: string; const Value: boolean);
    procedure UpdateFile;
    function ValueExists(const Section, Ident: string): boolean;
    function NodeExists(const Section, Ident: string): boolean;
    procedure DeleteKey(const Section, Ident: string);
    property FileName: DOMString read FFileName;
    property XMLDoc: TXMLDocument write SetXMLDoc;
  end;

implementation

{ TXmlIniFile }

constructor TXmlIniFile.Create(const AFileName, ARootNodeName: DOMString);
begin
  FFileName := AFileName;
  RootNodeName := ARootNodeName;
end;

procedure TXmlIniFile.DeleteKey(const Section, Ident: string);
var iRoot, iSection, iIdent: IXMLNode;
begin
  iRoot := FXMLDoc.ChildNodes.FindNode(RootNodeName);
  if iRoot <> nil then
  begin
    iSection := iRoot.ChildNodes.FindNode(Section);
    if iSection <> nil then
    begin
      iIdent := iSection.ChildNodes.FindNode(Ident);
      if iIdent <> nil then
        iSection.ChildNodes.Delete(Ident);
    end;
  end;
end;

function TXmlIniFile.NodeExists(const Section, Ident: string): boolean;
var iRoot, iSection, iIdent: IXMLNode;
begin
  Result := False;
  iRoot := FXMLDoc.ChildNodes.FindNode(RootNodeName);
  if iRoot <> nil then
  begin
    iSection := iRoot.ChildNodes.FindNode(Section);
    if iSection <> nil then
    begin
      iIdent := iSection.ChildNodes.FindNode(Ident);
      Result := Assigned(iIdent) and (iIdent.ChildNodes.Count > 0);
    end;
  end;
end;

function TXmlIniFile.ReadBool(const Section, Ident: string;
  const Default: boolean): boolean;
var iRoot, iSection, iIdent: IXMLNode;
begin
  Result := Default;
  iRoot := FXMLDoc.ChildNodes.FindNode(RootNodeName);
  if iRoot <> nil then
  begin
    iSection := iRoot.ChildNodes.FindNode(Section);
    if iSection <> nil then
    begin
      iIdent := iSection.ChildNodes.FindNode(Ident);
      if iIdent <> nil then
        Result := StrToBoolDef(iIdent.Text,Default);
    end;
  end;
end;

function TXmlIniFile.ReadInteger(const Section, Ident: string;
  const Default: integer): integer;
var iRoot, iSection, iIdent: IXMLNode;
begin
  Result := Default;
  iRoot := FXMLDoc.ChildNodes.FindNode(RootNodeName);
  if iRoot <> nil then
  begin
    iSection := iRoot.ChildNodes.FindNode(Section);
    if iSection <> nil then
    begin
      iIdent := iSection.ChildNodes.FindNode(Ident);
      if iIdent <> nil then
        Result := StrToIntDef(iIdent.Text,Default);
    end;
  end;
end;

function TXmlIniFile.ReadString(const Section, Ident,
  Default: string): string;
var iRoot, iSection, iIdent: IXMLNode;
begin
  Result := Default;
  iRoot := FXMLDoc.ChildNodes.FindNode(RootNodeName);
  if iRoot <> nil then
  begin
    iSection := iRoot.ChildNodes.FindNode(Section);
    if iSection <> nil then
    begin
      iIdent := iSection.ChildNodes.FindNode(Ident);
      if iIdent <> nil then
        Result := iIdent.Text;
    end;
  end;
end;

procedure TXmlIniFile.ReadStringList(const Section, Ident: string;
  Values: TStrings);
var iRoot, iSection, iIdent, iItem: IXMLNode;
    i: integer;
begin
  iRoot := FXMLDoc.ChildNodes.FindNode(RootNodeName);
  if iRoot <> nil then
  begin
    iSection := iRoot.ChildNodes.FindNode(Section);
    if iSection <> nil then
    begin
      iIdent := iSection.ChildNodes.FindNode(Ident);
      if iIdent <> nil then
      begin
        Values.Clear;
        for i := 0 to iIdent.ChildNodes.Count - 1 do
        begin
          iItem := iIdent.ChildNodes[i];
          if iItem.IsTextElement then
            Values.Values[iItem.NodeName] := iItem.Text;
        end;
      end;
    end;
  end;
end;

procedure TXmlIniFile.SetXMLDoc(const Value: TXMLDocument);
begin
  FXMLDoc := Value;
  if FileExists(FFileName) then
  begin
    FXMLDoc.Active := True;
    FXMLDoc.LoadFromFile(FFileName);
  end
  else
  begin
    FXMLDoc.XML.Text := '';
    FXMLDoc.Active := True;
    FXMLDoc.Version := '1.0';
    FXMLDoc.DocumentElement := FXMLDoc.CreateNode(RootNodeName);
  end;
end;

procedure TXmlIniFile.UpdateFile;
begin
  FXMLDoc.SaveToFile(FFileName);
end;

function TXmlIniFile.ValueExists(const Section, Ident: string): boolean;
var iRoot, iSection, iIdent: IXMLNode;
begin
  Result := False;
  iRoot := FXMLDoc.ChildNodes.FindNode(RootNodeName);
  if iRoot <> nil then
  begin
    iSection := iRoot.ChildNodes.FindNode(Section);
    if iSection <> nil then
    begin
      iIdent := iSection.ChildNodes.FindNode(Ident);
      Result := Assigned(iIdent) and iIdent.IsTextElement;
    end;
  end;
end;

procedure TXmlIniFile.WriteBool(const Section, Ident: string;
  const Value: boolean);
var iRoot, iSection, iIdent: IXMLNode;
begin
  iRoot := FXMLDoc.ChildNodes.FindNode(RootNodeName);
  if iRoot <> nil then
  begin
    iSection := iRoot.ChildNodes.FindNode(Section);
    if iSection = nil then iSection := iRoot.AddChild(Section);
    iIdent := iSection.ChildNodes.FindNode(Ident);
    if iIdent = nil then iIdent := iSection.AddChild(Ident);
    iIdent.Text := BoolToStr(Value,True);
  end;
end;

procedure TXmlIniFile.WriteInteger(const Section, Ident: string;
  const Value: integer);
var iRoot, iSection, iIdent: IXMLNode;
begin
  iRoot := FXMLDoc.ChildNodes.FindNode(RootNodeName);
  if iRoot <> nil then
  begin
    iSection := iRoot.ChildNodes.FindNode(Section);
    if iSection = nil then iSection := iRoot.AddChild(Section);
    iIdent := iSection.ChildNodes.FindNode(Ident);
    if iIdent = nil then iIdent := iSection.AddChild(Ident);
    iIdent.Text := IntToStr(Value);
  end;
end;

procedure TXmlIniFile.WriteString(const Section, Ident, Value: string);
var iRoot, iSection, iIdent: IXMLNode;
begin
  iRoot := FXMLDoc.ChildNodes.FindNode(RootNodeName);
  if iRoot <> nil then
  begin
    iSection := iRoot.ChildNodes.FindNode(Section);
    if iSection = nil then iSection := iRoot.AddChild(Section);
    iIdent := iSection.ChildNodes.FindNode(Ident);
    if iIdent = nil then iIdent := iSection.AddChild(Ident);
    iIdent.Text := Value;
  end;
end;

procedure TXmlIniFile.WriteStringList(const Section, Ident: string;
  Values: TStrings);
var iRoot, iSection, iIdent, iItem: IXMLNode;
    i: integer;
begin
  iRoot := FXMLDoc.ChildNodes.FindNode(RootNodeName);
  if iRoot <> nil then
  begin
    iSection := iRoot.ChildNodes.FindNode(Section);
    if iSection = nil then iSection := iRoot.AddChild(Section);
    iIdent := iSection.ChildNodes.FindNode(Ident);
    if iIdent = nil then iIdent := iSection.AddChild(Ident);
    for i := 0 to Values.Count - 1 do
    begin
      iItem := iIdent.ChildNodes.FindNode(Values.Names[i]);
      if iItem = nil then iItem := iIdent.AddChild(Values.Names[i]);
      iItem.Text := Values.ValueFromIndex[i];
    end;
  end;
end;

end.
