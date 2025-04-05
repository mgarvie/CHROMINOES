function [p_shapes, r_shape, p_num, d] = LPmake_colour_example2_C2()
% LPMAKE_COLOUR_EXAMPLE2_C2 Constructs an LP formulation of the generalized
% colouring equations for tiling a 98-by-98 square using four distinct polyominoes
% and two colours.
%
% This example uses:
%   - 750 copies of the straight tetromino
%   - 1051 copies of the 2×2 square
%   - 150 copies of the 2×3 rectangle
%   - 300 copies of the P-shaped pentomino
%
% Outputs:
%   p_shapes - 3D binary array representing the polyominoes
%   r_shape    - Binary matrix representing the rectangular region to tile.
%   p_num      - Number of distinct polyominoes used.
%   d               - Vector specifying the number of copies of polyominoes used.
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

  % Number of polyomino shapes
  p_num = 4;

  % Create and store the polyomino shapes
  p_shapes = zeros(98, 98, p_num);
  p_shapes(1:4, 1, 1)   = [1; 1; 1; 1];         % straight tetromino
  p_shapes(1:2, 1:2, 2) = [1 1; 1 1];           % 2×2 square
  p_shapes(1:2, 1:3, 3) = [1 1 1; 1 1 1];       % 2×3 rectangle
  p_shapes(1:3, 1:2, 4) = [1 1; 1 1; 1 0];      % P-shaped pentomino

  % Define the rectangular region to tile (98-by-98)
  r_shape = ones(98, 98);

  % Number of copies of the polyominoes
  d = [750, 1051, 150, 300];

  % Number of colours used (excluding white for holes)
  C = 2;

  % Construct the constraint matrix for the coloured tiling problem
  [a, b, num_chrom] = splitting_multihedral_matrix(r_shape, p_num, p_shapes, d, C);

  % Write the linear program to file
  filename = 'colour_example2_C2.lp';
  label = '\ LP file colour_example2_C2';
  variants_lp_write_multi(filename, label, a, b, p_num, d, num_chrom);

  % Notify user of file creation
  fprintf('\n');
  fprintf('LPmake_colour_example2_C2 created the LP file "%s"\n', filename);

end