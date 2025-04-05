function [a, b, var_p] = variomino_matrix(r, p_num, p, d)
% VARIOMINO_MATRIX Constructs the linear system for the generalized coloured 
% tiling problem.
%
% Given a region R and a set of chrominoes (each square has values between
% 1 and v), this function computes the linear system A*x = b to find solutions
% to the tiling problem. Each chromino can be reflected, rotated, and translated.
%
% When multiple chrominoes are provided (p_num > 1), constraints are added to
% specify how many copies of each chromino must be used. For a single chromino
% (p_num = 1), this constraint is omitted.
%
% Inputs:
%   r           - Integer matrix (mr x nr), representing the region.
%   p_num - Integer, number of distinct chrominoes.
%   p          - Integer matrix array (mr x nr x p_num), chrominoes stored "top-left tight".
%   d          - Integer vector (p_num x 1), number of copies of each chromino to use.
%
% Outputs:
%   a        - Integer matrix (eqn_num x var_num), the system matrix.
%   b        - Integer vector (eqn_num x 1), the right-hand side.
%   var_p - Integer vector (var_num x 1), mapping variables to their parent chromino.
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

  e = variomino_index(r);

  [mr, nr] = size(r);

  [v_num, v, v_p] = variomino_variants(mr, nr, p_num, p, d);

  if (1 < p_num)
      eqn_num = variomino_area(r) + p_num;
  else
      eqn_num = variomino_area(r);
  end

  var_num = 0;
  var_p = zeros(var_num, 1);

  for k = 1 : v_num
      q = v(:, :, k);
      s = variomino_condense(q);
      number = variomino_embed_number(r, s);
      for l = 1 : number
          var_num = var_num + 1;
          var_p(var_num, 1) = v_p(k);
      end
  end

  a = zeros(eqn_num, var_num);
  b = ones(eqn_num, 1);

  var = 0;

  for k = 1 : v_num
      q = v(:, :, k);
      s = variomino_condense(q);
      [ms, ns] = size(s);
      number = variomino_embed_number(r, s);
      list = variomino_embed_list(r, s, number);
      for l = 1 : number
          var = var + 1;
          ioff = list(l, 1);
          joff = list(l, 2);
          s2 = zeros(mr, nr);
          s2(1+ioff:ms+ioff, 1+joff:ns+joff) = s;
          e_dot_s2 = e .* (s2 ~= 0);
          eqn = e_dot_s2(e_dot_s2 ~= 0);
          a(eqn, var) = 1;
      end
  end

  if (1 < p_num)
      eqn = variomino_area(r);
      var = 0;
      for k = 1 : p_num
          pk_vars = sum(var_p == k);
          eqn = eqn + 1;
          a(eqn, var+1:var+pk_vars) = 1;
          b(eqn) = d(k);
          var = var + pk_vars;
      end
  end

end