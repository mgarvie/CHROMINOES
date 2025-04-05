function [p_shapes, r_shape, p_num, d, m, n] = LPmake_poly_example2()
% LPMAKE_POLY_EXAMPLE2 Constructs a linear system for tiling a 98-by-98 square 
% using four distinct polyominoes and saves it as an LP file.
%
% This example uses:
%   - 750 copies of the straight tetromino
%   - 1051 copies of the 2×2 square
%   - 150 copies of the 2×3 rectangle
%   - 300 copies of the P-shaped pentomino
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
%   Marcus Garvie, John Burkardt

  % Define the rectangular region to tile (98-by-98)
  r_shape = ones(98, 98);

  % Number of distinct polyominoes
  p_num = 4;

  % Create and store the polyomino shapes
  p_shapes = zeros(98, 98, p_num);
  p_shapes(1:4, 1, 1)   = [1; 1; 1; 1];         % straight tetromino
  p_shapes(1:2, 1:2, 2) = [1 1; 1 1];           % 2×2 square
  p_shapes(1:2, 1:3, 3) = [1 1 1; 1 1 1];       % 2×3 rectangle
  p_shapes(1:3, 1:2, 4) = [1 1; 1 1; 1 0];      % P-shaped pentomino

  % Number of copies of each polyomino
  d = [750, 1051, 150, 300];

  % Construct the constraint matrix for the tiling problem
  [a, b, ~] = polyomino_multihedral_matrix(r_shape, p_num, p_shapes, d);
  [m, n] = size(a);

  % Display matrix dimensions
  fprintf('\n');
  fprintf('Number of constraints (rows): %d\n', m);
  fprintf('Number of variables (columns): %d\n', n);

  % Write the linear program to file
  filename = 'poly_example2.lp';
  label = '\ LP file poly_example2';
  polyomino_lp_write(filename, label, m, n, a, b);

  % Notify user of file creation
  fprintf('\n');
  fprintf('LPmake_poly_example2 created the LP file "%s"\n', filename);

end