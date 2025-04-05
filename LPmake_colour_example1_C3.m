function [p_shape, d, r_shape] = LPmake_colour_example1_C3()
% LPMAKE_COLOUR_EXAMPLE1_C3 Constructs an LP formulation of the generalized
% colouring equations for tiling a 120-by-120 square using 3600 copies of a 
% tetromino with three colours.
%
% Outputs:
%   p_shape - Binary matrix representing the tetromino shape.
%   d             - Vector specifying the number of copies of polyominoes used.
%   r_shape  - Binary matrix representing the rectangular region to tile.
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

  % Define the tetromino shape (L-shaped)
  p_shape = [1 0 0;
                     1 1 1];

  % Define the rectangular region to tile (120-by-120)
  r_shape = ones(120, 120);

  % Number of copies of the polyominoes
  d = [3600];

  % Number of colours used (excluding white for holes)
  C = 3;

  % Construct the constraint matrix for the coloured tiling problem
  [a, b] = splitting_monohedral_matrix(r_shape, p_shape, C);

  % Write the linear program to file
  filename = 'colour_example1_C3.lp';
  label = '\ LP file colour_example1_C3';
  variants_lp_write_mono(filename, label, a, b, d);

  % Notify user of file creation
  fprintf('\n');
  fprintf('LPmake_colour_example1_C3 created the LP file "%s"\n', filename);

end