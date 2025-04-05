function pin = polyomino_index(p)
% POLYOMINO_INDEX Assigns an index to each nonzero entry of a polyomino.
%
% The indexing scheme arbitrarily proceeds by rows.
%
% Example:
%   P =
%     1 0 1 1
%     1 1 1 0
%     0 1 1 0
%
%   PIN =
%     1 0 2 3
%     4 5 6 0
%     0 7 8 0
%
% Inputs:
%   p  - Binary matrix (m x n) representing a polyomino.
%
% Output:
%   pin - Integer matrix (m x n), assigning an index to each nonzero entry.
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

  [m, n] = size(p);

  pv = reshape(p', m * n, 1);

  pc = cumsum(pv) .* pv;

  pin = reshape(pc, n, m);

  pin = pin';

end