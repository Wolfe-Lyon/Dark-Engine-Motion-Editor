object Form1: TForm1
  Left = 179
  Top = 1
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Motion Editor Version 2.0.2'
  ClientHeight = 524
  ClientWidth = 536
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clInfoText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object XRotGraph: TImage
    Left = 16
    Top = 24
    Width = 169
    Height = 105
  end
  object YRotGraph: TImage
    Left = 16
    Top = 152
    Width = 169
    Height = 105
  end
  object ZRotGraph: TImage
    Left = 16
    Top = 280
    Width = 169
    Height = 105
  end
  object Label3: TLabel
    Left = 36
    Top = 446
    Width = 69
    Height = 13
    Alignment = taRightJustify
    Caption = 'Current Frame:'
  end
  object Label4: TLabel
    Left = 15
    Top = 134
    Width = 90
    Height = 13
    Alignment = taRightJustify
    Caption = 'Current X Rotation:'
  end
  object Label5: TLabel
    Left = 15
    Top = 262
    Width = 90
    Height = 13
    Alignment = taRightJustify
    Caption = 'Current Y Rotation:'
  end
  object Label6: TLabel
    Left = 15
    Top = 390
    Width = 90
    Height = 13
    Alignment = taRightJustify
    Caption = 'Current Z Rotation:'
  end
  object YPreview: TImage
    Left = 352
    Top = 152
    Width = 169
    Height = 105
  end
  object ZPreview: TImage
    Left = 352
    Top = 280
    Width = 169
    Height = 105
  end
  object XPreview: TImage
    Left = 352
    Top = 24
    Width = 169
    Height = 105
  end
  object XGraphMaxLabel: TLabel
    Left = 158
    Top = 24
    Width = 27
    Height = 13
    Caption = '         '
    Color = clAqua
    ParentColor = False
    Visible = False
  end
  object XGraphMinLabel: TLabel
    Left = 192
    Top = 116
    Width = 27
    Height = 13
    Caption = '         '
    Visible = False
  end
  object YGraphMaxLabel: TLabel
    Left = 192
    Top = 152
    Width = 27
    Height = 13
    Caption = '         '
    Visible = False
  end
  object YGraphMinLabel: TLabel
    Left = 192
    Top = 244
    Width = 27
    Height = 13
    Caption = '         '
    Visible = False
  end
  object ZGraphMaxLabel: TLabel
    Left = 192
    Top = 280
    Width = 27
    Height = 13
    Caption = '         '
    Visible = False
  end
  object ZGraphMinLabel: TLabel
    Left = 192
    Top = 372
    Width = 27
    Height = 13
    Caption = '         '
    Visible = False
  end
  object FrameSelector: TTrackBar
    Left = 8
    Top = 408
    Width = 209
    Height = 33
    Enabled = False
    Min = 1
    Position = 1
    TabOrder = 0
    OnChange = FrameSelectorChange
  end
  object XRotSelector: TTrackBar
    Left = 192
    Top = 272
    Width = 25
    Height = 121
    Enabled = False
    Max = 359999
    Orientation = trVertical
    Frequency = 60000
    TabOrder = 1
    OnChange = XRotSelectorChange
  end
  object YRotSelector: TTrackBar
    Left = 192
    Top = 144
    Width = 25
    Height = 121
    Enabled = False
    Max = 359999
    Orientation = trVertical
    Frequency = 60000
    TabOrder = 2
    OnChange = YRotSelectorChange
  end
  object ZRotSelector: TTrackBar
    Left = 192
    Top = 16
    Width = 25
    Height = 121
    Enabled = False
    Max = 359999
    Orientation = trVertical
    Frequency = 60000
    TabOrder = 3
    OnChange = ZRotSelectorChange
  end
  object JointSelector: TComboBox
    Left = 16
    Top = 0
    Width = 161
    Height = 21
    Enabled = False
    ItemHeight = 13
    TabOrder = 4
    Text = '<Select Joint>'
    OnChange = JointSelectorChange
    Items.Strings = (
      '01 - Model Position'
      '02 - Left Ankle'
      '03 - Right Ankle'
      '04 - Left Knee'
      '05 - Right Knee'
      '06 - Left Hip'
      '07 - Right Hip'
      '08 - Model Rotation'
      '09 - Neck'
      '10 - Left Shoulder'
      '11 - Right Shoulder'
      '12 - Left Elbow'
      '13 - Right Elbow'
      '14 - Left Wrist'
      '15 - Right Wrist'
      '16 - Torso')
  end
  object IncFrameButton: TButton
    Left = 192
    Top = 444
    Width = 17
    Height = 17
    Caption = '>'
    Enabled = False
    TabOrder = 5
    OnClick = IncFrameButtonClick
  end
  object DecFrameButton: TButton
    Left = 16
    Top = 444
    Width = 17
    Height = 17
    Caption = '<'
    Enabled = False
    TabOrder = 6
    OnClick = DecFrameButtonClick
  end
  object ZRotEdit: TEdit
    Left = 112
    Top = 130
    Width = 57
    Height = 21
    Enabled = False
    MaxLength = 7
    TabOrder = 7
    Text = '0.000'
    OnKeyPress = ZRotEditKeyPress
  end
  object YRotEdit: TEdit
    Left = 118
    Top = 258
    Width = 57
    Height = 21
    Enabled = False
    MaxLength = 7
    TabOrder = 8
    Text = '0.000'
    OnKeyPress = YRotEditKeyPress
  end
  object XRotEdit: TEdit
    Left = 118
    Top = 386
    Width = 57
    Height = 21
    Enabled = False
    MaxLength = 7
    TabOrder = 9
    Text = '0.000'
    OnKeyPress = XRotEditKeyPress
  end
  object FrameNoEdit: TEdit
    Left = 110
    Top = 442
    Width = 33
    Height = 21
    Enabled = False
    TabOrder = 10
    Text = '1'
    OnKeyPress = FrameNoEditKeyPress
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 490
    Width = 536
    Height = 17
    Panels = <
      item
        Text = 'Current Motion: <NONE>'
        Width = 150
      end
      item
        Width = 80
      end
      item
        Width = 70
      end
      item
        Width = 50
      end>
  end
  object StatusBar2: TStatusBar
    Left = 0
    Top = 507
    Width = 536
    Height = 17
    Panels = <
      item
        Width = 50
      end>
  end
  object CBStanding: TCheckBox
    Left = 245
    Top = 24
    Width = 105
    Height = 17
    Caption = 'Standing'
    Enabled = False
    TabOrder = 13
    OnClick = CBStandingClick
  end
  object CBLeftFootfall: TCheckBox
    Left = 245
    Top = 40
    Width = 105
    Height = 17
    Caption = 'Left Footfall'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clDefault
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 14
    OnClick = CBLeftFootfallClick
  end
  object CBRightFootfall: TCheckBox
    Left = 245
    Top = 56
    Width = 105
    Height = 17
    Caption = 'Right Footfall'
    Enabled = False
    TabOrder = 15
    OnClick = CBRightFootfallClick
  end
  object CBLeftFootUp: TCheckBox
    Left = 245
    Top = 72
    Width = 105
    Height = 17
    Caption = 'Left Foot Up'
    Enabled = False
    TabOrder = 16
    OnClick = CBLeftFootUpClick
  end
  object CBRightFootUp: TCheckBox
    Left = 245
    Top = 88
    Width = 105
    Height = 17
    Caption = 'Right Foot Up'
    Enabled = False
    TabOrder = 17
    OnClick = CBRightFootUpClick
  end
  object CBFireRelease: TCheckBox
    Left = 245
    Top = 104
    Width = 105
    Height = 17
    Caption = 'Fire Release'
    Enabled = False
    TabOrder = 18
    OnClick = CBFireReleaseClick
  end
  object CBCanInterrupt: TCheckBox
    Left = 245
    Top = 120
    Width = 105
    Height = 17
    Caption = 'Can Interrupt'
    Enabled = False
    TabOrder = 19
    OnClick = CBCanInterruptClick
  end
  object CBStartMotionHere: TCheckBox
    Left = 245
    Top = 136
    Width = 105
    Height = 17
    Caption = 'Start Motion Here'
    Enabled = False
    TabOrder = 20
    OnClick = CBStartMotionHereClick
  end
  object CBEndMotionHere: TCheckBox
    Left = 245
    Top = 152
    Width = 105
    Height = 17
    Caption = 'End Motion Here'
    Enabled = False
    TabOrder = 21
    OnClick = CBEndMotionHereClick
  end
  object CBBlankTag1: TCheckBox
    Left = 245
    Top = 168
    Width = 105
    Height = 17
    Caption = '          '
    Enabled = False
    TabOrder = 22
    OnClick = CBBlankTag1Click
  end
  object CBBlankTag2: TCheckBox
    Left = 245
    Top = 184
    Width = 105
    Height = 17
    Caption = '          '
    Enabled = False
    TabOrder = 23
    OnClick = CBBlankTag2Click
  end
  object CBBlankTag3: TCheckBox
    Left = 245
    Top = 200
    Width = 105
    Height = 17
    Caption = '          '
    Enabled = False
    TabOrder = 24
    OnClick = CBBlankTag3Click
  end
  object CBTrigger1: TCheckBox
    Left = 245
    Top = 216
    Width = 105
    Height = 17
    Caption = 'Trigger 1'
    Enabled = False
    TabOrder = 25
    OnClick = CBTrigger1Click
  end
  object CBTrigger2: TCheckBox
    Left = 245
    Top = 232
    Width = 105
    Height = 17
    Caption = 'Trigger 2'
    Enabled = False
    TabOrder = 26
    OnClick = CBTrigger2Click
  end
  object CBTrigger3: TCheckBox
    Left = 245
    Top = 248
    Width = 105
    Height = 17
    Caption = 'Trigger 3'
    Enabled = False
    TabOrder = 27
    OnClick = CBTrigger3Click
  end
  object CBTrigger4: TCheckBox
    Left = 245
    Top = 264
    Width = 105
    Height = 17
    Caption = 'Trigger 4'
    Enabled = False
    TabOrder = 28
    OnClick = CBTrigger4Click
  end
  object CBTrigger5: TCheckBox
    Left = 245
    Top = 280
    Width = 105
    Height = 17
    Caption = 'Trigger 5'
    Enabled = False
    TabOrder = 29
    OnClick = CBTrigger5Click
  end
  object CBTrigger6: TCheckBox
    Left = 245
    Top = 296
    Width = 105
    Height = 17
    Caption = 'Trigger 6'
    Enabled = False
    TabOrder = 30
    OnClick = CBTrigger6Click
  end
  object CBTrigger7: TCheckBox
    Left = 245
    Top = 312
    Width = 105
    Height = 17
    Caption = 'Trigger 7'
    Enabled = False
    TabOrder = 31
    OnClick = CBTrigger7Click
  end
  object CBTrigger8: TCheckBox
    Left = 245
    Top = 328
    Width = 105
    Height = 17
    Caption = 'Trigger 8'
    Enabled = False
    TabOrder = 32
    OnClick = CBTrigger8Click
  end
  object PreviewPlayButton: TBitBtn
    Left = 352
    Top = 400
    Width = 73
    Height = 33
    Caption = 'Play'
    Enabled = False
    TabOrder = 33
    OnClick = PreviewPlayButtonClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00277777777777
      777777FF777777777777777700002AA77777777777777787FF77777777777777
      00002AAAA77777777777778777FF77777777777700002AAAAAA7777777777787
      7777FF777777777700002AAAAAAAA77777777787777777FF7777777700002AAA
      AAAAAAA77777778777777777FF77777700002AAAAAAAAAAAA777778777777777
      77FF777700002AAAAAAAAAAAAAA77787777777777777FF7700002AAAAAAAAAAA
      AAAAA78777777777777777FF00002AAAAAAAAAAAAAAAA7877777777777777788
      00002AAAAAAAAAAAAAA22787777777777777887700002AAAAAAAAAAAA2277787
      777777777788777700002AAAAAAAAAA227777787777777778877777700002AAA
      AAAAA22777777787777777887777777700002AAAAAA227777777778777778877
      7777777700002AAAA227777777777787778877777777777700002AA227777777
      7777778788777777777777770000222777777777777777887777777777777777
      0000}
    NumGlyphs = 2
  end
  object StopPreviewPlayButton: TBitBtn
    Left = 448
    Top = 400
    Width = 73
    Height = 33
    Caption = 'Stop'
    Enabled = False
    TabOrder = 34
    OnClick = StopPreviewPlayButtonClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00199999999999
      999999FFFFFFFFFFFFFFFFFF000019999999999999999987777777777777777F
      000019999999999999999987777777777777777F000019999999999999999987
      777777777777777F000019999999999999999987777777777777777F00001999
      9999999999999987777777777777777F00001999999999999999998777777777
      7777777F000019999999999999999987777777777777777F0000199999999999
      99999987777777777777777F000019999999999999999987777777777777777F
      000019999999999999999987777777777777777F000019999999999999999987
      777777777777777F000019999999999999999987777777777777777F00001999
      9999999999999987777777777777777F00001999999999999999998777777777
      7777777F000019999999999999999987777777777777777F0000199999999999
      99999987777777777777777F0000111111111111111111888888888888888888
      0000}
    NumGlyphs = 2
  end
  object MainMenu1: TMainMenu
    Left = 504
    Top = 32
    object File1: TMenuItem
      Caption = 'File'
      object New1: TMenuItem
        Caption = 'New'
        OnClick = New1Click
      end
      object Open1: TMenuItem
        Caption = 'Open...'
        OnClick = Open1Click
      end
      object Save1: TMenuItem
        Caption = 'Save'
        Enabled = False
        OnClick = Save1Click
      end
      object SaveAs1: TMenuItem
        Caption = 'Save As...'
        Enabled = False
        OnClick = SaveAs1Click
      end
      object Close1: TMenuItem
        Caption = 'Close'
        Enabled = False
        OnClick = Close1Click
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      Enabled = False
      object BlankCurrentJoint1: TMenuItem
        Caption = 'Blank Current Joint'
        Enabled = False
        OnClick = BlankCurrentJoint1Click
      end
      object SetMarkeratCurrentFrame1: TMenuItem
        Caption = 'Set Marker at Current Frame'
        OnClick = SetMarkeratCurrentFrame1Click
      end
      object CopyFromMarkedFrame1: TMenuItem
        Caption = 'Copy From Marked Frame'
        Enabled = False
        OnClick = CopyFromMarkedFrame1Click
      end
      object CurrentCreatureType1: TMenuItem
        Caption = 'Current Creature Type'
        object Humanoid1: TMenuItem
          Caption = 'Humanoid (Thief / SS2)'
          RadioItem = True
          OnClick = Humanoid1Click
        end
        object Burrick1: TMenuItem
          Caption = 'Burrick (Thief)'
          RadioItem = True
          OnClick = Burrick1Click
        end
      end
      object Options1: TMenuItem
        Caption = 'Options'
        object InteractiveGraphsinPreviewPlaybackMode1: TMenuItem
          Caption = 'Interactive Graphs in Preview Playback Mode'
          object PreviewGraphsYes: TMenuItem
            Caption = 'Yes'
            GroupIndex = 1
            RadioItem = True
            OnClick = PreviewGraphsYesClick
          end
          object PreviewGraphsNo: TMenuItem
            Caption = 'No'
            GroupIndex = 1
            RadioItem = True
            OnClick = PreviewGraphsNoClick
          end
        end
      end
      object LinearInterpolation1: TMenuItem
        Caption = 'Linear Interpolation'
        Enabled = False
        object InterpolateX1: TMenuItem
          Caption = 'Interpolate X (Curr Joint)'
          OnClick = InterpolateX1Click
        end
        object InterpolateY1: TMenuItem
          Caption = 'Interpolate Y (Curr Joint)'
          OnClick = InterpolateY1Click
        end
        object InterpolateZ1: TMenuItem
          Caption = 'Interpolate Z (Curr Joint)'
          OnClick = InterpolateZ1Click
        end
        object InterpolateXYZ1: TMenuItem
          Caption = 'Interpolate X, Y and Z (Curr Joint)'
          OnClick = InterpolateXYZ1Click
        end
        object InterpolateXAllJoints1: TMenuItem
          Break = mbBarBreak
          Caption = 'Interpolate X (All Joints)'
          OnClick = InterpolateXAllJoints1Click
        end
        object InterpolateYAllJoints1: TMenuItem
          Caption = 'Interpolate Y (All Joints)'
          OnClick = InterpolateYAllJoints1Click
        end
        object InterpolateZAllJoints1: TMenuItem
          Caption = 'Interpolate Z (All Joints)'
          OnClick = InterpolateZAllJoints1Click
        end
        object InterpolateXYandZAllJoints1: TMenuItem
          Caption = 'Interpolate X, Y and Z (All Joints)'
          OnClick = InterpolateXYandZAllJoints1Click
        end
      end
      object MotionParameters1: TMenuItem
        Caption = 'Motion Parameters...'
        OnClick = MotionParameters1Click
      end
    end
    object Tags1: TMenuItem
      Caption = 'Tags'
      Enabled = False
      object MenuStanding: TMenuItem
        Caption = 'Standing'
        OnClick = MenuStandingClick
      end
      object MenuLeftFootfall: TMenuItem
        Caption = 'LeftFootfall'
        OnClick = MenuLeftFootfallClick
      end
      object MenuRightFootfall: TMenuItem
        Caption = 'RightFootfall'
        OnClick = MenuRightFootfallClick
      end
      object MenuLeftFootUp: TMenuItem
        Caption = 'Left Foot Up'
        OnClick = MenuLeftFootUpClick
      end
      object MenuRightFootUp: TMenuItem
        Caption = 'Right Foot Up'
        OnClick = MenuRightFootUpClick
      end
      object MenuFireRelease: TMenuItem
        Caption = 'Fire Release'
        OnClick = MenuFireReleaseClick
      end
      object MenuCanInterrupt: TMenuItem
        Caption = 'Can Interrupt'
        OnClick = MenuCanInterruptClick
      end
      object MenuStartMotionHere: TMenuItem
        Caption = 'Start Motion Here'
        OnClick = MenuStartMotionHereClick
      end
      object MenuEndMotionHere: TMenuItem
        Caption = 'End Motion Here'
        OnClick = MenuEndMotionHereClick
      end
      object MenuBlankTag1: TMenuItem
        Caption = '          '
        OnClick = MenuBlankTag1Click
      end
      object MenuBlankTag2: TMenuItem
        Caption = '          '
        OnClick = MenuBlankTag2Click
      end
      object MenuBlankTag3: TMenuItem
        Caption = '          '
        OnClick = MenuBlankTag3Click
      end
      object MenuTrigger1: TMenuItem
        Caption = 'Trigger 1'
        OnClick = MenuTrigger1Click
      end
      object MenuTrigger2: TMenuItem
        Caption = 'Trigger 2'
        OnClick = MenuTrigger2Click
      end
      object MenuTrigger3: TMenuItem
        Caption = 'Trigger 3'
        OnClick = MenuTrigger3Click
      end
      object MenuTrigger4: TMenuItem
        Caption = 'Trigger 4'
        OnClick = MenuTrigger4Click
      end
      object MenuTrigger5: TMenuItem
        Caption = 'Trigger 5 (T2)'
        OnClick = MenuTrigger5Click
      end
      object MenuTrigger6: TMenuItem
        Caption = 'Trigger 6 (T2)'
        OnClick = MenuTrigger6Click
      end
      object MenuTrigger7: TMenuItem
        Caption = 'Trigger 7 (T2)'
        OnClick = MenuTrigger7Click
      end
      object MenuTrigger8: TMenuItem
        Caption = 'Trigger 8 (T2)'
        OnClick = MenuTrigger8Click
      end
    end
    object About1: TMenuItem
      Caption = 'About'
      object AboutMotionEditor1: TMenuItem
        Caption = 'About '#39'Motion Editor'#39
        OnClick = AboutMotionEditor1Click
      end
    end
    object Debug1: TMenuItem
      Caption = 'Debug'
      object ShowCurrentPositions1: TMenuItem
        Caption = 'Show Current Positions'
        OnClick = ShowCurrentPositions1Click
      end
    end
  end
  object OpenMIDialog: TOpenDialog
    Filter = 'Dark Motion Info Files (*.mi)|*.mi|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Open Dark Motion Info File'
    Left = 440
    Top = 32
  end
  object OpenMCDialog: TOpenDialog
    Filter = 'Dark Motion Control Files (*.mc)|*.mc|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Open Dark Motion Control File'
    Left = 440
  end
  object DXPreviewPlayTimer: TDXTimer
    ActiveOnly = False
    Enabled = False
    Interval = 1000
    OnTimer = DXPreviewPlayTimerTimer
    Left = 504
  end
  object SaveMCDialog: TSaveDialog
    Filter = 'Dark Motion Control Files (*.mc)|*.mc|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofPathMustExist, ofEnableSizing]
    Title = 'Save Dark Motion Control File As...'
    Left = 472
  end
  object SaveMIDialog: TSaveDialog
    Filter = 'Dark Motion Info Files (*.mi)|*.mi|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofPathMustExist, ofEnableSizing]
    Title = 'Save Dark Motion Info File As...'
    Left = 472
    Top = 32
  end
end
