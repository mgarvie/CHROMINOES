function displayVectorComponents(x)
% DISPLAYVECTORCOMPONENTS Prints the nonzero components of a vector.
%
% Given a vector x, this function displays each nonzero entry in the form:
%   x<i> = <value>
% where <i> is the index and <value> is the corresponding value in x.
%
% Inputs:
%   x - Numeric vector whose nonzero entries will be printed.
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
%   Marcus Garvie

  n = length(x);
  for i = 1:n
    if x(i) ~= 0
      fprintf('x%d = %d\n', i, x(i));
    end
  end

end