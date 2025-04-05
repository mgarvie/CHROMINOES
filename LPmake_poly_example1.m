function [p_shapes, r_shape] = LPmake_poly_example1()
% LPMAKE_POLY_EXAMPLE1 Constructs a linear system for tiling a 120-by-120 square 
% using 3600 copies of a free tetromino and saves it as an LP file.
%
% Outputs:
%   p_shapes - Binary matrix representing the tetromino.
%   r_shape    - Binary matrix representing the rectangular region to tile.
%
% Licensing:
%   This code is covered by the GNU General Public License (GPL).
%   See the LICENSE file for details.
%   (SPDX-License-Identifier: GPL-3.0-or-later)
%
% Modified:
%   25 March 2025
%
% Author:
%   Marcus Garvie

  % Define the free tetromino shape (L-shaped)
  p_shapes = [1 0 0;
                       1 1 1];

  % Define the rectangular region to tile (120-by-120)
  r_shape = ones(120, 120);

  % Construct the constraint matrix for the tiling problem
  [a, b] = polyomino_monohedral_matrix(r_shape, p_shapes);

  % Get the dimensions of the constraint matrix
  [m, n] = size(a);

  % Display matrix dimensions
  fprintf('\n');
  fprintf('Number of constraints (rows): %d\n', m);
  fprintf('Number of variables (columns): %d\n', n);

  % Write the linear program to file
  filename = 'poly_example1.lp';
  polyomino_lp_write(filename, '\ poly_example1', m, n, a, b);

  % Notify user of file creation
  fprintf('\n');
  fprintf('LPmake_poly_example1 created the LP file "%s"\n', filename);

end