unit ShowUsersUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ActnList, ImgList, ExtCtrls, ToolWin, AppEvnts,
  IniFiles;

type
  TShowUsersForm = class(TForm)
    tvUsers: TTreeView;
    TreeActionList: TActionList;
    actChange: TAction;
    actDelete: TAction;
    actAdd: TAction;
    ToolBar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    Panel1: TPanel;
    btnOk: TButton;
    btnCancelRegistry: TButton;
    actInputPassword: TAction;
    ApplicationEvents: TApplicationEvents;
    ImageList: TImageList;
    procedure actChangeExecute(Sender: TObject);
    procedure actChangeUpdate(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actDeleteUpdate(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actAddUpdate(Sender: TObject);
    procedure tvUsersDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tvUsersKeyPress(Sender: TObject; var Key: Char);
    procedure actInputPasswordExecute(Sender: TObject);
    procedure tvUsersChange(Sender: TObject; Node: TTreeNode);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure FormDestroy(Sender: TObject);
  private
    Nodes: array[0..5] of TTreeNode;
    LastNodeText: string;
    Users: TMemIniFile;
    procedure LoadFromFile;
  public
    EditMode: boolean;
    procedure PrepareView;
  end;

const
  UserCategories: array[0..5] of string =
    ('Диспетчеры',
     'Операторы',
     'Прибористы',
     'Инженеры-технологи',
     'Инженеры АСУ ТП',
     'Программисты');

var
  ShowUsersForm: TShowUsersForm;

function CategoryIndex(Value: string): integer;
procedure SaveToFile(Users: TMemIniFile; CurrentBasePath: string);

implementation

uses UserDetailUnit, GetPasswordUnit, StrUtils, EntityUnit,
     CRCCalcUnit, RemXUnit;

{$R *.dfm}

function CategoryIndex(Value: string): integer;
var i: integer;
begin
  Result:=0;
  for i:=0 to 5 do
  if Value = UserCategories[i] then
  begin
    Result:=i+1;
    Break;
  end;
end;

procedure TShowUsersForm.actChangeExecute(Sender: TObject);
var i: integer; Section: string;
begin
  i:=Integer(tvUsers.Selected.Data);
  UserDetailForm:=TUserDetailForm.Create(Self);
  try
    with UserDetailForm do
    begin
      Section:=Format('USER%d',[i]);
      if Users.SectionExists(Section) then
      begin
        UserFamily.Text:=Users.ReadString(Section,'LASTNAME','');
        UserName.Text:=Users.ReadString(Section,'FIRSTNAME','');
        UserSecondName.Text:=Users.ReadString(Section,'SECONDNAME','');
        UserCategory.ItemIndex:=Users.ReadInteger(Section,'CATEGORY',0);
        UserPassword.Text:=Users.ReadString(Section,'PASSWORD','');
        UserConfirm.Text:=UserPassword.Text;
      end
      else
        Exit;
      if ShowModal = mrOk then
      begin
        if Users.SectionExists(Section) then
        begin
          Users.WriteString(Section,'LASTNAME',UserFamily.Text);
          Users.WriteString(Section,'FIRSTNAME',UserName.Text);
          Users.WriteString(Section,'SECONDNAME',UserSecondName.Text);
          Users.WriteInteger(Section,'CATEGORY',UserCategory.ItemIndex);
          Users.WriteString(Section,'PASSWORD',UserPassword.Text);
          SaveToFile(Users,Caddy.CurrentBasePath);
        end
        else
          Exit;
        LastNodeText:=UserFamily.Text+' '+UserName.Text+' '+UserSecondName.Text;
        PrepareView;
      end;
    end;
  finally
    UserDetailForm.Free;
  end;
end;

procedure TShowUsersForm.actChangeUpdate(Sender: TObject);
begin
  actChange.Enabled:=(tvUsers.Selected <> nil) and
                     (tvUsers.Selected.Level > 0) and
                     (tvUsers.Selected.Text <> 'Администратор') and EditMode;
end;

procedure TShowUsersForm.actDeleteExecute(Sender: TObject);
var i: integer; Section: string;
begin
  i:=Integer(tvUsers.Selected.Data);
  if RemxForm.ShowQuestion('Удалить учетную запись?') = mrOk then
  begin
    Section:=Format('USER%d',[i]);
    if Users.SectionExists(Section) then
    begin
      Users.EraseSection(Section);
      SaveToFile(Users,Caddy.CurrentBasePath);
    end
    else
      Exit;
    PrepareView;
  end;
end;

procedure TShowUsersForm.actDeleteUpdate(Sender: TObject);
begin
  actDelete.Enabled:=(tvUsers.Selected <> nil) and
                     (tvUsers.Selected.Level > 0) and
                     (tvUsers.Selected.Text <> 'Администратор') and EditMode;
end;

procedure TShowUsersForm.actAddExecute(Sender: TObject);
var Section: string; Index: integer;
begin
  UserDetailForm:=TUserDetailForm.Create(Self);
  try
    with UserDetailForm do
    begin
      UserFamily.Text:='';
      UserName.Text:='';
      UserSecondName.Text:='';
      if tvUsers.Selected.Level > 0 then
        UserCategory.ItemIndex:=Integer(tvUsers.Selected.Parent.Data)
      else
        UserCategory.ItemIndex:=Integer(tvUsers.Selected.Data);
      UserPassword.Text:='';
      UserConfirm.Text:='';
      if ShowModal = mrOk then
      begin
        Index:=Users.ReadInteger('USERS','Count',0)+1;
        Section:=Format('USER%d',[Index-1]);
        Users.WriteInteger('USERS','Count',Index);
        Users.WriteInteger(Section,'ID',Index-1);
        Users.WriteString(Section,'LASTNAME',UserFamily.Text);
        Users.WriteString(Section,'FIRSTNAME',UserName.Text);
        Users.WriteString(Section,'SECONDNAME',UserSecondName.Text);
        Users.WriteInteger(Section,'CATEGORY',UserCategory.ItemIndex);
        Users.WriteString(Section,'PASSWORD',UserPassword.Text);
        SaveToFile(Users,Caddy.CurrentBasePath);
        LastNodeText:=UserFamily.Text+' '+
                      UserName.Text+' '+
                      UserSecondName.Text;
        PrepareView;
      end;
    end;
  finally
    UserDetailForm.Free;
  end;
end;

procedure TShowUsersForm.actAddUpdate(Sender: TObject);
begin
  actAdd.Enabled:=(tvUsers.Selected <> nil) and EditMode;
end;

procedure TShowUsersForm.tvUsersDblClick(Sender: TObject);
begin
  if actChange.Enabled and EditMode then actChange.Execute;
  if actInputPassword.Enabled and not EditMode then actInputPassword.Execute;
end;

procedure TShowUsersForm.PrepareView;
var i: integer; S: string; N: TTreeNode; SL: TStringList;
begin
  tvUsers.Items.Clear;
  for i:=0 to 5 do
  begin
    Nodes[i]:=tvUsers.Items.Add(nil,UserCategories[i]);
    Nodes[i].Data:=Pointer(i);
  end;
  SL:=TStringList.Create;
  try
    Users.ReadSections(SL);
    for i:=0 to SL.Count-1 do
    if SL[i] <> 'USERS' then
    begin
      S:=Users.ReadString(SL[i],'LASTNAME','')+' '+
         Users.ReadString(SL[i],'FIRSTNAME','')+' '+
         Users.ReadString(SL[i],'SECONDNAME','');
      N:=tvUsers.Items.AddChild(Nodes[Users.ReadInteger(SL[i],'CATEGORY',0)],S);
      N.ImageIndex:=1;
      N.SelectedIndex:=1;
      N.Data:=Pointer(Users.ReadInteger(SL[i],'ID',0));
      if S = LastNodeText then tvUsers.Selected:=N;
      N.Expand(True);
    end;
  finally
    SL.Free;
  end;
  if not (Nodes[5].HasChildren or Nodes[4].HasChildren) then
  with tvUsers.Items.AddChild(Nodes[5],'Администратор') do
  begin
    ImageIndex:=1;
    SelectedIndex:=1;
  end;
  for i:=0 to 5 do Nodes[i].AlphaSort(True);
end;

procedure TShowUsersForm.FormCreate(Sender: TObject);
begin
  EditMode:=True;
  LastNodeText:='';
  Users:=TMemIniFile.Create('');
  LoadFromFile;
end;

procedure TShowUsersForm.tvUsersKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if EditMode then
    begin
      if actChange.Enabled then actChange.Execute;
    end
    else
    begin
      if actInputPassword.Enabled then actInputPassword.Execute;
    end;
  end;
end;

procedure TShowUsersForm.actInputPasswordExecute(Sender: TObject);
var S,OldShortUserName: string; Found: boolean; SL: TStringList; i: integer;
begin
  OldShortUserName:=RemXForm.ShortUserName;
  GetPasswordForm:=TGetPasswordForm.Create(Self);
  try
    with GetPasswordForm do
    begin
      if ShowModal = mrOk then
      begin
        S:=tvUsers.Selected.Text;
        Found:=(S='Администратор') and (Edit1.Text = '3141592653');
        if not Found then
        begin
          SL:=TStringList.Create;
          try
            Users.ReadSections(SL);
            for i:=0 to SL.Count-1 do
            if SL[i] <> 'USERS' then
            begin
              if (S = (Users.ReadString(SL[i],'LASTNAME','')+' '+
                       Users.ReadString(SL[i],'FIRSTNAME','')+' '+
                       Users.ReadString(SL[i],'SECONDNAME',''))) and
                 (Edit1.Text = Users.ReadString(SL[i],'PASSWORD','')) then
              begin
                Found:=True;
                Break;
              end;
            end;
          finally
            SL.Free;
          end;
        end;
        if Found then
        with RemXForm do
        begin
          LongUserName:=S;
          Caddy.LongUserName := S;
          if S = 'Администратор' then
          begin
            ShortUserName:='Администратор';
            Caddy.UserLevel:=6;
          end
          else
          begin
            ShortUserName:=Copy(S,1,Pos(' ',S)-1)+' ';
            Delete(S,1,Pos(' ',S));
            ShortUserName:=ShortUserName+Copy(S,1,1)+'.';
            Delete(S,1,Pos(' ',S));
            ShortUserName:=ShortUserName+Copy(S,1,1)+'.';
            Caddy.UserLevel:=Integer(tvUsers.Selected.Parent.Data)+1;
          end;
          Caddy.AddChange('Система','Регистрация',OldShortUserName,ShortUserName,
               IfThen(OldShortUserName='','Регистрация','Смена')+' пользователя',
                                                                  ShortUserName);
          Self.Close;
        end
        else
        begin
          if S = 'Администратор' then
            OldShortUserName:=S
          else
          begin
            OldShortUserName:=Copy(S,1,Pos(' ',S)-1)+' ';
            Delete(S,1,Pos(' ',S));
            OldShortUserName:=OldShortUserName+Copy(S,1,1)+'.';
            Delete(S,1,Pos(' ',S));
            OldShortUserName:=OldShortUserName+Copy(S,1,1)+'.';
          end;
          Caddy.AddChange('Система','Регистрация','********','********',
                          'Ошибка ввода пароля для "'+OldShortUserName+'"',
                          RemXForm.ShortUserName);
          RemxForm.ShowWarning('Ошибка ввода пароля!');
        end;
      end;
    end;
  finally
    GetPasswordForm.Free;
  end;
end;

procedure TShowUsersForm.tvUsersChange(Sender: TObject; Node: TTreeNode);
begin
  actInputPassword.Enabled:=(tvUsers.Selected <> nil) and
                            (tvUsers.Selected.Level > 0) and
                             not EditMode;
end;

procedure TShowUsersForm.ApplicationEventsIdle(Sender: TObject;
  var Done: Boolean);
begin
  btnCancelRegistry.Enabled:=(RemXForm.ShortUserName <> '');
end;

procedure TShowUsersForm.FormDestroy(Sender: TObject);
begin
  Users.Free;
end;

procedure SaveToFile(Users: TMemIniFile; CurrentBasePath: string);
var List: TStringList; AF,M: TMemoryStream; CRC32: Cardinal;
    PtClass,FileName,BackName: string; F: TFileStream;
begin
  Screen.Cursor:=crHourGlass;
  try
    M:=TMemoryStream.Create;
    AF:=TMemoryStream.Create;
    List:=TStringList.Create;
    try
      Users.GetStrings(List);
      List.SaveToStream(AF);
      if AF.Size > 0 then
      begin
        AF.Position:=0;
        M.Clear;
        CompressStream(AF,M);
        M.Position:=0;
      end
      else
        M.Clear;
      CRC32:=0;
      CalcCRC32(M.Memory,M.Size,CRC32);
      PtClass:=IncludeTrailingPathDelimiter(CurrentBasePath)+'USERSDATA.CFG';
      FileName:=PtClass;
      BackName:=ChangeFileExt(FileName,'.~CFG');
      if FileExists(BackName) and DeleteFile(BackName) or
         not FileExists(BackName) then
      begin
        if FileExists(FileName) and RenameFile(FileName,BackName) or
           not FileExists(FileName) then
        begin
          if M.Size = 0 then
          begin
            if FileExists(PtClass) then DeleteFile(PtClass);
          end
          else
          if ForceDirectories(CurrentBasePath) then
          begin
            try
              F:=TFileStream.Create(PtClass,fmCreate or fmShareExclusive);
            except
              RemXForm.ShowWarning('Файл "'+ExtractFileName(PtClass)+
                      '" занят другим процессом. Попробуйте еще раз.');
              Exit;
            end;
            try
              F.WriteBuffer(CRC32,SizeOf(CRC32));
              M.SaveToStream(F);
            finally
              F.Free;
            end;
          end;
        end;
      end;
    finally
      AF.Free;
      M.Free;
      List.Free;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TShowUsersForm.LoadFromFile;
var FileName: string; M: TMemoryStream; List: TStringList;
begin
  Screen.Cursor:=crHourGlass;
  try
    List:=TStringList.Create;
    M:=TMemoryStream.Create;
    try
      FileName:=IncludeTrailingPathDelimiter(Caddy.CurrentBasePath)+'USERSDATA.CFG';
      if LoadStream(FileName,M) then
      begin
        List.LoadFromStream(M);
        Users.SetStrings(List);
      end
      else
        Caddy.AddSysMess('Загрузка списка пользователей',
                         'Ошибка при загрузке списка пользователей');
    finally
      M.Free;
      List.Free;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

end.
