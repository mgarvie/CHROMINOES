function area = variomino_area(p)
% VARIOMINO_AREA Returns the area of a chromino.
%
% A chromino is a polyomino where each unit square is assigned a value 
% between 1 and v. It is represented by a matrix with entries from 1 to v 
% indicating occupied squares and 0 otherwise.
%
% Inputs:
%   p  - Integer matrix (mp x np) representing the variomino.
%
% Outputs:
%   area - Integer, the area of the variomino (number of occupied squares).
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

  area = sum(sum(p ~= 0));

end