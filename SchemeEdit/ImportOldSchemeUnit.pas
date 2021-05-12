unit ImportOldSchemeUnit;

interface

uses Windows, Classes, SysUtils, Controls, Contnrs, Graphics, JPEG, DinElementsUnit,
     DinDigitalEditorUnit, DinUnitEditorUnit;

type
  TBackType = (btJPEG,btBitmap);
  TBack = class(TComponent)
  private
    FNotEmpty: Boolean;
    FBackType: TBackType;
    FBmpBackImage: TBitmap;
    FJpgBackImage: TJPEGImage;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property NotEmpty: Boolean read FNotEmpty write FNotEmpty;
    property BackImage: TJPEGImage read FJpgBackImage write FJpgBackImage;
    property LargeImage: TBitmap read FBmpBackImage write FBmpBackImage;
    property BackType: TBackType read FBackType write FBackType;
  end;

  TDinamic = class(TGraphicControl)
  private
    FTransparent: Boolean;
  protected
  public
    DinamicType: byte;
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); virtual; abstract;
  published
    property Transparent: Boolean read FTransparent write FTransparent
             default True;
    property Cursor stored False;
  end;

  TEntityDinamic = class(TDinamic)
  private
    FParName: string;
  protected
  public
  published
    property ParName: string read FParName write FParName;
  end;

// Переход на схему
  TDinJumper = class(TDinamic)
  private
    Body: record
            DinType: byte;
            Framed: Boolean;
            Solid: Boolean;
            ScreenName: string[255];
            Text: string[255];
            Color: TColor;
            KeyLevel: byte;
            Font: TFontRec;
            Left: Integer;
            Top: Integer;
            Width: Integer;
            Height: Integer;
            Reserved1: boolean;
            Reserved2: boolean;
            Reserved3: boolean;
            Reserved4: Integer;
            Reserved5: Integer;
            Reserved6: Integer;
          end;
    FSolid: Boolean;
    FFramed: Boolean;
    FText: string;
    FScreenName: string;
    FColor: TColor;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
  published
    property ScreenName: string read FScreenName write FScreenName;
    property Framed: Boolean read FFramed write FFramed;
    property Solid: Boolean read FSolid write FSolid;
    property Color: TColor read FColor write FColor;
    property Font;
    property Text: string read FText write FText;
  end;

// Динамический текст
  TText = class(TEntityDinamic)
  private
    Body: record
            DinType: byte;
            PtName: string[10];
            Font: TFontRec;
            Color: TColor;
            Text: string[255];
            ShowPanel: boolean;
            Solid: Boolean;
            Framed: Boolean;
            FrameColor: TColor;
            Font0: TFontRec;
            Color0: TColor;
            Text0: string[255];
            Font1: TFontRec;
            Color1: TColor;
            Text1: string[255];
            Left: Integer;
            Top: Integer;
            Width: Integer;
            Height: Integer;
            Reserved1: boolean;
            Reserved2: boolean;
            Reserved3: boolean;
            Reserved4: Integer;
            Reserved5: Integer;
            Reserved6: Integer;
          end;
    FFont1: TFont;
    FFont0: TFont;
    FFramed: Boolean;
    FText1: string;
    FText0: string;
    FColor1: TColor;
    FColor0: TColor;
    procedure SetFont0(const Value: TFont);
    procedure SetFont1(const Value: TFont);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SaveToStream(Stream: TStream); override;
  published
    property Caption;
    property Color;
    property Font;
    property Framed: Boolean read FFramed write FFramed;
    property Text0: string read FText0 write FText0;
    property Text1: string read FText1 write FText1;
    property Color0: TColor read FColor0 write FColor0;
    property Color1: TColor read FColor1 write FColor1;
    property Font0: TFont read FFont0 write SetFont0;
    property Font1: TFont read FFont1 write SetFont1;
  end;

// Аналоговая величина
  TAnalog = class(TEntityDinamic)
  private
    Body: record
            DinType: byte;
            PtName: string[10];
            PtParam: string[10];
            Font: TFontRec;
            Color: TColor;
            Framed: Boolean;
            FrameColor: TColor;
            ShowPanel: boolean;
            ShowBar: boolean;
            ShowLevel: boolean;
            BarLevelVisible: boolean;
            BarLevelColor: TColor;
            BarLevelInverse: boolean;
            ShowUnit: boolean;
            ShowChecks: boolean;
            ShowValue: boolean;
            Left: Integer;
            Top: Integer;
            Width: Integer;
            Height: Integer;
            Reserved1: boolean;
            Reserved2: boolean;
            Reserved3: boolean;
            Reserved4: Integer;
            Reserved5: Integer;
            Reserved6: Integer;
          end;
    FShowUnit: Boolean;
    FInverseBar: Boolean;
    FShowAsLevel: Boolean;
    FShowFrame: Boolean;
    FShowValue: Boolean;
    FShowTrips: Boolean;
    FShowBar: Boolean;
    FFramed: Boolean;
    FParameter: string;
    FFormatString: string;
    FBarColor: TColor;
    FColorFrame: TColor;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
  published
    property Color;
    property Font;
    property FormatString: string read FFormatString write FFormatString;
    property Framed: Boolean read FFramed write FFramed;
    property ShowFrame: Boolean read FShowFrame write FShowFrame;
    property ShowValue: Boolean read FShowValue write FShowValue default True;
    property ColorFrame: TColor read FColorFrame write FColorFrame;
    property ShowEU: Boolean read FShowTrips write FShowTrips;
    property ShowUnit: Boolean read FShowUnit write FShowUnit;
    property ShowBar: Boolean read FShowBar write FShowBar;
    property ShowAsLevel: Boolean read FShowAsLevel write FShowAsLevel;
    property BarColor: TColor read FBarColor write FBarColor;
    property InverseBar: Boolean read FInverseBar write FInverseBar;
    property Parameter: string read FParameter write FParameter;
  end;

// Дискретная величина
  TDinType = (dtRect,dtCircle,dt3DRect,dt3DCircle,dtGaz,dtRad,dtVent);
  TDigital = class(TEntityDinamic)
  private
    Body: record
            DinType: byte;
            PtName: string[10];
            Kind: TViewKind;
            Border: TBorderKind;
            Left: Integer;
            Top: Integer;
            Width: Integer;
            Height: Integer;
            Reserved1: boolean;
            Reserved2: boolean;
            Reserved3: boolean;
            Reserved4: Integer;
            Reserved5: Integer;
            Reserved6: Integer;
          end;
    FDinType: TDinType;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
  published
    property DinType: TDinType read FDinType write FDinType;
  end;

// Контур регулирования
  TDinContur = class(TEntityDinamic)
  private
    Body: record
            DinType: byte;
            PtName: string[10];
            Font: TFontRec;
            Left: Integer;
            Top: Integer;
            Width: Integer;
            Height: Integer;
            Reserved1: boolean;
            Reserved2: boolean;
            Reserved3: boolean;
            Reserved4: Integer;
            Reserved5: Integer;
            Reserved6: Integer;
          end;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
  published
  end;

// Задвижка
  TDinLatchOrientation = (loHorizontal,loVertical);
  TDinLatch = class(TEntityDinamic)
  private
    Body: record
            DinType: byte;
            PtName: string[10];
            Vertical: boolean;
            Left: Integer;
            Top: Integer;
            Width: Integer;
            Height: Integer;
            Reserved1: boolean;
            Reserved2: boolean;
            Reserved3: boolean;
            Reserved4: Integer;
            Reserved5: Integer;
            Reserved6: Integer;
          end;
    FLatchOrientation: TDinLatchOrientation;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
  published
    property LatchOrientation: TDinLatchOrientation read FLatchOrientation
                                write FLatchOrientation;
  end;

// Кнопка
  TCommand = class(TEntityDinamic)
  private
    Body: record
            DinType: byte;
            PtName: string[10];
            Text: string[255];
            Fixed: boolean;
            Font: TFontRec;
            Left: Integer;
            Top: Integer;
            Width: Integer;
            Height: Integer;
            Reserved1: boolean;
            Reserved2: boolean;
            Reserved3: boolean;
            Reserved4: Integer;
            Reserved5: Integer;
            Reserved6: Integer;
          end;
    FFixed: Boolean;
    FText: string;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
  published
    property Text: string read FText write FText;
    property Font;
    property Fixed: Boolean read FFixed write FFixed;
  end;

// Труба
  TPipeDirection = (pdHorizontally, pdVertically);
  TPipeHierarchy = (phMaster, phSlave);
  TDinPipe = class(TEntityDinamic)
  private
    Body: record
            DinType: byte;
            PtName: string[10];
            Color: TColor;
            Color0: TColor;
            Color1: TColor;
            LineWidth: Byte;
            LineWidth0: Byte;
            LineWidth1: Byte;
            LineStyle: TPenStyle;
            LineStyle0: TPenStyle;
            LineStyle1: TPenStyle;
            LineKind: Byte;
            BaseColor: boolean;
            Left: Integer;
            Top: Integer;
            Width: Integer;
            Height: Integer;
            Reserved1: boolean;
            Reserved2: boolean;
            Reserved3: boolean;
            Reserved4: Integer;
            Reserved5: Integer;
            Reserved6: Integer;
          end;
    FTrueColor: Boolean;
    FPipeWidth: Byte;
    FColor: TColor;
    FColorON: TColor;
    FColorOFF: TColor;
    FPipeStyle: TPenStyle;
    FPipeDirection: TPipeDirection;
    FPipeHierarchy: TPipeHierarchy;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
  published
    property Color: TColor read FColor write FColor;
    property PipeStyle: TPenStyle read FPipeStyle write FPipeStyle;
    property PipeDirection: TPipeDirection read FPipeDirection write FPipeDirection;
    property PipeHierarchy: TPipeHierarchy read FPipeHierarchy write FPipeHierarchy;
    property TrueColor: Boolean read FTrueColor write FTrueColor;
    property ColorOFF: TColor read FColorOFF write FColorOFF;
    property ColorON: TColor read FColorON write FColorON default clWhite;
    property PipeWidth: Byte read FPipeWidth write FPipeWidth default 2;
  end;

// Устройство
  TDinNode = class(TEntityDinamic)
  private
    Body: record
            DinType: byte;
            PtName: string[10];
            Left: Integer;
            Top: Integer;
            Width: Integer;
            Height: Integer;
            Reserved1: boolean;
            Reserved2: boolean;
            Reserved3: boolean;
            Reserved4: Integer;
            Reserved5: Integer;
            Reserved6: Integer;
          end;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
  end;

// Цилиндр
  TTerminator = 1..99;
  TFillDirection = (fdVertical,fdHorizontal);
  TRxTube = class(TDinamic)
  private
    Body: record
            DinType: byte;
            UnitKind: TUnitKind;
            Volume: boolean;
            Solid: boolean;
            Color: TColor;
            Terminator: TTerminator;
            LightColor: TColor;
            DarkColor: TColor;
            Border: boolean;
            BorderColor: TColor;
            Orientation: TUnitOrientation;
            Left: Integer;
            Top: Integer;
            Width: Integer;
            Height: Integer;
            Reserved1: boolean;
            Reserved2: boolean;
            Reserved3: boolean;
            Reserved4: Integer;
            Reserved5: Integer;
            Reserved6: Integer;
          end;
    FBevelVisible: Boolean;
    FDarkColor: TColor;
    FBevelColor: TColor;
    FLightColor: TColor;
    FFillDirection: TFillDirection;
    FTerminator: TTerminator;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
  published
    property Align;
    property Anchors;
    property Color;
    property Constraints;
    property LightColor: TColor read FLightColor write FLightColor default clAqua;
    property DarkColor: TColor read FDarkColor write FDarkColor default $00404000;
    property Terminator: TTerminator read FTerminator write FTerminator default 70;
    property FillDirection: TFillDirection read FFillDirection
             write FFillDirection default fdVertical;
    property BevelVisible: Boolean
                   read FBevelVisible write FBevelVisible default False;
    property BevelColor: TColor
                   read FBevelColor write FBevelColor default clBlack;
    property ShowHint;
  end;

// Конус
  TRxCone = class(TRxTube)
  private
    Body: record
            DinType: byte;
            UnitKind: TUnitKind;
            Volume: boolean;
            Solid: boolean;
            Color: TColor;
            Terminator: TTerminator;
            LightColor: TColor;
            DarkColor: TColor;
            Border: boolean;
            BorderColor: TColor;
            Orientation: TUnitOrientation;
            Left: Integer;
            Top: Integer;
            Width: Integer;
            Height: Integer;
            Reserved1: boolean;
            Reserved2: boolean;
            Reserved3: boolean;
            Reserved4: Integer;
            Reserved5: Integer;
            Reserved6: Integer;
          end;
    FReverse: Boolean;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
  published
    property Reverse: Boolean read FReverse write FReverse;
  end;

// Усечённый конус
  TTruncFactor = 1..32;
  TRxTruncCone = class(TRxCone)
  private
    Body: record
            DinType: byte;
            UnitKind: TUnitKind;
            Volume: boolean;
            Solid: boolean;
            Color: TColor;
            Terminator: TTerminator;
            LightColor: TColor;
            DarkColor: TColor;
            Border: boolean;
            BorderColor: TColor;
            Orientation: TUnitOrientation;
            Left: Integer;
            Top: Integer;
            Width: Integer;
            Height: Integer;
            Reserved1: boolean;
            Reserved2: boolean;
            Reserved3: boolean;
            Reserved4: Integer;
            Reserved5: Integer;
            Reserved6: Integer;
          end;
    FTruncFactor: TTruncFactor;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
  published
    property TruncFactor: TTruncFactor
          read FTruncFactor write FTruncFactor default 4;
  end;

// Полусфера
  TRxCover = class(TRxCone)
  private
    Body: record
            DinType: byte;
            UnitKind: TUnitKind;
            Volume: boolean;
            Solid: boolean;
            Color: TColor;
            Terminator: TTerminator;
            LightColor: TColor;
            DarkColor: TColor;
            Border: boolean;
            BorderColor: TColor;
            Orientation: TUnitOrientation;
            Left: Integer;
            Top: Integer;
            Width: Integer;
            Height: Integer;
            Reserved1: boolean;
            Reserved2: boolean;
            Reserved3: boolean;
            Reserved4: Integer;
            Reserved5: Integer;
            Reserved6: Integer;
          end;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
  end;

procedure LoadOldSchemeFromFile(const FileName: string; Items: TComponentList;
                                Background: TBackground);

implementation

procedure LoadOldSchemeFromFile(const FileName: string; Items: TComponentList;
                                Background: TBackground);
var M,M1,Stream: TMemoryStream; CBack: TBack; Curr: TDinamic; i: integer;
    Body: record
            PictType: integer;
            PictSize: Int64;
            Color: TColor;
            Empty: boolean;
            Stretch: Boolean;
            Mozaik: Boolean;
          end;
begin
  if FileExists(FileName) then
  begin
    RegisterClasses([TBack,TText,TAnalog,TDigital,TDinContur,TDinLatch,
                     TCommand,TDinPipe,TRxTube,TRxCone,TRxTruncCone,
                     TRxCover,TDinJumper,TDinNode]);
    CBack:=TBack.Create(nil);
    try
      M:=TMemoryStream.Create;
      try
        M.LoadFromFile(FileName);
        try
          CBack:=M.ReadComponent(CBack) as TBack;
        except
          CBack.NotEmpty:=False;
        end;
//---------------------------------------------
        M1:=TMemoryStream.Create;
        Stream:=TMemoryStream.Create;
        try
          if CBack.BackType = btJPEG then
          begin
            Body.PictType:=-1;
            if FileFormats.Find(LowerCase('.jpg'),i) then
              Body.PictType:=i;
          end
          else
          begin
            Body.PictType:=-1;
            if FileFormats.Find(LowerCase('.bmp'),i) then
              Body.PictType:=i;
          end;
          Body.Empty:=not CBack.NotEmpty;
          if CBack.NotEmpty then
          begin
            if CBack.BackType = btJPEG then
            begin
              if Assigned(CBack.BackImage) then
                CBack.BackImage.SaveToStream(M1);
            end
            else
            begin
              if Assigned(CBack.LargeImage) then
                CBack.LargeImage.SaveToStream(M1);
            end;
          end;
          Body.PictSize:=M1.Size;
          Body.Color:=clBlack;
          Body.Mozaik:=False;
          Stream.WriteBuffer(Body,SizeOf(Body));
          if not Body.Empty then
          begin
            M1.Position:=0;
            M1.SaveToStream(Stream);
          end;
          Stream.Position:=0;
          Background.LoadFromStream(Stream);
        finally
          Stream.Free;
          M1.Free;
        end;
//---------------------------------------------
        while M.Position < M.Size do
        begin
          try
            Curr:=M.ReadComponent(nil) as TDinamic;
            Items.Add(Curr);
          except
            // Ошибка загрузки динамического элемента
          end;
        end;
      finally
        M.Free;
      end;
    finally
      CBack.Free;
    end;
    UnregisterClasses([TBack,TText,TAnalog,TDigital,TDinContur,TDinLatch,
                     TCommand,TDinPipe,TRxTube,TRxCone,TRxTruncCone,
                     TRxCover,TDinJumper,TDinNode]);
  end;
end;

{ TDinamic }

constructor TDinamic.Create(AOwner: TComponent);
begin
  inherited;
  FTransparent:=True;
  Width:=30;
  Height:=30;
end;

{ TBack }

constructor TBack.Create(AOwner: TComponent);
begin
  inherited;
  FJpgBackImage:=TJPEGImage.Create;
  FBmpBackImage:=TBitmap.Create;
  FBackType:=btJPEG;
end;

destructor TBack.Destroy;
begin
  FBmpBackImage.Free;
  FJpgBackImage.Free;
  inherited;
end;

{ TDinJumper }

constructor TDinJumper.Create(AOwner: TComponent);
begin
  inherited;
  Width:=50;
  Height:=50;
  DinamicType:=0;
end;

procedure TDinJumper.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinamicType;
  Body.Framed:=Framed;
  Body.Solid:=Solid;
  Body.ScreenName:=ScreenName+'.SCM';
  Body.Text:=Text;
  Body.Color:=Color;
  Body.KeyLevel:=0;
  Body.Font.Name:=Font.Name;
  Body.Font.Color:=Font.Color;
  Body.Font.CharSet:=Font.Charset;
  Body.Font.Size:=Font.Size;
  Body.Font.Style:=Font.Style;
  Body.Left:=Left;
  Body.Top:=Top;
  Body.Width:=Width;
  Body.Height:=Height;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TText }

constructor TText.Create(AOwner: TComponent);
begin
  inherited;
  FFont1:=TFont.Create;
  FFont0:=TFont.Create;
  Width := 65;
  Height := 17;
  Caption:='Текст';
  Hint:='';
  ShowHint:=True;
  Color:=clBlack;
  Transparent:=True;
  Font.Color:=clWhite;
  FFont0.Color:=clWhite;
  FColor0:=clRed;
  FText0:=Caption;
  FFont1.Color:=clLime;
  FColor1:=clBlack;
  FText1:=Caption;
  DinamicType:=2;
end;

destructor TText.Destroy;
begin
  FFont0.Free;
  FFont1.Free;
  inherited;
end;

procedure TText.SaveToStream(Stream: TStream);
begin                  
  Body.DinType:=DinamicType;  
  Body.PtName:=ParName;   
  Body.ShowPanel:=Framed; 
  Body.Solid:=not Transparent;
  Body.Framed:=False;
  Body.FrameColor:=clGray;
  Body.Text:=Text;
  Body.Color:=Color;
  Body.Font.Name:=Font.Name;
  Body.Font.Color:=Font.Color;
  Body.Font.CharSet:=Font.Charset;
  Body.Font.Size:=Font.Size;
  Body.Font.Style:=Font.Style;
  Body.Text0:=Text0;
  Body.Color0:=Color0;
  Body.Font0.Name:=Font0.Name;
  Body.Font0.Color:=Font0.Color;
  Body.Font0.CharSet:=Font0.Charset;
  Body.Font0.Size:=Font0.Size;
  Body.Font0.Style:=Font0.Style;
  Body.Text1:=Text1;
  Body.Color1:=Color1;
  Body.Font1.Name:=Font1.Name;
  Body.Font1.Color:=Font1.Color;
  Body.Font1.CharSet:=Font1.Charset;
  Body.Font1.Size:=Font1.Size;
  Body.Font1.Style:=Font1.Style;
  Body.Left:=Left;
  Body.Top:=Top;
  Body.Width:=Width;
  Body.Height:=Height;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TText.SetFont0(const Value: TFont);
begin
  FFont0.Assign(Value);
end;

procedure TText.SetFont1(const Value: TFont);
begin
  FFont1.Assign(Value);
end;

{ TAnalog }

constructor TAnalog.Create(AOwner: TComponent);
begin
  inherited;
  FShowValue:=True;
  ShowHint:=True;
  Hint:='Аналоговая величина';
  FParameter:='PV';
  Width := 65;
  Height := 17;
  FFormatString:='%.1f';
  Font.Name:='Arial';
  Font.Size:=9;
  Font.Color:=clLime;
  Color:=clBlack;
  DinamicType:=1;
end;

procedure TAnalog.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinamicType;
  Body.PtName:=ParName;
  Body.PtParam:=Parameter;
  Body.FrameColor:=clGray;
  Body.ShowPanel:=Framed;
  Body.ShowBar:=not ShowAsLevel;
  Body.ShowLevel:=ShowAsLevel;
  Body.BarLevelVisible:=ShowBar;
  Body.BarLevelColor:=BarColor;
  Body.BarLevelInverse:=InverseBar;
  Body.ShowUnit:=ShowUnit;
  Body.ShowChecks:=FShowTrips;
  Body.ShowValue:=ShowValue;
  Body.Framed:=ShowFrame;
  Body.Color:=Color;
  Body.Font.Name:=Font.Name;
  Body.Font.Color:=Font.Color;
  Body.Font.CharSet:=Font.Charset;
  Body.Font.Size:=Font.Size;
  Body.Font.Style:=Font.Style;
  Body.Left:=Left;
  Body.Top:=Top;
  Body.Width:=Width;
  Body.Height:=Height;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TDigital }

constructor TDigital.Create(AOwner: TComponent);
begin
  inherited;
  Width:=20;
  Height:=20;
  DinamicType:=3;
end;

procedure TDigital.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinamicType;
  Body.PtName:=ParName;
  case DinType of
   dtRect: Body.Kind:=dkRect;
   dtCircle: Body.Kind:=dkEllipce;
   dt3DRect: Body.Kind:=dkRect;
   dt3DCircle: Body.Kind:=dkEllipce;
   dtGaz,dtRad,dtVent: Body.Kind:=dkRect;
  end;
  if DinType in [dt3DRect,dt3DCircle] then
    Body.Border:=bkVolume
  else
    Body.Border:=bkNone;
  Body.Left:=Left;
  Body.Top:=Top;
  Body.Width:=Width;
  Body.Height:=Height;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TDinContur }

constructor TDinContur.Create(AOwner: TComponent);
begin
  inherited;
  Width := 80;
  Height := 80;
  Constraints.MaxWidth:=80;
  Constraints.MinWidth:=80;
  Constraints.MaxHeight:=80;
  Constraints.MinHeight:=80;
  DinamicType:=4;
end;

procedure TDinContur.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinamicType;
  Body.PtName:=ParName;
  Body.Font.Name:='Tahoma';
  Body.Font.Color:=clLime;
  Body.Font.CharSet:=RUSSIAN_CHARSET;
  Body.Font.Size:=8;
  Body.Font.Style:=[];
  Body.Left:=Left;
  Body.Top:=Top;
  Body.Width:=Width;
  Body.Height:=Height;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TDinLatch }

constructor TDinLatch.Create(AOwner: TComponent);
begin
  inherited;
  Width := 20;
  Height := 20;
  FLatchOrientation := loVertical;
  Hint := 'Задвижка';
  ShowHint := True;
  DinamicType:=5;
end;

procedure TDinLatch.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinamicType;
  Body.PtName:=ParName;
  Body.Vertical := LatchOrientation <> loHorizontal;
  Body.Left:=Left;
  Body.Top:=Top;
  Body.Width:=Width;
  Body.Height:=Height;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TCommand }

constructor TCommand.Create(AOwner: TComponent);
begin
  inherited;
  SetBounds(0,0,50,22);
  FText:='Кнопка';
  Cursor:=crHandPoint;
  DinamicType:=6;
end;

procedure TCommand.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinamicType;
  Body.PtName:=ParName;
  Body.Text:=Text;
  Body.Fixed:=Fixed;
  Body.Font.Name:=Font.Name;
  Body.Font.Color:=Font.Color;
  Body.Font.CharSet:=Font.Charset;
  Body.Font.Size:=Font.Size;
  Body.Font.Style:=Font.Style;
  Body.Left:=Left;
  Body.Top:=Top;
  Body.Width:=Width;
  Body.Height:=Height;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TDinPipe }

constructor TDinPipe.Create(AOwner: TComponent);
begin
  inherited;
  FColorON := clWhite;
  FPipeWidth := 2;
  Width := 40;
  Height := 10;
  FPipeDirection := pdHorizontally;
  FPipeHierarchy := phMaster;
  FPipeStyle := psSolid;
  FColor:=clGray;
  Transparent := True;
  ShowHint := True;
  Hint := 'Труба';
  DinamicType:=7;
end;

procedure TDinPipe.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinamicType;
  Body.PtName:=ParName;
  Body.Color:=Color;
  Body.Color0:=ColorOFF;
  Body.Color1:=ColorON;
  Body.LineWidth:=PipeWidth;
  Body.LineWidth0:=PipeWidth;
  Body.LineWidth1:=PipeWidth;
  Body.LineStyle:=PipeStyle;
  Body.LineStyle0:=PipeStyle;
  Body.LineStyle1:=PipeStyle;
  Body.LineKind:=Ord(PipeDirection);
  Body.BaseColor:=not TrueColor;
  Body.Left:=Left;
  Body.Top:=Top;
  Body.Width:=Width;
  Body.Height:=Height;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TDinNode }

constructor TDinNode.Create(AOwner: TComponent);
begin
  inherited;
  Width:=80;
  Height:=40;
  Constraints.MaxWidth:=80;
  Constraints.MinWidth:=80;
  Constraints.MaxHeight:=40;
  Constraints.MinHeight:=40;
  DinamicType:=8;
end;

procedure TDinNode.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinamicType;
  Body.PtName:=ParName;
  Body.Left:=Left;
  Body.Top:=Top;
  Body.Width:=Width;
  Body.Height:=Height;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TRxTube }

constructor TRxTube.Create(AOwner: TComponent);
begin
  inherited;
  FTransparent := True;
  Width := 40;
  Height := 40;
  FTerminator := 70;
  FLightColor := clCream;
  FDarkColor := clBlack;
  FFillDirection := fdVertical;
  FBevelVisible := False;
  FBevelColor := clBlack;
  DinamicType:=9;
end;

procedure TRxTube.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinamicType;
  Body.Border:=BevelVisible;
  Body.Solid:=not Transparent;
  Body.Volume:=True;
  Body.Terminator:=Terminator;
  Body.DarkColor:=DarkColor;
  Body.Color:=Color;
  Body.LightColor:=LightColor;
  Body.BorderColor:=BevelColor;
  Body.UnitKind:=ukCylinder;
  Body.Orientation:=TUnitOrientation(Ord(FillDirection));
  Body.Left:=Left;
  Body.Top:=Top;
  Body.Width:=Width;
  Body.Height:=Height;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TRxCone }

constructor TRxCone.Create(AOwner: TComponent);
begin
  inherited;
  DinamicType:=9;
end;

procedure TRxCone.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinamicType;
  Body.Border:=BevelVisible;
  Body.Solid:=not Transparent;
  Body.Volume:=True;
  Body.Terminator:=Terminator;
  Body.DarkColor:=DarkColor;
  Body.Color:=Color;
  Body.LightColor:=LightColor;
  Body.BorderColor:=BevelColor;
  Body.UnitKind:=ukCone;
  Body.Orientation:=TUnitOrientation(Ord(FillDirection));
  Body.Left:=Left;
  Body.Top:=Top;
  Body.Width:=Width;
  Body.Height:=Height;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TRxTruncCone }

constructor TRxTruncCone.Create(AOwner: TComponent);
begin
  inherited;
  FTruncFactor := 4;
  DinamicType:=9;
end;

procedure TRxTruncCone.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinamicType;
  Body.Border:=BevelVisible;
  Body.Solid:=not Transparent;
  Body.Volume:=True;
  Body.Terminator:=Terminator;
  Body.DarkColor:=DarkColor;
  Body.Color:=Color;
  Body.LightColor:=LightColor;
  Body.BorderColor:=BevelColor;
  Body.UnitKind:=ukTruncCone1;
  Body.Orientation:=TUnitOrientation(Ord(FillDirection));
  Body.Left:=Left;
  Body.Top:=Top;
  Body.Width:=Width;
  Body.Height:=Height;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TRxCover }

constructor TRxCover.Create(AOwner: TComponent);
begin
  inherited;
  DinamicType:=9;
end;

procedure TRxCover.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinamicType;
  Body.Border:=BevelVisible;
  Body.Solid:=not Transparent;
  Body.Volume:=True;
  Body.Terminator:=Terminator;
  Body.DarkColor:=DarkColor;
  Body.Color:=Color;
  Body.LightColor:=LightColor;
  Body.BorderColor:=BevelColor;
  Body.UnitKind:=ukHemisphere;
  Body.Orientation:=TUnitOrientation(Ord(FillDirection));
  Body.Left:=Left;
  Body.Top:=Top;
  Body.Width:=Width;
  Body.Height:=Height;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

end.
