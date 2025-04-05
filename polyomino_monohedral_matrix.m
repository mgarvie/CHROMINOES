function [a, b] = polyomino_monohedral_matrix(r, p)
% POLYOMINO_MONOHEDRAL_MATRIX Sets up the linear system for polyomino monotiling.
%
% Given a region R and a polyomino P (represented as binary matrices), this 
% function computes the linear system A*x = b for monotiling R with P, allowing 
% rotations and reflections of P.
%
% Inputs:
%   r  - Binary matrix (mr x nr) describing the region.
%   p - Binary matrix (mp x np) describing the polyomino.
%
% Outputs:
%   a - Integer matrix (eqn_num x var_num), the system matrix.
%   b - Integer vector (eqn_num x 1), the right-hand side vector.
%
%   Usage example:
%   [a, b] = polyomino_monohedral_matrix(ones(2,4), [1 0 0; 1 1 1])
%   (Unlike in the multihedral case, p is assumed to be "tight.")
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

  e = polyomino_index(r);

  [mp, np] = size(p);
  [mr, nr] = size(r);

  [mn_num, mn_v, nm_num, nm_v] = polyomino_variants(mp, np, p);

  eqn_num = sum(sum(r)) + 1;

  var_num = 0;

  for k = 1 : mn_num
    mq = mp;
    nq = np;
    q = mn_v(1:mq, 1:nq, k);

    number = polyomino_embed_number(mr, nr, r, mq, nq, q);

    for l = 1 : number
      var_num = var_num + 1;
    end
  end

  for k = 1 : nm_num
    mq = np;
    nq = mp;
    q = nm_v(1:mq, 1:nq, k);

    number = polyomino_embed_number(mr, nr, r, mq, nq, q);

    for l = 1 : number
      var_num = var_num + 1;
    end
  end

  a = zeros(eqn_num, var_num);
  b = ones(eqn_num, 1);

  var = 0;

  for k = 1 : mn_num
    mq = mp;
    nq = np;
    q = mn_v(1:mq, 1:nq, k);

    number = polyomino_embed_number(mr, nr, r, mq, nq, q);
    list = polyomino_embed_list(mr, nr, r, mq, nq, q, number);

    for l = 1 : number
      var = var + 1;
      ioff = list(l, 1);
      joff = list(l, 2);
      q2 = zeros(mr, nr);
      q2(1+ioff:mq+ioff, 1+joff:nq+joff) = q(1:mq, 1:nq);
      e_dot_q2 = e .* q2;
      eqn = e_dot_q2(e_dot_q2 ~= 0);
      a(eqn, var) = 1;
    end
  end

  for k = 1 : nm_num
    mq = np;
    nq = mp;
    q = nm_v(1:mq, 1:nq, k);

    number = polyomino_embed_number(mr, nr, r, mq, nq, q);
    list = polyomino_embed_list(mr, nr, r, mq, nq, q, number);

    for l = 1 : number
      var = var + 1;
      ioff = list(l, 1);
      joff = list(l, 2);
      q2 = zeros(mr, nr);
      q2(1+ioff:mq+ioff, 1+joff:nq+joff) = q(1:mq, 1:nq);
      e_dot_q2 = e .* q2;
      eqn = e_dot_q2(e_dot_q2 ~= 0);
      a(eqn, var) = 1;
    end
  end

  eqn = eqn_num;
  a(eqn, 1:var_num) = 1;
  b(eqn) = sum(sum(r)) / sum(sum(p));

end