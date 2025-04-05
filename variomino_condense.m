function q = variomino_condense(p)
% VARIOMINO_CONDENSE Condenses a chromino by removing empty rows and columns.
%
% Given a chromino represented by a matrix with entries between 1 and v for 
% occupied squares and 0 for empty space, this function removes any initial 
% or final rows and columns consisting entirely of zeros.
%
% Inputs:
%   p - Integer matrix (mp x np) representing the chromino.
%
% Outputs:
%   q - Integer matrix (mq x nq), the condensed chromino.
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

  [mq, nq] = size(p);

  if (mq <= 0 || nq <= 0)
      q = [];
      return
  end

  q = p;

  while (all(q(1, :) == 0))
      q = q(2:end, :);
      mq = mq - 1;
      if (mq <= 0)
          q = [];
          return
      end
  end

  while (all(q(end, :) == 0))
      q = q(1:end-1, :);
      mq = mq - 1;
      if (mq <= 0)
          q = [];
          return
      end
  end

  while (all(q(:, 1) == 0))
      q = q(:, 2:end);
      nq = nq - 1;
      if (nq <= 0)
          q = [];
          return
      end
  end

  while (all(q(:, end) == 0))
      q = q(:, 1:end-1);
      nq = nq - 1;
      if (nq <= 0)
          q = [];
          return
      end
  end

end