object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Banco de Dados Relacional'
  ClientHeight = 498
  ClientWidth = 479
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Button1: TButton
    Left = 151
    Top = 8
    Width = 115
    Height = 49
    Caption = 'Inserir Cliente'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 272
    Top = 8
    Width = 193
    Height = 50
    Caption = 'Consultar Pedidos dos Clientes'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 8
    Width = 137
    Height = 49
    Caption = 'Consultar Cliente'
    TabOrder = 2
    OnClick = Button3Click
  end
  object ListBox1: TListBox
    Left = 8
    Top = 72
    Width = 457
    Height = 418
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    TabOrder = 3
  end
  object FDConnection1: TFDConnection
    Left = 40
    Top = 88
  end
end
