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

unit MotFiles;

{All file handling is done in here.}

interface

   Procedure ReadMIFile(MIFileName :String);
   Procedure ReadMCFile(MCFileName :String);
   Procedure WriteMIFile(MIFileName :String);
   Procedure WriteMCFile(MCFileName :String);

implementation

Uses Dialogs                 {for ShowMessage},
     Unit1                   {for access to main form},
     MotTypes                {for EulerPointer},
     Classes                 {for TList},
     MotMaths                {for Quaternion2Euler, etc},
     GraphAndPreviewPlotting {for redefinition of JointSelector menu};

Var
   MIFile :File;

Procedure ReadMIFile(MIFileName :String);

var
   FrameRateStr :String;
   FrameCountStr :String;
   NameEnd :Boolean;
   Counter :Integer;
   CurrByte :Byte;
   CreatureTypeDetected :Boolean;
   TagSet :MITagPointer;
   MIJointMap1 :LongWord;
   MIJointMap2 :LongWord;
   MIJointMap3 :LongWord;
   FlagFrameNumber :LongWord;
   FlagType :LongWord;
      
Begin
   AssignFile(MIFile, MIFileName);
   try
      Reset(MIFile, 1);
      BlockRead(MIFile, MIDWord1, 4);
      If (MIDWord1<>0) then ShowMessage('Warning - may not be a .mi file!');
      BlockRead(MIFile, CreatureClass, 4);
      {Do some kind of creature class check here?}
      CreatureTypeDetected := False;
      If (CreatureClass = 524287) then
      Begin
         Form1.StatusBar1.Panels.Items[3].Text := 'Humanoid';
         CurrCreatureType := Humanoid;
         NJoints := HumNJoints;
         Form1.Humanoid1.Checked := True;
         CreatureTypeDetected := True;
{        Form1.Burrick1.Checked := False;}
         Form1.Humanoid1.Enabled := True;
         Form1.Burrick1.Enabled := True;
      End;
      If (CreatureClass = 1048575) then
      Begin
         Form1.StatusBar1.Panels.Items[3].Text := 'Human with Sword';
         CurrCreatureType := Humanoid;
         NJoints := HumNJoints;
         Form1.Humanoid1.Checked := True;
         CreatureTypeDetected := True;
{        Form1.Burrick1.Checked := False;}
         Form1.Humanoid1.Enabled := True;
         Form1.Burrick1.Enabled := True;
      End;
      If (CreatureClass = 4194303) then
      Begin
         Form1.StatusBar1.Panels.Items[3].Text := 'Bugbeast';
         CurrCreatureType := Humanoid;
         NJoints := HumNJoints;
         Form1.Humanoid1.Checked := True;
         CreatureTypeDetected := True;
{        Form1.Burrick1.Checked := False;}
         Form1.Humanoid1.Enabled := True;
         Form1.Burrick1.Enabled := True;
      End;
      If (CreatureClass = 14) then
      Begin
         Form1.StatusBar1.Panels.Items[3].Text := 'Arm';
         CurrCreatureType := PlayerArm;
         NJoints := ArmNJoints;
         Form1.Humanoid1.Checked := False;
         Form1.Humanoid1.Enabled := False;
         CreatureTypeDetected := True;
         Form1.Burrick1.Checked := False;
         Form1.Burrick1.Enabled := False;
      End;
      If (CreatureClass = 2097151) then
      Begin
         Form1.StatusBar1.Panels.Items[3].Text := 'Crayman';
         CurrCreatureType := Humanoid;
         NJoints := HumNJoints;
         Form1.Humanoid1.Checked := True;
         Form1.Humanoid1.Enabled := True;
         Form1.Burrick1.Enabled := True;
         CreatureTypeDetected := True;
{        Form1.Burrick1.Checked := False;}
      End;
      If (CreatureClass = 536870911) then
      Begin
         Form1.StatusBar1.Panels.Items[3].Text := 'Spider';
         CurrCreatureType := Humanoid;
         NJoints := HumNJoints;
         Form1.Humanoid1.Checked := True;
         CreatureTypeDetected := True;
{        Form1.Burrick1.Checked := False;}
         Form1.Humanoid1.Enabled := False;
         Form1.Burrick1.Enabled := False;
      End;
      If (CreatureClass = 127) then
      Begin
         Form1.StatusBar1.Panels.Items[3].Text := 'Sweel';
         CurrCreatureType := Humanoid;
         NJoints := HumNJoints;
         Form1.Humanoid1.Checked := True;
         CreatureTypeDetected := True;
{        Form1.Burrick1.Checked := False;}
      End;

      If Not(CreatureTypeDetected) then
      Begin
         Form1.StatusBar1.Panels.Items[3].Text := ('Unknown');
{         Form1.CreatureTypeLabel.Caption := 'Unknown';}
         CurrCreatureType := 0;
         NJoints := 0;
         ShowMessage('Warning - this motion does not correspond to any currently supported creature type.');
      End
      Else ReformatJointSelector(CreatureClass);

      BlockRead(MIFile, FrameCount, 4);
      NFrames := Trunc(FrameCount);
      Str(NFrames, FrameCountStr);
      Form1.StatusBar1.Panels.Items[1].Text := (FrameCountStr + ' frames');

      BlockRead(MIFile, FrameRate, 4);
      Str(FrameRate, FrameRateStr);
      Form1.StatusBar1.Panels.Items[2].Text := (FrameRateStr + ' fps');
      Form1.FrameSelector.Max := NFrames;
      Form1.Close1.Enabled := True;

      BlockRead(MIFile, MIDWord2, 4);

   {get motion name from .mi block}
      MIMotName:='';
      NameEnd:=False;
      for Counter:=1 to 16 do
      begin
         BlockRead(MIFile, CurrByte, 1);
         if((not(NameEnd)) and (CurrByte<>0)) then
         MIMotName:=MIMotName+Char(CurrByte);
         if (CurrByte=0) then NameEnd:=True;
      end;

      for Counter:=1 to 15 do
      begin
{String of fifteen zeros (usually!) after motion name}
         BlockRead(MIFile, MIArray1[Counter], 4);
      end;

{Get length of .mc joint-to-.mjo and .map joint mapping data}
      BlockRead(MIFile, MIJointSectionLength, 4);
      BlockRead(MIFile, MIUnknown1, 4);
      BlockRead(MIFile, MINumberOfFlagsSet, 4);
      BlockRead(MIFile, MIUnknown2, 4);
      BlockRead(MIFile, MIUnknown3, 4);
      BlockRead(MIFile, MIUnknown4, 4);
      BlockRead(MIFile, MIUnknown5, 4);
{Read .mc / .mjo & .map joint mapping}
      For Counter:=1 to (MIJointSectionLength-1) do
      Begin
         BlockRead(MIFile, MIJointMap1, 4);
         BlockRead(MIFile, MIJointMap2, 4);
         BlockRead(MIFile, MIJointMap3, 4);
      End;

{Initialise tag list}
   MITagList := TList.Create;
   For Counter := 1 to NFrames do
   Begin
      New(TagSet);
      TagSet.Standing        := False;      TagSet.LeftFootfall    := False;
      TagSet.RightFootfall   := False;      TagSet.LeftFootUp      := False;
      TagSet.RightFootUp     := False;      TagSet.FireRelease     := False;
      TagSet.CanInterrupt    := False;      TagSet.StartMotionHere := False;
      TagSet.EndMotionHere   := False;      TagSet.BlankTag1       := False;
      TagSet.BlankTag2       := False;      TagSet.BlankTag3       := False;
      TagSet.Trigger1        := False;      TagSet.Trigger2        := False;
      TagSet.Trigger3        := False;      TagSet.Trigger4        := False;
      TagSet.Trigger5        := False;      TagSet.Trigger6        := False;
      TagSet.Trigger7        := False;      TagSet.Trigger8        := False;
      MITagList.Add(TagSet);
   End;

{Read .mi flag settings (footfall, can interrupt, etc}
      For Counter:=1 to MINumberOfFlagsSet do
      Begin
         BlockRead(MIFile, FlagFrameNumber, 4);
         BlockRead(MIFile, FlagType, 4);
{Add this data to the flag list (TList)}
{Stored as bitfields. 1=standing, 2=Left footfall, 4=... etc}
         If (FlagType >= 524288) then
         Begin
            FlagType := FlagType - 524288;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.Trigger8 := True;
         end;
         If (FlagType >= 262144) then
         Begin
            FlagType := FlagType - 262144;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.Trigger7 := True;
         end;
         If (FlagType >= 131072) then
         Begin
            FlagType := FlagType - 131072;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.Trigger6 := True;
         end;
         If (FlagType >=  65536) then
         Begin
            FlagType := FlagType -  65536;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.Trigger5 := True;
         end;
         If (FlagType >=  32768) then
         Begin
            FlagType := FlagType -  32768;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.Trigger4 := True;
         end;
         If (FlagType >=  16384) then
         Begin
            FlagType := FlagType -  16384;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.Trigger3 := True;
         end;
         If (FlagType >=   8192) then
         Begin
            FlagType := FlagType -   8192;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.Trigger2 := True;
         end;
         If (FlagType >=   4096) then
         Begin
            FlagType := FlagType -   4096;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.Trigger1 := True;
         end;
         If (FlagType >=   2048) then
         Begin
            FlagType := FlagType -   2048;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.BlankTag3 := True;
         end;
         If (FlagType >=   1024) then
         Begin
            FlagType := FlagType -   1024;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.BlankTag2 := True;
         end;
         If (FlagType >=    512) then
         Begin
            FlagType := FlagType -    512;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.BlankTag1 := True;
         end;
         If (FlagType >=    256) then
         Begin
            FlagType := FlagType -    256;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.EndMotionHere := True;
         end;
         If (FlagType >=    128) then
         Begin
            FlagType := FlagType -    128;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.StartMotionHere := True;
         end;
         If (FlagType >=     64) then
         Begin
            FlagType := FlagType -     64;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.CanInterrupt := True;
         end;
         If (FlagType >=     32) then
         Begin
            FlagType := FlagType -     32;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.FireRelease := True;
         end;
         If (FlagType >=     16) then
         Begin
            FlagType := FlagType -     16;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.RightFootUp := True;
         end;
         If (FlagType >=      8) then
         Begin
            FlagType := FlagType -      8;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.LeftFootUp := True;
         end;
         If (FlagType >=      4) then
         Begin
            FlagType := FlagType -      4;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.RightFootfall := True;
         end;
         If (FlagType >=      2) then
         Begin
            FlagType := FlagType -      2;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.LeftFootfall := True;
         end;
         If (FlagType >=      1) then
         Begin
            FlagType := FlagType -      1;
            TagSet := MITagList.Items[FlagFrameNumber];
            TagSet^.Standing := True;
         end;
      end;

      Form1.StatusBar1.Panels.Items[0].Text := ('Current Motion: '+MIMotName);

      MIFileOpened := True;

      Form1.DXPreviewPlayTimer.Interval := Round(1000 / FrameRate);
   Finally
      Close(MIFile);
   End {try};
End {ReadMIFile};

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

Procedure WriteHumanoidJointMap;

Var
   MIJointMap1 :LongWord;
   MIJointMap2 :LongWord;
   MIJointMap3 :LongWord;

Begin
   MIJointMap1 := 0;
   MIJointMap2 := 2;
   MIJointMap3 := 1;
   BlockWrite(MIFile, MIJointMap1, 4); BlockWrite(MIFile, MIJointMap2, 4); BlockWrite(MIFile, MIJointMap3, 4);
   MIJointMap1 := 0;
   MIJointMap2 := 3;
   MIJointMap3 := 2;
   BlockWrite(MIFile, MIJointMap1, 4); BlockWrite(MIFile, MIJointMap2, 4); BlockWrite(MIFile, MIJointMap3, 4);
   MIJointMap1 := 0;
   MIJointMap2 := 4;
   MIJointMap3 := 3;
   BlockWrite(MIFile, MIJointMap1, 4); BlockWrite(MIFile, MIJointMap2, 4); BlockWrite(MIFile, MIJointMap3, 4);
   MIJointMap1 := 0;
   MIJointMap2 := 5;
   MIJointMap3 := 4;
   BlockWrite(MIFile, MIJointMap1, 4); BlockWrite(MIFile, MIJointMap2, 4); BlockWrite(MIFile, MIJointMap3, 4);
   MIJointMap1 := 0;
   MIJointMap2 := 6;
   MIJointMap3 := 5;
   BlockWrite(MIFile, MIJointMap1, 4); BlockWrite(MIFile, MIJointMap2, 4); BlockWrite(MIFile, MIJointMap3, 4);
   MIJointMap1 := 0;
   MIJointMap2 := 7;
   MIJointMap3 := 6;
   BlockWrite(MIFile, MIJointMap1, 4); BlockWrite(MIFile, MIJointMap2, 4); BlockWrite(MIFile, MIJointMap3, 4);
   MIJointMap1 := 0;
   MIJointMap2 := 8;
   MIJointMap3 := 7;
   BlockWrite(MIFile, MIJointMap1, 4); BlockWrite(MIFile, MIJointMap2, 4); BlockWrite(MIFile, MIJointMap3, 4);
   MIJointMap1 := 0;
   MIJointMap2 := 9;
   MIJointMap3 := 8;
   BlockWrite(MIFile, MIJointMap1, 4); BlockWrite(MIFile, MIJointMap2, 4); BlockWrite(MIFile, MIJointMap3, 4);
   MIJointMap1 := 0;
   MIJointMap2 := 10;
   MIJointMap3 := 9;
   BlockWrite(MIFile, MIJointMap1, 4); BlockWrite(MIFile, MIJointMap2, 4); BlockWrite(MIFile, MIJointMap3, 4);
   MIJointMap1 := 0;
   MIJointMap2 := 11;
   MIJointMap3 := 10;
   BlockWrite(MIFile, MIJointMap1, 4); BlockWrite(MIFile, MIJointMap2, 4); BlockWrite(MIFile, MIJointMap3, 4);
   MIJointMap1 := 0;
   MIJointMap2 := 12;
   MIJointMap3 := 11;
   BlockWrite(MIFile, MIJointMap1, 4); BlockWrite(MIFile, MIJointMap2, 4); BlockWrite(MIFile, MIJointMap3, 4);
   MIJointMap1 := 0;
   MIJointMap2 := 13;
   MIJointMap3 := 12;
   BlockWrite(MIFile, MIJointMap1, 4); BlockWrite(MIFile, MIJointMap2, 4); BlockWrite(MIFile, MIJointMap3, 4);
   MIJointMap1 := 0;
   MIJointMap2 := 14;
   MIJointMap3 := 13;
   BlockWrite(MIFile, MIJointMap1, 4); BlockWrite(MIFile, MIJointMap2, 4); BlockWrite(MIFile, MIJointMap3, 4);
   MIJointMap1 := 0;
   MIJointMap2 := 15;
   MIJointMap3 := 14;
   BlockWrite(MIFile, MIJointMap1, 4); BlockWrite(MIFile, MIJointMap2, 4); BlockWrite(MIFile, MIJointMap3, 4);
   MIJointMap1 := 0;
   MIJointMap2 := 18;
   MIJointMap3 := 15;
   BlockWrite(MIFile, MIJointMap1, 4); BlockWrite(MIFile, MIJointMap2, 4); BlockWrite(MIFile, MIJointMap3, 4);
end {WriteHumanoidJointMap};

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

Procedure WritePlayerArmJointMap;

Var
   MIJointMap1 :LongWord;
   MIJointMap2 :LongWord;
   MIJointMap3 :LongWord;

Begin
   MIJointMap1 := 0;
   MIJointMap2 := 1;
   MIJointMap3 := 1;
   BlockWrite(MIFile, MIJointMap1, 4); BlockWrite(MIFile, MIJointMap2, 4); BlockWrite(MIFile, MIJointMap3, 4);
   MIJointMap1 := 0;
   MIJointMap2 := 2;
   MIJointMap3 := 2;
   BlockWrite(MIFile, MIJointMap1, 4); BlockWrite(MIFile, MIJointMap2, 4); BlockWrite(MIFile, MIJointMap3, 4);
   MIJointMap1 := 0;
   MIJointMap2 := 3;
   MIJointMap3 := 3;
   BlockWrite(MIFile, MIJointMap1, 4); BlockWrite(MIFile, MIJointMap2, 4); BlockWrite(MIFile, MIJointMap3, 4);
end {WritePlayerArmJointMap};

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

Procedure WriteMIFile(MIFileName :String);

var
   FrameRateStr :String;
   FrameCountStr :String;
   NameEnd :Boolean;
   Counter :Integer;
   CurrByte :Byte;
   CreatureTypeDetected :Boolean;
   TagSet :MITagPointer;
   FlagFrameNumber :LongWord;
   FlagType :LongWord;

Begin
   AssignFile(MIFile, MIFileName);
   try
      Rewrite(MIFile, 1);
      BlockWrite(MIFile, MIDWord1, 4);
      BlockWrite(MIFile, CreatureClass, 4);
      BlockWrite(MIFile, FrameCount, 4);
      BlockWrite(MIFile, FrameRate, 4);
      BlockWrite(MIFile, MIDWord2, 4);
   {Write motion name to .mi block}
      For Counter:=1 to 16 do
      Begin
         If (Counter <= Length(MIMotName)) then
            CurrByte := Ord(MIMotName[Counter])
         Else
            CurrByte := 0;
         BlockWrite(MIFile, CurrByte, 1);
      end;

      For Counter:=1 to 15 do
      Begin
{String of fifteen zeros (usually!) after motion name}
         BlockWrite(MIFile, MIArray1[Counter], 4);
      end;

{Get length of .mc joint-to-.mjo and .map joint mapping data}
      BlockWrite(MIFile, MIJointSectionLength, 4);
      BlockWrite(MIFile, MIUnknown1, 4);
{Calculate number of flagged frames}
      MINumberOfFlagsSet := 0;
      For Counter := 1 to NFrames Do
      Begin
         TagSet := MITagList.Items[Counter - 1];
         If ((TagSet^.Standing) or
             (TagSet^.LeftFootfall) or
             (TagSet^.RightFootfall) or
             (TagSet^.LeftFootUp) or
             (TagSet^.RightFootUp) or
             (TagSet^.FireRelease) or
             (TagSet^.CanInterrupt) or
             (TagSet^.StartMotionHere) or
             (TagSet^.EndMotionHere) or
             (TagSet^.BlankTag1) or
             (TagSet^.BlankTag2) or
             (TagSet^.BlankTag3) or
             (TagSet^.Trigger1) or
             (TagSet^.Trigger2) or
             (TagSet^.Trigger3) or
             (TagSet^.Trigger4) or
             (TagSet^.Trigger5) or
             (TagSet^.Trigger6) or
             (TagSet^.Trigger7) or
             (TagSet^.Trigger8)) then Inc(MINumberOfFlagsSet);
      End;
      BlockWrite(MIFile, MINumberOfFlagsSet, 4);
      BlockWrite(MIFile, MIUnknown2, 4);
      BlockWrite(MIFile, MIUnknown3, 4);
      BlockWrite(MIFile, MIUnknown4, 4);
      BlockWrite(MIFile, MIUnknown5, 4);

{Read .mc / .mjo & .map joint mapping}
      If ((CurrCreatureType = Humanoid) or
          (CurrCreatureType = Burrick)) then WriteHumanoidJointMap;
      If (CurrCreatureType  = PlayerArm) then WritePlayerArmJointMap;
{      For Counter:=1 to (MIJointSectionLength-1) do
      Begin
         MIJointMap1 := 255;
         MIJointMap2 := 255;
         MIJointMap3 := 255;
         BlockWrite(MIFile, MIJointMap1, 4);
         BlockWrite(MIFile, MIJointMap2, 4);
         BlockWrite(MIFile, MIJointMap3, 4);
      End;}

      For Counter := 1 to NFrames do
      Begin
         FlagType := 0;
         TagSet := MITagList.Items[Counter - 1];
         If (TagSet^.Standing)        then FlagType := FlagType +      1;
         If (TagSet^.LeftFootfall)    then FlagType := FlagType +      2;
         If (TagSet^.RightFootfall)   then FlagType := FlagType +      4;
         If (TagSet^.LeftFootUp)      then FlagType := FlagType +      8;
         If (TagSet^.RightFootUp)     then FlagType := FlagType +     16;
         If (TagSet^.FireRelease)     then FlagType := FlagType +     32;
         If (TagSet^.CanInterrupt)    then FlagType := FlagType +     64;
         If (TagSet^.StartMotionHere) then FlagType := FlagType +    128;
         If (TagSet^.EndMotionHere)   then FlagType := FlagType +    256;
         If (TagSet^.BlankTag1)       then FlagType := FlagType +    512;
         If (TagSet^.BlankTag2)       then FlagType := FlagType +   1024;
         If (TagSet^.BlankTag3)       then FlagType := FlagType +   2048;
         If (TagSet^.Trigger1)        then FlagType := FlagType +   4096;
         If (TagSet^.Trigger2)        then FlagType := FlagType +   8192;
         If (TagSet^.Trigger3)        then FlagType := FlagType +  16384;
         If (TagSet^.Trigger4)        then FlagType := FlagType +  32768;
         If (TagSet^.Trigger5)        then FlagType := FlagType +  65536;
         If (TagSet^.Trigger6)        then FlagType := FlagType + 131072;
         If (TagSet^.Trigger7)        then FlagType := FlagType + 262144;
         If (TagSet^.Trigger8)        then FlagType := FlagType + 524288;
         If (FlagType > 0) then
         Begin
            FlagFrameNumber := (Counter - 1);
            BlockWrite(MIFile, FlagFrameNumber, 4);
            BlockWrite(MIFile, FlagType, 4);
         End;
      End;
   Finally
      Close(MIFile);
   End {try};
End {WriteMIFile};

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

Procedure ReadMCFile(MCFileName :String);

var
   Counter        :Integer;
   Counter2       :Integer;
   DataStart      :Array[1..16] of LongWord;
   SpareByte      :Byte;
{   CoordinateSet  :PositionPointer;}
   AngleSet       :EulerPointer;
   Q1, Q2, Q3, Q4 :Single;

Begin
   AssignFile(MCFile, MCFileName);
   Try
      Reset(MCFile, 1);
      BlockRead(MCFile, MCNJoints, 4);
      NJoints := MCNJoints;
      If (MCNJoints<>16) then ShowMessage('Warning - may not be a humanoid .mc file!');
      For Counter:=1 to MCNJoints do
      Begin
         BlockRead(MCFile, DataStart[Counter], 4);
      End;

      While (Filepos(MCFile)<Datastart[1]) do BlockRead(MCFile, SpareByte, 1);

   {   PositionList := TList.Create;}

      EulerList[1] := TList.Create;

   {  Import joint 1 data - potitional offset}
      For Counter:=1 to NFrames do
      begin
         New(AngleSet);
         BlockRead(MCFile, AngleSet^.X, 4);
         BlockRead(MCFile, AngleSet^.Y, 4);
         BlockRead(MCFile, AngleSet^.Z, 4);
         EulerList[1].Add(AngleSet);
   {Writeln(DebugFile, FormatFloat('0.000', AngleSet^.X),'   |||   ',
                       FormatFloat('0.000', AngleSet^.Y),'   |||   ',
                       FormatFloat('0.000', AngleSet^.Z));}

      end;

   {  Import joints 2-... data - read as quaternions and convert to Euler angles}
      For Counter2:= 2 to MCNJoints Do
      begin
         EulerList[Counter2] := TList.Create;
         Seek(MCFile, DataStart[Counter2]);
         For Counter := 1 to NFrames do
         begin
            New(AngleSet);
            BlockRead(MCFile, Q1, 4);
            BlockRead(MCFile, Q2, 4);
            BlockRead(MCFile, Q3, 4);
            BlockRead(MCFile, Q4, 4);
   {Writeln(DebugFile, FormatFloat('0.000', Q1),'   |||   ',
                       FormatFloat('0.000', Q2),'   |||   ',
                       FormatFloat('0.000', Q3),'   |||   ',
                       FormatFloat('0.000', Q4));}
            Quaternion2Euler(Q1, Q2, Q3, Q4, AngleSet^.X, AngleSet^.Y, AngleSet^.Z);

   {Euler2Quaternion(AngleSet^.X, AngleSet^.Y, AngleSet^.Z, Q1, Q2, Q3, Q4);
   Writeln(DebugFile, FormatFloat('0.000', Q1),'   |||   ',
                      FormatFloat('0.000', Q2),'   |||   ',
                      FormatFloat('0.000', Q3),'   |||   ',
                      FormatFloat('0.000', Q4));
   writeln(DebugFile);}

            EulerList[Counter2].Add(AngleSet);
         end;
      end;
   Finally
      CloseFile(MCFile);
   End {Try};
End {ReadMCFile};

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

Procedure WriteMCFile(MCFileName :String);

var
{   MCNJoints      :LongWord;}
   Counter        :Integer;
   Counter2       :Integer;
   DataStart      :Array[1..16] of LongWord;
   SpareByte      :Byte;
   AngleSet       :EulerPointer;
   Q1, Q2, Q3, Q4 :Single;

Begin
   AssignFile(MCFile, MCFileName);
   Try
      Rewrite(MCFile, 1);
      BlockWrite(MCFile, MCNJoints, 4);

      For Counter := 1 to MCNJoints do
      begin
         {Start of position data (1st joint)}
         If (Counter = 1) then DataStart[Counter] := 4 + (4 * MCNJoints);
         {Start of first rotation data (2nd joint - after position data)}
         If (Counter = 2) then DataStart[Counter] := DataStart[Counter - 1] + 3 * 4 * NFrames;
         {Start of remaining joints}
         If (Counter > 2) then DataStart[Counter] := DataStart[Counter - 1] + 4 * 4 * NFrames;
         BlockWrite(MCFile, DataStart[Counter], 4);
      end;

      SpareByte := 0;
      {Fill file with zeroes to allow easy seeking when writing data later}
      While (Filepos(MCFile)<(Datastart[MCNJoints] + 4 * 4 * NFrames)) do BlockWrite(MCFile, SpareByte, 1);

      Seek(MCFile, DataStart[1]);
      For Counter:=1 to NFrames do
      begin
         AngleSet := EulerList[1].Items[Counter - 1];
         BlockWrite(MCFile, AngleSet^.X, 4);
         BlockWrite(MCFile, AngleSet^.Y, 4);
         BlockWrite(MCFile, AngleSet^.Z, 4);
      end;

      For Counter2 := 2 to MCNJoints Do
      begin
         Seek(MCFile, DataStart[Counter2]);
         For Counter := 1 to NFrames do
         begin
            AngleSet:=EulerList[Counter2].Items[Counter - 1];
            Euler2Quaternion(AngleSet^.X, AngleSet^.Y, AngleSet^.Z, Q1, Q2, Q3, Q4);
            BlockWrite(MCFile, Q1, 4);
            BlockWrite(MCFile, Q2, 4);
            BlockWrite(MCFile, Q3, 4);
            BlockWrite(MCFile, Q4, 4);
         end;
      end;
   Finally
      Close(MCFile);
   End {Try};
End {WriteMCFile};

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

end.
