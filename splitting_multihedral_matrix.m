function [a, b, num_chrom] = splitting_multihedral_matrix(r_shape, p_num, p_shapes, d, C)
% SPLITTING_MULTIHEDRAL_MATRIX Constructs linear system Ax = b for chromino splitting.
%
% Constructs the linear system associated with a multihedral polyomino splitting
% problem, imposing constraints for each of the p_num polyominoes.
%
% Inputs:
%   r_shape    - Binary matrix representing the region shape.
%   p_num      - Number of distinct polyominoes.
%   p_shapes - Binary matrix array (:,:,p_num), polyomino shapes.
%   d               - Integer vector (p_num x 1), specifying usage constraints.
%   C              - Integer, number of colours.
%
% Outputs:
%   a                  - Integer matrix (C + p_num x n), the coefficient matrix.
%   b                  - Integer vector (C + p_num x 1), the right-hand side vector.
%   num_chrom - Integer vector (1 x p_num), number of chromono variants for each polyomino.
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

  m = C + p_num; 
  b = zeros(m, 1);

  [rowsR, colsR] = size(r_shape);

  if any(r_shape(:) == 0)
      for j = 1 : colsR
          for i = 1 : rowsR
              if r_shape(i, j) == 1
                  r_shape_pari(i, j) = mod(i + j, C) + 1;
              end
          end
      end
  else
      for page = 1 : C
          variantsR(:, :, page) = zeros(rowsR, colsR);
      end
      for j = 1 : colsR
          for i = 1 : rowsR
              if r_shape(i, j) == 1
                  for page = 1 : C
                      variantsR(i, j, page) = mod(i + j + page - 1, C) + 1;
                  end
              end
          end
      end
      for page = 1 : C
          ind = variantsR(1, 1, page);
          if ind == 1
              keep = page;
              break
          end
      end
      r_shape_pari = variantsR(:, :, keep);
  end

  for colour = 1 : C
      b(colour) = length(find(r_shape_pari == colour));
  end

  count = 0;
  for i = C + 1 : m
      count = count + 1;
      b(i) = d(count);
  end

  count = 0;
  num_chrom = zeros(1, p_num);
  for page = 1 : p_num
      poly = p_shapes(:, :, page);
      poly(~any(poly, 2), :) = [];
      poly(:, ~any(poly, 1)) = [];
      [rows, cols] = size(poly);
      chroms = FindAllChrom(poly, C);
      [~, ~, npoly] = size(chroms);
      num_chrom(page) = npoly;
      for i = 1 : npoly
          count = count + 1;
          variants(:, :, count) = zeros(rowsR, colsR);
          variants(1:rows, 1:cols, count) = chroms(:, :, i);
      end
  end

  n = count;

  a = zeros(m, n);

  for colour = 1 : C
      for page = 1 : n
          poly = variants(:, :, page);
          a(colour, page) = length(find(poly == colour));
      end
  end

  count1 = 0;
  count2 = 0;
  for i = C + 1 : m
      count2 = count2 + 1;
      num = num_chrom(count2);
      for j = 1 : num
          count1 = count1 + 1;
          a(i, count1) = 1;
      end
  end

end
 