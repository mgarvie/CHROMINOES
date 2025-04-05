function area = polyomino_area(p)
% POLYOMINO_AREA Returns the area of a polyomino.
%
% A polyomino is a shape formed by connecting unit squares edgewise. It is 
% represented as a binary matrix, where entries of 1 indicate cells that belong 
% to the polyomino and entries of 0 indicate empty space.
%
% Inputs:
%   p - Binary matrix representing the polyomino.
%
% Output:
%   area - Scalar integer representing the number of 1s in p (the area).
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

  area = sum(sum(p));

end