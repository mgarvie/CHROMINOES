function [r_label, r_color] = plot_variomino(r_shape, p_num, p_shapes, d, sol_file, ...
    solver, lineWidth)
% PLOT_VARIOMINO plots the solution of a generalized coloured tiling problem 
% after optimization.
%
% Discussion:
%   This function plots the solution of a generalized coloured ILP tiling problem from using
%   one of two supported optimizers (CPLEX or Gurobi). It reads in a previously
%   computed solution vector from file, then constructs and plots the tiling.
%
%   The tiling solution is plotted in light-cyan with boundaries marked between
%   adjacent chrominoes. 'Holes' are left white. Each chromino (even duplicate shapes) 
%   receives a distinct label in the solution.
%
%   This function corresponds to step 3 of the following workflow:
%     1. Generate the LP file using an appropriate 'LP_make' script in MATLAB.
%     2. Solve the LP file using an optimizer (CPLEX or Gurobi).
%     3. Load the solution file (.SOL)  in MATLAB and run this function to view the tiling.
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
%   Marcus Garvie
%
% Inputs:
%   r_shape    - integer matrix, a chromino representing the region (0 = empty).
%   p_num      - integer, the number of chromino shapes to be used.
%   p_shapes  - integer 3D array, each chromino packed in a top-left-tight matrix.
%   d               - integer vector of length p_num, number of copies of each chromino.
%   sol_file      - string, name of the file containing a single solution ('.sol').
%   solver        - integer: 1 for CPLEX, 2 for Gurobi.
%   lineWidth   - the width of lines used to draw the chrominoes (usually
%                       between 0.5 and 2.0)
%
% Outputs:
%   r_label   - integer matrix, showing chromino index placement.
%   r_color   - integer matrix, used for coloured tiling display.
%

  if solver == 1
    x = cplex_solution_read(sol_file);
  elseif solver == 2
    x = gurobi_solution_read(sol_file);
  else
    error('Unknown solver. Use 1 for CPLEX or 2 for Gurobi.');
  end

  [r_label, r_color] = variomino_tiling_print(r_shape, p_num, p_shapes, d, x, '');

  plotBoundaries_perfect_colour(r_color, lineWidth); % each tile gets a different colour

  axis equal tight

  return
end