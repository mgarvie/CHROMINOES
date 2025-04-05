function q = variomino_transform(p, rotate, reflect)
% VARIOMINO_TRANSFORM Applies rotation and reflection to a chromino.
%
% Given a chromino represented by a matrix whose entries are integers between 
% 1 and v (occupied squares) or 0 (empty), this function returns the chromino 
% after applying specified reflection and rotation transformations.
%
% Inputs:
%   p          - Integer matrix (mp x np), representing the chromino.
%   rotate   - Integer (0, 1, 2, or 3), number of 90-degree counterclockwise rotations.
%   reflect  - Integer (0 or 1). If 1, reflect horizontally before rotation.
%
% Outputs:
%   q - Integer matrix (mq x nq), representing the transformed chromino.
%
% Licensing:
%   This code is covered by the GNU General Public License (GPL).
%   See the LICENSE file for details.
%   (SPDX-License-Identifier: GPL-3.0-or-later)
%
% Modified:
%   26 March 2025
%
% Author:
%   John Burkardt

  reflect = mod(reflect, 2);

  if (reflect == 1)
      q = fliplr(p);
  else
      q = p;
  end

  rotate = mod(rotate, 4);

  for k = 1 : rotate
      q = flipud(q');
  end

end