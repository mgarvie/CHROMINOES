function [r_label, r_color] = variomino_tiling_print(r_shape, p_num, ...
  p_shapes, d, x, label)
% VARIOMINO_TILING_PRINT prints a chromino tiling.
%
% Discussion:
%   A polyomino is a shape formed by connecting unit squares edgewise.
%
%   A chromino is a polyomino in which each square has been assigned
%   a value between 1 and v.
%
%   A chromino can be represented by an MxN matrix, whose entries are
%   between 1 and v for squares that are part of the chromino, 
%   and 0 otherwise.
%
%   The internal parameter COLOR_CHOICE specifies how the colors identifying
%   each chromino are determined.
%
%   The internal parameter SHOW_ZERO specifies whether zero cells should
%   be shown or blanked out.
%
% Licensing:
%   This code is covered by the GNU General Public License (GPL).
%   See the LICENSE file for details.
%   (SPDX-License-Identifier: GPL-3.0-or-later)
%
% Modified:
%   27 March 2025
%
% Author:
%   John Burkardt, Marcus Garvie (edited)
%
% Inputs:
%   r_shape  - Integer matrix (r_m x r_n), representing the region to be tiled.
%   p_num    - Integer, the number of chromino shapes.
%   p_shapes - Integer array (r_m x r_n x p_num), representing chrominoes.
%              Chrominoes are "top-left tight" with trailing zeros.
%   d        - Integer array (p_num), the copies of each chromino to use.
%   x        - Integer array (x_m x 1), binary solution vector indicating the
%              selected chromino configurations.
%   label    - String, label for the printout (e.g., 'Solution #3').
%
% Outputs:
%   r_label  - Integer matrix (r_m x r_n), numeric indices of chrominoes.
%   r_color  - Integer matrix (r_m x r_n), color indices of chrominoes.

  % COLOR_CHOICE:
  %   1: Single color for all chrominoes.
  %   2: Unique colors for each visible chromino.
  %   3: Unique colors for every chromino, visible or not.
  %   4: Unique colors for each chromino parent and variants.
  color_choice = 1;

  % SHOW_ZERO:
  %   0: Do not show zero regions.
  %   1: Show zero regions.
  show_zero = 1;

  [A, ~, ~] = variomino_matrix(r_shape, p_num, p_shapes, d);
  [~, a_n] = size(A);
  [r_m, r_n] = size(r_shape);

  r_num = variomino_area(r_shape);
  r_index = variomino_index(r_shape);
  x_index = 1;

  xc = zeros(a_n, 1);
  xi = zeros(a_n, 1);
  nz = 0;

  for i = 1:a_n
    if (x(i, x_index) ~= 0)
      nz = nz + 1;
      xc(i) = nz;
      xi(i) = nz;
    end
  end

  axc = A(1:r_num, :) * xc;
  axi = A(1:r_num, :) * xi;

  r_color = zeros(r_m, r_n);
  r_label = zeros(r_m, r_n);

  for i = 1:r_m
    for j = 1:r_n
      if (r_index(i,j) ~= 0)
        r_color(i,j) = axc(r_index(i,j));
        r_label(i,j) = axi(r_index(i,j));
      end
    end
  end

  % Print numeric labels.
  fprintf('\n%s\n  Numeric Labels\n\n', label);
  smax = max(r_label(:));
  for i = 1:r_m
    fprintf(' ');
    for j = 1:r_n
      if (r_label(i,j) == 0 && show_zero == 0)
        fprintf(repmat(' ',1,(smax>=10)+2));
      else
        fprintf([' %',num2str((smax>=10)+1),'d'], r_label(i,j));
      end
    end
    fprintf('\n');
  end

  % Print color indices.
  fprintf('\n%s\n  "Colors"\n\n', label);
  for i = 1:r_m
    fprintf(' ');
    for j = 1:r_n
      if (r_label(i,j) == 0 && show_zero == 0)
        fprintf(repmat(' ',1,(smax>=10)+2));
      else
        fprintf([' %',num2str((smax>=10)+1),'d'], r_color(i,j));
      end
    end
    fprintf('\n');
  end

end