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

unit motmaths;

{Unit containing the pure mathematical procedures and functions used by the Motion Editor.
 Inverse Sin & Cos, Vector Rotation (used by preview windows), angle calculations and
 Quaternion<->Euler converters}

interface

Function ASin(x :Single): Single;
Function ACos(x :Single): Single;
Procedure RotateVector(XcIn, YcIn, ZcIn, XRot, YRot, ZRot :Single; Var XcOut, YcOut, ZcOut :Single);
Function GetAngle(Sine, Cosine :Single) :Single;
Procedure Quaternion2Euler(Q1, Q2, Q3, Q4 :Single; var AngX, AngY, AngZ :Single);
Procedure Euler2Quaternion(AngX, AngY, AngZ :Single; var Q1, Q2, Q3, Q4 :Single);

implementation

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Function ASin(x :Single): Single;
{Have to define inverse sine, because it isn't in standard Delphi(!)}
Begin
   If (Abs(x - 1)<0.0001) then ASin:=(Pi / 2);     { 90 degrees}
   If (Abs(x + 1)<0.0001) then ASin:=(-Pi / 2);    {-90 degrees}
   If (Abs(x)    <0.0001) then ASin:=(0.0);        {  0 degrees}

   If not((Abs(x - 1)<0.0001) or
          (Abs(x + 1)<0.0001) or
          (Abs(x)    <0.0001)) then ASin := ArcTan (x/sqrt (1-sqr (x)))
End {Function ASin};

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Function ACos(x :Single): Single;
{Have to define inverse cosine, because it isn't in standard Delphi(!)}
Begin
   If (Abs(x - 1)<0.0001) then ACos:=(0.0);        {  0 degrees}
   If (Abs(x + 1)<0.0001) then ACos:=(Pi);         {180 degrees}
   If (Abs(x)    <0.0001) then ACos:=(Pi / 2);     { 90 degrees}

   If not((Abs(x - 1)<0.0001) or
          (Abs(x + 1)<0.0001) or
          (Abs(x)    <0.0001)) then ACos := ArcTan (sqrt (1-sqr (x)) /x)
End {Function ACos};

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure RotateVector(XcIn, YcIn, ZcIn, XRot, YRot, ZRot :Single; Var XcOut, YcOut, ZcOut :Single);
{Rotates an orientation using matrix / vector multiplication}
Var
   A, B, C, D, E, F :Single; {Rotation matrix elements}

Begin
{    |  CE      -CF       D  |   (XcIn)   (XcOut)
     |  BDE+AF  -BDF+AE  -BC | * (YcIn) = (YcOut)
     | -ADE+BF   ADF+BE   AC |   (ZcIn)   (ZcOut)

     A = Cos(X)
     B = Sin(X)
     C = Cos(Y)
     D = Sin(Y)
     E = Cos(Z)
     F = Sin(Z)}

      A := Cos(2 * Pi * XRot / 360); B := Sin(2 * Pi * XRot / 360);
      C := Cos(2 * Pi * YRot / 360); D := Sin(2 * Pi * YRot / 360);
      E := Cos(2 * Pi * ZRot / 360); F := Sin(2 * Pi * ZRot / 360);

      XcOut := (C * E * XcIn) - (C * F * YcIn) + (D * ZcIn);
      YcOut := (( B * D * E + A * F) * XcIn) + ((-B * D * F + A * E) * YcIn) + (-B * C * ZcIn);
      ZcOut := ((-A * D * E + B * F) * XcIn) + (( A * D * F + B * E) * YcIn) + ( A * C * ZcIn);
End {Procedure RotateVector};

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Function GetAngle(Sine, Cosine :Single) :Single;

var
   AngleDone :Boolean;
   SpareAngle :Single;

begin
   AngleDone := False;

   {Sine = 0, Cosine = 1}
   If ((Abs(Sine) < 0.0001) and (Abs(Cosine - 1) < 0.0001)) then
   begin
      GetAngle  := 0.0;
      AngleDone := True;
   end;

   {Sine = 1, Cosine = 0}
   If ((Abs(Sine - 1) < 0.0001) and (Abs(Cosine) < 0.0001)) then
   begin
      GetAngle  := Pi / 2;
      AngleDone := True;
   end;

   {Sine = 0, Cosine = -1}
   If ((Abs(Sine) < 0.0001) and (Abs(Cosine + 1) < 0.0001)) then
   begin
      GetAngle  := Pi;
      AngleDone := True;
   end;

   {Sine = -1, Cosine = 0}
   If ((Abs(Sine + 1) < 0.0001) and (Abs(Cosine) < 0.0001)) then
   begin
      GetAngle  := 3 * Pi / 2;
      AngleDone := True;
   end;

   if not(AngleDone) then
   begin
      SpareAngle := ArcTan(Sine / Cosine); {May need to check multiplicities on this...}



      If (SpareAngle<0) then SpareAngle:=SpareAngle + 2 * Pi;

      If (((Sine / Cosine) > 0) and
           (Sine < 0) and (Cosine < 0) and
           (SpareAngle < Pi)) then SpareAngle := SpareAngle + Pi;

      If (((Sine / Cosine) < 0) and
           (Sine < 0) and (Cosine > 0) and
           (SpareAngle < Pi)) then SpareAngle := SpareAngle + Pi;

      If (((Sine / Cosine) < 0) and
           (Sine > 0) and (Cosine < 0) and
           (SpareAngle > Pi)) then SpareAngle := SpareAngle - Pi;

      If (((Sine / Cosine) > 0) and
           (Sine > 0) and (Cosine > 0) and
           (SpareAngle > Pi)) then SpareAngle := SpareAngle - Pi;

      GetAngle := SpareAngle;
   end;
end {Function GetAngle};

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure Quaternion2Euler(Q1, Q2, Q3, Q4 :Single; var AngX, AngY, AngZ :Single);

Var
   Mat :Array[1..9] of Single; {3 x 3 rotation matrix - Element 1 is top left,
                                                        Element 3 is top right,
                                                        Element 7 is bottom left,
                                                        Element 9 is bottom right}
   XX, XY, XZ, XW, YY, YZ, YW, ZZ, ZW :Single;
   A, B, C, D, E, F                   :Single; {Cos(x), Sin(x), Cos(y), Sin(y), Cos(z), Sin(z)}
   AC, BC, EC, FC                     :Single; {Mat[9], Mat[6], Mat[1], Mat[2]}

Begin
{Generate rotation matrix}
   XX := Q1 * Q1;
   XY := Q1 * Q2;
   XZ := Q1 * Q3;
   XW := Q1 * Q4;

   YY := Q2 * Q2;
   YZ := Q2 * Q3;
   YW := Q2 * Q4;

   ZZ := Q3 * Q3;
   ZW := Q3 * Q4;

   Mat[1] := 1 - 2 * (YY + ZZ);
   Mat[2] :=     2 * (XY - ZW);
   Mat[3] :=     2 * (XZ + YW);
   Mat[4] :=     2 * (XY + ZW);
   Mat[5] := 1 - 2 * (XX + ZZ);
   Mat[6] :=     2 * (YZ - XW);
   Mat[7] :=     2 * (XZ - YW);
   Mat[8] :=     2 * (YZ + XW);
   Mat[9] := 1 - 2 * (XX + YY);

{Extract angles from rotation matrix - inverse sin?}
   D := Mat[3];      {Sin(y)}
   C := Cos(ASin(D)); {Cos(y)}

   AC :=  Mat[9];     {Cos(x) x Cos(y)}
   BC := -Mat[6];     {Sin(x) x Cos(y)}
   EC :=  Mat[1];     {Cos(z) x Cos(y)}
   FC := -Mat[2];     {Sin(z) x Cos(y)}

   AngY := ASin(D);

   If (Abs(C)>0.0001) then {If not in Gimbal Lock}
   begin
      A := AC / C;
      B := BC / C;
      E := EC / C;
      F := FC / C;

      AngX := GetAngle(B, A); {May need to check these.}
      AngZ := GetAngle(F, E); {May need to check these.}
   end
   else
   begin
      AngX := 0;
      AngZ := GetAngle(Mat[4], Mat[5]); {Check this.}
   end;

   AngX := (360.0 * AngX / (2 * Pi)); {Convert to degrees...}
   AngY := (360.0 * AngY / (2 * Pi)); {Convert to degrees...}
   AngZ := (360.0 * AngZ / (2 * Pi)); {Convert to degrees...}

{Ensure X, Y and Z angles are within 0-360 range}
   If (AngX < 0.0) then AngX := AngX + 360.0;
   If (AngY < 0.0) then AngY := AngY + 360.0;
   If (AngZ < 0.0) then AngZ := AngZ + 360.0;

End {Procedure Quaternion2Euler};

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure Euler2Quaternion(AngX, AngY, AngZ :Single; var Q1, Q2, Q3, Q4 :Single);

Var
   Mat :Array[1..9] of Single; {3 x 3 rotation matrix - Element 1 is top left,
                                                        Element 3 is top right,
                                                        Element 7 is bottom left,
                                                        Element 9 is bottom right}
   T, S, X, Y, Z, W                   :Single; {Intermediate variables}
   A, B, C, D, E, F                   :Single; {Cos(x), Sin(x), Cos(y), Sin(y), Cos(z), Sin(z)}
   AD, BD                             :Single;

Begin
{Generate rotation matrix}
   A := Cos(2 * Pi * AngX / 360); {Get values to insert into rotation matrix}
   B := Sin(2 * Pi * AngX / 360.0); {Converting to radians first...}
   C := Cos(2 * Pi * AngY / 360);
   D := Sin(2 * Pi * AngY / 360);
   E := Cos(2 * Pi * AngZ / 360);
   F := Sin(2 * Pi * AngZ / 360);

   AD := A * D;
   BD := B * D;

   Mat[1] :=  (C * E);
   Mat[2] := -(C * F);
   Mat[3] :=  D;
   Mat[4] :=  (BD * E) + (A * F);
   Mat[5] := -(BD * F) + (A * E);
   Mat[6] := -(B * C);
   Mat[7] := -(AD * E) + (B * F);
   Mat[8] :=  (AD * F) + (B * E);
   Mat[9] :=  (A * C);

   {Calculate trace - based upon 4 x 4 rotation matrix, so need to add "imaginary" elements}
   T := 1 + Mat[1] + Mat[5] + Mat[9];

   If (T > 0.00000001) then
   begin
      S := Sqrt(T) * 2;
      X := ( mat[8] - mat[6] ) / S;
      Y := ( mat[3] - mat[7] ) / S;
      Z := ( mat[4] - mat[2] ) / S;
      W := 0.25 * S;
   end
   else
   begin
      if ((Mat[1] > Mat[5]) and (Mat[1] > Mat[9])) then  {Column 1 has greatest major diagonal element}
      begin
         S := Sqrt( 1.0 + Mat[1] - Mat[5] - Mat[9] ) * 2;
         X := 0.25 * S;
         Y := (Mat[4] + Mat[2] ) / S;
         Z := (Mat[3] + Mat[7] ) / S;
         W := (Mat[8] - Mat[6] ) / S;
      end
      else if (Mat[5] > Mat[9] ) then {Column 2 has the greatest major diagonal element}
      begin
         S := Sqrt( 1.0 + Mat[5] - Mat[1] - Mat[9] ) * 2;
         X := (Mat[4] + Mat[2] ) / S;
         Y := 0.25 * S;
         Z := (Mat[8] + Mat[6] ) / S;
         W := (Mat[3] - Mat[7] ) / S;
      end
      else {Column 3 has the greatest major diagonal element}
      begin
         S := Sqrt( 1.0 + Mat[9] - Mat[1] - Mat[5] ) * 2;
         X := (Mat[3] + Mat[7] ) / S;
         Y := (Mat[8] + Mat[6] ) / S;
         Z := 0.25 * S;
         W := (Mat[4] - Mat[2] ) / S;
      end;
   end;
   {Return quaternions}
   Q1 := X;
   Q2 := Y;
   Q3 := Z;
   Q4 := W;

End {Euler2Quaternion};

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

end.
