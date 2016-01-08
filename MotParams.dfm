object MotParamsForm: TMotParamsForm
  Left = 192
  Top = 107
  Width = 313
  Height = 215
  Caption = 'Motion Parameters'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object FrameCountEdit: TSpinEdit
    Left = 112
    Top = 40
    Width = 73
    Height = 22
    MaxValue = 2147483647
    MinValue = 2
    TabOrder = 0
    Value = 2
    OnChange = FrameCountEditChange
  end
  object StaticText1: TStaticText
    Left = 16
    Top = 42
    Width = 90
    Height = 17
    Caption = 'Number of frames:'
    TabOrder = 1
  end
  object FrameRateEdit: TSpinEdit
    Left = 112
    Top = 64
    Width = 73
    Height = 22
    MaxLength = 1
    MaxValue = 2147483647
    MinValue = 0
    TabOrder = 2
    Value = 30
    OnChange = FrameRateEditChange
  end
  object StaticText2: TStaticText
    Left = 16
    Top = 66
    Width = 57
    Height = 17
    Caption = 'Frame rate:'
    TabOrder = 3
  end
  object StaticText3: TStaticText
    Left = 192
    Top = 66
    Width = 18
    Height = 17
    Caption = 'fps'
    TabOrder = 4
  end
  object CreatureClassSelector: TComboBox
    Left = 112
    Top = 16
    Width = 169
    Height = 21
    ItemHeight = 13
    ItemIndex = 1
    TabOrder = 5
    Text = 'Human with Sword'
    OnChange = CreatureClassSelectorChange
    Items.Strings = (
      'Humanoid'
      'Human with Sword'
      'Crayman'
      'Spider'
      'Sweel'
      'Arm')
  end
  object MotParamsOK: TBitBtn
    Left = 48
    Top = 120
    Width = 89
    Height = 49
    Caption = 'OK'
    TabOrder = 6
    OnClick = MotParamsOKClick
  end
  object MotParamsCancel: TBitBtn
    Left = 152
    Top = 120
    Width = 89
    Height = 49
    Caption = 'Cancel'
    TabOrder = 7
    OnClick = MotParamsCancelClick
  end
  object MotionNameEdit: TEdit
    Left = 112
    Top = 88
    Width = 169
    Height = 21
    MaxLength = 8
    TabOrder = 8
    OnChange = MotionNameEditChange
  end
  object StaticText4: TStaticText
    Left = 16
    Top = 90
    Width = 68
    Height = 17
    Caption = 'Motion name:'
    TabOrder = 9
  end
end
