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

unit GraphAndPreviewPlotting;

interface

   Procedure ClearGraphWindows(JointNo :Integer);
   Procedure ClearPreviewWindows;
   Procedure RedrawGraphs(FrameNo, JointNo, MarkedFrameNo :Integer);
   Procedure RedrawPreviews(FrameNo, JointNo :Integer);
   Procedure DrawGrids(FrameN :Integer);
   Procedure AssignJointRotations;
   Procedure DrawStickMan(FrameN, JointN :Integer);
   Procedure DrawStickArm(FrameN, JointN :Integer);
   Procedure ReformatJointSelector(Passed_CreatureClass :Integer);

implementation

Uses Unit1, MotTypes, MotMaths, CoordSetup,
     Windows {Needed for 'RGB'},
     Classes {Needed for 'RECT'},
     SysUtils{Needed for 'FormatFloat'};
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Var
   CurrJointPosition :Array[0..21] of EulerRecord; {Joint positions after rotation}
   XStart, YStart, ZStart :Single; {Virtual space coordinates for joints}
   XEnd,   YEnd,   ZEnd   :Single;
   XPlot1, XPlot2, YPlot1, YPlot2 :Array[1..3] of Integer; {Display coordinates for drawing
                                                            with - 1=XPreview, 2=YPreview, 3=ZPreview}


Procedure ClearGraphWindows(JointNo :Integer);

Begin
   {Set graph window backgrounds to relevant colour}
   If (JointNo=1) then Form1.XRotGraph.Canvas.Brush.Color := RGB(0, 255, 255)
   else                Form1.XRotGraph.Canvas.Brush.Color := RGB(255, 0, 0);
   Form1.XRotGraph.Canvas.FillRect(Rect(0, 0, Form1.XRotGraph.Width, Form1.XRotGraph.Height));

   If (JointNo=1) then Form1.YRotGraph.Canvas.Brush.Color := RGB(255, 0, 255)
   else                Form1.YRotGraph.Canvas.Brush.Color := RGB(0, 255, 0);
   Form1.YRotGraph.Canvas.FillRect(Rect(0, 0, Form1.YRotGraph.Width, Form1.YRotGraph.Height));

   If (JointNo=1) then Form1.ZRotGraph.Canvas.Brush.Color := RGB(255, 255, 0)
   else                Form1.ZRotGraph.Canvas.Brush.Color := RGB(0, 0, 255);
   Form1.ZRotGraph.Canvas.FillRect(Rect(0, 0, Form1.ZRotGraph.Width, Form1.ZRotGraph.Height));
End {Procedure ClearPreviewWindows};

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure ClearPreviewWindows;

Begin
   {Set preview window backgrounds to black}
   Form1.XPreview.Canvas.Brush.Color := RGB( 0, 0, 0);
   Form1.XPreview.Canvas.FillRect(Rect(0, 0, Form1.XPreview.Width, Form1.XPreview.Height));
   Form1.YPreview.Canvas.Brush.Color := RGB( 0, 0, 0);
   Form1.YPreview.Canvas.FillRect(Rect(0, 0, Form1.YPreview.Width, Form1.YPreview.Height));
   Form1.ZPreview.Canvas.Brush.Color := RGB( 0, 0, 0);
   Form1.ZPreview.Canvas.FillRect(Rect(0, 0, Form1.ZPreview.Width, Form1.ZPreview.Height));
End {Procedure ClearPreviewWindows};

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

{Procedure PlotGraphs;}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure RedrawGraphs(FrameNo, JointNo, MarkedFrameNo :Integer);

Var
   Counter :Integer;
   X1, X2  :Array[1..3] of Integer; {X & Y start & end coordinates for lines plotted on graphs}
   Y1, Y2  :Array[1..3] of Integer;
   P       :EulerPointer;
   NDataPoints :Array[1..3] of Integer; {Number of data points in graphs.  E.g. 360 for all
                                         rotations because there are 360 degrees.}
   XMin, XMax :Single; {For working out NDataPoints by calculating the number of points}
   YMin, YMax :Single; {spanned by the data between the min and max values.}
   ZMin, ZMax :Single;

begin
   If (JointNo = 1) then
   Begin
   XMax := -9999999;   YMax := -9999999;   ZMax := -9999999;
   XMin :=  9999999;   YMin :=  9999999;   ZMin :=  9999999;
      For Counter := 1 to NFrames Do
      Begin
         P := EulerList[JointNo].Items[Counter - 1];
         If (P^.X > XMax) then XMax := P^.X;         If (P^.X < XMin) then XMin := P^.X;
         If (P^.Y > YMax) then YMax := P^.Y;         If (P^.Y < YMin) then YMin := P^.Y;
         If (P^.Z > ZMax) then ZMax := P^.Z;         If (P^.Z < ZMin) then ZMin := P^.Z;
      End;
      NDataPoints[1] := Round(XMax - XMin);
      NDataPoints[2] := Round(YMax - YMin);
      NDataPoints[3] := Round(ZMax - ZMin);

{Display min and max ranges on graphs in translate mode (joint 1)}
      Form1.XGraphMaxLabel.Caption := FormatFloat('  0.000', XMax);
      Form1.XGraphMinLabel.Caption := FormatFloat('  0.000', XMin);
      Form1.YGraphMaxLabel.Caption := FormatFloat('  0.000', YMax);
      Form1.YGraphMinLabel.Caption := FormatFloat('  0.000', YMin);
      Form1.ZGraphMaxLabel.Caption := FormatFloat('  0.000', ZMax);
      Form1.ZGraphMinLabel.Caption := FormatFloat('  0.000', ZMin);
{Position labels so that they are on the right hand edge of the graph}
      Form1.XGraphMaxLabel.Left := (Form1.XRotGraph.Left + Form1.XRotGraph.Width) - Form1.XGraphMaxLabel.Width;
      Form1.XGraphMinLabel.Left := (Form1.XRotGraph.Left + Form1.XRotGraph.Width) - Form1.XGraphMinLabel.Width;
      Form1.YGraphMaxLabel.Left := (Form1.YRotGraph.Left + Form1.YRotGraph.Width) - Form1.YGraphMaxLabel.Width;
      Form1.YGraphMinLabel.Left := (Form1.YRotGraph.Left + Form1.YRotGraph.Width) - Form1.YGraphMinLabel.Width;
      Form1.ZGraphMaxLabel.Left := (Form1.ZRotGraph.Left + Form1.ZRotGraph.Width) - Form1.ZGraphMaxLabel.Width;
      Form1.ZGraphMinLabel.Left := (Form1.ZRotGraph.Left + Form1.ZRotGraph.Width) - Form1.ZGraphMinLabel.Width;

      If (XMin = XMax) then
      Begin         NDataPoints[1] := 360;         XMin := -180;         XMax :=  180;
      End;
      If (YMin = YMax) then
      Begin         NDataPoints[2] := 360;         YMin := -180;         YMax :=  180;
      End;
      If (ZMin = ZMax) then
      Begin         NDataPoints[3] := 360;         ZMin := -180;         ZMax :=  180;
      End;
   End;
   {Redraw graphs - SLOW!}

   ClearGraphWindows(JointNo);

   {Shade sector of graph corresponding to currently marked frame}
   If(MarkedFrameNo > 0) then
   Begin
      X1[1] := Round((Form1.XRotGraph.Width / NFrames) * (MarkedFrameNo - 1));
      X2[1] := Round((Form1.XRotGraph.Width / NFrames) * MarkedFrameNo);
      X1[2] := Round((Form1.YRotGraph.Width / NFrames) * (MarkedFrameNo - 1));
      X2[2] := Round((Form1.YRotGraph.Width / NFrames) * MarkedFrameNo);
      X1[3] := Round((Form1.ZRotGraph.Width / NFrames) * (MarkedFrameNo - 1));
      X2[3] := Round((Form1.ZRotGraph.Width / NFrames) * MarkedFrameNo);
      If (JointNo=1) then Form1.XRotGraph.Canvas.Brush.Color := RGB(0, 128, 128)
      else                Form1.XRotGraph.Canvas.Brush.Color := RGB(128, 0, 0);
      Form1.XRotGraph.Canvas.FillRect(Rect(X1[1], 0, X2[1], Form1.XRotGraph.Height));

      If (JointNo=1) then Form1.YRotGraph.Canvas.Brush.Color := RGB(128, 0, 128)
      else                Form1.YRotGraph.Canvas.Brush.Color := RGB(0, 128, 0);
      Form1.YRotGraph.Canvas.FillRect(Rect(X1[2], 0, X2[2], Form1.YRotGraph.Height));

      If (JointNo=1) then Form1.ZRotGraph.Canvas.Brush.Color := RGB(128, 128, 0)
      else                Form1.ZRotGraph.Canvas.Brush.Color := RGB(0, 0, 128);
      Form1.ZRotGraph.Canvas.FillRect(Rect(X1[3], 0, X2[3], Form1.ZRotGraph.Height));
   End;
   {End of shade routine}

   If ((NFrames>0) and (JointNo > 0)) then
   Begin
      For Counter := 1 to NFrames do
      begin
         If (Counter = FrameNo) then
         Begin
            Form1.XRotGraph.Canvas.Pen.Color := RGB(0, 0, 0);
            Form1.YRotGraph.Canvas.Pen.Color := RGB(0, 0, 0);
            Form1.ZRotGraph.Canvas.Pen.Color := RGB(0, 0, 0);
         End
         Else
         Begin
            Form1.XRotGraph.Canvas.Pen.Color := RGB(255, 255, 255);
            Form1.YRotGraph.Canvas.Pen.Color := RGB(255, 255, 255);
            Form1.ZRotGraph.Canvas.Pen.Color := RGB(255, 255, 255);
         End;


         {Get start coordinates for lines to plot}
         X1[1] := Round((Form1.XRotGraph.Width / NFrames) * (Counter - 1));
         X2[1] := Round((Form1.XRotGraph.Width / NFrames) * Counter);
         X1[2] := Round((Form1.YRotGraph.Width / NFrames) * (Counter - 1));
         X2[2] := Round((Form1.YRotGraph.Width / NFrames) * Counter);
         X1[3] := Round((Form1.ZRotGraph.Width / NFrames) * (Counter - 1));
         X2[3] := Round((Form1.ZRotGraph.Width / NFrames) * Counter);

         P := EulerList[JointNo].Items[Counter - 1];

{For some reason, DromEd's X, Y and Z axes correspond to my -Z, -Y and -X axes (in rotation)
 respectively.  Therefore, I need to swap the graph plotting data around a bit for joints > 1.
 Do same with preview windows...  Don't forget to put in '360-' to get -X from X, etc...}
         If (CurrJoint > 1) then
         Begin
            Y1[3] := Round(((Form1.XRotGraph.Height / 360) * P^.X));
            Y1[2] := Round(((Form1.YRotGraph.Height / 360) * P^.Y));
            Y1[1] := Round(((Form1.ZRotGraph.Height / 360) * P^.Z));
         End
         Else
         Begin
            Y1[1] := Round(Form1.XRotGraph.Height * (1-((P^.X/(XMax-XMin))-(XMin/(XMax-XMin)))));
            Y1[2] := Round(Form1.YRotGraph.Height * (1-((P^.Y/(YMax-YMin))-(YMin/(YMax-YMin)))));
            Y1[3] := Round(Form1.ZRotGraph.Height * (1-((P^.Z/(ZMax-ZMin))-(ZMin/(ZMax-ZMin)))));
         End;
         If (Counter = NFrames) then
         Begin
            If (CurrJoint > 1) then
            Begin
               Y2[3] := Round((Form1.XRotGraph.Height / 360) * P^.X);
               Y2[2] := Round((Form1.YRotGraph.Height / 360) * P^.Y);
               Y2[1] := Round((Form1.ZRotGraph.Height / 360) * P^.Z);
            End
            Else
            Begin
               Y2[1] := Round(Form1.XRotGraph.Height * (1-((P^.X/(XMax-XMin))-(XMin/(XMax-XMin)))));
               Y2[2] := Round(Form1.YRotGraph.Height * (1-((P^.Y/(YMax-YMin))-(YMin/(YMax-YMin)))));
               Y2[3] := Round(Form1.ZRotGraph.Height * (1-((P^.Z/(ZMax-ZMin))-(ZMin/(ZMax-ZMin)))));
            End;
         End
         else
         Begin
            P := EulerList[JointNo].Items[Counter];
            If (CurrJoint > 1) then
            Begin
               Y2[3] := Round((Form1.XRotGraph.Height / 360) * P^.X);
               Y2[2] := Round((Form1.YRotGraph.Height / 360) * P^.Y);
               Y2[1] := Round((Form1.ZRotGraph.Height / 360) * P^.Z);
            End
            Else
            Begin
               Y2[1] := Round(Form1.XRotGraph.Height * (1-((P^.X/(XMax-XMin))-(XMin/(XMax-XMin)))));
               Y2[2] := Round(Form1.YRotGraph.Height * (1-((P^.Y/(YMax-YMin))-(YMin/(YMax-YMin)))));
               Y2[3] := Round(Form1.ZRotGraph.Height * (1-((P^.Z/(ZMax-ZMin))-(ZMin/(ZMax-ZMin)))));
            End;
         End;
         Form1.XRotGraph.Canvas.MoveTo(X1[1], Y1[1]);
         Form1.XRotGraph.Canvas.LineTo(X2[1], Y2[1]);
         Form1.YRotGraph.Canvas.MoveTo(X1[2], Y1[2]);
         Form1.YRotGraph.Canvas.LineTo(X2[2], Y2[2]);
         Form1.ZRotGraph.Canvas.MoveTo(X1[3], Y1[3]);
         Form1.ZRotGraph.Canvas.LineTo(X2[3], Y2[3]);
      End;
   End;
   {Plot graph here}
end {RedrawGraphs};

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure DrawGrids(FrameN :Integer);

var
   P       :EulerPointer;

Begin
   P := EulerList[1].Items[FrameN - 1];
   CurrJointPosition[HumButt].X := P^.X;
   CurrJointPosition[HumButt].Y := P^.Y;
   CurrJointPosition[HumButt].Z := P^.Z;

   {X Preview}
   XStart := -(CurrJointPosition[HumButt].X);
   YStart := -(CurrJointPosition[HumButt].Y);
   ZStart := -(CurrJointPosition[HumButt].Z);
{Writeln(DebugFile, FormatFloat('0.000', XStart),'   |||   ',
                   FormatFloat('0.000', YStart),'   |||   ',
                   FormatFloat('0.000', ZStart));}

   {Draw stationary line for showing movement in Z direction - bobbing direction}
   XPlot1[1] :=  0;
   YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (ZStart - PreviewScale));
   XPlot2[1] :=  Form1.XPreview.Width;
   YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (ZStart - PreviewScale));
   If (CurrJoint > 1) Then Form1.XPreview.Canvas.Pen.Color := RGB(255,   0,   0)
                      Else Form1.XPreview.Canvas.Pen.Color := RGB(  0, 255, 255);
   Form1.XPreview.Canvas.MoveTo(XPlot1[1], YPlot1[1]);
   Form1.XPreview.Canvas.LineTo(XPlot2[1], YPlot2[1]);
   {Draw stationary line for showing movement in Y direction - swaying direction}
   XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (YStart - PreviewScale));
   YPlot1[1] :=  0;
   XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (YStart - PreviewScale));
   YPlot2[1] :=  Form1.XPreview.Height;
   If (CurrJoint > 1) Then Form1.XPreview.Canvas.Pen.Color := RGB(255,   0,   0)
                      Else Form1.XPreview.Canvas.Pen.Color := RGB(  0, 255, 255);
   Form1.XPreview.Canvas.MoveTo(XPlot1[1], YPlot1[1]);
   Form1.XPreview.Canvas.LineTo(XPlot2[1], YPlot2[1]);

   {Y Preview}
   {Draw stationary line for showing movement in X direction - walking direction}
   XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (XStart - PreviewScale));
   YPlot1[2] :=  Form1.YPreview.Height;
   XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (XStart - PreviewScale));
   YPlot2[2] :=  0;
   If (CurrJoint > 1) Then Form1.YPreview.Canvas.Pen.Color := RGB(  0, 255,   0)
                      Else Form1.YPreview.Canvas.Pen.Color := RGB(255,   0, 255);
   Form1.YPreview.Canvas.MoveTo(XPlot1[2], YPlot1[2]);
   Form1.YPreview.Canvas.LineTo(XPlot2[2], YPlot2[2]);
   {Draw stationary line for showing movement in Z direction - bobbing direction}
   XPlot1[2] :=  0;
   YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (ZStart - PreviewScale));
   XPlot2[2] :=  Form1.YPreview.Width;
   YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (ZStart - PreviewScale));
   If (CurrJoint > 1) Then Form1.YPreview.Canvas.Pen.Color := RGB(  0, 255,   0)
                      Else Form1.YPreview.Canvas.Pen.Color := RGB(255,   0, 255);
   Form1.YPreview.Canvas.MoveTo(XPlot1[2], YPlot1[2]);
   Form1.YPreview.Canvas.LineTo(XPlot2[2], YPlot2[2]);

   {Z Preview}
   {Draw stationary line for showing movement in X direction - walking direction}
   XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (XStart - PreviewScale));
   YPlot1[3] :=  Form1.ZPreview.Height;
   XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (XStart - PreviewScale));
   YPlot2[3] :=  0;
   If (CurrJoint > 1) Then Form1.ZPreview.Canvas.Pen.Color := RGB(  0,   0, 255)
                      Else Form1.ZPreview.Canvas.Pen.Color := RGB(255, 255,   0);
   Form1.ZPreview.Canvas.MoveTo(XPlot1[3], YPlot1[3]);
   Form1.ZPreview.Canvas.LineTo(XPlot2[3], YPlot2[3]);
   {Draw stationary line for showing movement in Y direction - swaying direction}
   XPlot1[3] :=  0;
   YPlot1[3] := (Form1.ZPreview.Height  div 2) + Round((256 * YStart) / (YStart - PreviewScale));
   XPlot2[3] :=  Form1.ZPreview.Width;
   YPlot2[3] := (Form1.ZPreview.Height  div 2) + Round((256 * YStart) / (YStart - PreviewScale));
   If (CurrJoint > 1) Then Form1.ZPreview.Canvas.Pen.Color := RGB(  0,   0, 255)
                      Else Form1.ZPreview.Canvas.Pen.Color := RGB(255, 255,   0);
   Form1.ZPreview.Canvas.MoveTo(XPlot1[3], YPlot1[3]);
   Form1.ZPreview.Canvas.LineTo(XPlot2[3], YPlot2[3]);
End {Procedure DrawGrids};

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure AssignJointRotations;

Var
   Counter :Integer;

Begin
   For Counter := 0 to 21 Do
   Begin
      CurrJointPosition[Counter].X := JointPosition[CurrCreatureType,Counter].X -
                                      JointPosition[CurrCreatureType,8].X;
      CurrJointPosition[Counter].Y := JointPosition[CurrCreatureType,Counter].Y -
                                      JointPosition[CurrCreatureType,8].Y;
      CurrJointPosition[Counter].Z := JointPosition[CurrCreatureType,Counter].Z -
                                      JointPosition[CurrCreatureType,8].Z;
   End; {For}
End; {Procedure AssignJointRotations}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure HumLAnkleRotate(FrmNo :Integer);

Var
   P       :EulerPointer;

Begin
{Apply rotation from left ankle - affects left toe}
   P := EulerList[HumLAnkle].Items[FrmNo - 1];
{I've no idea why Y & Z need 180 degrees added - it was found by trial and
 error!}
   RotateVector((CurrJointPosition[HumLToe].Z - CurrJointPosition[HumLAnkle].Z),
                (CurrJointPosition[HumLToe].Y - CurrJointPosition[HumLAnkle].Y),
                (CurrJointPosition[HumLToe].X - CurrJointPosition[HumLAnkle].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumLToe].Z,
                CurrJointPosition[HumLToe].Y,
                CurrJointPosition[HumLToe].X);

   CurrJointPosition[HumLToe].X := CurrJointPosition[HumLToe].X + CurrJointPosition[HumLAnkle].X;
   CurrJointPosition[HumLToe].Y := CurrJointPosition[HumLToe].Y + CurrJointPosition[HumLAnkle].Y;
   CurrJointPosition[HumLToe].Z := CurrJointPosition[HumLToe].Z + CurrJointPosition[HumLAnkle].Z;
{End left ankle}
End; {Procedure HumLAnkleRotate}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure HumRAnkleRotate(FrmNo :Integer);

Var
   P       :EulerPointer;

Begin
{Apply rotation from right ankle - affects right toe}
   P := EulerList[HumRAnkle].Items[FrmNo - 1];
{I've no idea why Y & Z need 180 degrees added - it was found by trial and
 error!}
   RotateVector((CurrJointPosition[HumRToe].Z - CurrJointPosition[HumRAnkle].Z),
                (CurrJointPosition[HumRToe].Y - CurrJointPosition[HumRAnkle].Y),
                (CurrJointPosition[HumRToe].X - CurrJointPosition[HumRAnkle].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumRToe].Z,
                CurrJointPosition[HumRToe].Y,
                CurrJointPosition[HumRToe].X);

   CurrJointPosition[HumRToe].X := CurrJointPosition[HumRToe].X + CurrJointPosition[HumRAnkle].X;
   CurrJointPosition[HumRToe].Y := CurrJointPosition[HumRToe].Y + CurrJointPosition[HumRAnkle].Y;
   CurrJointPosition[HumRToe].Z := CurrJointPosition[HumRToe].Z + CurrJointPosition[HumRAnkle].Z;
{End right ankle}
End; {Procedure HumRAnkleRotate}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure HumLKneeRotate(FrmNo :Integer);

Var
   P       :EulerPointer;

Begin
{Apply rotation from left knee - affects left ankle & children}
   P := EulerList[HumLKnee].Items[FrmNo - 1];
{I've no idea why Y & Z need 180 degrees added - it was found by trial and
 error!}
{Need to rotate left ankle AND toe about left knee}
   RotateVector((CurrJointPosition[HumLAnkle].Z - CurrJointPosition[HumLKnee].Z),
                (CurrJointPosition[HumLAnkle].Y - CurrJointPosition[HumLKnee].Y),
                (CurrJointPosition[HumLAnkle].X - CurrJointPosition[HumLKnee].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumLAnkle].Z,
                CurrJointPosition[HumLAnkle].Y,
                CurrJointPosition[HumLAnkle].X);

   CurrJointPosition[HumLAnkle].X := CurrJointPosition[HumLAnkle].X + CurrJointPosition[HumLKnee].X;
   CurrJointPosition[HumLAnkle].Y := CurrJointPosition[HumLAnkle].Y + CurrJointPosition[HumLKnee].Y;
   CurrJointPosition[HumLAnkle].Z := CurrJointPosition[HumLAnkle].Z + CurrJointPosition[HumLKnee].Z;

   RotateVector((CurrJointPosition[HumLToe].Z - CurrJointPosition[HumLKnee].Z),
                (CurrJointPosition[HumLToe].Y - CurrJointPosition[HumLKnee].Y),
                (CurrJointPosition[HumLToe].X - CurrJointPosition[HumLKnee].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumLToe].Z,
                CurrJointPosition[HumLToe].Y,
                CurrJointPosition[HumLToe].X);

   CurrJointPosition[HumLToe].X := CurrJointPosition[HumLToe].X + CurrJointPosition[HumLKnee].X;
   CurrJointPosition[HumLToe].Y := CurrJointPosition[HumLToe].Y + CurrJointPosition[HumLKnee].Y;
   CurrJointPosition[HumLToe].Z := CurrJointPosition[HumLToe].Z + CurrJointPosition[HumLKnee].Z;
{End left knee}
End; {Procedure HumLKneeRotate}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure HumRKneeRotate(FrmNo :Integer);

Var
   P       :EulerPointer;

Begin
{Apply rotation from right knee - affects right ankle & children}
   P := EulerList[HumRKnee].Items[FrmNo - 1];
{I've no idea why Y & Z need 180 degrees added - it was found by trial and
 error!}
{Need to rotate right ankle AND toe about right knee}
   RotateVector((CurrJointPosition[HumRAnkle].Z - CurrJointPosition[HumRKnee].Z),
                (CurrJointPosition[HumRAnkle].Y - CurrJointPosition[HumRKnee].Y),
                (CurrJointPosition[HumRAnkle].X - CurrJointPosition[HumRKnee].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumRAnkle].Z,
                CurrJointPosition[HumRAnkle].Y,
                CurrJointPosition[HumRAnkle].X);

   CurrJointPosition[HumRAnkle].X := CurrJointPosition[HumRAnkle].X + CurrJointPosition[HumRKnee].X;
   CurrJointPosition[HumRAnkle].Y := CurrJointPosition[HumRAnkle].Y + CurrJointPosition[HumRKnee].Y;
   CurrJointPosition[HumRAnkle].Z := CurrJointPosition[HumRAnkle].Z + CurrJointPosition[HumRKnee].Z;

   RotateVector((CurrJointPosition[HumRToe].Z - CurrJointPosition[HumRKnee].Z),
                (CurrJointPosition[HumRToe].Y - CurrJointPosition[HumRKnee].Y),
                (CurrJointPosition[HumRToe].X - CurrJointPosition[HumRKnee].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumRToe].Z,
                CurrJointPosition[HumRToe].Y,
                CurrJointPosition[HumRToe].X);

   CurrJointPosition[HumRToe].X := CurrJointPosition[HumRToe].X + CurrJointPosition[HumRKnee].X;
   CurrJointPosition[HumRToe].Y := CurrJointPosition[HumRToe].Y + CurrJointPosition[HumRKnee].Y;
   CurrJointPosition[HumRToe].Z := CurrJointPosition[HumRToe].Z + CurrJointPosition[HumRKnee].Z;
{End right knee}
End; {Procedure HumRKneeRotate}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure HumLHipRotate(FrmNo :Integer);

Var
   P       :EulerPointer;

Begin
{Apply rotation from humanoid left hip - affects left knee & children}
   P := EulerList[HumLHip].Items[FrmNo - 1];
{I've no idea why Y & Z need 180 degrees added - it was found by trial and
 error!}
{Need to rotate left knee, ankle AND toe about left hip}
   RotateVector((CurrJointPosition[HumLKnee].Z - CurrJointPosition[HumLHip].Z),
                (CurrJointPosition[HumLKnee].Y - CurrJointPosition[HumLHip].Y),
                (CurrJointPosition[HumLKnee].X - CurrJointPosition[HumLHip].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumLKnee].Z,
                CurrJointPosition[HumLKnee].Y,
                CurrJointPosition[HumLKnee].X);

   CurrJointPosition[HumLKnee].X := CurrJointPosition[HumLKnee].X + CurrJointPosition[HumLHip].X;
   CurrJointPosition[HumLKnee].Y := CurrJointPosition[HumLKnee].Y + CurrJointPosition[HumLHip].Y;
   CurrJointPosition[HumLKnee].Z := CurrJointPosition[HumLKnee].Z + CurrJointPosition[HumLHip].Z;

   RotateVector((CurrJointPosition[HumLAnkle].Z - CurrJointPosition[HumLHip].Z),
                (CurrJointPosition[HumLAnkle].Y - CurrJointPosition[HumLHip].Y),
                (CurrJointPosition[HumLAnkle].X - CurrJointPosition[HumLHip].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumLAnkle].Z,
                CurrJointPosition[HumLAnkle].Y,
                CurrJointPosition[HumLAnkle].X);

   CurrJointPosition[HumLAnkle].X := CurrJointPosition[HumLAnkle].X + CurrJointPosition[HumLHip].X;
   CurrJointPosition[HumLAnkle].Y := CurrJointPosition[HumLAnkle].Y + CurrJointPosition[HumLHip].Y;
   CurrJointPosition[HumLAnkle].Z := CurrJointPosition[HumLAnkle].Z + CurrJointPosition[HumLHip].Z;

   RotateVector((CurrJointPosition[HumLToe].Z - CurrJointPosition[HumLHip].Z),
                (CurrJointPosition[HumLToe].Y - CurrJointPosition[HumLHip].Y),
                (CurrJointPosition[HumLToe].X - CurrJointPosition[HumLHip].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumLToe].Z,
                CurrJointPosition[HumLToe].Y,
                CurrJointPosition[HumLToe].X);

   CurrJointPosition[HumLToe].X := CurrJointPosition[HumLToe].X + CurrJointPosition[HumLHip].X;
   CurrJointPosition[HumLToe].Y := CurrJointPosition[HumLToe].Y + CurrJointPosition[HumLHip].Y;
   CurrJointPosition[HumLToe].Z := CurrJointPosition[HumLToe].Z + CurrJointPosition[HumLHip].Z;
{End humanoid left hip}
End; {Procedure HumLHipRotate}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure HumRHipRotate(FrmNo :Integer);

Var
   P       :EulerPointer;

Begin
{Apply rotation from right hip - affects right knee & children}
   P := EulerList[HumRHip].Items[FrmNo - 1];
{I've no idea why Y & Z need 180 degrees added - it was found by trial and
 error!}
{Need to rotate right knee, ankle AND toe about right hip}
   RotateVector((CurrJointPosition[HumRKnee].Z - CurrJointPosition[HumRHip].Z),
                (CurrJointPosition[HumRKnee].Y - CurrJointPosition[HumRHip].Y),
                (CurrJointPosition[HumRKnee].X - CurrJointPosition[HumRHip].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumRKnee].Z,
                CurrJointPosition[HumRKnee].Y,
                CurrJointPosition[HumRKnee].X);

   CurrJointPosition[HumRKnee].X := CurrJointPosition[HumRKnee].X + CurrJointPosition[HumRHip].X;
   CurrJointPosition[HumRKnee].Y := CurrJointPosition[HumRKnee].Y + CurrJointPosition[HumRHip].Y;
   CurrJointPosition[HumRKnee].Z := CurrJointPosition[HumRKnee].Z + CurrJointPosition[HumRHip].Z;

   RotateVector((CurrJointPosition[HumRAnkle].Z - CurrJointPosition[HumRHip].Z),
                (CurrJointPosition[HumRAnkle].Y - CurrJointPosition[HumRHip].Y),
                (CurrJointPosition[HumRAnkle].X - CurrJointPosition[HumRHip].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumRAnkle].Z,
                CurrJointPosition[HumRAnkle].Y,
                CurrJointPosition[HumRAnkle].X);

   CurrJointPosition[HumRAnkle].X := CurrJointPosition[HumRAnkle].X + CurrJointPosition[HumRHip].X;
   CurrJointPosition[HumRAnkle].Y := CurrJointPosition[HumRAnkle].Y + CurrJointPosition[HumRHip].Y;
   CurrJointPosition[HumRAnkle].Z := CurrJointPosition[HumRAnkle].Z + CurrJointPosition[HumRHip].Z;

   RotateVector((CurrJointPosition[HumRToe].Z - CurrJointPosition[HumRHip].Z),
                (CurrJointPosition[HumRToe].Y - CurrJointPosition[HumRHip].Y),
                (CurrJointPosition[HumRToe].X - CurrJointPosition[HumRHip].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumRToe].Z,
                CurrJointPosition[HumRToe].Y,
                CurrJointPosition[HumRToe].X);

   CurrJointPosition[HumRToe].X := CurrJointPosition[HumRToe].X + CurrJointPosition[HumRHip].X;
   CurrJointPosition[HumRToe].Y := CurrJointPosition[HumRToe].Y + CurrJointPosition[HumRHip].Y;
   CurrJointPosition[HumRToe].Z := CurrJointPosition[HumRToe].Z + CurrJointPosition[HumRHip].Z;
{End right hip}
End; {Procedure HumRHipRotate}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure HumNeckRotate(FrmNo :Integer);

Var
   P       :EulerPointer;

Begin
{Apply rotation from neck - affects head}
   P := EulerList[HumNeck].Items[FrmNo - 1];
{I've no idea why Y & Z need 180 degrees added - it was found by trial and
 error!}
{Need to rotate left elbow, wrist AND finger about left shoulder}
   RotateVector((CurrJointPosition[HumHead].Z - CurrJointPosition[HumNeck].Z),
                (CurrJointPosition[HumHead].Y - CurrJointPosition[HumNeck].Y),
                (CurrJointPosition[HumHead].X - CurrJointPosition[HumNeck].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumHead].Z,
                CurrJointPosition[HumHead].Y,
                CurrJointPosition[HumHead].X);

   CurrJointPosition[HumHead].X := CurrJointPosition[HumHead].X + CurrJointPosition[HumNeck].X;
   CurrJointPosition[HumHead].Y := CurrJointPosition[HumHead].Y + CurrJointPosition[HumNeck].Y;
   CurrJointPosition[HumHead].Z := CurrJointPosition[HumHead].Z + CurrJointPosition[HumNeck].Z;
{end neck rotation}
End; {Procedure HumNeckRotate}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure HumLShoulderRotate(FrmNo :Integer);

Var
   P       :EulerPointer;

Begin
{Apply rotation from left shoulder - affects left elbow, wrist & finger}
   P := EulerList[HumLShoulder].Items[FrmNo - 1];
{I've no idea why Y & Z need 180 degrees added - it was found by trial and
 error!}
{Need to rotate left elbow, wrist AND finger about left shoulder}
   RotateVector((CurrJointPosition[HumLElbow].Z - CurrJointPosition[HumLShoulder].Z),
                (CurrJointPosition[HumLElbow].Y - CurrJointPosition[HumLShoulder].Y),
                (CurrJointPosition[HumLElbow].X - CurrJointPosition[HumLShoulder].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumLElbow].Z,
                CurrJointPosition[HumLElbow].Y,
                CurrJointPosition[HumLElbow].X);

   CurrJointPosition[HumLElbow].X := CurrJointPosition[HumLElbow].X + CurrJointPosition[HumLShoulder].X;
   CurrJointPosition[HumLElbow].Y := CurrJointPosition[HumLElbow].Y + CurrJointPosition[HumLShoulder].Y;
   CurrJointPosition[HumLElbow].Z := CurrJointPosition[HumLElbow].Z + CurrJointPosition[HumLShoulder].Z;

   RotateVector((CurrJointPosition[HumLWrist].Z - CurrJointPosition[HumLShoulder].Z),
                (CurrJointPosition[HumLWrist].Y - CurrJointPosition[HumLShoulder].Y),
                (CurrJointPosition[HumLWrist].X - CurrJointPosition[HumLShoulder].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumLWrist].Z,
                CurrJointPosition[HumLWrist].Y,
                CurrJointPosition[HumLWrist].X);

   CurrJointPosition[HumLWrist].X := CurrJointPosition[HumLWrist].X + CurrJointPosition[HumLShoulder].X;
   CurrJointPosition[HumLWrist].Y := CurrJointPosition[HumLWrist].Y + CurrJointPosition[HumLShoulder].Y;
   CurrJointPosition[HumLWrist].Z := CurrJointPosition[HumLWrist].Z + CurrJointPosition[HumLShoulder].Z;

   RotateVector((CurrJointPosition[HumLFinger].Z - CurrJointPosition[HumLShoulder].Z),
                (CurrJointPosition[HumLFinger].Y - CurrJointPosition[HumLShoulder].Y),
                (CurrJointPosition[HumLFinger].X - CurrJointPosition[HumLShoulder].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumLFinger].Z,
                CurrJointPosition[HumLFinger].Y,
                CurrJointPosition[HumLFinger].X);

   CurrJointPosition[HumLFinger].X := CurrJointPosition[HumLFinger].X + CurrJointPosition[HumLShoulder].X;
   CurrJointPosition[HumLFinger].Y := CurrJointPosition[HumLFinger].Y + CurrJointPosition[HumLShoulder].Y;
   CurrJointPosition[HumLFinger].Z := CurrJointPosition[HumLFinger].Z + CurrJointPosition[HumLShoulder].Z;
{End left shoulder}
End; {Procedure HumLShoulderRotate}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure HumRShoulderRotate(FrmNo :Integer);

Var
   P       :EulerPointer;

Begin
{Apply rotation from right shoulder - affects right elbow, wrist & finger}
   P := EulerList[HumRShoulder].Items[FrmNo - 1];
{I've no idea why Y & Z need 180 degrees added - it was found by trial and
 error!}
{Need to rotate right elbow, wrist AND finger about right shoulder}
   RotateVector((CurrJointPosition[HumRElbow].Z - CurrJointPosition[HumRShoulder].Z),
                (CurrJointPosition[HumRElbow].Y - CurrJointPosition[HumRShoulder].Y),
                (CurrJointPosition[HumRElbow].X - CurrJointPosition[HumRShoulder].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumRElbow].Z,
                CurrJointPosition[HumRElbow].Y,
                CurrJointPosition[HumRElbow].X);

   CurrJointPosition[HumRElbow].X := CurrJointPosition[HumRElbow].X + CurrJointPosition[HumRShoulder].X;
   CurrJointPosition[HumRElbow].Y := CurrJointPosition[HumRElbow].Y + CurrJointPosition[HumRShoulder].Y;
   CurrJointPosition[HumRElbow].Z := CurrJointPosition[HumRElbow].Z + CurrJointPosition[HumRShoulder].Z;

   RotateVector((CurrJointPosition[HumRWrist].Z - CurrJointPosition[HumRShoulder].Z),
                (CurrJointPosition[HumRWrist].Y - CurrJointPosition[HumRShoulder].Y),
                (CurrJointPosition[HumRWrist].X - CurrJointPosition[HumRShoulder].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumRWrist].Z,
                CurrJointPosition[HumRWrist].Y,
                CurrJointPosition[HumRWrist].X);

   CurrJointPosition[HumRWrist].X := CurrJointPosition[HumRWrist].X + CurrJointPosition[HumRShoulder].X;
   CurrJointPosition[HumRWrist].Y := CurrJointPosition[HumRWrist].Y + CurrJointPosition[HumRShoulder].Y;
   CurrJointPosition[HumRWrist].Z := CurrJointPosition[HumRWrist].Z + CurrJointPosition[HumRShoulder].Z;

   RotateVector((CurrJointPosition[HumRFinger].Z - CurrJointPosition[HumRShoulder].Z),
                (CurrJointPosition[HumRFinger].Y - CurrJointPosition[HumRShoulder].Y),
                (CurrJointPosition[HumRFinger].X - CurrJointPosition[HumRShoulder].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumRFinger].Z,
                CurrJointPosition[HumRFinger].Y,
                CurrJointPosition[HumRFinger].X);

   CurrJointPosition[HumRFinger].X := CurrJointPosition[HumRFinger].X + CurrJointPosition[HumRShoulder].X;
   CurrJointPosition[HumRFinger].Y := CurrJointPosition[HumRFinger].Y + CurrJointPosition[HumRShoulder].Y;
   CurrJointPosition[HumRFinger].Z := CurrJointPosition[HumRFinger].Z + CurrJointPosition[HumRShoulder].Z;
{End right shoulder}
End; {Procedure HumRShoulderRotate}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure ArmRShoulderRotate(FrmNo :Integer);

Var
   P       :EulerPointer;

Begin
{Apply rotation from right shoulder - affects right elbow, wrist & finger}
   P := EulerList[ArmRShoulder].Items[FrmNo - 1];
{I've no idea why Y & Z need 180 degrees added - it was found by trial and
 error!}
{Need to rotate right elbow, wrist AND finger about right shoulder}
   RotateVector((CurrJointPosition[ArmRElbow].Z - CurrJointPosition[ArmRShoulder].Z),
                (CurrJointPosition[ArmRElbow].Y - CurrJointPosition[ArmRShoulder].Y),
                (CurrJointPosition[ArmRElbow].X - CurrJointPosition[ArmRShoulder].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[ArmRElbow].Z,
                CurrJointPosition[ArmRElbow].Y,
                CurrJointPosition[ArmRElbow].X);

   CurrJointPosition[ArmRElbow].X := CurrJointPosition[ArmRElbow].X + CurrJointPosition[ArmRShoulder].X;
   CurrJointPosition[ArmRElbow].Y := CurrJointPosition[ArmRElbow].Y + CurrJointPosition[ArmRShoulder].Y;
   CurrJointPosition[ArmRElbow].Z := CurrJointPosition[ArmRElbow].Z + CurrJointPosition[ArmRShoulder].Z;

   RotateVector((CurrJointPosition[ArmRWrist].Z - CurrJointPosition[ArmRShoulder].Z),
                (CurrJointPosition[ArmRWrist].Y - CurrJointPosition[ArmRShoulder].Y),
                (CurrJointPosition[ArmRWrist].X - CurrJointPosition[ArmRShoulder].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[ArmRWrist].Z,
                CurrJointPosition[ArmRWrist].Y,
                CurrJointPosition[ArmRWrist].X);

   CurrJointPosition[ArmRWrist].X := CurrJointPosition[ArmRWrist].X + CurrJointPosition[ArmRShoulder].X;
   CurrJointPosition[ArmRWrist].Y := CurrJointPosition[ArmRWrist].Y + CurrJointPosition[ArmRShoulder].Y;
   CurrJointPosition[ArmRWrist].Z := CurrJointPosition[ArmRWrist].Z + CurrJointPosition[ArmRShoulder].Z;

   RotateVector((CurrJointPosition[ArmRFinger].Z - CurrJointPosition[ArmRShoulder].Z),
                (CurrJointPosition[ArmRFinger].Y - CurrJointPosition[ArmRShoulder].Y),
                (CurrJointPosition[ArmRFinger].X - CurrJointPosition[ArmRShoulder].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[ArmRFinger].Z,
                CurrJointPosition[ArmRFinger].Y,
                CurrJointPosition[ArmRFinger].X);

   CurrJointPosition[ArmRFinger].X := CurrJointPosition[ArmRFinger].X + CurrJointPosition[ArmRShoulder].X;
   CurrJointPosition[ArmRFinger].Y := CurrJointPosition[ArmRFinger].Y + CurrJointPosition[ArmRShoulder].Y;
   CurrJointPosition[ArmRFinger].Z := CurrJointPosition[ArmRFinger].Z + CurrJointPosition[ArmRShoulder].Z;
{End right shoulder}
End; {Procedure ArmRShoulderRotate}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure HumLElbowRotate(FrmNo :Integer);

Var
   P       :EulerPointer;

Begin
{Apply rotation from left elbow - affects left wrist & finger}
   P := EulerList[HumLElbow].Items[FrmNo - 1];
{I've no idea why Y & Z need 180 degrees added - it was found by trial and
 error!}
{Need to rotate left wrist AND finger about left elbow}
   RotateVector((CurrJointPosition[HumLWrist].Z - CurrJointPosition[HumLElbow].Z),
                (CurrJointPosition[HumLWrist].Y - CurrJointPosition[HumLElbow].Y),
                (CurrJointPosition[HumLWrist].X - CurrJointPosition[HumLElbow].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumLWrist].Z,
                CurrJointPosition[HumLWrist].Y,
                CurrJointPosition[HumLWrist].X);

   CurrJointPosition[HumLWrist].X := CurrJointPosition[HumLWrist].X + CurrJointPosition[HumLElbow].X;
   CurrJointPosition[HumLWrist].Y := CurrJointPosition[HumLWrist].Y + CurrJointPosition[HumLElbow].Y;
   CurrJointPosition[HumLWrist].Z := CurrJointPosition[HumLWrist].Z + CurrJointPosition[HumLElbow].Z;

   RotateVector((CurrJointPosition[HumLFinger].Z - CurrJointPosition[HumLElbow].Z),
                (CurrJointPosition[HumLFinger].Y - CurrJointPosition[HumLElbow].Y),
                (CurrJointPosition[HumLFinger].X - CurrJointPosition[HumLElbow].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumLFinger].Z,
                CurrJointPosition[HumLFinger].Y,
                CurrJointPosition[HumLFinger].X);

   CurrJointPosition[HumLFinger].X := CurrJointPosition[HumLFinger].X + CurrJointPosition[HumLElbow].X;
   CurrJointPosition[HumLFinger].Y := CurrJointPosition[HumLFinger].Y + CurrJointPosition[HumLElbow].Y;
   CurrJointPosition[HumLFinger].Z := CurrJointPosition[HumLFinger].Z + CurrJointPosition[HumLElbow].Z;
{End left elbow}
End; {Procedure HumLElbowRotate}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure HumRElbowRotate(FrmNo :Integer);

Var
   P       :EulerPointer;

Begin
{Apply rotation from right elbow - affects right wrist & finger}
   P := EulerList[HumRElbow].Items[FrmNo - 1];
{I've no idea why Y & Z need 180 degrees added - it was found by trial and
 error!}
{Need to rotate right wrist AND finger about right elbow}
   RotateVector((CurrJointPosition[HumRWrist].Z - CurrJointPosition[HumRElbow].Z),
                (CurrJointPosition[HumRWrist].Y - CurrJointPosition[HumRElbow].Y),
                (CurrJointPosition[HumRWrist].X - CurrJointPosition[HumRElbow].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumRWrist].Z,
                CurrJointPosition[HumRWrist].Y,
                CurrJointPosition[HumRWrist].X);

   CurrJointPosition[HumRWrist].X := CurrJointPosition[HumRWrist].X + CurrJointPosition[HumRElbow].X;
   CurrJointPosition[HumRWrist].Y := CurrJointPosition[HumRWrist].Y + CurrJointPosition[HumRElbow].Y;
   CurrJointPosition[HumRWrist].Z := CurrJointPosition[HumRWrist].Z + CurrJointPosition[HumRElbow].Z;

   RotateVector((CurrJointPosition[HumRFinger].Z - CurrJointPosition[HumRElbow].Z),
                (CurrJointPosition[HumRFinger].Y - CurrJointPosition[HumRElbow].Y),
                (CurrJointPosition[HumRFinger].X - CurrJointPosition[HumRElbow].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumRFinger].Z,
                CurrJointPosition[HumRFinger].Y,
                CurrJointPosition[HumRFinger].X);

   CurrJointPosition[HumRFinger].X := CurrJointPosition[HumRFinger].X + CurrJointPosition[HumRElbow].X;
   CurrJointPosition[HumRFinger].Y := CurrJointPosition[HumRFinger].Y + CurrJointPosition[HumRElbow].Y;
   CurrJointPosition[HumRFinger].Z := CurrJointPosition[HumRFinger].Z + CurrJointPosition[HumRElbow].Z;
{End right elbow}
End; {Procedure HumRElbowRotate}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure ArmRElbowRotate(FrmNo :Integer);

Var
   P       :EulerPointer;

Begin
{Apply rotation from right elbow - affects right wrist & finger}
   P := EulerList[ArmRElbow].Items[FrmNo - 1];
{I've no idea why Y & Z need 180 degrees added - it was found by trial and
 error!}
{Need to rotate right wrist AND finger about right elbow}
   RotateVector((CurrJointPosition[ArmRWrist].Z - CurrJointPosition[ArmRElbow].Z),
                (CurrJointPosition[ArmRWrist].Y - CurrJointPosition[ArmRElbow].Y),
                (CurrJointPosition[ArmRWrist].X - CurrJointPosition[ArmRElbow].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[ArmRWrist].Z,
                CurrJointPosition[ArmRWrist].Y,
                CurrJointPosition[ArmRWrist].X);

   CurrJointPosition[ArmRWrist].X := CurrJointPosition[ArmRWrist].X + CurrJointPosition[ArmRElbow].X;
   CurrJointPosition[ArmRWrist].Y := CurrJointPosition[ArmRWrist].Y + CurrJointPosition[ArmRElbow].Y;
   CurrJointPosition[ArmRWrist].Z := CurrJointPosition[ArmRWrist].Z + CurrJointPosition[ArmRElbow].Z;

   RotateVector((CurrJointPosition[ArmRFinger].Z - CurrJointPosition[ArmRElbow].Z),
                (CurrJointPosition[ArmRFinger].Y - CurrJointPosition[ArmRElbow].Y),
                (CurrJointPosition[ArmRFinger].X - CurrJointPosition[ArmRElbow].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[ArmRFinger].Z,
                CurrJointPosition[ArmRFinger].Y,
                CurrJointPosition[ArmRFinger].X);

   CurrJointPosition[ArmRFinger].X := CurrJointPosition[ArmRFinger].X + CurrJointPosition[ArmRElbow].X;
   CurrJointPosition[ArmRFinger].Y := CurrJointPosition[ArmRFinger].Y + CurrJointPosition[ArmRElbow].Y;
   CurrJointPosition[ArmRFinger].Z := CurrJointPosition[ArmRFinger].Z + CurrJointPosition[ArmRElbow].Z;
{End right elbow}
End; {Procedure ArmRElbowRotate}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure HumLWristRotate(FrmNo :Integer);

Var
   P       :EulerPointer;

Begin
{Apply rotation from left wrist - affects left finger}
   P := EulerList[HumLWrist].Items[FrmNo - 1];
{I've no idea why Y & Z need 180 degrees added - it was found by trial and
 error!}
   RotateVector((CurrJointPosition[HumLFinger].Z - CurrJointPosition[HumLWrist].Z),
                (CurrJointPosition[HumLFinger].Y - CurrJointPosition[HumLWrist].Y),
                (CurrJointPosition[HumLFinger].X - CurrJointPosition[HumLWrist].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumLFinger].Z,
                CurrJointPosition[HumLFinger].Y,
                CurrJointPosition[HumLFinger].X);

   CurrJointPosition[HumLFinger].X := CurrJointPosition[HumLFinger].X + CurrJointPosition[HumLWrist].X;
   CurrJointPosition[HumLFinger].Y := CurrJointPosition[HumLFinger].Y + CurrJointPosition[HumLWrist].Y;
   CurrJointPosition[HumLFinger].Z := CurrJointPosition[HumLFinger].Z + CurrJointPosition[HumLWrist].Z;
{End left wrist}
End; {Procedure HumLWristRotate}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure HumRWristRotate(FrmNo :Integer);

Var
   P       :EulerPointer;

Begin
{Apply rotation from right wrist - affects right finger}
   P := EulerList[HumRWrist].Items[FrmNo - 1];
{I've no idea why Y & Z need 180 degrees added - it was found by trial and
 error!}
   RotateVector((CurrJointPosition[HumRFinger].Z - CurrJointPosition[HumRWrist].Z),
                (CurrJointPosition[HumRFinger].Y - CurrJointPosition[HumRWrist].Y),
                (CurrJointPosition[HumRFinger].X - CurrJointPosition[HumRWrist].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumRFinger].Z,
                CurrJointPosition[HumRFinger].Y,
                CurrJointPosition[HumRFinger].X);

   CurrJointPosition[HumRFinger].X := CurrJointPosition[HumRFinger].X + CurrJointPosition[HumRWrist].X;
   CurrJointPosition[HumRFinger].Y := CurrJointPosition[HumRFinger].Y + CurrJointPosition[HumRWrist].Y;
   CurrJointPosition[HumRFinger].Z := CurrJointPosition[HumRFinger].Z + CurrJointPosition[HumRWrist].Z;
{End right wrist}
End; {Procedure HumRWristRotate}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure ArmRWristRotate(FrmNo :Integer);

Var
   P       :EulerPointer;

Begin
{Apply rotation from right wrist - affects right finger}
   P := EulerList[ArmRWrist].Items[FrmNo - 1];
{I've no idea why Y & Z need 180 degrees added - it was found by trial and
 error!}
   RotateVector((CurrJointPosition[ArmRFinger].Z - CurrJointPosition[ArmRWrist].Z),
                (CurrJointPosition[ArmRFinger].Y - CurrJointPosition[ArmRWrist].Y),
                (CurrJointPosition[ArmRFinger].X - CurrJointPosition[ArmRWrist].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[ArmRFinger].Z,
                CurrJointPosition[ArmRFinger].Y,
                CurrJointPosition[ArmRFinger].X);

   CurrJointPosition[ArmRFinger].X := CurrJointPosition[ArmRFinger].X + CurrJointPosition[ArmRWrist].X;
   CurrJointPosition[ArmRFinger].Y := CurrJointPosition[ArmRFinger].Y + CurrJointPosition[ArmRWrist].Y;
   CurrJointPosition[ArmRFinger].Z := CurrJointPosition[ArmRFinger].Z + CurrJointPosition[ArmRWrist].Z;
{End right wrist}
End; {Procedure ArmRWristRotate}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure HumRootRotate(FrmNo :Integer);
{Rotates the humanoid model in the preview window about the root rotation joint}
var
   Counter :Integer;
   P       :EulerPointer;

begin
   For Counter := 0 to 21 Do
   Begin
{'Unblank' current joint}
{Apply rotation from joint 8 (root torso rotation) - applies to all joints}
      P := EulerList[8].Items[FrmNo - 1];
{I've no idea why Y & Z need 180 degrees added - it was found by trial and
 error!}
      RotateVector((CurrJointPosition[Counter].Z - CurrJointPosition[8].Z),
                   (CurrJointPosition[Counter].Y - CurrJointPosition[8].Y),
                   (CurrJointPosition[Counter].X - CurrJointPosition[8].X),
                   (359.0 - P^.X),
                   (359.0 - (P^.Y + 180.0)),
                   (359.0 - (P^.Z + 180.0)),
                   CurrJointPosition[Counter].Z,
                   CurrJointPosition[Counter].Y,
                   CurrJointPosition[Counter].X);

      CurrJointPosition[Counter].X := CurrJointPosition[Counter].X + CurrJointPosition[8].X;
      CurrJointPosition[Counter].Y := CurrJointPosition[Counter].Y + CurrJointPosition[8].Y;
      CurrJointPosition[Counter].Z := CurrJointPosition[Counter].Z + CurrJointPosition[8].Z;
   End {For - Do};
end; {Procedure HumRootRotate}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure HumTorsoRotate(FrmNo :Integer);

Var
   P       :EulerPointer;

Begin
{Apply rotation from torso joint (16) - affects entire upper body (neck, shoulders, elbows, wrists)}
   P := EulerList[16].Items[FrmNo - 1];
{I've no idea why Y & Z need 180 degrees added - it was found by trial and
 error!}
   RotateVector((CurrJointPosition[HumNeck].Z - CurrJointPosition[HumAbdomen].Z),
                (CurrJointPosition[HumNeck].Y - CurrJointPosition[HumAbdomen].Y),
                (CurrJointPosition[HumNeck].X - CurrJointPosition[HumAbdomen].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumNeck].Z,
                CurrJointPosition[HumNeck].Y,
                CurrJointPosition[HumNeck].X);

   CurrJointPosition[HumNeck].X := CurrJointPosition[HumNeck].X + CurrJointPosition[HumAbdomen].X;
   CurrJointPosition[HumNeck].Y := CurrJointPosition[HumNeck].Y + CurrJointPosition[HumAbdomen].Y;
   CurrJointPosition[HumNeck].Z := CurrJointPosition[HumNeck].Z + CurrJointPosition[HumAbdomen].Z;

   RotateVector((CurrJointPosition[HumHead].Z - CurrJointPosition[HumAbdomen].Z),
                (CurrJointPosition[HumHead].Y - CurrJointPosition[HumAbdomen].Y),
                (CurrJointPosition[HumHead].X - CurrJointPosition[HumAbdomen].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumHead].Z,
                CurrJointPosition[HumHead].Y,
                CurrJointPosition[HumHead].X);

   CurrJointPosition[HumHead].X := CurrJointPosition[HumHead].X + CurrJointPosition[HumAbdomen].X;
   CurrJointPosition[HumHead].Y := CurrJointPosition[HumHead].Y + CurrJointPosition[HumAbdomen].Y;
   CurrJointPosition[HumHead].Z := CurrJointPosition[HumHead].Z + CurrJointPosition[HumAbdomen].Z;

   RotateVector((CurrJointPosition[HumLShoulder].Z - CurrJointPosition[HumAbdomen].Z),
                (CurrJointPosition[HumLShoulder].Y - CurrJointPosition[HumAbdomen].Y),
                (CurrJointPosition[HumLShoulder].X - CurrJointPosition[HumAbdomen].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumLShoulder].Z,
                CurrJointPosition[HumLShoulder].Y,
                CurrJointPosition[HumLShoulder].X);

   CurrJointPosition[HumLShoulder].X := CurrJointPosition[HumLShoulder].X + CurrJointPosition[HumAbdomen].X;
   CurrJointPosition[HumLShoulder].Y := CurrJointPosition[HumLShoulder].Y + CurrJointPosition[HumAbdomen].Y;
   CurrJointPosition[HumLShoulder].Z := CurrJointPosition[HumLShoulder].Z + CurrJointPosition[HumAbdomen].Z;

   RotateVector((CurrJointPosition[HumRShoulder].Z - CurrJointPosition[HumAbdomen].Z),
                (CurrJointPosition[HumRShoulder].Y - CurrJointPosition[HumAbdomen].Y),
                (CurrJointPosition[HumRShoulder].X - CurrJointPosition[HumAbdomen].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumRShoulder].Z,
                CurrJointPosition[HumRShoulder].Y,
                CurrJointPosition[HumRShoulder].X);

   CurrJointPosition[HumRShoulder].X := CurrJointPosition[HumRShoulder].X + CurrJointPosition[HumAbdomen].X;
   CurrJointPosition[HumRShoulder].Y := CurrJointPosition[HumRShoulder].Y + CurrJointPosition[HumAbdomen].Y;
   CurrJointPosition[HumRShoulder].Z := CurrJointPosition[HumRShoulder].Z + CurrJointPosition[HumAbdomen].Z;

   RotateVector((CurrJointPosition[HumRElbow].Z - CurrJointPosition[HumAbdomen].Z),
                (CurrJointPosition[HumRElbow].Y - CurrJointPosition[HumAbdomen].Y),
                (CurrJointPosition[HumRElbow].X - CurrJointPosition[HumAbdomen].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumRElbow].Z,
                CurrJointPosition[HumRElbow].Y,
                CurrJointPosition[HumRElbow].X);

   CurrJointPosition[HumRElbow].X := CurrJointPosition[HumRElbow].X + CurrJointPosition[HumAbdomen].X;
   CurrJointPosition[HumRElbow].Y := CurrJointPosition[HumRElbow].Y + CurrJointPosition[HumAbdomen].Y;
   CurrJointPosition[HumRElbow].Z := CurrJointPosition[HumRElbow].Z + CurrJointPosition[HumAbdomen].Z;

   RotateVector((CurrJointPosition[HumLElbow].Z - CurrJointPosition[HumAbdomen].Z),
                (CurrJointPosition[HumLElbow].Y - CurrJointPosition[HumAbdomen].Y),
                (CurrJointPosition[HumLElbow].X - CurrJointPosition[HumAbdomen].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumLElbow].Z,
                CurrJointPosition[HumLElbow].Y,
                CurrJointPosition[HumLElbow].X);

   CurrJointPosition[HumLElbow].X := CurrJointPosition[HumLElbow].X + CurrJointPosition[HumAbdomen].X;
   CurrJointPosition[HumLElbow].Y := CurrJointPosition[HumLElbow].Y + CurrJointPosition[HumAbdomen].Y;
   CurrJointPosition[HumLElbow].Z := CurrJointPosition[HumLElbow].Z + CurrJointPosition[HumAbdomen].Z;

   RotateVector((CurrJointPosition[HumRWrist].Z - CurrJointPosition[HumAbdomen].Z),
                (CurrJointPosition[HumRWrist].Y - CurrJointPosition[HumAbdomen].Y),
                (CurrJointPosition[HumRWrist].X - CurrJointPosition[HumAbdomen].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumRWrist].Z,
                CurrJointPosition[HumRWrist].Y,
                CurrJointPosition[HumRWrist].X);

   CurrJointPosition[HumRWrist].X := CurrJointPosition[HumRWrist].X + CurrJointPosition[HumAbdomen].X;
   CurrJointPosition[HumRWrist].Y := CurrJointPosition[HumRWrist].Y + CurrJointPosition[HumAbdomen].Y;
   CurrJointPosition[HumRWrist].Z := CurrJointPosition[HumRWrist].Z + CurrJointPosition[HumAbdomen].Z;

   RotateVector((CurrJointPosition[HumLWrist].Z - CurrJointPosition[HumAbdomen].Z),
                (CurrJointPosition[HumLWrist].Y - CurrJointPosition[HumAbdomen].Y),
                (CurrJointPosition[HumLWrist].X - CurrJointPosition[HumAbdomen].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumLWrist].Z,
                CurrJointPosition[HumLWrist].Y,
                CurrJointPosition[HumLWrist].X);

   CurrJointPosition[HumLWrist].X := CurrJointPosition[HumLWrist].X + CurrJointPosition[HumAbdomen].X;
   CurrJointPosition[HumLWrist].Y := CurrJointPosition[HumLWrist].Y + CurrJointPosition[HumAbdomen].Y;
   CurrJointPosition[HumLWrist].Z := CurrJointPosition[HumLWrist].Z + CurrJointPosition[HumAbdomen].Z;

   RotateVector((CurrJointPosition[HumRFinger].Z - CurrJointPosition[HumAbdomen].Z),
                (CurrJointPosition[HumRFinger].Y - CurrJointPosition[HumAbdomen].Y),
                (CurrJointPosition[HumRFinger].X - CurrJointPosition[HumAbdomen].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumRFinger].Z,
                CurrJointPosition[HumRFinger].Y,
                CurrJointPosition[HumRFinger].X);

   CurrJointPosition[HumRFinger].X := CurrJointPosition[HumRFinger].X + CurrJointPosition[HumAbdomen].X;
   CurrJointPosition[HumRFinger].Y := CurrJointPosition[HumRFinger].Y + CurrJointPosition[HumAbdomen].Y;
   CurrJointPosition[HumRFinger].Z := CurrJointPosition[HumRFinger].Z + CurrJointPosition[HumAbdomen].Z;

   RotateVector((CurrJointPosition[HumLFinger].Z - CurrJointPosition[HumAbdomen].Z),
                (CurrJointPosition[HumLFinger].Y - CurrJointPosition[HumAbdomen].Y),
                (CurrJointPosition[HumLFinger].X - CurrJointPosition[HumAbdomen].X),
                (359.0 - P^.X),
                (359.0 - (P^.Y + 180.0)),
                (359.0 - (P^.Z + 180.0)),
                CurrJointPosition[HumLFinger].Z,
                CurrJointPosition[HumLFinger].Y,
                CurrJointPosition[HumLFinger].X);

   CurrJointPosition[HumLFinger].X := CurrJointPosition[HumLFinger].X + CurrJointPosition[HumAbdomen].X;
   CurrJointPosition[HumLFinger].Y := CurrJointPosition[HumLFinger].Y + CurrJointPosition[HumAbdomen].Y;
   CurrJointPosition[HumLFinger].Z := CurrJointPosition[HumLFinger].Z + CurrJointPosition[HumAbdomen].Z;
{End torso joint (joint 16)}
End; {Procedure HumTorsoRotate}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure DrawStickHumanoid(Counter :Integer);

Begin
   If(Counter = HumLAnkle) Then
   Begin
   {Draw left foot}
      XStart := (CurrJointPosition[HumLAnkle].X - CurrJointPosition[8].X);
      YStart := (CurrJointPosition[HumLAnkle].Y - CurrJointPosition[8].Y);
      ZStart := (CurrJointPosition[HumLAnkle].Z - CurrJointPosition[8].Z);
      XEnd   := (CurrJointPosition[HumLToe].X   - CurrJointPosition[8].X);
      YEnd   := (CurrJointPosition[HumLToe].Y   - CurrJointPosition[8].Y);
      ZEnd   := (CurrJointPosition[HumLToe].Z   - CurrJointPosition[8].Z);

      {X Preview}
      XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
      YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
      XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
      YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

      {Y Preview}
      XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
      YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
      XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
      YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

      {Z Preview}
      XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
      YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
      XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
      YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));
   End;

   If(Counter = HumRAnkle) Then
   Begin
   {Draw right foot}
      XStart := (CurrJointPosition[HumRAnkle].X - CurrJointPosition[8].X);
      YStart := (CurrJointPosition[HumRAnkle].Y - CurrJointPosition[8].Y);
      ZStart := (CurrJointPosition[HumRAnkle].Z - CurrJointPosition[8].Z);
      XEnd   := (CurrJointPosition[HumRToe].X   - CurrJointPosition[8].X);
      YEnd   := (CurrJointPosition[HumRToe].Y   - CurrJointPosition[8].Y);
      ZEnd   := (CurrJointPosition[HumRToe].Z   - CurrJointPosition[8].Z);

      {X Preview}
      XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
      YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
      XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
      YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

      {Y Preview}
      XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
      YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
      XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
      YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

      {Z Preview}
      XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
      YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
      XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
      YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));
   End;

   If(Counter = HumLKnee) Then
   Begin
   {Draw left lower leg}
      XStart := (CurrJointPosition[HumLKnee].X - CurrJointPosition[8].X);
      YStart := (CurrJointPosition[HumLKnee].Y - CurrJointPosition[8].Y);
      ZStart := (CurrJointPosition[HumLKnee].Z - CurrJointPosition[8].Z);
      XEnd   := (CurrJointPosition[HumLAnkle].X   - CurrJointPosition[8].X);
      YEnd   := (CurrJointPosition[HumLAnkle].Y   - CurrJointPosition[8].Y);
      ZEnd   := (CurrJointPosition[HumLAnkle].Z   - CurrJointPosition[8].Z);

      {X Preview}
      XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
      YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
      XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
      YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

      {Y Preview}
      XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
      YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
      XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
      YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

      {Z Preview}
      XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
      YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
      XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
      YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));
   End;

   If(Counter = HumRKnee) Then
   Begin
   {Draw right lower leg}
      XStart := (CurrJointPosition[HumRKnee].X - CurrJointPosition[8].X);
      YStart := (CurrJointPosition[HumRKnee].Y - CurrJointPosition[8].Y);
      ZStart := (CurrJointPosition[HumRKnee].Z - CurrJointPosition[8].Z);
      XEnd   := (CurrJointPosition[HumRAnkle].X   - CurrJointPosition[8].X);
      YEnd   := (CurrJointPosition[HumRAnkle].Y   - CurrJointPosition[8].Y);
      ZEnd   := (CurrJointPosition[HumRAnkle].Z   - CurrJointPosition[8].Z);

      {X Preview}
      XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
      YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
      XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
      YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

      {Y Preview}
      XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
      YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
      XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
      YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

      {Z Preview}
      XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
      YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
      XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
      YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));
   End;

   If(Counter = HumLHip) Then
   Begin
   {Draw left upper leg}
      XStart := (CurrJointPosition[HumLHip].X - CurrJointPosition[8].X);
      YStart := (CurrJointPosition[HumLHip].Y - CurrJointPosition[8].Y);
      ZStart := (CurrJointPosition[HumLHip].Z - CurrJointPosition[8].Z);
      XEnd   := (CurrJointPosition[HumLKnee].X   - CurrJointPosition[8].X);
      YEnd   := (CurrJointPosition[HumLKnee].Y   - CurrJointPosition[8].Y);
      ZEnd   := (CurrJointPosition[HumLKnee].Z   - CurrJointPosition[8].Z);

      {X Preview}
      XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
      YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
      XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
      YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

      {Y Preview}
      XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
      YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
      XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
      YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

      {Z Preview}
      XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
      YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
      XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
      YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));
   End;

   If(Counter = HumRHip) Then
   Begin
   {Draw right upper leg}
      XStart := (CurrJointPosition[HumRHip].X - CurrJointPosition[8].X);
      YStart := (CurrJointPosition[HumRHip].Y - CurrJointPosition[8].Y);
      ZStart := (CurrJointPosition[HumRHip].Z - CurrJointPosition[8].Z);
      XEnd   := (CurrJointPosition[HumRKnee].X   - CurrJointPosition[8].X);
      YEnd   := (CurrJointPosition[HumRKnee].Y   - CurrJointPosition[8].Y);
      ZEnd   := (CurrJointPosition[HumRKnee].Z   - CurrJointPosition[8].Z);

      {X Preview}
      XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
      YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
      XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
      YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

      {Y Preview}
      XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
      YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
      XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
      YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

      {Z Preview}
      XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
      YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
      XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
      YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));
   End;

   If(Counter = HumNeck) Then
   Begin
   {Draw left hand}
      XStart := (CurrJointPosition[HumNeck].X - CurrJointPosition[8].X);
      YStart := (CurrJointPosition[HumNeck].Y - CurrJointPosition[8].Y);
      ZStart := (CurrJointPosition[HumNeck].Z - CurrJointPosition[8].Z);
      XEnd   := (CurrJointPosition[HumHead].X   - CurrJointPosition[8].X);
      YEnd   := (CurrJointPosition[HumHead].Y   - CurrJointPosition[8].Y);
      ZEnd   := (CurrJointPosition[HumHead].Z   - CurrJointPosition[8].Z);

      {X Preview}
      XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
      YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
      XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
      YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

      {Y Preview}
      XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
      YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
      XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
      YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

      {Z Preview}
      XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
      YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
      XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
      YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));
   End;

   If(Counter = HumLWrist) Then
   Begin
   {Draw left hand}
      XStart := (CurrJointPosition[HumLWrist].X - CurrJointPosition[8].X);
      YStart := (CurrJointPosition[HumLWrist].Y - CurrJointPosition[8].Y);
      ZStart := (CurrJointPosition[HumLWrist].Z - CurrJointPosition[8].Z);
      XEnd   := (CurrJointPosition[HumLFinger].X - CurrJointPosition[8].X);
      YEnd   := (CurrJointPosition[HumLFinger].Y - CurrJointPosition[8].Y);
      ZEnd   := (CurrJointPosition[HumLFinger].Z - CurrJointPosition[8].Z);

      {X Preview}
      XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
      YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
      XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
      YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

      {Y Preview}
      XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
      YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
      XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
      YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

      {Z Preview}
      XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
      YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
      XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
      YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));
   End;

   If(Counter = HumRWrist) Then
   Begin
   {Draw right hand}
      XStart := (CurrJointPosition[HumRWrist].X - CurrJointPosition[8].X);
      YStart := (CurrJointPosition[HumRWrist].Y - CurrJointPosition[8].Y);
      ZStart := (CurrJointPosition[HumRWrist].Z - CurrJointPosition[8].Z);
      XEnd   := (CurrJointPosition[HumRFinger].X   - CurrJointPosition[8].X);
      YEnd   := (CurrJointPosition[HumRFinger].Y   - CurrJointPosition[8].Y);
      ZEnd   := (CurrJointPosition[HumRFinger].Z   - CurrJointPosition[8].Z);

      {X Preview}
      XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
      YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
      XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
      YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

      {Y Preview}
      XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
      YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
      XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
      YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

      {Z Preview}
      XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
      YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
      XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
      YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));
   End;

   If(Counter = HumLElbow) Then
   Begin
   {Draw left lower arm}
      XStart := (CurrJointPosition[HumLElbow].X - CurrJointPosition[8].X);
      YStart := (CurrJointPosition[HumLElbow].Y - CurrJointPosition[8].Y);
      ZStart := (CurrJointPosition[HumLElbow].Z - CurrJointPosition[8].Z);
      XEnd   := (CurrJointPosition[HumLWrist].X   - CurrJointPosition[8].X);
      YEnd   := (CurrJointPosition[HumLWrist].Y   - CurrJointPosition[8].Y);
      ZEnd   := (CurrJointPosition[HumLWrist].Z   - CurrJointPosition[8].Z);

      {X Preview}
      XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
      YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
      XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
      YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

      {Y Preview}
      XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
      YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
      XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
      YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

      {Z Preview}
      XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
      YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
      XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
      YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));
   End;

   If(Counter = HumRElbow) Then
   Begin
   {Draw right lower arm}
      XStart := (CurrJointPosition[HumRElbow].X - CurrJointPosition[8].X);
      YStart := (CurrJointPosition[HumRElbow].Y - CurrJointPosition[8].Y);
      ZStart := (CurrJointPosition[HumRElbow].Z - CurrJointPosition[8].Z);
      XEnd   := (CurrJointPosition[HumRWrist].X   - CurrJointPosition[8].X);
      YEnd   := (CurrJointPosition[HumRWrist].Y   - CurrJointPosition[8].Y);
      ZEnd   := (CurrJointPosition[HumRWrist].Z   - CurrJointPosition[8].Z);

      {X Preview}
      XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
      YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
      XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
      YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

      {Y Preview}
      XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
      YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
      XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
      YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

      {Z Preview}
      XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
      YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
      XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
      YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));
   End;

   If(Counter = HumLShoulder) Then
   Begin
   {Draw left upper arm}
      XStart := (CurrJointPosition[HumLShoulder].X - CurrJointPosition[8].X);
      YStart := (CurrJointPosition[HumLShoulder].Y - CurrJointPosition[8].Y);
      ZStart := (CurrJointPosition[HumLShoulder].Z - CurrJointPosition[8].Z);
      XEnd   := (CurrJointPosition[HumLElbow].X   - CurrJointPosition[8].X);
      YEnd   := (CurrJointPosition[HumLElbow].Y   - CurrJointPosition[8].Y);
      ZEnd   := (CurrJointPosition[HumLElbow].Z   - CurrJointPosition[8].Z);

      {X Preview}
      XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
      YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
      XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
      YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

      {Y Preview}
      XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
      YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
      XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
      YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

      {Z Preview}
      XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
      YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
      XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
      YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));
   End;

   If(Counter = HumRShoulder) Then
   Begin
   {Draw right upper arm}
      XStart := (CurrJointPosition[HumRShoulder].X - CurrJointPosition[8].X);
      YStart := (CurrJointPosition[HumRShoulder].Y - CurrJointPosition[8].Y);
      ZStart := (CurrJointPosition[HumRShoulder].Z - CurrJointPosition[8].Z);
      XEnd   := (CurrJointPosition[HumRElbow].X   - CurrJointPosition[8].X);
      YEnd   := (CurrJointPosition[HumRElbow].Y   - CurrJointPosition[8].Y);
      ZEnd   := (CurrJointPosition[HumRElbow].Z   - CurrJointPosition[8].Z);

      {X Preview}
      XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
      YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
      XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
      YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

      {Y Preview}
      XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
      YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
      XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
      YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

      {Z Preview}
      XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
      YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
      XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
      YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));

   End;
End; {Procedure DrawStickHumanoid}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure DrawStickMan(FrameN, JointN :Integer);

Var
   TempCounter :Integer;

Begin
   {Ensure we have a motion loaded before attempting to display it, or we get an exception.}
{   If ((NFrames>0) and (MIFileOpened) and (MCFileOpened)) then}
   If ((NFrames>0) and (DataLoaded)) then
   Begin


   {Calculate new joint positions from rotations for current frame}


{Think about replacing these nasty (and very similar) subroutines - one for each rotation
 joint - by a single, universal subroutine that filters out joints affected by rotation of
 _current_ joint by using an array of boolean flags...}

{Humanoids and Burricks share a common skeleton}
      If ((CurrCreatureType = Humanoid) or
          (CurrCreatureType = Burrick) {or
          (CurrCreatureType = HumanWithSword)}) then
      begin
         AssignJointRotations;
         HumLAnkleRotate(FrameN);       HumRAnkleRotate(FrameN);
         HumLKneeRotate(FrameN);        HumRKneeRotate(FrameN);
         HumLHipRotate(FrameN);         HumRHipRotate(FrameN);
         HumNeckRotate(FrameN);
         HumLShoulderRotate(FrameN);    HumRShoulderRotate(FrameN);
         HumLElbowRotate(FrameN);       HumRElbowRotate(FrameN);
         HumLWristRotate(FrameN);       HumRWristRotate(FrameN);
         HumRootRotate(FrameN);
         HumTorsoRotate(FrameN);
      End; {If humanoid or burrick}

      For TempCounter := 1 to NJoints do
      begin

{Initialise plotting coordinates to known values, so we can check if they've been changed
 later}
         XPlot1[1] := 999; XPlot1[2] := 999; XPlot1[3] := 999;
         XPlot2[1] := 999; XPlot2[2] := 999; XPlot2[3] := 999;
         YPlot1[1] := 999; YPlot1[2] := 999; YPlot1[3] := 999;
         YPlot2[1] := 999; YPlot2[2] := 999; YPlot2[3] := 999;

         If (TempCounter = JointN) then
         Begin
{Highlight currently selected joint}
            Form1.XPreview.Canvas.Pen.Color := RGB(128, 128, 128);
            Form1.YPreview.Canvas.Pen.Color := RGB(128, 128, 128);
            Form1.ZPreview.Canvas.Pen.Color := RGB(128, 128, 128);
         End
         Else
         Begin
            Form1.XPreview.Canvas.Pen.Color := RGB(255, 255, 255);
            Form1.YPreview.Canvas.Pen.Color := RGB(255, 255, 255);
            Form1.ZPreview.Canvas.Pen.Color := RGB(255, 255, 255);
         End;

         {Draw bones / stick man/burrick here}
         If ((CurrCreatureType = Humanoid) or (CurrCreatureType = Burrick)) then
              DrawStickHumanoid(TempCounter);


{If coordinates have been defined (changed from 999) then draw bones}
{Of course, trouble will arise if any coordinate actually IS 999!}
         If ((XPlot1[1]<>999) and (XPlot1[2]<>999) and (XPlot1[3]<>999) and
             (XPlot2[1]<>999) and (XPlot2[2]<>999) and (XPlot2[3]<>999) and
             (YPlot1[1]<>999) and (YPlot1[2]<>999) and (YPlot1[3]<>999) and
             (YPlot2[1]<>999) and (YPlot2[2]<>999) and (YPlot2[3]<>999)) then
         Begin
            Form1.XPreview.Canvas.MoveTo(XPlot1[1], YPlot1[1]);
            Form1.XPreview.Canvas.LineTo(XPlot2[1], YPlot2[1]);
            Form1.YPreview.Canvas.MoveTo(XPlot1[2], YPlot1[2]);
            Form1.YPreview.Canvas.LineTo(XPlot2[2], YPlot2[2]);
            Form1.ZPreview.Canvas.MoveTo(XPlot1[3], YPlot1[3]);
            Form1.ZPreview.Canvas.LineTo(XPlot2[3], YPlot2[3]);
         End;
      End; {End of draw joints loop}
{Add finishing touches to stick man here:}
      XStart := (CurrJointPosition[HumRShoulder].X - CurrJointPosition[8].X);
      YStart := (CurrJointPosition[HumRShoulder].Y - CurrJointPosition[8].Y);
      ZStart := (CurrJointPosition[HumRShoulder].Z - CurrJointPosition[8].Z);
      XEnd   := (CurrJointPosition[HumLShoulder].X   - CurrJointPosition[8].X);
      YEnd   := (CurrJointPosition[HumLShoulder].Y   - CurrJointPosition[8].Y);
      ZEnd   := (CurrJointPosition[HumLShoulder].Z   - CurrJointPosition[8].Z);

      {X Preview}
      XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
      YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
      XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
      YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

      {Y Preview}
      XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
      YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
      XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
      YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

      {Z Preview}
      XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
      YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
      XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
      YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));

      Form1.XPreview.Canvas.MoveTo(XPlot1[1], YPlot1[1]);
      Form1.XPreview.Canvas.LineTo(XPlot2[1], YPlot2[1]);
      Form1.YPreview.Canvas.MoveTo(XPlot1[2], YPlot1[2]);
      Form1.YPreview.Canvas.LineTo(XPlot2[2], YPlot2[2]);
      Form1.ZPreview.Canvas.MoveTo(XPlot1[3], YPlot1[3]);
      Form1.ZPreview.Canvas.LineTo(XPlot2[3], YPlot2[3]);
{------------------------------------------------------------------------------}
      XStart := (CurrJointPosition[HumRShoulder].X - CurrJointPosition[8].X);
      YStart := (CurrJointPosition[HumRShoulder].Y - CurrJointPosition[8].Y);
      ZStart := (CurrJointPosition[HumRShoulder].Z - CurrJointPosition[8].Z);
      XEnd   := (CurrJointPosition[HumRHip].X   - CurrJointPosition[8].X);
      YEnd   := (CurrJointPosition[HumRHip].Y   - CurrJointPosition[8].Y);
      ZEnd   := (CurrJointPosition[HumRHip].Z   - CurrJointPosition[8].Z);

      {X Preview}
      XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
      YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
      XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
      YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

      {Y Preview}
      XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
      YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
      XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
      YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

      {Z Preview}
      XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
      YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
      XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
      YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));

      Form1.XPreview.Canvas.MoveTo(XPlot1[1], YPlot1[1]);
      Form1.XPreview.Canvas.LineTo(XPlot2[1], YPlot2[1]);
      Form1.YPreview.Canvas.MoveTo(XPlot1[2], YPlot1[2]);
      Form1.YPreview.Canvas.LineTo(XPlot2[2], YPlot2[2]);
      Form1.ZPreview.Canvas.MoveTo(XPlot1[3], YPlot1[3]);
      Form1.ZPreview.Canvas.LineTo(XPlot2[3], YPlot2[3]);
{------------------------------------------------------------------------------}
      XStart := (CurrJointPosition[HumLShoulder].X - CurrJointPosition[8].X);
      YStart := (CurrJointPosition[HumLShoulder].Y - CurrJointPosition[8].Y);
      ZStart := (CurrJointPosition[HumLShoulder].Z - CurrJointPosition[8].Z);
      XEnd   := (CurrJointPosition[HumLHip].X   - CurrJointPosition[8].X);
      YEnd   := (CurrJointPosition[HumLHip].Y   - CurrJointPosition[8].Y);
      ZEnd   := (CurrJointPosition[HumLHip].Z   - CurrJointPosition[8].Z);

      {X Preview}
      XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
      YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
      XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
      YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

      {Y Preview}
      XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
      YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
      XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
      YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

      {Z Preview}
      XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
      YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
      XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
      YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));

      Form1.XPreview.Canvas.MoveTo(XPlot1[1], YPlot1[1]);
      Form1.XPreview.Canvas.LineTo(XPlot2[1], YPlot2[1]);
      Form1.YPreview.Canvas.MoveTo(XPlot1[2], YPlot1[2]);
      Form1.YPreview.Canvas.LineTo(XPlot2[2], YPlot2[2]);
      Form1.ZPreview.Canvas.MoveTo(XPlot1[3], YPlot1[3]);
      Form1.ZPreview.Canvas.LineTo(XPlot2[3], YPlot2[3]);
{------------------------------------------------------------------------------}
      XStart := (CurrJointPosition[HumRHip].X - CurrJointPosition[8].X);
      YStart := (CurrJointPosition[HumRHip].Y - CurrJointPosition[8].Y);
      ZStart := (CurrJointPosition[HumRHip].Z - CurrJointPosition[8].Z);
      XEnd   := (CurrJointPosition[HumLHip].X - CurrJointPosition[8].X);
      YEnd   := (CurrJointPosition[HumLHip].Y - CurrJointPosition[8].Y);
      ZEnd   := (CurrJointPosition[HumLHip].Z - CurrJointPosition[8].Z);

      {X Preview}
      XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
      YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
      XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
      YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

      {Y Preview}
      XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
      YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
      XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
      YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

      {Z Preview}
      XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
      YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
      XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
      YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));

      Form1.XPreview.Canvas.MoveTo(XPlot1[1], YPlot1[1]);
      Form1.XPreview.Canvas.LineTo(XPlot2[1], YPlot2[1]);
      Form1.YPreview.Canvas.MoveTo(XPlot1[2], YPlot1[2]);
      Form1.YPreview.Canvas.LineTo(XPlot2[2], YPlot2[2]);
      Form1.ZPreview.Canvas.MoveTo(XPlot1[3], YPlot1[3]);
      Form1.ZPreview.Canvas.LineTo(XPlot2[3], YPlot2[3]);
   End;
End {Procedure DrawStickMan};

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure DrawStickArm(FrameN, JointN :Integer);

Var
   TempCounter :Integer;

Begin
   {Ensure we have a motion loaded before attempting to display it, or we get an exception.}
{   If ((NFrames>0) and (MIFileOpened) and (MCFileOpened)) then}
   If ((NFrames>0) and (DataLoaded)) then
   Begin


   {Calculate new joint positions from rotations for current frame}


{Think about replacing these nasty (and very similar) subroutines - one for each rotation
 joint - by a single, universal subroutine that filters out joints affected by rotation of
 _current_ joint by using an array of boolean flags...}

{Humanoids and Burricks share a common skeleton}
      If (CurrCreatureType = PlayerArm) then
      begin
         AssignJointRotations;
{         ArmButtRotate(FrameN);}
         ArmRShoulderRotate(FrameN);
         ArmRElbowRotate(FrameN);
         ArmRWristRotate(FrameN);
      End; {If arm}

      For TempCounter := 1 to NJoints do
      begin

{Initialise plotting coordinates to known values, so we can check if they've been changed
 later}
         XPlot1[1] := 999; XPlot1[2] := 999; XPlot1[3] := 999;
         XPlot2[1] := 999; XPlot2[2] := 999; XPlot2[3] := 999;
         YPlot1[1] := 999; YPlot1[2] := 999; YPlot1[3] := 999;
         YPlot2[1] := 999; YPlot2[2] := 999; YPlot2[3] := 999;

         If (TempCounter = JointN) then
         Begin
{Highlight currently selected joint}
            Form1.XPreview.Canvas.Pen.Color := RGB(128, 128, 128);
            Form1.YPreview.Canvas.Pen.Color := RGB(128, 128, 128);
            Form1.ZPreview.Canvas.Pen.Color := RGB(128, 128, 128);
         End
         Else
         Begin
            Form1.XPreview.Canvas.Pen.Color := RGB(255, 255, 255);
            Form1.YPreview.Canvas.Pen.Color := RGB(255, 255, 255);
            Form1.ZPreview.Canvas.Pen.Color := RGB(255, 255, 255);
         End;

         {Draw bones / stick arm here}
         If (CurrCreatureType = PlayerArm) then
         Begin
{xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx}
            If(TempCounter = ArmRWrist) Then
            Begin
               {Draw right hand}
               XStart := (CurrJointPosition[ArmRWrist].X - CurrJointPosition[ArmButt].X);
               YStart := (CurrJointPosition[ArmRWrist].Y - CurrJointPosition[ArmButt].Y);
               ZStart := (CurrJointPosition[ArmRWrist].Z - CurrJointPosition[ArmButt].Z);
               XEnd   := (CurrJointPosition[ArmRFinger].X - CurrJointPosition[ArmButt].X);
               YEnd   := (CurrJointPosition[ArmRFinger].Y - CurrJointPosition[ArmButt].Y);
               ZEnd   := (CurrJointPosition[ArmRFinger].Z - CurrJointPosition[ArmButt].Z);

               {X Preview}
               XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
               YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
               XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
               YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

               {Y Preview}
               XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
               YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
               XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
               YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

               {Z Preview}
               XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
               YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
               XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
               YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));
            End;

            If(TempCounter = ArmRElbow) Then
            Begin
               {Draw right lower arm}
               XStart := (CurrJointPosition[ArmRElbow].X - CurrJointPosition[ArmButt].X);
               YStart := (CurrJointPosition[ArmRElbow].Y - CurrJointPosition[ArmButt].Y);
               ZStart := (CurrJointPosition[ArmRElbow].Z - CurrJointPosition[ArmButt].Z);
               XEnd   := (CurrJointPosition[ArmRWrist].X   - CurrJointPosition[ArmButt].X);
               YEnd   := (CurrJointPosition[ArmRWrist].Y   - CurrJointPosition[ArmButt].Y);
               ZEnd   := (CurrJointPosition[ArmRWrist].Z   - CurrJointPosition[ArmButt].Z);

               {X Preview}
               XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
               YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
               XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
               YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

               {Y Preview}
               XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
               YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
               XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
               YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

               {Z Preview}
               XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
               YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
               XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
               YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));
            End;

            If(TempCounter = ArmRShoulder) Then
            Begin
               {Draw right upper arm}
               XStart := (CurrJointPosition[ArmRShoulder].X - CurrJointPosition[ArmButt].X);
               YStart := (CurrJointPosition[ArmRShoulder].Y - CurrJointPosition[ArmButt].Y);
               ZStart := (CurrJointPosition[ArmRShoulder].Z - CurrJointPosition[ArmButt].Z);
               XEnd   := (CurrJointPosition[ArmRElbow].X   - CurrJointPosition[ArmButt].X);
               YEnd   := (CurrJointPosition[ArmRElbow].Y   - CurrJointPosition[ArmButt].Y);
               ZEnd   := (CurrJointPosition[ArmRElbow].Z   - CurrJointPosition[ArmButt].Z);

               {X Preview}
               XPlot1[1] := (Form1.XPreview.Width  div 2) + Round((256 * YStart) / (XStart - PreviewScale));
               YPlot1[1] := (Form1.XPreview.Height div 2) + Round((256 * ZStart) / (XStart - PreviewScale));
               XPlot2[1] := (Form1.XPreview.Width  div 2) + Round((256 * YEnd)   / (XEnd   - PreviewScale));
               YPlot2[1] := (Form1.XPreview.Height div 2) + Round((256 * ZEnd)   / (XEnd   - PreviewScale));

               {Y Preview}
               XPlot1[2] := (Form1.YPreview.Width  div 2) + Round((256 * XStart) / (YStart - PreviewScale));
               YPlot1[2] := (Form1.YPreview.Height div 2) + Round((256 * ZStart) / (YStart - PreviewScale));
               XPlot2[2] := (Form1.YPreview.Width  div 2) + Round((256 * XEnd)   / (YEnd   - PreviewScale));
               YPlot2[2] := (Form1.YPreview.Height div 2) + Round((256 * ZEnd)   / (YEnd   - PreviewScale));

               {Z Preview}
               XPlot1[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XStart) / (ZStart - PreviewScale));
               YPlot1[3] := (Form1.ZPreview.Height div 2) + Round((256 * YStart) / (ZStart - PreviewScale));
               XPlot2[3] := (Form1.ZPreview.Width  div 2) + Round((256 * XEnd)   / (ZEnd   - PreviewScale));
               YPlot2[3] := (Form1.ZPreview.Height div 2) + Round((256 * YEnd)   / (ZEnd   - PreviewScale));
            End;
         End;
{If coordinates have been defined (changed from 999) then draw bones}
{Of course, trouble will arise if any coordinate actually IS 999!}
         If ((XPlot1[1]<>999) and (XPlot1[2]<>999) and (XPlot1[3]<>999) and
             (XPlot2[1]<>999) and (XPlot2[2]<>999) and (XPlot2[3]<>999) and
             (YPlot1[1]<>999) and (YPlot1[2]<>999) and (YPlot1[3]<>999) and
             (YPlot2[1]<>999) and (YPlot2[2]<>999) and (YPlot2[3]<>999)) then
         Begin
            Form1.XPreview.Canvas.MoveTo(XPlot1[1], YPlot1[1]);
            Form1.XPreview.Canvas.LineTo(XPlot2[1], YPlot2[1]);
            Form1.YPreview.Canvas.MoveTo(XPlot1[2], YPlot1[2]);
            Form1.YPreview.Canvas.LineTo(XPlot2[2], YPlot2[2]);
            Form1.ZPreview.Canvas.MoveTo(XPlot1[3], YPlot1[3]);
            Form1.ZPreview.Canvas.LineTo(XPlot2[3], YPlot2[3]);
         End;
      End; {End of draw joints loop}
   End;
End {Procedure DrawStickArm};

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure RedrawPreviews(FrameNo, JointNo :Integer);

begin
   ClearPreviewWindows;
   If (DataLoaded) then
   Begin
      DrawGrids(FrameNo);
      If ((CurrCreatureType = Humanoid) or
          (CurrCreatureType = Burrick))  then DrawStickMan(FrameNo, JointNo);
      If  (CurrCreatureType = PlayerArm) then DrawStickArm(FrameNo, JointNo);
   End;
end {Procedure RedrawPreviews};

Procedure ReformatJointSelector(Passed_CreatureClass :Integer);

Begin
{Humanoid}
   If ((Passed_CreatureClass = CC_Humanoid) or
       (Passed_CreatureClass = CC_Human_With_Sword) or
       (Passed_CreatureClass = CC_Crayman) or
       (Passed_CreatureClass = CC_Bugbeast)) then
   Begin
      Form1.JointSelector.Clear;
      Form1.JointSelector.Items.Capacity := 16;
      Form1.JointSelector.Items.Add('01 - Model Position');
      Form1.JointSelector.Items.Add('02 - Left Ankle');
      Form1.JointSelector.Items.Add('03 - Right Ankle');
      Form1.JointSelector.Items.Add('04 - Left Knee');
      Form1.JointSelector.Items.Add('05 - Right Knee');
      Form1.JointSelector.Items.Add('06 - Left Hip');
      Form1.JointSelector.Items.Add('07 - Right Hip');
      Form1.JointSelector.Items.Add('08 - Model Rotation');
      Form1.JointSelector.Items.Add('09 - Neck');
      Form1.JointSelector.Items.Add('10 - Left Shoulder');
      Form1.JointSelector.Items.Add('11 - Right Shoulder');
      Form1.JointSelector.Items.Add('12 - Left Elbow');
      Form1.JointSelector.Items.Add('13 - Right Elbow');
      Form1.JointSelector.Items.Add('14 - Left Wrist');
      Form1.JointSelector.Items.Add('15 - Right Wrist');
      Form1.JointSelector.Items.Add('16 - Torso');
   End
   Else
   If (Passed_CreatureClass = CC_Player_Arm) then
   Begin
      Form1.JointSelector.Clear;
      Form1.JointSelector.Items.Capacity := 4;
      Form1.JointSelector.Items.Add('01 - Model Position');
      Form1.JointSelector.Items.Add('02 - Shoulder');
      Form1.JointSelector.Items.Add('03 - Elbow');
      Form1.JointSelector.Items.Add('04 - Wrist');
   End;
   Form1.JointSelector.Text := '<Select Joint>';
End;


end.
