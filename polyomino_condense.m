function [mq, nq, q] = polyomino_condense(mp, np, p)
% POLYOMINO_CONDENSE Condenses a polyomino.
%
% A polyomino is represented by a binary matrix, where entries of 1 indicate
% cells that belong to the polyomino and entries of 0 indicate empty space.
% This function replaces all nonzero entries by 1 and then condenses the polyomino
% matrix by removing initial and final rows and columns that are entirely zero.
%
% Inputs:
%   mp - Integer, number of rows in the polyomino matrix.
%   np  - Integer, number of columns in the polyomino matrix.
%   p    - Binary matrix (mp x np) representing the polyomino.
%
% Outputs:
%   mq - Integer, number of rows in the condensed polyomino.
%   nq  - Integer, number of columns in the condensed polyomino.
%   q    - Binary matrix (mq x nq) representing the condensed polyomino.
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

  if (mp <= 0 || np <= 0)
    mq = 0;
    nq = 0;
    q = [];
    return;
  end

  mq = mp;
  nq = np;
  q = p;

  q(q ~= 0) = 1;

  while (sum(q(1, :)) == 0)
    q = q(2:mq, :);
    mq = mq - 1;
    if (mq <= 0)
      mq = 0;
      nq = 0;
      q = [];
      return;
    end
  end

  while (sum(q(mq, :)) == 0)
    q = q(1:mq-1, :);
    mq = mq - 1;
    if (mq <= 0)
      mq = 0;
      nq = 0;
      q = [];
      return;
    end
  end

  while (sum(q(:, 1)) == 0)
    q = q(:, 2:nq);
    nq = nq - 1;
    if (nq <= 0)
      mq = 0;
      nq = 0;
      q = [];
      return;
    end
  end

  while (sum(q(:, nq)) == 0)
    q = q(:, 1:nq-1);
    nq = nq - 1;
    if (nq <= 0)
      mq = 0;
      nq = 0;
      q = [];
      return;
    end
  end

end