object Form1: TForm1
  Left = 223
  Top = 131
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  BorderWidth = 4
  Caption = 'TickTick'
  ClientHeight = 433
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00CCC0
    000CCCC0000000000CCCC7777CCCCCCC0000CCCC00000000CCCC7777CCCCCCCC
    C0000CCCCCCCCCCCCCC7777CCCCC0CCCCC0000CCCCCCCCCCCC7777CCCCC700CC
    C00CCCC0000000000CCCC77CCC77000C0000CCCC00000000CCCC7777C7770000
    00000CCCC000000CCCC777777777C000C00000CCCC0000CCCC77777C777CCC00
    CC00000CCCCCCCCCC77777CC77CCCCC0CCC000CCCCC00CCCCC777CCC7CCCCCCC
    CCCC0CCCCCCCCCCCCCC7CCCCCCCCCCCC0CCCCCCCCCCCCCCCCCCCCCC7CCC70CCC
    00CCCCCCCC0CC0CCCCCCCC77CC7700CC000CCCCCC000000CCCCCC777CC7700CC
    0000CCCC00000000CCCC7777CC7700CC0000C0CCC000000CCC7C7777CC7700CC
    0000C0CCC000000CCC7C7777CC7700CC0000CCCC00000000CCCC7777CC7700CC
    000CCCCCC000000CCCCCC777CC7700CC00CCCCCCCC0CC0CCCCCCCC77CC770CCC
    0CCCCCCCCCCCCCCCCCCCCCC7CCC7CCCCCCCC0CCCCCCCCCCCCCC7CCCCCCCCCCC0
    CCC000CCCCC00CCCCC777CCC7CCCCC00CC00000CCCCCCCCCC77777CC77CCC000
    C00000CCCC0000CCCC77777C777C000000000CCCC000000CCCC777777777000C
    0000CCCC00000000CCCC7777C77700CCC00CCCC0000000000CCCC77CCC770CCC
    CC0000CCCCCCCCCCCC7777CCCCC7CCCCC0000CCCCCCCCCCCCCC7777CCCCCCCCC
    0000CCCC00000000CCCC7777CCCCCCC0000CCCC0000000000CCCC7777CCC0000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 394
    Height = 433
    Align = alClient
    BevelOuter = bvLowered
    Color = 8954504
    TabOrder = 0
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 392
      Height = 20
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'h:m:s [cs | ms]'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2897964
      Font.Height = -15
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label2: TLabel
      Left = 1
      Top = 413
      Width = 392
      Height = 19
      Align = alBottom
      Alignment = taCenter
      AutoSize = False
      Caption = 'h'#176', m'#176', s'#176', cs'#176
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2897964
      Font.Height = -15
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Image1: TImage
      Left = 1
      Top = 21
      Width = 392
      Height = 392
      Align = alClient
      Constraints.MinHeight = 320
      Constraints.MinWidth = 320
    end
  end
  object Timer1: TTimer
    Interval = 45
    OnTimer = Timer1Timer
    Left = 15
    Top = 35
  end
  object MainMenu1: TMainMenu
    Left = 15
    Top = 65
    object ypedheure1: TMenuItem
      Caption = 'Type d'#39'heure'
      object TyHeure1: TMenuItem
        AutoCheck = True
        Caption = 'Duree de la session'
        Checked = True
        RadioItem = True
      end
      object TyHeure2: TMenuItem
        AutoCheck = True
        Caption = 'Heure systeme'
        RadioItem = True
      end
    end
  end
end
