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

unit MotTypes;

interface

{type
  PositionPointer = ^PositionRecord;
  PositionRecord = record
    X: Single;
    Y: Single;
    Z: Single;
  end;}

type
  EulerPointer = ^EulerRecord;
  EulerRecord = record
    X: Single;
    Y: Single;
    Z: Single;
  end;

type
  MITagPointer = ^MITagRecord;
  MITagRecord = record
    Standing: Boolean;
    LeftFootfall: Boolean;
    RightFootfall: Boolean;
    LeftFootUp: Boolean;
    RightFootUp: Boolean;
    FireRelease: Boolean;
    CanInterrupt: Boolean;
    StartMotionHere: Boolean;
    EndMotionHere: Boolean;
    BlankTag1: Boolean;
    BlankTag2: Boolean;
    BlankTag3: Boolean;
    Trigger1: Boolean;
    Trigger2: Boolean;
    Trigger3: Boolean;
    Trigger4: Boolean;
    Trigger5: Boolean;
    Trigger6: Boolean;
    Trigger7: Boolean;
    Trigger8: Boolean;
  end;

implementation

end.
