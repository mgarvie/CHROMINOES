function [mq, nq, q] = polyomino_transform(m, n, p, rotate, reflect)
% POLYOMINO_TRANSFORM Applies rotation and reflection to a polyomino.
%
% Given a polyomino represented as a binary matrix, this function returns 
% the polyomino after applying specified reflection and rotation transformations.
%
% Inputs:
%   m, n    - Integers specifying the number of rows and columns in polyomino P.
%   p         - Binary matrix (m x n), representing the polyomino. The matrix must 
%                be "tight," having at least one '1' in rows 1 and m, and columns 1 and n.
%   rotate  - Integer (0, 1, 2, or 3), number of 90-degree counterclockwise rotations.
%   reflect - Integer (0 or 1). If 1, the polyomino is reflected horizontally 
%                before any rotations are performed.
%
% Outputs:
%   mq, nq  - Integers specifying the number of rows and columns of the transformed 
%                  polyomino.
%   q           - Binary matrix (mq x nq), the transformed polyomino.
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

  mq = m;
  nq = n;

  reflect = mod(reflect, 2);

  if (reflect == 1)
    q = fliplr(p);
  else
    q = p;
  end

  rotate = mod(rotate, 4);

  for k = 1 : rotate
    r = mq;
    s = nq;
    mq = s;
    nq = r;
    q = flipud(q');
  end

end