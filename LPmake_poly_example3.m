function [p_shapes, r_shape, p_num, d, m, n] = LPmake_poly_example3()
% LPMAKE_POLY_EXAMPLE3 Constructs a linear system for tiling a 40-by-40 square 
% using five distinct free polyominoes and saves it as an LP file.
%
% This example uses:
%   - 216 copies of a 2×1 domino
%   - 76 copies of the 2×2 square
%   - 76 copies of an L-shaped triomino
%   - 40 copies of a compact 3×3 shape
%   - 20 copies of a large 5×7 polyomino
%
% Outputs:
%   p_shapes - 3D binary array representing the polyomino shapes.
%   r_shape    - Binary matrix representing the region to tile.
%   p_num      - Number of distinct polyominoes used.
%   d               - Vector specifying the number of copies of each polyomino.
%   m              - Number of constraints in the LP formulation.
%   n               - Number of variables in the LP formulation.
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

  % Define the rectangular region to tile (40-by-40)
  r_shape = ones(40, 40);

  % Number of distinct polyominoes
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
                             0 0 0 0 0 1 0];                             % large 5×7 shape

  % Number of copies of each polyomino
  d = [216, 76, 76, 40, 20];

  % Construct the constraint matrix for the tiling problem
  [a, b, ~] = polyomino_multihedral_matrix(r_shape, p_num, p_shapes, d);
  [m, n] = size(a);

  % Display matrix dimensions
  fprintf('\n');
  fprintf('Number of constraints (rows): %d\n', m);
  fprintf('Number of variables (columns): %d\n', n);

  % Write the linear program to file
  filename = 'poly_example3.lp';
  label = '\ LP file poly_example3';
  polyomino_lp_write(filename, label, m, n, a, b);

  % Notify user of file creation
  fprintf('\n');
  fprintf('LPmake_poly_example3 created the LP file "%s"\n', filename);

end