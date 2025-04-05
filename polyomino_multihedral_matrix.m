function [a, b, var_p] = polyomino_multihedral_matrix(r, p_num, p, d)
% POLYOMINO_MULTIHEDRAL_MATRIX Linear system for multihedral polyomino tiling.
%
% Given a region R and multiple polyominoes (represented as binary matrices),
% this function computes the linear system A*x = b for tiling R using each of
% the given polyominoes exactly the specified number of times. Reflections,
% rotations, and translations of each polyomino are permitted.
%
% Inputs:
%   r           - Binary matrix (mr x nr) describing the region.
%   p_num - Number of distinct polyominoes.
%   p          - Binary matrix array (mr x nr x p_num), each slice represents a 
%                 polyomino, stored "top-left tight" (first row and first column 
%                 contain at least one 1).
%   d          - Integer vector (p_num x 1), specifying how many copies of each 
%                 polyomino must be used in the tiling.
%
% Outputs:
%   a        - Integer matrix (eqn_num x var_num), the system matrix.
%   b        - Integer vector (eqn_num x 1), the right-hand side vector.
%   var_p - Integer vector (var_num x 1), indicating which polyomino each 
%               variable corresponds to.
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

  [mr, nr] = size(r);

  [v_num, v, v_p] = polyomino_multihedral_variants(mr, nr, p_num, p, d);

  eqn_num = polyomino_area(r) + p_num;

  var_num = 0;
  var_p = zeros(var_num, 1);

  for k = 1 : v_num

    q = v(1:mr, 1:nr, k);

    [ms, ns, s] = polyomino_condense(mr, nr, q);

    number = polyomino_embed_number(mr, nr, r, ms, ns, s);

    for l = 1 : number
      var_num = var_num + 1;
      var_p(var_num, 1) = v_p(k);
    end

  end

  a = zeros(eqn_num, var_num);
  b = ones(eqn_num, 1);

  var = 0;

  for k = 1 : v_num

    q = v(1:mr, 1:nr, k);

    [ms, ns, s] = polyomino_condense(mr, nr, q);

    number = polyomino_embed_number(mr, nr, r, ms, ns, s);

    list = polyomino_embed_list(mr, nr, r, ms, ns, s, number);

    for l = 1 : number
      var = var + 1;
      ioff = list(l, 1);
      joff = list(l, 2);
      s2 = zeros(mr, nr);
      s2(1+ioff:ms+ioff, 1+joff:ns+joff) = s(1:ms, 1:ns);
      e_dot_s2 = e .* s2;
      eqn = e_dot_s2(e_dot_s2 ~= 0);
      a(eqn, var) = 1;
    end

  end

  eqn = polyomino_area(r);

  var = 0;
  for k = 1 : p_num
    pk_vars = sum(var_p == k);
    eqn = eqn + 1;
    a(eqn, var+1:var+pk_vars) = 1;
    b(eqn) = d(k);
    var = var + pk_vars;
  end

end