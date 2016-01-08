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

unit MotParams;
{Dialog for editting motion parameters (frame count, creature type, etc)}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Buttons;

type
  TMotParamsForm = class(TForm)
    FrameCountEdit: TSpinEdit;
    StaticText1: TStaticText;
    FrameRateEdit: TSpinEdit;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    CreatureClassSelector: TComboBox;
    MotParamsOK: TBitBtn;
    MotParamsCancel: TBitBtn;
    MotionNameEdit: TEdit;
    StaticText4: TStaticText;
    procedure FormShow(Sender: TObject);
    procedure CreatureClassSelectorChange(Sender: TObject);
    procedure FrameCountEditChange(Sender: TObject);
    procedure FrameRateEditChange(Sender: TObject);
    procedure MotParamsCancelClick(Sender: TObject);
    procedure MotParamsOKClick(Sender: TObject);
    procedure MotionNameEditChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MotParamsForm: TMotParamsForm;

implementation

{$R *.dfm}

uses
   Unit1,
   MotTypes,
   GraphAndPreviewPlotting;

Var
   CreatureClassTmp :LongWord;
   FrameCountTmp :Integer;
   MIMotNameTmp :String;
   FrameRateTmp :LongWord;
   NJointsTmp :Integer;

procedure TMotParamsForm.FormShow(Sender: TObject);

Var
   CreatureTypeDetected :Boolean;

begin
   CreatureClassTmp := CreatureClass;
   {Set current creature class on selector}
   CreatureTypeDetected := False;
   If (CreatureClassTmp = 524287) then
   Begin
      {Humanoid}
      MotParamsForm.CreatureClassSelector.ItemIndex := 0;
      CreatureTypeDetected := True;
      CurrCreatureType := Humanoid;
      NJoints := HumNJoints;
   End;
   If (CreatureClassTmp = 1048575) then
   Begin
      {Human with sword}
      MotParamsForm.CreatureClassSelector.ItemIndex := 1;
      CreatureTypeDetected := True;
   End;
   If (CreatureClassTmp = 4194303) then
   Begin
      {Bugbeast}
      MotParamsForm.CreatureClassSelector.ItemIndex := 2;
      CreatureTypeDetected := True;
   End;
   If (CreatureClassTmp = 14) then
   Begin
      {Arm}
      MotParamsForm.CreatureClassSelector.ItemIndex := 5;
      CreatureTypeDetected := True;
      CurrCreatureType := PlayerArm;
      NJoints := ArmNJoints;
   End;
   If (CreatureClassTmp = 2097151) then
   Begin
      {Crayman}
      MotParamsForm.CreatureClassSelector.ItemIndex := 4;
      CreatureTypeDetected := True;
   End;
   If (CreatureClassTmp = 536870911) then
   Begin
      {Spider1}
      MotParamsForm.CreatureClassSelector.ItemIndex := 5;
      CreatureTypeDetected := True;
   End;
   If (CreatureClassTmp = 127) then
   Begin
      {Spider2}
      MotParamsForm.CreatureClassSelector.ItemIndex := 6;
      CreatureTypeDetected := True;
   End;
   If Not(CreatureTypeDetected) then
   Begin
      MotParamsForm.CreatureClassSelector.ItemIndex := -1;
      MotParamsForm.CreatureClassSelector.Text := 'Unknown'
   End;
   FrameCountTmp := Round(FrameCount);
   Self.FrameCountEdit.Value := FrameCountTmp;
   MIMotNameTmp := MIMotName;
   Self.MotionNameEdit.Text := MIMotNameTmp;
   FrameRateTmp := FrameRate;
   If (FrameRateTmp = 0) then FrameRateTmp := 30;
   Self.FrameRateEdit.Value := FrameRateTmp;
   NJointsTmp := NJoints;
end;

procedure TMotParamsForm.CreatureClassSelectorChange(Sender: TObject);

{Only human motions currently implemented}

begin
   {Humanoid}
   If (Self.CreatureClassSelector.ItemIndex = 0) then
   Begin
      CreatureClassTmp :=    524287;
      CurrCreatureType := Humanoid;
      NJoints := HumNJoints;
      Form1.Humanoid1.Checked := True;
   End;
   {Human with sword}
   If (Self.CreatureClassSelector.ItemIndex = 1) then CreatureClassTmp :=   1048575;
   {Arm}
   If (Self.CreatureClassSelector.ItemIndex = 5) then
   Begin
      CreatureClassTmp :=        14;
      CurrCreatureType := PlayerArm;
      NJoints := ArmNJoints;
   End;
   If ((Self.CreatureClassSelector.ItemIndex <> 0) and
       (Self.CreatureClassSelector.ItemIndex <> 1) and
       (Self.CreatureClassSelector.ItemIndex <> 5)) then
                       Self.CreatureClassSelector.ItemIndex := 0;
   {Bugbeast}
{   If (Self.CreatureClassSelector.ItemIndex = 2) then CreatureClassTmp :=   4194303;}
   {Crayman}
{   If (Self.CreatureClassSelector.ItemIndex = 4) then CreatureClassTmp :=   2097151;}
   {Spider1}
{   If (Self.CreatureClassSelector.ItemIndex = 5) then CreatureClassTmp := 536870911;}
   {Spider2}
{   If (Self.CreatureClassSelector.ItemIndex = 6) then CreatureClassTmp :=       127;}

   {Temporary - fix later}
   NJointsTmp := 16;
end;

procedure TMotParamsForm.FrameCountEditChange(Sender: TObject);

begin
   FrameCountTmp := Self.FrameCountEdit.Value;
end;

procedure TMotParamsForm.FrameRateEditChange(Sender: TObject);
begin
   FrameRateTmp := Self.FrameRateEdit.Value;
end;

procedure TMotParamsForm.MotParamsCancelClick(Sender: TObject);
begin
   Self.Close;
end;

procedure IncreaseFrameCount;

var
   AngleSet     :EulerPointer;
   JointCounter :Integer;
   FrameCounter :Integer;
   TagSet       :MITagPointer;

Begin
   For JointCounter := 1 to NJoints do
   Begin
      For FrameCounter := NFrames to Trunc(FrameCountTmp)-1 Do
      Begin
         New(AngleSet);
         If(JointCounter<>1) then
         Begin
            AngleSet^.X := 180.0;
            AngleSet^.Y := 0.0;
            AngleSet^.Z := 0.0;
         End
         Else
         Begin
            AngleSet^.X := 0.0;
            AngleSet^.Y := 0.0;
            AngleSet^.Z := 0.0;
         End;
         EulerList[JointCounter].Add(AngleSet);
      End;
   End;

   For FrameCounter := NFrames to Trunc(FrameCountTmp)-1 Do
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

procedure DecreaseFrameCount;

var
   JointCounter :Integer;
   FrameCounter :Integer;

Begin
   For JointCounter := 1 to NJoints do
      For FrameCounter := Trunc(FrameCount)-1 downto NFrames Do
          EulerList[JointCounter].Delete(FrameCounter-1);
End;


procedure TMotParamsForm.MotParamsOKClick(Sender: TObject);

var
   FrameRateStr :String;
   FrameCountStr :String;
   Counter :Integer;

begin
   {Commit to changes made on parameters form, then close}
   CreatureClass := CreatureClassTmp;
   NJoints       := NJointsTmp;
   MCNJoints     := NJointsTmp;
   MIJointSectionLength := 16;        //Human/humanoid temporary
   FrameRate     := FrameRateTmp;
   MIMotName     := MIMotNameTmp;
   MIDWord1      := 0;
   MIDWord2      := 0;
   For Counter := 1 to 15 do MIArray1[Counter] := 0;
   MIUnknown1    := 0;
   MIUnknown2    := 0;
   MIUnknown3    := 1;
   MIUnknown4    := 8;
   MIUnknown5    := 0;

   {Make changes in status bar}
   Str(FrameRate, FrameRateStr);
   If (FrameRate>0) then Form1.DXPreviewPlayTimer.Interval := Round(1000 / FrameRate);

   {Need to resize Euler angle linked lists here}
   {1. Need to add frames}
   If ((FrameCountTmp > FrameCount) and (FrameCount > 0)) then IncreaseFrameCount;
   {2. Need to cut frames}
   If (FrameCountTmp < FrameCount) then DecreaseFrameCount;

   FrameCount := FrameCountTmp;

   NFrames := Trunc(FrameCount);
   Form1.FrameSelector.Max := NFrames;
   Str(NFrames, FrameCountStr);
   Form1.StatusBar1.Panels.Items[0].Text := ('Current Motion: ' + MIMotName);
   Form1.StatusBar1.Panels.Items[1].Text := (FrameCountStr + ' frames');
   Form1.StatusBar1.Panels.Items[2].Text := (FrameRateStr + ' fps');
   Form1.StatusBar1.Panels.Items[3].Text := Self.CreatureClassSelector.Text;
   DataLoaded := True;

{   Form1.Humanoid1.Checked := True;}
{   CurrCreatureType := Humanoid;}
   ReformatJointSelector(CreatureClass);   
   If ((CreatureClass = CC_Humanoid) or
       (CreatureClass = CC_Human_With_Sword) or
       (CreatureClass = CC_Bugbeast) or
       (CreatureClass = CC_Crayman)) then
   Begin
      Form1.Humanoid1.Enabled := True;
      Form1.Burrick1.Enabled := True;
   End
   Else
   Begin
      Form1.Humanoid1.Enabled := False;
      Form1.Burrick1.Enabled := False;
   End;
   Self.Close;
end;

procedure TMotParamsForm.MotionNameEditChange(Sender: TObject);
begin
   MIMotNameTmp := Self.MotionNameEdit.Text;
end;

end.
