function [p_shapes, r_shape, p_num, d] = LPmake_colour_example3_C2()
% LPMAKE_COLOUR_EXAMPLE3_C2 Constructs an LP formulation of the generalized
% colouring equations for tiling a 40-by-40 square using five distinct polyominoes
% and two colours.
%
% This example uses:
%   - 216 copies of a 2×1 domino
%   - 76 copies of the 2×2 square
%   - 76 copies of an L-shaped triomino
%   - 40 copies of a compact 3×3 shape
%   - 20 copies of a large 5×7 polyomino
%
% Outputs:
%   p_shapes - 3D binary array representing the polyominoes.
%   r_shape    - Binary matrix representing the rectangular region to tile.
%   p_num      - Number of distinct polyominoes used.
%   d               - Vector specifying the number of copies of each polyomino.
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
  p_num = 5;

  % Create and store the polyomino shapes
  p_shapes = zeros(40, 40, p_num);
  p_shapes(1:2, 1, 1)     = [1; 1];                                      % 2×1 domino
  p_shapes(1:2, 1:2, 2)   = [1 1; 1 1];                                  % 2×2 square
  p_shapes(1:3, 1:2, 3)   = [1 0; 1 1; 1 0];                              % L-shaped triomino
  p_shapes(1:3, 1:3, 4)   = [0 1 0; 0 1 1; 1 1 0];                        % compact 3×3 shape
  p_shapes(1:5, 1:7, 5)   = [0 1 0 1 0 1 0;
                             1 1 1 1 1 1 1;
                             0 1 0 1 1 1 0;
                             0 0 0 0 1 1 1;
                             0 0 0 0 0 1 0];                             % large 5×7 polyomino

  % Define the rectangular region to tile (40-by-40)
  r_shape = ones(40, 40);

  % Number of copies of the polyominoes
  d = [216, 76, 76, 40, 20];

  % Number of colours used (excluding white for holes)
  C = 2;

  % Construct the constraint matrix for the coloured tiling problem
  [a, b, num_chrom] = splitting_multihedral_matrix(r_shape, p_num, p_shapes, d, C);

  % Write the linear program to file
  filename = 'colour_example3_C2.lp';
  label = '\ LP file colour_example3_C2';
  variants_lp_write_multi(filename, label, a, b, p_num, d, num_chrom);

  % Notify user of file creation
  fprintf('\n');
  fprintf('LPmake_colour_example3_C2 created the LP file "%s"\n', filename);

end