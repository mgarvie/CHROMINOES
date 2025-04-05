function [a, b] = splitting_monohedral_matrix(r_shape, p_shape, C)
% SPLITTING_MONOHEDRAL_MATRIX Constructs linear system Ax = b 
% for chromino splitting.
%
% Constructs the linear system for a chromino splitting problem associated 
% with a monohedral polyomino tiling problem. The polyomino constraint is 
% implicitly included and not separately imposed.
%
% Inputs:
%   r_shape  - Binary matrix representing the region shape.
%   p_shape - Binary matrix representing the polyomino shape.
%   C            - Integer, number of colours.
%
% Outputs:
%   a       - Integer matrix (C x n), the coefficient matrix.
%   b       - Integer vector (C x 1), the right-hand side vector.
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

  m = C;
  b = zeros(m, 1);

  [rowsR, colsR] = size(r_shape);

  if any(r_shape(:) == 0)
      for j = 1 : colsR
          for i = 1 : rowsR
              if r_shape(i,j) == 1
                  r_shape_pari(i,j) = mod(i + j, C) + 1;
              end
          end
      end
  else
      for page = 1 : C
          variantsR(:, :, page) = zeros(rowsR, colsR);
      end
      for j = 1 : colsR
          for i = 1 : rowsR
              if r_shape(i,j) == 1
                  for page = 1 : C
                      variantsR(i,j,page) = mod(i + j + page - 1, C) + 1;
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

  poly = p_shape;
  variants = FindAllChrom(poly, C);
  [~, ~, n] = size(variants);

  a = zeros(m, n);

  for colour = 1 : C
      for page = 1 : n
          poly = variants(:, :, page);
          a(colour, page) = length(find(poly == colour));
      end
  end

end