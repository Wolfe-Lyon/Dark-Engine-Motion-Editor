{
    Motion Editor (source code) - used for editing motion data in Dark
    Engine games.
    Copyright (C) 2011  Philip M. Anderson

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Menus, StdCtrls, MotTypes, DXClass, Buttons;

type
  TForm1 = class(TForm)
    XRotGraph: TImage;
    YRotGraph: TImage;
    ZRotGraph: TImage;
    FrameSelector: TTrackBar;
    XRotSelector: TTrackBar;
    YRotSelector: TTrackBar;
    ZRotSelector: TTrackBar;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    Close1: TMenuItem;
    Exit1: TMenuItem;
    About1: TMenuItem;
    AboutMotionEditor1: TMenuItem;
    JointSelector: TComboBox;
    OpenMIDialog: TOpenDialog;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    OpenMCDialog: TOpenDialog;
    Edit1: TMenuItem;
    BlankCurrentJoint1: TMenuItem;
    IncFrameButton: TButton;
    DecFrameButton: TButton;
    XPreview: TImage;
    YPreview: TImage;
    ZPreview: TImage;
    CurrentCreatureType1: TMenuItem;
    Humanoid1: TMenuItem;
    Burrick1: TMenuItem;
    Options1: TMenuItem;
    InteractiveGraphsinPreviewPlaybackMode1: TMenuItem;
    PreviewGraphsYes: TMenuItem;
    PreviewGraphsNo: TMenuItem;
    ZRotEdit: TEdit;
    YRotEdit: TEdit;
    XRotEdit: TEdit;
    SetMarkeratCurrentFrame1: TMenuItem;
    LinearInterpolation1: TMenuItem;
    InterpolateX1: TMenuItem;
    InterpolateY1: TMenuItem;
    InterpolateZ1: TMenuItem;
    InterpolateXYZ1: TMenuItem;
    InterpolateXAllJoints1: TMenuItem;
    InterpolateYAllJoints1: TMenuItem;
    InterpolateZAllJoints1: TMenuItem;
    InterpolateXYandZAllJoints1: TMenuItem;
    CopyFromMarkedFrame1: TMenuItem;
    DXPreviewPlayTimer: TDXTimer;
    FrameNoEdit: TEdit;
    StatusBar1: TStatusBar;
    StatusBar2: TStatusBar;
    MotionParameters1: TMenuItem;
    CBStanding: TCheckBox;
    CBLeftFootfall: TCheckBox;
    CBRightFootfall: TCheckBox;
    CBLeftFootUp: TCheckBox;
    CBRightFootUp: TCheckBox;
    CBFireRelease: TCheckBox;
    CBCanInterrupt: TCheckBox;
    CBStartMotionHere: TCheckBox;
    CBEndMotionHere: TCheckBox;
    CBBlankTag1: TCheckBox;
    CBBlankTag2: TCheckBox;
    CBBlankTag3: TCheckBox;
    CBTrigger1: TCheckBox;
    CBTrigger2: TCheckBox;
    CBTrigger3: TCheckBox;
    CBTrigger4: TCheckBox;
    CBTrigger5: TCheckBox;
    CBTrigger6: TCheckBox;
    CBTrigger7: TCheckBox;
    CBTrigger8: TCheckBox;
    Tags1: TMenuItem;
    MenuStanding: TMenuItem;
    MenuLeftFootfall: TMenuItem;
    MenuRightFootfall: TMenuItem;
    MenuLeftFootUp: TMenuItem;
    MenuRightFootUp: TMenuItem;
    MenuFireRelease: TMenuItem;
    MenuCanInterrupt: TMenuItem;
    MenuStartMotionHere: TMenuItem;
    MenuEndMotionHere: TMenuItem;
    MenuBlankTag1: TMenuItem;
    MenuBlankTag2: TMenuItem;
    MenuBlankTag3: TMenuItem;
    MenuTrigger1: TMenuItem;
    MenuTrigger2: TMenuItem;
    MenuTrigger3: TMenuItem;
    MenuTrigger4: TMenuItem;
    MenuTrigger5: TMenuItem;
    MenuTrigger6: TMenuItem;
    MenuTrigger7: TMenuItem;
    MenuTrigger8: TMenuItem;
    SaveMCDialog: TSaveDialog;
    SaveMIDialog: TSaveDialog;
    PreviewPlayButton: TBitBtn;
    StopPreviewPlayButton: TBitBtn;
    XGraphMaxLabel: TLabel;
    XGraphMinLabel: TLabel;
    YGraphMaxLabel: TLabel;
    YGraphMinLabel: TLabel;
    ZGraphMaxLabel: TLabel;
    ZGraphMinLabel: TLabel;
    Debug1: TMenuItem;
    ShowCurrentPositions1: TMenuItem;

    procedure FormPaint(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FrameSelectorChange(Sender: TObject);
    procedure XRotSelectorChange(Sender: TObject);
    procedure YRotSelectorChange(Sender: TObject);
    procedure ZRotSelectorChange(Sender: TObject);
    procedure JointSelectorChange(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure BlankCurrentJoint1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Close1Click(Sender: TObject);
    procedure AboutMotionEditor1Click(Sender: TObject);
    procedure DecFrameButtonClick(Sender: TObject);
    procedure IncFrameButtonClick(Sender: TObject);
    procedure PreviewPlayButtonClick(Sender: TObject);
    procedure PreviewPlayTimerTimer(Sender: TObject);
    procedure StopPreviewPlayButtonClick(Sender: TObject);
    procedure Humanoid1Click(Sender: TObject);
    procedure Burrick1Click(Sender: TObject);
    procedure PreviewGraphsYesClick(Sender: TObject);
    procedure PreviewGraphsNoClick(Sender: TObject);
    procedure SetMarkeratCurrentFrame1Click(Sender: TObject);
    procedure InterpolateX1Click(Sender: TObject);
    procedure InterpolateY1Click(Sender: TObject);
    procedure InterpolateZ1Click(Sender: TObject);
    procedure InterpolateXYZ1Click(Sender: TObject);
    procedure InterpolateXAllJoints1Click(Sender: TObject);
    procedure InterpolateYAllJoints1Click(Sender: TObject);
    procedure InterpolateZAllJoints1Click(Sender: TObject);
    procedure InterpolateXYandZAllJoints1Click(Sender: TObject);
    procedure CopyFromMarkedFrame1Click(Sender: TObject);
    procedure DXPreviewPlayTimerTimer(Sender: TObject; LagCount: Integer);
    procedure MotionParameters1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure MenuStandingClick(Sender: TObject);
    procedure MenuLeftFootfallClick(Sender: TObject);
    procedure MenuRightFootfallClick(Sender: TObject);
    procedure MenuLeftFootUpClick(Sender: TObject);
    procedure MenuRightFootUpClick(Sender: TObject);
    procedure MenuFireReleaseClick(Sender: TObject);
    procedure MenuCanInterruptClick(Sender: TObject);
    procedure MenuStartMotionHereClick(Sender: TObject);
    procedure MenuEndMotionHereClick(Sender: TObject);
    procedure MenuBlankTag1Click(Sender: TObject);
    procedure MenuBlankTag2Click(Sender: TObject);
    procedure MenuBlankTag3Click(Sender: TObject);
    procedure MenuTrigger1Click(Sender: TObject);
    procedure MenuTrigger2Click(Sender: TObject);
    procedure MenuTrigger3Click(Sender: TObject);
    procedure MenuTrigger4Click(Sender: TObject);
    procedure MenuTrigger5Click(Sender: TObject);
    procedure MenuTrigger6Click(Sender: TObject);
    procedure MenuTrigger7Click(Sender: TObject);
    procedure MenuTrigger8Click(Sender: TObject);
    procedure CBStandingClick(Sender: TObject);
    procedure CBLeftFootfallClick(Sender: TObject);
    procedure CBRightFootfallClick(Sender: TObject);
    procedure CBLeftFootUpClick(Sender: TObject);
    procedure CBRightFootUpClick(Sender: TObject);
    procedure CBFireReleaseClick(Sender: TObject);
    procedure CBCanInterruptClick(Sender: TObject);
    procedure CBStartMotionHereClick(Sender: TObject);
    procedure CBEndMotionHereClick(Sender: TObject);
    procedure CBBlankTag1Click(Sender: TObject);
    procedure CBBlankTag2Click(Sender: TObject);
    procedure CBBlankTag3Click(Sender: TObject);
    procedure CBTrigger1Click(Sender: TObject);
    procedure CBTrigger2Click(Sender: TObject);
    procedure CBTrigger3Click(Sender: TObject);
    procedure CBTrigger4Click(Sender: TObject);
    procedure CBTrigger5Click(Sender: TObject);
    procedure CBTrigger6Click(Sender: TObject);
    procedure CBTrigger7Click(Sender: TObject);
    procedure CBTrigger8Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure ZRotEditKeyPress(Sender: TObject; var Key: Char);
    procedure YRotEditKeyPress(Sender: TObject; var Key: Char);
    procedure XRotEditKeyPress(Sender: TObject; var Key: Char);
    procedure FrameNoEditKeyPress(Sender: TObject; var Key: Char);
    procedure ShowCurrentPositions1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
{Creature types}
   Humanoid  = 1;   HumNJoints = 16;
   Burrick   = 2;
   Spider    = 3;
   PlayerArm = 4;   ArmNJoints =  4;

{Creature class values}
   CC_Player_Arm       =        14;
   CC_Sweel            =       127;
   CC_Humanoid         =    524287;
   CC_Human_With_Sword =   1048575;
   CC_Crayman          =   2097151;
   CC_Bugbeast         =   4194303;
   CC_Spider           = 536870911;

{Joints} {Burrick found to have the same joints as humanoid}
   {Humanoid & burrick}         {Spider}              {Player arm}
   HumLToe      = 0;                                  ArmButt      = 0;
   HumRToe      = 1;                                  ArmRShoulder = 1;
   HumLAnkle    = 2;                                  ArmRElbow    = 2;
   HumRAnkle    = 3;                                  ArmRWrist    = 3;
   HumLKnee     = 4;                                  ArmRFinger   = 4;
   HumRKnee     = 5;
   HumLHip      = 6;
   HumRHip      = 7;
   HumButt      = 8; {Root for model rotation}
   HumNeck      = 9;
   HumLShoulder = 10;
   HumRShoulder = 11;
   HumLElbow    = 12;
   HumRElbow    = 13;
   HumLWrist    = 14;
   HumRWrist    = 15;
   HumLFinger   = 16;
   HumRFinger   = 17;
   HumAbdomen   = 18;
   HumHead      = 19;

var
   Form1: TForm1;
   NFrames :LongWord;
   MIFileName :String;
   MIFileOpened :Boolean;
   MCFileName :String;
   MCFile :File;
   MCFileOpened :Boolean;
   MemoryAllocated :Boolean;
   CurrFrame :LongWord;
   CurrJoint :LongWord;
   CurrXRotation :Single;
   CurrYRotation :Single;
   CurrZRotation :Single;
   EulerList :Array[1..16] of TList;
   MCNJoints :LongWord;
   PreviewPlayEnabled :Boolean;
   CurrCreatureType :Integer; {Currently selected creature type - humanoid/burrick/spider}
{  DebugFile :Text;}
   MarkedFrameNumber :LongWord; {Used to set a marker at a particular frame for
                                interpolation and copy/paste}
   MIMotName :String; {Name string stored in .mi file}
   CreatureClass :LongWord; {Creature type in .mi file}
   MIDWord1 :LongWord; {First DWORD (unknown) in .mi file}
   MIDWord2 :LongWord; {Fifth DWORD (unknown) in .mi file}
   FrameCount :Single; {Number of frames from .mi file}
   FrameRate :LongWord;
   NJoints :LongWord;
   DataLoaded :Boolean; {Is a file open, or has file/new been done?}
   MITagList :TList;
   MIArray1 :Array[1..15] of LongWord;
   MIJointSectionLength :LongWord;
   MIUnknown1 :LongWord;
   MINumberOfFlagsSet :LongWord;
   MIUnknown2 :LongWord;
   MIUnknown3 :LongWord;
   MIUnknown4 :LongWord;
   MIUnknown5 :LongWord;

Const
   PreviewScale = 25;
{PreviewScale shouldn't really be here - temporary, as above}

implementation

uses about,
     MotMaths,
     GraphAndPreviewPlotting,
     CoordSetup,
     MotFiles,
     MotParams;

{$R *.dfm}

Procedure Initialise;
{Initialise all variables}
begin
   MCFileOpened := False;
   MIFileOpened := False;
   MemoryAllocated := False;
   NFrames:=0;
   MIFileName := '';
   CurrFrame := 1;
   PreviewPlayEnabled := False;
   MarkedFrameNumber := 0;

{   Assign(DebugFile, 'e:\debug.txt');
   Rewrite(DebugFile);}

   Form1.XGraphMaxLabel.Color := RGB(  0, 255, 255);
   Form1.XGraphMinLabel.Color := RGB(  0, 255, 255);
   Form1.YGraphMaxLabel.Color := RGB(255,   0, 255);
   Form1.YGraphMinLabel.Color := RGB(255,   0, 255);
   Form1.ZGraphMaxLabel.Color := RGB(255, 255,   0);
   Form1.ZGraphMinLabel.Color := RGB(255, 255,   0);

{Set up joint initial positions}
   InitHumanoidJointPositions;
   InitBurrickJointPositions;
   InitSpiderJointPositions;
   InitPlayerArmJointPositions;
   CurrCreatureType := 0; {Default to unknown}
   NJoints := 0;
{Default to mode where all sliders and graphs animate in preview playback mode}
{   Form1.PreviewGraphsYes.Checked := False;}
   Form1.PreviewGraphsNo.Checked  := True;
   Form1.StatusBar1.Panels.Items[0].Text := ('Current Motion: <NONE>');
   Form1.StatusBar1.Panels.Items[1].Text := ('');
   Form1.StatusBar1.Panels.Items[2].Text := ('');
   Form1.StatusBar1.Panels.Items[3].Text := ('');
   Form1.StatusBar2.Panels.Items[0].Text := ('Current File: <NONE>');

{Blank graph and preview windows}
   RedrawGraphs(0, 0, 0);
   RedrawPreviews(0, 0);
   DataLoaded := False;
end;

Procedure UnlockForm;

Begin
   Form1.JointSelector.Enabled      := True;
   Form1.Close1.Enabled             := True;
{   Form1.Save1.Enabled              := True;}
   Form1.SaveAs1.Enabled            := True;
{   Form1.BlankCurrentJoint1.Enabled := True;}
   Form1.Edit1.Enabled              := True;
{Unlock tag check boxes and menu}
   Form1.Tags1.Enabled              := True;
   Form1.CBStanding.Enabled         := True;
   Form1.CBLeftFootfall.Enabled     := True;
   Form1.CBRightFootfall.Enabled    := True;
   Form1.CBLeftFootUp.Enabled       := True;
   Form1.CBRightFootUp.Enabled      := True;
   Form1.CBFireRelease.Enabled      := True;
   Form1.CBCanInterrupt.Enabled     := True;
   Form1.CBStartMotionHere.Enabled  := True;
   Form1.CBEndMotionHere.Enabled    := True;
   Form1.CBBlankTag1.Enabled        := True;
   Form1.CBBlankTag2.Enabled        := True;
   Form1.CBBlankTag3.Enabled        := True;
   Form1.CBTrigger1.Enabled         := True;
   Form1.CBTrigger2.Enabled         := True;
   Form1.CBTrigger3.Enabled         := True;
   Form1.CBTrigger4.Enabled         := True;
   Form1.CBTrigger5.Enabled         := True;
   Form1.CBTrigger6.Enabled         := True;
   Form1.CBTrigger7.Enabled         := True;
   Form1.CBTrigger8.Enabled         := True;
End;

Procedure LockForm;

Begin
   Form1.JointSelector.Enabled      := False;
   Form1.XRotSelector.Enabled       := False;
   Form1.YRotSelector.Enabled       := False;
   Form1.ZRotSelector.Enabled       := False;
   Form1.FrameSelector.Enabled      := False;
   Form1.Close1.Enabled             := False;
   Form1.Save1.Enabled              := False;
   Form1.SaveAs1.Enabled            := False;
   Form1.DecFrameButton.Enabled     := False;
   Form1.IncFrameButton.Enabled     := False;
   Form1.BlankCurrentJoint1.Enabled := False;
   Form1.PreviewPlayButton.Enabled  := False;
   Form1.Edit1.Enabled              := False;
   Form1.XRotEdit.Enabled           := False;
   Form1.YRotEdit.Enabled           := False;
   Form1.ZRotEdit.Enabled           := False;
   Form1.LinearInterpolation1.Enabled := False;
   Form1.CopyFromMarkedFrame1.Enabled := False;
   Form1.FrameNoEdit.Enabled          := False;
{Unlock tag check boxes and menu}
   Form1.Tags1.Enabled              := False;
   Form1.CBStanding.Enabled         := False;
   Form1.CBLeftFootfall.Enabled     := False;
   Form1.CBRightFootfall.Enabled    := False;
   Form1.CBLeftFootUp.Enabled       := False;
   Form1.CBRightFootUp.Enabled      := False;
   Form1.CBFireRelease.Enabled      := False;
   Form1.CBCanInterrupt.Enabled     := False;
   Form1.CBStartMotionHere.Enabled  := False;
   Form1.CBEndMotionHere.Enabled    := False;
   Form1.CBBlankTag1.Enabled        := False;
   Form1.CBBlankTag2.Enabled        := False;
   Form1.CBBlankTag3.Enabled        := False;
   Form1.CBTrigger1.Enabled         := False;
   Form1.CBTrigger2.Enabled         := False;
   Form1.CBTrigger3.Enabled         := False;
   Form1.CBTrigger4.Enabled         := False;
   Form1.CBTrigger5.Enabled         := False;
   Form1.CBTrigger6.Enabled         := False;
   Form1.CBTrigger7.Enabled         := False;
   Form1.CBTrigger8.Enabled         := False;
End;


Procedure Finalise; {Close all files, and deallocate all resources.}

var
   Counter :Integer;

Begin
{Close files.}
   If (MCFileOpened) then
   Begin
{      CloseFile(MCFile);}
      MCFileOpened := False;
   End;

   If (MIFileOpened) then
   Begin
{      CloseFile(MIFile);}
      MIFileOpened := False;
   End;

{Deallocate memory.}
   If (MemoryAllocated) then
   Begin
      For Counter := 1 to MCNJoints do EulerList[Counter].Free;
      MemoryAllocated := False;
   End;

   If (DataLoaded) then DataLoaded := False;
   
End;

procedure TForm1.FormPaint(Sender: TObject);
begin
   {Redraw graphs for currently selected joint}
   RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
   RedrawPreviews(CurrFrame, CurrJoint);
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
   Form1.OpenMIDialog.Execute;
   MIFileName := Form1.OpenMIDialog.FileName;

   If(MIFileName<>'') then
   begin
      ReadMIFile(MIFileName);
      Form1.OpenMCDialog.Execute;
      MCFileName := Form1.OpenMCDialog.FileName;
      if (MCFileName<>'') then
      begin
         ReadMCFile(MCFileName);
         MemoryAllocated := True;
         DataLoaded := True;
         UnlockForm;
         MCFileOpened := True;
      end;
   end;
   If (MCFileOpened) then
   Begin
      Self.StatusBar2.Panels.Items[0].Text := ('Current File: '+MCFileName);
      Self.Save1.Enabled := True;
   End;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   DataLoaded := False;
   Initialise;
   NFrames := 0;
   FrameCount := 0;
   FrameRate := 0;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
   Finalise;
   Halt(1)
end;

procedure TForm1.FrameSelectorChange(Sender: TObject);

var
   CurrFrameStr :String;
   P :EulerPointer;
   TagSet :MITagPointer;

begin
   CurrFrame := Form1.FrameSelector.Position;
   Str(CurrFrame, CurrFrameStr);
   Form1.FrameNoEdit.Text := CurrFrameStr;

   P := EulerList[CurrJoint].Items[CurrFrame - 1];

   If (CurrJoint > 1) then
   Begin
      Form1.XRotSelector.Position := Round(1000*P^.X);
      Form1.YRotSelector.Position := Round(1000*P^.Y);
      Form1.ZRotSelector.Position := Round(1000*P^.Z);
   End;

   If (CurrJoint = 1) then
   Begin
      Form1.XRotEdit.Text := FormatFloat('0.000', P^.Z);
      Form1.YRotEdit.Text := FormatFloat('0.000', P^.Y);
      Form1.ZRotEdit.Text := FormatFloat('0.000', P^.X);
      RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
      RedrawPreviews(CurrFrame, CurrJoint);
   End;

   RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
   RedrawPreviews(CurrFrame, CurrJoint);

{Set the tag checkboxes to reflect status of current frame}
   TagSet := MITagList.Items[CurrFrame - 1];
   Self.CBStanding.Checked        := TagSet.Standing;
   Self.CBLeftFootfall.Checked    := TagSet.LeftFootfall;
   Self.CBRightFootfall.Checked   := TagSet.RightFootfall;
   Self.CBLeftFootUp.Checked      := TagSet.LeftFootUp;
   Self.CBRightFootUp.Checked     := TagSet.RightFootUp;
   Self.CBFireRelease.Checked     := TagSet.FireRelease;
   Self.CBCanInterrupt.Checked    := TagSet.CanInterrupt;
   Self.CBStartMotionHere.Checked := TagSet.StartMotionHere;
   Self.CBEndMotionHere.Checked   := TagSet.EndMotionHere;
   Self.CBBlankTag1.Checked       := TagSet.BlankTag1;
   Self.CBBlankTag2.Checked       := TagSet.BlankTag2;
   Self.CBBlankTag3.Checked       := TagSet.BlankTag3;
   Self.CBTrigger1.Checked        := TagSet.Trigger1;
   Self.CBTrigger2.Checked        := TagSet.Trigger2;
   Self.CBTrigger3.Checked        := TagSet.Trigger3;
   Self.CBTrigger4.Checked        := TagSet.Trigger4;
   Self.CBTrigger5.Checked        := TagSet.Trigger5;
   Self.CBTrigger6.Checked        := TagSet.Trigger6;
   Self.CBTrigger7.Checked        := TagSet.Trigger7;
   Self.CBTrigger8.Checked        := TagSet.Trigger8;
end;

procedure TForm1.XRotSelectorChange(Sender: TObject);

var
   CurrXRotStr :String;
   P           :EulerPointer;

begin
   If (CurrJoint > 1) then
   Begin
      CurrXRotation := (Form1.XRotSelector.Position/1000);
      CurrXRotStr := FormatFloat('0.000', CurrXRotation);
      Form1.XRotEdit.Text := CurrXRotStr;

      P := EulerList[CurrJoint].Items[CurrFrame - 1];
      P^.X := CurrXRotation;

      RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
      RedrawPreviews(CurrFrame, CurrJoint);
   End;
end;

procedure TForm1.YRotSelectorChange(Sender: TObject);

var
   CurrYRotStr :String;
   P           :EulerPointer;

begin
   If (CurrJoint > 1) then
   Begin
      CurrYRotation := (Form1.YRotSelector.Position/1000);
      CurrYRotStr := FormatFloat('0.000', CurrYRotation);
      Form1.YRotEdit.Text := CurrYRotStr;

      P := EulerList[CurrJoint].Items[CurrFrame - 1];
      P^.Y := CurrYRotation;

      RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
      RedrawPreviews(CurrFrame, CurrJoint);
   End;
end;

procedure TForm1.ZRotSelectorChange(Sender: TObject);

var
   CurrZRotStr :String;
   P           :EulerPointer;

begin
   If (CurrJoint > 1) then
   Begin
      CurrZRotation := (Form1.ZRotSelector.Position/1000);
      CurrZRotStr := FormatFloat('0.000', CurrZRotation);
      Form1.ZRotEdit.Text := CurrZRotStr;

      P := EulerList[CurrJoint].Items[CurrFrame - 1];
      P^.Z := CurrZRotation;

      RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
      RedrawPreviews(CurrFrame, CurrJoint);
   End;
end;

procedure TForm1.JointSelectorChange(Sender: TObject);

var
   CurrJointStr :String;
   P            :EulerPointer;
   CurrFrameStr :String;

begin
   CurrJoint := JointSelector.ItemIndex + 1;
   Str(CurrJoint, CurrJointStr);
   RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
   RedrawPreviews(CurrFrame, CurrJoint);

   CurrFrame := Form1.FrameSelector.Position;
   Str(CurrFrame, CurrFrameStr);

   P := EulerList[CurrJoint].Items[CurrFrame - 1];

   If (CurrJoint = 1) then
   Begin
      Form1.XRotEdit.Text := FormatFloat('0.000',P^.Z);
      Form1.YRotEdit.Text := FormatFloat('0.000',P^.Y);
      Form1.ZRotEdit.Text := FormatFloat('0.000',P^.X);
      Form1.XRotSelector.Visible := False;
      Form1.YRotSelector.Visible := False;
      Form1.ZRotSelector.Visible := False;
      Form1.XGraphMaxLabel.Visible := True;
      Form1.XGraphMinLabel.Visible := True;
      Form1.YGraphMaxLabel.Visible := True;
      Form1.YGraphMinLabel.Visible := True;
      Form1.ZGraphMaxLabel.Visible := True;
      Form1.ZGraphMinLabel.Visible := True;
   End;

   If (CurrJoint > 1) then
   Begin
      Form1.XRotSelector.Position := Round(1000*P^.X);
      Form1.YRotSelector.Position := Round(1000*P^.Y);
      Form1.ZRotSelector.Position := Round(1000*P^.Z);
      Form1.XRotEdit.Text := FormatFloat('0.000',P^.X);
      Form1.YRotEdit.Text := FormatFloat('0.000',P^.Y);
      Form1.ZRotEdit.Text := FormatFloat('0.000',P^.Z);
      Form1.XRotSelector.Visible := True;
      Form1.YRotSelector.Visible := True;
      Form1.ZRotSelector.Visible := True;
      Form1.XGraphMaxLabel.Visible := False;
      Form1.XGraphMinLabel.Visible := False;
      Form1.YGraphMaxLabel.Visible := False;
      Form1.YGraphMinLabel.Visible := False;
      Form1.ZGraphMaxLabel.Visible := False;
      Form1.ZGraphMinLabel.Visible := False;
   End;

{Ensure that the user cannot 'blank current joint' when no joint is selected.
 This would normally lead to a crash!}
   If (CurrJoint = 0) then Form1.BlankCurrentJoint1.Enabled := False
                      else Form1.BlankCurrentJoint1.Enabled := True;

   Form1.XRotSelector.Enabled := True;
   Form1.YRotSelector.Enabled := True;
   Form1.ZRotSelector.Enabled := True;
   Form1.FrameSelector.Enabled := True;
   Form1.DecFrameButton.Enabled := True;
   Form1.IncFrameButton.Enabled := True;
   Form1.PreviewPlayButton.Enabled := True;
   Form1.XRotEdit.Enabled := True;
   Form1.YRotEdit.Enabled := True;
   Form1.ZRotEdit.Enabled := True;
   Form1.FrameNoEdit.Enabled := True;

   If ((CurrJoint = 0) or (CurrJoint = 1)) then
   Begin
      Form1.XRotSelector.Enabled := False;
      Form1.YRotSelector.Enabled := False;
      Form1.ZRotSelector.Enabled := False;
   End;
   If (CurrJoint = 0) then
   Begin
      Form1.FrameSelector.Enabled := False;
      Form1.DecFrameButton.Enabled := False;
      Form1.IncFrameButton.Enabled := False;
      Form1.PreviewPlayButton.Enabled := False;
      Form1.XRotEdit.Enabled := False;
      Form1.YRotEdit.Enabled := False;
      Form1.ZRotEdit.Enabled := False;
      Form1.FrameNoEdit.Enabled := False;
   End;

   If (CurrJoint = 1) then
   Begin
      Label4.Caption := 'Current X Translation:';
      Label5.Caption := 'Current Y Translation:';
      Label6.Caption := 'Current Z Translation:';
   End
   Else
   Begin
      Label4.Caption := 'Current X Rotation:';
      Label5.Caption := 'Current Y Rotation:';
      Label6.Caption := 'Current Z Rotation:';
   End;
End;

procedure TForm1.Save1Click(Sender: TObject);
begin
   WriteMIFile(MIFileName);
   WriteMCFile(MCFileName);
end;

procedure TForm1.BlankCurrentJoint1Click(Sender: TObject);
{Neutral pose is given by XRot = 180, YRot = 0 and ZRot = 0 for each joint}
Var
   Counter :LongWord;
   P       :EulerPointer;

begin
   If(CurrJoint<>1) then
   Begin
      For Counter := 1 to NFrames Do
      begin
         P := EulerList[CurrJoint].Items[Counter - 1];
         P^.X := 180.0;
         P^.Y := 0.0;
         P^.Z := 0.0;
      end;
   end
   else
   {Ensure that when joint 1 is blanked, the position is reset to 0, 0, 0 - and not 180, 0, 0}
   Begin
      For Counter := 1 to NFrames Do
      begin
         P := EulerList[CurrJoint].Items[Counter - 1];
         P^.X := 0.0;
         P^.Y := 0.0;
         P^.Z := 0.0;
      end;
   End;
   RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Finalise;
   Halt(1);
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
   Finalise;
   NFrames := 0;
   LockForm;
   Initialise;
end;

procedure TForm1.AboutMotionEditor1Click(Sender: TObject);
begin
   AboutBox.ShowModal;
end;

procedure TForm1.DecFrameButtonClick(Sender: TObject);
begin
   If (FrameSelector.Position>FrameSelector.Min) Then
      FrameSelector.Position := FrameSelector.Position - 1;
end;

procedure TForm1.IncFrameButtonClick(Sender: TObject);
begin
   If (FrameSelector.Position<FrameSelector.Max) Then
      FrameSelector.Position := FrameSelector.Position + 1;
End;

procedure TForm1.PreviewPlayButtonClick(Sender: TObject);

begin
   PreviewPlayEnabled := True;
{Reset to start of animation, so that preview play spans whole motion}
{Dirty trick to reset display to frame 1, and force redraw.}
   FrameSelector.Position := FrameSelector.Max;
   FrameSelector.Position := 1;
   StopPreviewPlayButton.Enabled := True;
   Self.DXPreviewPlayTimer.Enabled := True;
end;

procedure TForm1.PreviewPlayTimerTimer(Sender: TObject);

var
   CurrFrameStr :String;

begin
{   If (PreviewPlayEnabled and (FrameSelector.Position < NFrames)) then}
   If (PreviewPlayEnabled and (CurrFrame < NFrames)) then
      If (PreviewGraphsYes.Checked) then FrameSelector.Position := FrameSelector.Position + 1
      else
      Begin
         Redrawpreviews(CurrFrame, CurrJoint);
         Inc(CurrFrame);
         Str(CurrFrame,CurrFrameStr);
      End;
{   If (PreviewPlayEnabled and (FrameSelector.Position = NFrames)) then}
   If (PreviewPlayEnabled and (CurrFrame = NFrames)) then
   Begin
{At end of preview play, deactivate preview play mode, and reset animation to
 first frame}
      PreviewPlayEnabled := False;
{Dirty trick to reset display to frame 1, and force redraw.}
      FrameSelector.Position := FrameSelector.Max;
      FrameSelector.Position := 1;
      StopPreviewPlayButton.Enabled := False;
   End;
end;

procedure TForm1.StopPreviewPlayButtonClick(Sender: TObject);
begin
   PreviewPlayEnabled := False;
   Self.DXPreviewPlayTimer.Enabled := False;
   Self.StopPreviewPlayButton.Enabled := False;
end;

procedure TForm1.Humanoid1Click(Sender: TObject);
{User selects Humanoid creature type from Edit menu}
begin
   CurrCreatureType := Humanoid;
   NJoints := HumNJoints;
   RedrawPreviews(CurrFrame, CurrJoint);
   Humanoid1.Checked := True;
{   Burrick1.Checked := False;}
end;

procedure TForm1.Burrick1Click(Sender: TObject);
{User selects Burrick creature type from Edit menu}
begin
   CurrCreatureType := Burrick;
   NJoints := HumNJoints;
   RedrawPreviews(CurrFrame, CurrJoint);
{   Humanoid1.Checked := False;}
   Burrick1.Checked := True;
end;

procedure TForm1.PreviewGraphsYesClick(Sender: TObject);
{User selects full animation on preview playback (graphs, sliders and preview
 windows.}
begin
   PreviewGraphsYes.Checked := True;
{   PreviewGraphsNo.Checked  := False;}
end;

procedure TForm1.PreviewGraphsNoClick(Sender: TObject);
{User selects limited animation on preview playback (preview windows only.}
begin
{   PreviewGraphsYes.Checked := False;}
   PreviewGraphsNo.Checked  := True;
end;

procedure TForm1.SetMarkeratCurrentFrame1Click(Sender: TObject);
begin
   MarkedFrameNumber := CurrFrame;
   LinearInterpolation1.Enabled := True;
   CopyFromMarkedFrame1.Enabled := True;
   RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
end;

Procedure InterpolateZ;

var
   LoFrame, HiFrame :Integer; {Temporary variables to ensure that interpolation
                               always works as frame number increases}
   LoFrameX, HiFrameX :Single; {X axis Euler angle at two keyframes}
   Counter :Integer;
   LoP, HiP, IntP  :EulerPointer;
   Interval :Single; {Difference in angle between two successive interpolated frames}

begin
   If (MarkedFrameNumber>CurrFrame) then
   Begin
      LoFrame := CurrFrame;
      HiFrame := MarkedFrameNumber;
   End
   Else
   Begin
      LoFrame := MarkedFrameNumber;
      HiFrame := CurrFrame;
   End;

   LoP := EulerList[CurrJoint].Items[LoFrame - 1];
   LoFrameX := LoP.X;
   HiP := EulerList[CurrJoint].Items[HiFrame - 1];
   HiFrameX := HiP.X;

   If (Abs(HiFrameX - LoFrameX)<=180.0) then
   Begin
      Interval := (HiFrameX - LoFrameX) / (HiFrame - LoFrame);
      For Counter := (LoFrame+1) to (HiFrame-1) Do
      Begin
         IntP := EulerList[CurrJoint].Items[Counter - 1];
         IntP^.X := LoFrameX + ((Counter - LoFrame) * Interval);
      End;
   End
   Else
   Begin
      If (LoFrameX<HiFrameX) Then LoFrameX := LoFrameX + 360.0
                             Else HiFrameX := HiFrameX + 360.0;
      Interval := (HiFrameX - LoFrameX) / (HiFrame - LoFrame);
      For Counter := (LoFrame+1) to (HiFrame-1) Do
      Begin
         IntP := EulerList[CurrJoint].Items[Counter - 1];
         IntP^.X := LoFrameX + ((Counter - LoFrame) * Interval);
         If (IntP^.X > 360.0) Then IntP^.X := IntP^.X - 360.0;
      End;
   End;
End;

procedure TForm1.InterpolateZ1Click(Sender: TObject);
Begin
   InterpolateZ;
   RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
end;

Procedure InterpolateY;

var
   LoFrame, HiFrame :Integer; {Temporary variables to ensure that interpolation
                               always works as frame number increases}
   LoFrameY, HiFrameY :Single; {Y axis Euler angle at two keyframes}
   Counter :Integer;
   LoP, HiP, IntP  :EulerPointer;
   Interval :Single; {Difference in angle between two successive interpolated frames}

begin
   If (MarkedFrameNumber>CurrFrame) then
   Begin
      LoFrame := CurrFrame;
      HiFrame := MarkedFrameNumber;
   End
   Else
   Begin
      LoFrame := MarkedFrameNumber;
      HiFrame := CurrFrame;
   End;

   LoP := EulerList[CurrJoint].Items[LoFrame - 1];
   LoFrameY := LoP.Y;
   HiP := EulerList[CurrJoint].Items[HiFrame - 1];
   HiFrameY := HiP.Y;

   If (Abs(HiFrameY - LoFrameY)<=180.0) then
   Begin
      Interval := (HiFrameY - LoFrameY) / (HiFrame - LoFrame);
      For Counter := (LoFrame+1) to (HiFrame-1) Do
      Begin
         IntP := EulerList[CurrJoint].Items[Counter - 1];
         IntP^.Y := LoFrameY + ((Counter - LoFrame) * Interval);
      End;
   End
   Else
   Begin
      If (LoFrameY<HiFrameY) Then LoFrameY := LoFrameY + 360.0
                             Else HiFrameY := HiFrameY + 360.0;
      Interval := (HiFrameY - LoFrameY) / (HiFrame - LoFrame);
      For Counter := (LoFrame+1) to (HiFrame-1) Do
      Begin
         IntP := EulerList[CurrJoint].Items[Counter - 1];
         IntP^.Y := LoFrameY + ((Counter - LoFrame) * Interval);
         If (IntP^.Y > 360.0) Then IntP^.Y := IntP^.Y - 360.0;
      End;
   End;
End;

procedure TForm1.InterpolateY1Click(Sender: TObject);
Begin
   InterpolateY;
   RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
end;

Procedure InterpolateX;

var
   LoFrame, HiFrame :Integer; {Temporary variables to ensure that interpolation
                               always works as frame number increases}
   LoFrameZ, HiFrameZ :Single; {Z axis Euler angle at two keyframes}
   Counter :Integer;
   LoP, HiP, IntP  :EulerPointer;
   Interval :Single; {Difference in angle between two successive interpolated frames}

begin
   If (MarkedFrameNumber>CurrFrame) then
   Begin
      LoFrame := CurrFrame;
      HiFrame := MarkedFrameNumber;
   End
   Else
   Begin
      LoFrame := MarkedFrameNumber;
      HiFrame := CurrFrame;
   End;

   LoP := EulerList[CurrJoint].Items[LoFrame - 1];
   LoFrameZ := LoP.Z;
   HiP := EulerList[CurrJoint].Items[HiFrame - 1];
   HiFrameZ := HiP.Z;

   If (Abs(HiFrameZ - LoFrameZ)<=180.0) then
   Begin
      Interval := (HiFrameZ - LoFrameZ) / (HiFrame - LoFrame);
      For Counter := (LoFrame+1) to (HiFrame-1) Do
      Begin
         IntP := EulerList[CurrJoint].Items[Counter - 1];
         IntP^.Z := LoFrameZ + ((Counter - LoFrame) * Interval);
      End;
   End
   Else
   Begin
      If (LoFrameZ<HiFrameZ) Then LoFrameZ := LoFrameZ + 360.0
                             Else HiFrameZ := HiFrameZ + 360.0;
      Interval := (HiFrameZ - LoFrameZ) / (HiFrame - LoFrame);
      For Counter := (LoFrame+1) to (HiFrame-1) Do
      Begin
         IntP := EulerList[CurrJoint].Items[Counter - 1];
         IntP^.Z := LoFrameZ + ((Counter - LoFrame) * Interval);
         If (IntP^.Z > 360.0) Then IntP^.Z := IntP^.Z - 360.0;
      End;
   End;
End;

procedure TForm1.InterpolateX1Click(Sender: TObject);
Begin
   InterpolateX;
   RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
end;

procedure TForm1.InterpolateXYZ1Click(Sender: TObject);
begin
   InterpolateX;
   InterpolateY;
   InterpolateZ;
   RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
end;

procedure TForm1.InterpolateXAllJoints1Click(Sender: TObject);

Var
  CurrJointBackup :Integer;
  Counter :Integer;

begin
   CurrJointBackUp := CurrJoint;
   For Counter := 1 to 16 Do
   Begin
      CurrJoint := Counter;
      InterpolateX;
   End;
   CurrJoint := CurrJointBackUp;
   RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
end;

procedure TForm1.InterpolateYAllJoints1Click(Sender: TObject);

Var
  CurrJointBackup :Integer;
  Counter :Integer;

begin
   CurrJointBackUp := CurrJoint;
   For Counter := 1 to 16 Do
   Begin
      CurrJoint := Counter;
      InterpolateY;
   End;
   CurrJoint := CurrJointBackUp;
   RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
end;

procedure TForm1.InterpolateZAllJoints1Click(Sender: TObject);

Var
  CurrJointBackup :Integer;
  Counter :Integer;

begin
   CurrJointBackUp := CurrJoint;
   For Counter := 1 to 16 Do
   Begin
      CurrJoint := Counter;
      InterpolateZ;
   End;
   CurrJoint := CurrJointBackUp;
   RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
end;

procedure TForm1.InterpolateXYandZAllJoints1Click(Sender: TObject);

Var
   CurrJointBackup :Integer;
   Counter :Integer;

begin
   CurrJointBackUp := CurrJoint;
   For Counter := 1 to 16 Do
   Begin
      CurrJoint := Counter;
      InterpolateX;
      InterpolateY;
      InterpolateZ;
   End;
   CurrJoint := CurrJointBackUp;
   RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
end;

procedure TForm1.CopyFromMarkedFrame1Click(Sender: TObject);

Var
   CurrJointBackup :Integer;
   MarkedP, CurrP :EulerPointer;
   CopiedX, CopiedY, CopiedZ :Single;
   Counter :Integer;

begin
   CurrJointBackup := CurrJoint;
   For Counter := 1 to 16 Do
   Begin
      CurrJoint := Counter;
      MarkedP := EulerList[CurrJoint].Items[MarkedFrameNumber - 1];
      CopiedX := MarkedP.X;
      CopiedY := MarkedP.Y;
      CopiedZ := MarkedP.Z;
      CurrP := EulerList[CurrJoint].Items[CurrFrame - 1];
      CurrP.X := CopiedX;
      CurrP.Y := CopiedY;
      CurrP.Z := CopiedZ;
   End;
   CurrJoint := CurrJointBackup;
   RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
   RedrawPreviews(CurrFrame, CurrJoint);
end;

procedure TForm1.DXPreviewPlayTimerTimer(Sender: TObject;
  LagCount: Integer);

var
   CurrFrameStr :String;

begin
{   If (PreviewPlayEnabled and (FrameSelector.Position < NFrames)) then}
   If (PreviewPlayEnabled and (CurrFrame < NFrames)) then
      If (PreviewGraphsYes.Checked) then FrameSelector.Position := FrameSelector.Position + 1
      else
      Begin
         Redrawpreviews(CurrFrame, CurrJoint);
         Inc(CurrFrame);
         Str(CurrFrame,CurrFrameStr);
      End;
{   If (PreviewPlayEnabled and (FrameSelector.Position = NFrames)) then}
   If (PreviewPlayEnabled and (CurrFrame = NFrames)) then
   Begin
{At end of preview play, deactivate preview play mode, and reset animation to
 first frame}
      PreviewPlayEnabled := False;
{Dirty trick to reset display to frame 1, and force redraw.}
      FrameSelector.Position := FrameSelector.Max;
      FrameSelector.Position := 1;
      StopPreviewPlayButton.Enabled := False;
   End;

end;

procedure TForm1.MotionParameters1Click(Sender: TObject);

begin
   MotParamsForm.ShowModal;
end;

procedure TForm1.New1Click(Sender: TObject);

var
   JointCounter :Integer;
   FrameCounter :Integer;
   AngleSet :EulerPointer;
   TagSet :MITagPointer;

begin
   NFrames := 0;
   FrameCount := 0;
   FrameRate := 0;
{   CreatureClass := 524287;}
   CreatureClass := 99999;
{   NJoints := 16;}
   MotParamsForm.ShowModal;
   If (DataLoaded) then
   Begin
      UnlockForm;
      MITagList := TList.Create;

      For JointCounter := 1 to NJoints do
      Begin
         EulerList[JointCounter] := TList.Create;

         If(JointCounter<>1) then
         Begin
            For FrameCounter := 1 to NFrames Do
            begin
               New(AngleSet);
               AngleSet^.X := 180.0;
               AngleSet^.Y := 0.0;
               AngleSet^.Z := 0.0;
               EulerList[JointCounter].Add(AngleSet);
            end;
         end
         else
         {Ensure that when joint 1 is blanked, the position is reset to 0, 0, 0 - and not 180, 0, 0}
         Begin
            For FrameCounter := 1 to NFrames Do
            begin
               New(AngleSet);
               AngleSet^.X := 0.0;
               AngleSet^.Y := 0.0;
               AngleSet^.Z := 0.0;
               EulerList[JointCounter].Add(AngleSet);
            end;
         End;
      End;

      For FrameCounter := 1 to NFrames Do
      Begin
         New(TagSet);
         TagSet^.Standing := False;       TagSet^.LeftFootfall := False;
         TagSet^.RightFootfall := False;  TagSet^.LeftFootUp := False;
         TagSet^.RightFootUp := False;    TagSet^.FireRelease := False;
         TagSet^.CanInterrupt := False;   TagSet^.StartMotionHere := False;
         TagSet^.EndMotionHere := False;  TagSet^.BlankTag1 := False;
         TagSet^.BlankTag2 := False;      TagSet^.BlankTag3 := False;
         TagSet^.Trigger1 := False;       TagSet^.Trigger2 := False;
         TagSet^.Trigger3 := False;       TagSet^.Trigger4 := False;
         TagSet^.Trigger5 := False;       TagSet^.Trigger6 := False;
         TagSet^.Trigger7 := False;       TagSet^.Trigger8 := False;
         MITagList.Add(TagSet);
      End;
   End;
end;

procedure TForm1.MenuStandingClick(Sender: TObject);
begin
   Self.MenuStanding.Checked := Not(Self.MenuStanding.Checked);
   Self.CBStanding.Checked   :=     Self.MenuStanding.Checked;
end;

procedure TForm1.MenuLeftFootfallClick(Sender: TObject);
begin
   Self.MenuLeftFootfall.Checked := Not(Self.MenuLeftFootfall.Checked);
   Self.CBLeftFootfall.Checked   :=     Self.MenuLeftFootfall.Checked;
end;

procedure TForm1.MenuRightFootfallClick(Sender: TObject);
begin
   Self.MenuRightFootfall.Checked := Not(Self.MenuRightFootfall.Checked);
   Self.CBRightFootfall.Checked   :=     Self.MenuRightFootfall.Checked;
end;

procedure TForm1.MenuLeftFootUpClick(Sender: TObject);
begin
   Self.MenuLeftFootUp.Checked := Not(Self.MenuLeftFootUp.Checked);
   Self.CBLeftFootUp.Checked   :=     Self.MenuLeftFootUp.Checked;
end;

procedure TForm1.MenuRightFootUpClick(Sender: TObject);
begin
   Self.MenuRightFootUp.Checked := Not(Self.MenuRightFootUp.Checked);
   Self.CBRightFootUp.Checked   :=     Self.MenuRightFootUp.Checked;
end;

procedure TForm1.MenuFireReleaseClick(Sender: TObject);
begin
   Self.MenuFireRelease.Checked := Not(Self.MenuFireRelease.Checked);
   Self.CBFireRelease.Checked   :=     Self.MenuFireRelease.Checked;
end;

procedure TForm1.MenuCanInterruptClick(Sender: TObject);
begin
   Self.MenuCanInterrupt.Checked := Not(Self.MenuCanInterrupt.Checked);
   Self.CBCanInterrupt.Checked   :=     Self.MenuCanInterrupt.Checked;
end;

procedure TForm1.MenuStartMotionHereClick(Sender: TObject);
begin
   Self.MenuStartMotionHere.Checked := Not(Self.MenuStartMotionHere.Checked);
   Self.CBStartMotionHere.Checked   :=     Self.MenuStartMotionHere.Checked;
end;

procedure TForm1.MenuEndMotionHereClick(Sender: TObject);
begin
   Self.MenuEndMotionHere.Checked := Not(Self.MenuEndMotionHere.Checked);
   Self.CBEndMotionHere.Checked   :=     Self.MenuEndMotionHere.Checked;
end;

procedure TForm1.MenuBlankTag1Click(Sender: TObject);
begin
   Self.MenuBlankTag1.Checked := Not(Self.MenuBlankTag1.Checked);
   Self.CBBlankTag1.Checked   :=     Self.MenuBlankTag1.Checked;
end;

procedure TForm1.MenuBlankTag2Click(Sender: TObject);
begin
   Self.MenuBlankTag2.Checked := Not(Self.MenuBlankTag2.Checked);
   Self.CBBlankTag2.Checked   :=     Self.MenuBlankTag2.Checked;
end;

procedure TForm1.MenuBlankTag3Click(Sender: TObject);
begin
   Self.MenuBlankTag3.Checked := Not(Self.MenuBlankTag3.Checked);
   Self.CBBlankTag3.Checked   :=     Self.MenuBlankTag3.Checked;
end;

procedure TForm1.MenuTrigger1Click(Sender: TObject);
begin
   Self.MenuTrigger1.Checked := Not(Self.MenuTrigger1.Checked);
   Self.CBTrigger1.Checked   :=     Self.MenuTrigger1.Checked;
end;

procedure TForm1.MenuTrigger2Click(Sender: TObject);
begin
   Self.MenuTrigger2.Checked := Not(Self.MenuTrigger2.Checked);
   Self.CBTrigger2.Checked   :=     Self.MenuTrigger2.Checked;
end;

procedure TForm1.MenuTrigger3Click(Sender: TObject);
begin
   Self.MenuTrigger3.Checked := Not(Self.MenuTrigger3.Checked);
   Self.CBTrigger3.Checked   :=     Self.MenuTrigger3.Checked;
end;

procedure TForm1.MenuTrigger4Click(Sender: TObject);
begin
   Self.MenuTrigger4.Checked := Not(Self.MenuTrigger4.Checked);
   Self.CBTrigger4.Checked   :=     Self.MenuTrigger4.Checked;
end;

procedure TForm1.MenuTrigger5Click(Sender: TObject);
begin
   Self.MenuTrigger5.Checked := Not(Self.MenuTrigger5.Checked);
   Self.CBTrigger5.Checked   :=     Self.MenuTrigger5.Checked;
end;

procedure TForm1.MenuTrigger6Click(Sender: TObject);
begin
   Self.MenuTrigger6.Checked := Not(Self.MenuTrigger6.Checked);
   Self.CBTrigger6.Checked   :=     Self.MenuTrigger6.Checked;
end;

procedure TForm1.MenuTrigger7Click(Sender: TObject);
begin
   Self.MenuTrigger7.Checked := Not(Self.MenuTrigger7.Checked);
   Self.CBTrigger7.Checked   :=     Self.MenuTrigger7.Checked;
end;

procedure TForm1.MenuTrigger8Click(Sender: TObject);
begin
   Self.MenuTrigger8.Checked := Not(Self.MenuTrigger8.Checked);
   Self.CBTrigger8.Checked   :=     Self.MenuTrigger8.Checked;
end;

procedure TForm1.CBStandingClick(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuStanding.Checked := Self.CBStanding.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.Standing := Self.CBStanding.Checked;
end;

procedure TForm1.CBLeftFootfallClick(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuLeftFootfall.Checked := Self.CBLeftFootfall.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.LeftFootfall := Self.CBLeftFootfall.Checked;
end;

procedure TForm1.CBRightFootfallClick(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuRightFootfall.Checked := Self.CBRightFootfall.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.RightFootfall := Self.CBRightFootfall.Checked;
end;

procedure TForm1.CBLeftFootUpClick(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuLeftFootUp.Checked := Self.CBLeftFootUp.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.LeftFootUp := Self.CBLeftFootUp.Checked;
end;

procedure TForm1.CBRightFootUpClick(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuRightFootUp.Checked := Self.CBRightFootUp.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.RightFootUp := Self.CBRightFootUp.Checked;
end;

procedure TForm1.CBFireReleaseClick(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuFireRelease.Checked := Self.CBFireRelease.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.FireRelease := Self.CBFireRelease.Checked;
end;

procedure TForm1.CBCanInterruptClick(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuCanInterrupt.Checked := Self.CBCanInterrupt.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.CanInterrupt := Self.CBCanInterrupt.Checked;
end;

procedure TForm1.CBStartMotionHereClick(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuStartMotionHere.Checked := Self.CBStartMotionHere.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.StartMotionHere := Self.CBStartMotionHere.Checked;
end;

procedure TForm1.CBEndMotionHereClick(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuEndMotionHere.Checked := Self.CBEndMotionHere.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.EndMotionHere := Self.CBEndMotionHere.Checked;
end;

procedure TForm1.CBBlankTag1Click(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuBlankTag1.Checked := Self.CBBlankTag1.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.BlankTag1 := Self.CBBlankTag1.Checked;
end;

procedure TForm1.CBBlankTag2Click(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuBlankTag2.Checked := Self.CBBlankTag2.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.BlankTag2 := Self.CBBlankTag2.Checked;
end;

procedure TForm1.CBBlankTag3Click(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuBlankTag3.Checked := Self.CBBlankTag3.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.BlankTag3 := Self.CBBlankTag3.Checked;
end;

procedure TForm1.CBTrigger1Click(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuTrigger1.Checked := Self.CBTrigger1.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.Trigger1 := Self.CBTrigger1.Checked;
end;

procedure TForm1.CBTrigger2Click(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuTrigger2.Checked := Self.CBTrigger2.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.Trigger2 := Self.CBTrigger2.Checked;
end;

procedure TForm1.CBTrigger3Click(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuTrigger3.Checked := Self.CBTrigger3.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.Trigger3 := Self.CBTrigger3.Checked;
end;

procedure TForm1.CBTrigger4Click(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuTrigger4.Checked := Self.CBTrigger4.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.Trigger4 := Self.CBTrigger4.Checked;
end;

procedure TForm1.CBTrigger5Click(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuTrigger5.Checked := Self.CBTrigger5.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.Trigger5 := Self.CBTrigger5.Checked;
end;

procedure TForm1.CBTrigger6Click(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuTrigger6.Checked := Self.CBTrigger6.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.Trigger6 := Self.CBTrigger6.Checked;
end;

procedure TForm1.CBTrigger7Click(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuTrigger7.Checked := Self.CBTrigger7.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.Trigger7 := Self.CBTrigger7.Checked;
end;

procedure TForm1.CBTrigger8Click(Sender: TObject);

var
   TagSet :MITagPointer;

begin
   Self.MenuTrigger8.Checked := Self.CBTrigger8.Checked;
   TagSet := MITagList.Items[CurrFrame - 1];
   TagSet^.Trigger8 := Self.CBTrigger8.Checked;
end;

procedure TForm1.SaveAs1Click(Sender: TObject);

var
   Position :Integer;

begin
   Form1.SaveMIDialog.Execute;
   MIFileName := Form1.SaveMIDialog.FileName;
   Position := Length(MIFileName);
   if Not((UpperCase(MIFileName[Position  ]) = 'I') and
          (UpperCase(MIFileName[Position-1]) = 'M') and
          (MIFileName[Position-2] = '.')) then
          MIFileName := MIFileName + '.mi';

   If(MIFileName<>'') then
   begin
      WriteMIFile(MIFileName);
      Form1.SaveMCDialog.Execute;
      MCFileName := Form1.SaveMCDialog.FileName;
      Position := Length(MCFileName);
      if Not((UpperCase(MCFileName[Position  ]) = 'C') and
             (UpperCase(MCFileName[Position-1]) = 'M') and
             (MCFileName[Position-2] = '.')) then
             MCFileName := MCFileName + '.mc';
      if (MCFileName<>'') then
      Begin
         WriteMCFile(MCFileName);
         Self.Save1.Enabled := True;
      End;
   end;
   Self.StatusBar2.Panels.Items[0].Text := ('Current File: '+MCFileName);
end;

procedure TForm1.ZRotEditKeyPress(Sender: TObject; var Key: Char);

var
   ZRotTemp :Single;
   P        :EulerPointer;

begin
   If (Key = #13) then
   Begin
      ZRotTemp:=StrToFloat(ZRotEdit.Text);
      If (CurrJoint = 1) then
      Begin
         P := EulerList[CurrJoint].Items[CurrFrame - 1];
         P^.X := ZRotTemp;
         RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
         RedrawPreviews(CurrFrame, CurrJoint);
      End;

      If (CurrJoint > 1) then
      Begin
         ZRotSelector.Position := Round(1000*ZRotTemp);
      End;
      Key := #0;
   End;
end;

procedure TForm1.YRotEditKeyPress(Sender: TObject; var Key: Char);

var
   YRotTemp :Single;
   P        :EulerPointer;

begin
   If (Key = #13) then
   Begin
      YRotTemp:=StrToFloat(YRotEdit.Text);
      If (CurrJoint = 1) then
      Begin
         P := EulerList[CurrJoint].Items[CurrFrame - 1];
         P^.Y := YRotTemp;
         RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
         RedrawPreviews(CurrFrame, CurrJoint);
      End;

      If (CurrJoint > 1) then
      Begin
         YRotSelector.Position := Round(1000*YRotTemp);
      End;
      Key := #0;
   End;
end;

procedure TForm1.XRotEditKeyPress(Sender: TObject; var Key: Char);

var
   XRotTemp :Single;
   P        :EulerPointer;

begin
   If (Key = #13) then
   Begin
      XRotTemp:=StrToFloat(XRotEdit.Text);
      If (CurrJoint = 1) then
      Begin
         P := EulerList[CurrJoint].Items[CurrFrame - 1];
         P^.Z := XRotTemp;
         RedrawGraphs(CurrFrame, CurrJoint, MarkedFrameNumber);
         RedrawPreviews(CurrFrame, CurrJoint);
      End;

      If (CurrJoint > 1) then
      Begin
         XRotSelector.Position := Round(1000*XRotTemp);
      End;
      Key := #0;
   End;
end;

procedure TForm1.FrameNoEditKeyPress(Sender: TObject; var Key: Char);

var
   FrameTemp :Integer;

begin
   If (Key = #13) then
   Begin
      FrameTemp:=StrToInt(FrameNoEdit.Text);
      FrameSelector.Position := FrameTemp;
      Key := #0;
   End;
end;

procedure TForm1.ShowCurrentPositions1Click(Sender: TObject);

Var
   PositionReadout :String;
   Counter :Integer;
   JointString :String;

begin
   PositionReadout := '';
   For Counter := 0 to 21 do
   Begin
      Str(Counter, JointString);
      PositionReadout := PositionReadout + JointString + ':   ';
      PositionReadout := PositionReadout + FormatFloat('0.000', JointPosition[Humanoid, Counter].X) + '     ';
      PositionReadout := PositionReadout + FormatFloat('0.000', JointPosition[Humanoid, Counter].Y) + '     ';
      PositionReadout := PositionReadout + FormatFloat('0.000', JointPosition[Humanoid, Counter].Z) + '     ';
      PositionReadout := PositionReadout + #13#10;
   End;
   ShowMessage(PositionReadout);
end;

end.



{Version 1.0, P. M. Anderson, Sunday, 26th January, 2003.
 First functional version.  Most major bugs eliminated.
 To do:
    Implement 'About' box.
    Write documentation.
    Implement 'Save As'.
    Implement 'New'.
    Allow addition / removal of frames to / from data stream.}

{Version 1.1, P. M. Anderson, Sunday 9th February, 2003.
 First update.
    1. Addition:
       Added two buttons, used to increase/decrease the current frame position
       by one, requested by TTLG's jericho, because of difficulties in selecting
       specific frames in motions with large number of frames - slider becomes
       too sensitive and often skips frames.

    2. Bug Fix:
       Changed the graph redraw (and preview redraw) method from
       'Form1.Canvas.Rectangle(X1, Y1, X2, Y2)' to
       'Form1.Canvas.FillRect(Rect(X1, Y1, X2, Y2))'.  For some reason, with the
       former method, the filled rectangles would become 'faded' if the form
       was moved or redraws (e.g. minimised then restored).  I don't know why
       the old method failed, but the new method seems to work.

    3. Bug Fix:
       Added code to redraw graphs into FrameSelectorChange.
       Previously, the graphs would not be redrawn occasionally when the frame
       is changed.  New code ensures that graphs will always be up to date when
       frame number is changed.

    4. Bug Fix:
       Added code to ensure that Edit/Blank Current Joint becomes disabled when
       no data is loaded, and enabled when data is loaded.

    5. Bug Fix:
       For some reason, my X, Y and Z axes corresponded to DromEd's -Z, -Y and
       -X axes respectively.  Changed the graph and preview windows so
       that although they are still labelled X, Y and Z, they are now actually
       -Z, -Y and -X respectively.  I also swapped the positions of the X and Z
       rotation slider bars, for the same reason.

    6. Addition:
       Added three preview windows, so that the current pose
       can be viewed along the X, Y and Z axes simultaneously (in three
       different 'winows'.  Also added a preview play function, requiring the
       use of a 'timer' component.}

{Version 1.2, P. M. Anderson, Thursday 24th April, 2003 - ?????
 Second update.
    1. Modification:
       Tidied source a little, by splitting huge, repetative routines into
       smaller subroutines.  Consider generalising some of these routines to
       reduce source length.

    2. Addition:
       Also added feature for burrick motion editting, and because Burricks and
       Humanoids share a common joint skeleton, the same redraw preview routines
       are used for both.  New item added to EDIT menu to allow the user to
       switch between Burrick and Humanoid preview drawings.

    3. Bug fix:
       Modified 'Blank Current Joint' routine, so that now all rotations are
       blanked to 180, 0, 0 (as before) but joint 1 (position) is blanked to
       0, 0, 0.

    4. Bug found:
       When the second last frame is reached, and the 'next frame' button is
       clicked, the current frame skips back to the beginning (frame 1).  Fix.

    5. Modification:
       Set New1.Enabled to FALSE, so that the user cannot select File/New.

    6. Bug Fix:
       Ensured that 'Blank Current Joint' menu item is inaccessible when no
       joint is selected.  This item was not disabled previously, and caused
       crashes on selection.

    7. Bug Fix:
       In 'procedure TForm1.PreviewPlayTimerTimer(Sender: TObject)', the
       current frame was reset to frame 1 every time the last frame was selected
       on the frame selector slider.  This was only supposed to happen during
       'preview play' mode, so that at the end of the preview, the animation
       would reset to the beginning.  A check was added to ensure that preview
       play mode was active before resetting the frame number fixed the bug.

    8. Addition:
       Added option to Edit menu, to allow user to turn on/off the animated
       graphs and sliders in preview playback mode.  May be useful for slower
       computers.

    9. Addition:
       Added text entry boxes for joint rotations, so the user has the choice of
       using the sliders, or manual entry.  The old labels (now redundant) have
       not yet been removed.

   10. Bug Fix:
       In earlier versions, the positions of the arms in this program's preview
       window sometimes differed from the positions of the arms in DromEd and
       Thief.  This was discovered to be caused by a sensitivity to the order in
       which the seperate rotations are executed.  The order has been changed in
       this version to match the order of definition (i.e. joint 1 is rotated
       first, then 2 etc), however, the root rotation occurs 15th, rather than
       8th.  Now things should work properly.}

{Version 1.3, P. M. Anderson, Friday 5th September, 2003 - Sunday 7th September, 2003
 Third update.
    1. Modification:
       Changed options in Edit/Creature Type and Edit/Options menus to more
       appropriate RADIO-BUTTON type, rather than CHECKED type as it was before.
    2. Modification:
       Added command to redraw graphs in procedure BlankCurrentJoint1Click -
       graphs didn't redraw automatically in old versions.
    3. Addition:
       Added crude linear interpolation.  Can interpolate X, Y and Z axes
       independently, and also simultaneously.
    4. Modification:
       Changed captions on Edit/Creature Type menu items to reflect which Dark
       game (Thief or SS2) the creature type in question is relevant to.
    5. Addition:
       Improved interpolation so that all joints can be interpolated together,
       as well as just one.
    6. Addition:
       Added copy feature, where the contents of one frame can be copied into
       another.

Version 1.4, P. M. Anderson, Friday 5th September, 2003 - Sunday 7th September, 2003
Major Update:

    1. Modification:
       Disabled 'maximise' button to prevent window resizing.
    2. Modification:
       Set FORM1.ONACTIVATE event to FormPaint, to try to remove XP/2000 bug where form is
       not drawn properly on startup.
    3. Modification:
       Moved "Current Joint" label to a more appropriate location, and also added colon.
    4. Modification:
       Moved code to draw stick man/burrick from Procedure RedrawPreviews to new
       Procedure DrawStickMan
    5. Modification:
       Moved code to blank preview windows (prior to drawing stick man) to separate Procedure
       ClearPreviewWindows
    6. Addition:
       Added code to draw stationary lines in preview windows, so that motions involving
       translation (walking motions) can be displayed fully.  Stick character appears to walk
       past stationary lines.
    7. Modification:
       Moved all mathematical code into new unit, 'motmaths.pas':
          Function ASin;
          Function ACos;
          Procedure RotateVector;
          Function GetAngle;
          Procedure Quaternion2Euler;
          Procedure Euler2Quaternion;
    8. Modification:
       Moved all graph and preview related code into new unit, 'GraphAndPreviewPlotting'.
    9. Modification:
       Replaced PreviewPlayTimer (Timer) with DXPreviewPlayTimer (DXTimer) from DelphiX
       component, to try to solve timer problems on WinXP.
   10. Modification:
       Replaced CurrFrameLabel with FrameNoEdit, so that desired frame number can be entered
       directly just as in rotations.

Version 2.0.0, P. M. Anderson, Friday 25th October, 2003 - ?????
Massive Update:

    1. Bug fix:
       Fixed DrawGrids routine so that each window's redraw event only references its own
       width and height.
    2. Modification:
       Replaced the majority of the labels on the main form with data in two new status bars.
    3. Modification:
       Removed all unused variable declarations.
       Changed type of MarkedFrameNumber to LongWord (to match CurrFrame).
    4. Modification:
       Changed default behaviour to "Don't update graphs & sliders" on playback.
    5. Addition:
       Added facility to modify motion parameters (frame count, frame rate, creature class
       etc)
    6. Addition:
       Added File/New function to create new motions.
    7. Addition:
       Now allows the editting of frame-based flags (like Left Footfall, or CanInterrupt)
       from .mi file, using new Tags menu, or column of checkboxes.
    8. Addition:
       Now saves modified .mi file (including any flags set) as well as modified .mc file.
    9. Modification:
       Graph and preview windows now blank out when File/Close is selected.
   10. Addition:
       Implemented File/Save As...
   11. Modification:
       Replaced preview play & stop buttons (BUTTON) with BitBtn, and introduced glyphs.

Version 2.0.1, P. M. Anderson, Wednesday 10th December, 2003
Update:

    1. Modification:
       Changes to values in edit boxes now only take effect when enter is pressed
    2. Modification:
       Now rotations (and translations) are no longer restricted to integer vales.  Reals to
       three decimal places can be used.
    3. Addition:
       Joint 1 (translation) can now be editted at last.
    4. Modification:
       Modified interpolation routines to include joint 1.
    5. Modification:
       Changed colours of grids in preview windows to reflect the graphs' colours.
    6. Modification:
       Sliders disappear when joint 1 is selected, as slider editting isn't really
       appropriate.
    7. Modification:
       Unlike rotations, there is no real limit (except that imposed by the 'XXX.XXX'
       representation) to the values allowed in translation (joint 1).  Therefore graphs in
       joint 1 mode will scale to span only the full range of values currently set.  Labels
       show maximum and minimum values.
    8. Bug fix:
       Fixed File/Save so that it is only enabled when a filename has already been allocated.
    9. Bug fix:
       Fixed some issues with File/Close.
   10. Addition:
       Added 'built with Delphi' image to About form.

Version 2.0.2, P. M. Anderson, Sunday 13th June, 2004
Update:

    1. Modification:
       Rearranged "displayed joint" order (those with absolute positions including head, toes
       and fingers) to match order in .map and .mjo files.  "Calculated joint" order (those
       with rotations defined in .mc files) remain the same.

    2. Bug fix:
       Writing of flags (in .mi file) was incorrect, as the value '2048' was assigned to both
       'Blank 3' AND 'Trigger 1'.  This has now been fixed.

    3. Addition:
       Added functionality to edit player arm.  In addition, the JointSelector drop-down menu
       is now generated at run-time rather than compile-time, so that its contents are
       changed depending on edit mode (humanoid/arm).
 }
