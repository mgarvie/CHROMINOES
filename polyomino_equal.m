function value = polyomino_equal(m1, n1, p1, m2, n2, p2)
% POLYOMINO_EQUAL Checks if two polyominoes are equal.
%
% Two polyominoes P1 and P2 are represented as binary matrices containing
% entries of 0 or 1. The matrices should be "tight," meaning each matrix
% has at least one '1' in its first and last rows, and in its first and last
% columns.
%
% This function determines if P1 and P2 represent exactly the same shape.
%
% Inputs:
%   m1, n1 - Number of rows and columns in polyomino P1.
%   p1        - Binary matrix (m1 x n1) representing polyomino P1.
%   m2, n2 - Number of rows and columns in polyomino P2.
%   p2        - Binary matrix (m2 x n2) representing polyomino P2.
%
% Output:
%   value  - Logical true if polyominoes P1 and P2 are identical, false otherwise.
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

  if (m1 ~= m2)
    value = false;
  elseif (n1 ~= n2)
    value = false;
  else
    s1 = sum(sum(p1(1:m1,1:n1)));
    s2 = sum(sum(p2(1:m2,1:n2)));
    if (s1 ~= s2)
      value = false;
    else
      s = sum(sum(p1(1:m1,1:n1) .* p2(1:m2,1:n2)));
      if (s ~= s1)
        value = false;
      else
        value = true;
      end
    end
  end

end