function pin = variomino_index(p)
% VARIOMINO_INDEX Assigns indices to each nonzero entry of a chromino.
%
% Given a chromino represented by a matrix whose entries are integers 
% between 1 and v (occupied squares) or 0 (empty), this function assigns 
% sequential indices to each nonzero entry in column-major order.
%
% Example:
%   P =
%     3  0  2  2
%     3  1  2  0
%     0  1  1  0
%
%   PIN =
%     1 0 5 8
%     2 3 6 0
%     0 4 7 0
%
% Inputs:
%   p  - Integer matrix (m x n), representing the chromino.
%
% Outputs:
%   pin - Integer matrix (m x n), indices assigned to nonzero entries.
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

  q = (p ~= 0);
  qvec = reshape(q, m * n, 1);
  qcum = cumsum(qvec) .* qvec;
  pin = reshape(qcum, m, n);

end