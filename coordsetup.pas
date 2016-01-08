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

unit CoordSetup;

{Unit to initialise coordinates of various joints & termini}

interface

Uses Unit1, MotTypes;

   Procedure InitHumanoidJointPositions;
   Procedure InitBurrickJointPositions;
   Procedure InitSpiderJointPositions;
   Procedure InitPlayerArmJointPositions;

Var
   JointPosition :Array[1..4, 0..21] of EulerRecord; {Dimension 1 = creature type;
                                                   Dimension 2 = joint/terminus number}
implementation

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure InitHumanoidJointPositions;
{Initialise humanoid joint positions - taken from Karras.e}

Begin

   JointPosition[Humanoid, HumLToe].X       :=   XCOORD; {LToe}
   JointPosition[Humanoid, HumLToe].Y       :=   YCOORD;
   JointPosition[Humanoid, HumLToe].Z       :=   ZCOORD;

   JointPosition[Humanoid, HumRToe].X       :=   XCOORD; {RToe}
   JointPosition[Humanoid, HumRToe].Y       :=   YCOORD;
   JointPosition[Humanoid, HumRToe].Z       :=   ZCOORD;

   JointPosition[Humanoid, HumLAnkle].X      :=  XCOORD; {LAnkle}
   JointPosition[Humanoid, HumLAnkle].Y      :=  YCOORD;
   JointPosition[Humanoid, HumLAnkle].Z      :=  ZCOORD;

   JointPosition[Humanoid, HumRAnkle].X      :=  XCOORD; {RAnkle}
   JointPosition[Humanoid, HumRAnkle].Y      :=  YCOORD;
   JointPosition[Humanoid, HumRAnkle].Z      :=  ZCOORD;

   JointPosition[Humanoid, HumLKnee].X       :=  XCOORD; {LKnee}
   JointPosition[Humanoid, HumLKnee].Y       :=  YCOORD;
   JointPosition[Humanoid, HumLKnee].Z       :=  ZCOORD;

   JointPosition[Humanoid, HumRKnee].X       :=  XCOORD; {RKnee}
   JointPosition[Humanoid, HumRKnee].Y       :=  YCOORD;
   JointPosition[Humanoid, HumRKnee].Z       :=  ZCOORD;

   JointPosition[Humanoid, HumLHip].X        :=  XCOORD; {LHip}
   JointPosition[Humanoid, HumLHip].Y        :=  YCOORD;
   JointPosition[Humanoid, HumLHip].Z        :=  ZCOORD;

   JointPosition[Humanoid, HumRHip].X        :=  XCOORD; {RHip}
   JointPosition[Humanoid, HumRHip].Y        :=  YCOORD;
   JointPosition[Humanoid, HumRHip].Z        :=  ZCOORD;

   JointPosition[Humanoid, HumButt].X           :=  XCOORD; {Model Rotation (model centre?)}
   JointPosition[Humanoid, HumButt].Y           :=  YCOORD; {Based on joint 'ABDOMEN'}
   JointPosition[Humanoid, HumButt].Z           :=  ZCOORD;

   JointPosition[Humanoid, HumNeck].X        :=  XCOORD; {Neck}
   JointPosition[Humanoid, HumNeck].Y        :=  YCOORD;
   JointPosition[Humanoid, HumNeck].Z        :=  ZCOORD;

   JointPosition[Humanoid, HumLShoulder].X   :=  XCOORD; {LShoulder}
   JointPosition[Humanoid, HumLShoulder].Y   :=  YCOORD;
   JointPosition[Humanoid, HumLShoulder].Z   :=  ZCOORD;

   JointPosition[Humanoid, HumRShoulder].X   :=  XCOORD; {RShoulder}
   JointPosition[Humanoid, HumRShoulder].Y   :=  YCOORD;
   JointPosition[Humanoid, HumRShoulder].Z   :=  ZCOORD;

   JointPosition[Humanoid, HumLElbow].X      :=  XCOORD; {LElbow}
   JointPosition[Humanoid, HumLElbow].Y      :=  YCOORD;
   JointPosition[Humanoid, HumLElbow].Z      :=  ZCOORD;

   JointPosition[Humanoid, HumRElbow].X      :=  XCOORD; {RElbow}
   JointPosition[Humanoid, HumRElbow].Y      :=  YCOORD;
   JointPosition[Humanoid, HumRElbow].Z      :=  ZCOORD;

   JointPosition[Humanoid, HumLWrist].X      :=  XCOORD; {LWrist}
   JointPosition[Humanoid, HumLWrist].Y      :=  YCOORD;
   JointPosition[Humanoid, HumLWrist].Z      :=  ZCOORD;

   JointPosition[Humanoid, HumRWrist].X      :=  XCOORD; {RWrist}
   JointPosition[Humanoid, HumRWrist].Y      :=  YCOORD;
   JointPosition[Humanoid, HumRWrist].Z      :=  ZCOORD;

   JointPosition[Humanoid, HumLFinger].X    :=   XCOORD; {LFinger}
   JointPosition[Humanoid, HumLFinger].Y    :=   YCOORD;
   JointPosition[Humanoid, HumLFinger].Z    :=   ZCOORD;

   JointPosition[Humanoid, HumRFinger].X    :=   XCOORD; {RFinger}
   JointPosition[Humanoid, HumRFinger].Y    :=   YCOORD;
   JointPosition[Humanoid, HumRFinger].Z    :=   ZCOORD;

   JointPosition[Humanoid, HumAbdomen].X     :=  XCOORD; {Torso (JButt)}
   JointPosition[Humanoid, HumAbdomen].Y     :=  YCOORD;
   JointPosition[Humanoid, HumAbdomen].Z     :=  ZCOORD;

   JointPosition[Humanoid, HumHead].X       :=   XCOORD; {Head}
   JointPosition[Humanoid, HumHead].Y       :=   YCOORD;
   JointPosition[Humanoid, HumHead].Z       :=   ZCOORD;

End; {Procedure InitHumanoidJointPositions}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure InitBurrickJointPositions;
{Initialise humanoid joint positions - taken from burrick.e, which was converted
 from burrick.bin using Shadowspawn's BINTOE program.}

Begin
   JointPosition[Burrick, 1].X := 0.000000;
   JointPosition[Burrick, 1].Y := 0.000000;
   JointPosition[Burrick, 1].Z := 0.000000;

   JointPosition[Burrick, HumLAnkle].X      :=  XCOORD; {LAnkle}
   JointPosition[Burrick, HumLAnkle].Y      :=  YCOORD;
   JointPosition[Burrick, HumLAnkle].Z      :=  ZCOORD;

   JointPosition[Burrick, HumRAnkle].X      :=  XCOORD; {RAnkle}
   JointPosition[Burrick, HumRAnkle].Y      :=  YCOORD;
   JointPosition[Burrick, HumRAnkle].Z      :=  ZCOORD;

   JointPosition[Burrick, HumLKnee].X       :=  XCOORD; {LKnee}
   JointPosition[Burrick, HumLKnee].Y       :=  YCOORD;
   JointPosition[Burrick, HumLKnee].Z       :=  ZCOORD;

   JointPosition[Burrick, HumRKnee].X       :=  XCOORD; {RKnee}
   JointPosition[Burrick, HumRKnee].Y       :=  YCOORD;
   JointPosition[Burrick, HumRKnee].Z       :=  ZCOORD;

   JointPosition[Burrick, HumLHip].X        :=  XCOORD; {LHip}
   JointPosition[Burrick, HumLHip].Y        :=  YCOORD;
   JointPosition[Burrick, HumLHip].Z        :=  ZCOORD;

   JointPosition[Burrick, HumRHip].X        :=  XCOORD; {RHip}
   JointPosition[Burrick, HumRHip].Y        :=  YCOORD;
   JointPosition[Burrick, HumRHip].Z        :=  ZCOORD;

   JointPosition[Burrick, 8].X           :=  XCOORD; {Model Rotation (model centre?)}
   JointPosition[Burrick, 8].Y           :=  YCOORD; {Based on joint 'ABDOMEN'}
   JointPosition[Burrick, 8].Z           :=  ZCOORD;

   JointPosition[Burrick, HumNeck].X        :=  XCOORD; {Neck}
   JointPosition[Burrick, HumNeck].Y        :=  YCOORD;
   JointPosition[Burrick, HumNeck].Z        :=  ZCOORD;

   JointPosition[Burrick, HumLShoulder].X   :=  XCOORD; {LShoulder}
   JointPosition[Burrick, HumLShoulder].Y   :=  YCOORD;
   JointPosition[Burrick, HumLShoulder].Z   :=  ZCOORD;

   JointPosition[Burrick, HumRShoulder].X   :=  XCOORD; {RShoulder}
   JointPosition[Burrick, HumRShoulder].Y   :=  YCOORD;
   JointPosition[Burrick, HumRShoulder].Z   :=  ZCOORD;

   JointPosition[Burrick, HumLElbow].X      :=  XCOORD; {LElbow}
   JointPosition[Burrick, HumLElbow].Y      :=  YCOORD;
   JointPosition[Burrick, HumLElbow].Z      :=  ZCOORD;

   JointPosition[Burrick, HumRElbow].X      :=  XCOORD; {RElbow}
   JointPosition[Burrick, HumRElbow].Y      :=  YCOORD;
   JointPosition[Burrick, HumRElbow].Z      :=  ZCOORD;

   JointPosition[Burrick, HumLWrist].X      :=  XCOORD; {LWrist}
   JointPosition[Burrick, HumLWrist].Y      :=  YCOORD;
   JointPosition[Burrick, HumLWrist].Z      :=  ZCOORD;

   JointPosition[Burrick, HumRWrist].X      :=  XCOORD; {RWrist}
   JointPosition[Burrick, HumRWrist].Y      :=  YCOORD;
   JointPosition[Burrick, HumRWrist].Z      :=  ZCOORD;

   JointPosition[Burrick, HumAbdomen].X     :=  XCOORD; {Torso (JButt)}
   JointPosition[Burrick, HumAbdomen].Y     :=  YCOORD;
   JointPosition[Burrick, HumAbdomen].Z     :=  ZCOORD;

{Probably also need locations of joint boxes for feet, hands and head...}

   JointPosition[Burrick, HumLToe].X       :=  XCOORD; {LToe}
   JointPosition[Burrick, HumLToe].Y       :=  YCOORD;
   JointPosition[Burrick, HumLToe].Z       :=  ZCOORD;

   JointPosition[Burrick, HumRToe].X       :=  XCOORD; {RToe}
   JointPosition[Burrick, HumRToe].Y       :=  YCOORD;
   JointPosition[Burrick, HumRToe].Z       :=  ZCOORD;

   JointPosition[Burrick, HumLFinger].X    :=  XCOORD; {LFinger}
   JointPosition[Burrick, HumLFinger].Y    :=  YCOORD;
   JointPosition[Burrick, HumLFinger].Z    :=  ZCOORD;

   JointPosition[Burrick, HumRFinger].X    :=  XCOORD; {RFinger}
   JointPosition[Burrick, HumRFinger].Y    :=  YCOORD;
   JointPosition[Burrick, HumRFinger].Z    :=  ZCOORD;

   JointPosition[Burrick, HumHead].X       :=  XCOORD; {Head}
   JointPosition[Burrick, HumHead].Y       :=  YCOORD;
   JointPosition[Burrick, HumHead].Z       :=  ZCOORD;
End {InitBurrickJointPositions};

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure InitSpiderJointPositions;

Begin
{Not yet implemented}
End {Procedure InitSpiderJointPositions};

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}

Procedure InitPlayerArmJointPositions;
{Initialise humanoid joint positions - taken from Armsw2.e}

Begin
   JointPosition[PlayerArm, ArmButt].X :=  XCOORD; {Butt}
   JointPosition[PlayerArm, ArmButt].Y :=  YCOORD;
   JointPosition[PlayerArm, ArmButt].Z :=  ZCOORD;

   JointPosition[PlayerArm, ArmRShoulder].X :=  XCOORD; {RShoulder}
   JointPosition[PlayerArm, ArmRShoulder].Y :=  YCOORD;
   JointPosition[PlayerArm, ArmRShoulder].Z :=  ZCOORD;

   JointPosition[PlayerArm, ArmRElbow].X      :=  XCOORD; {RElbow}
   JointPosition[PlayerArm, ArmRElbow].Y      :=  YCOORD;
   JointPosition[PlayerArm, ArmRElbow].Z      :=  ZCOORD;

   JointPosition[PlayerArm, ArmRFinger].X       :=  XCOORD; {RFinger}
   JointPosition[PlayerArm, ArmRFinger].Y       :=  YCOORD;
   JointPosition[PlayerArm, ArmRFinger].Z       :=  ZCOORD;
End; {Procedure InitPlayerArmJointPositions}

{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}
{--------------------------------------------------------------------------------------------}


end.
