function plot_mono(r_shape, p_shapes, sol_file, image_file, solver)
% PLOT_MONO Visualizes monohedral tilings from an optimizer solution file.
%
% Combines the functionality of POLYOMINO_MONOHEDRAL_TILING_PLOT and one of
% CPLEX_SOLUTION_READ or GUROBI_SOLUTION_READ. Assumes:
%
% 1. You have run the appropriate LPmake file in MATLAB.
% 2. You solved the resulting .lp file with an external optimizer.
% 3. You now use this function to visualize the solution(s) from step 2.
%
% Inputs:
%   r_shape      - Binary matrix representing the region to tile.
%   p_shapes   - Binary matrix representing the polyomino used for tiling.
%   sol_file        - Filename of the optimizer solution file (extension '.sol').
%   image_file   - Base filename for image output (e.g., 'tiling.png').
%                        Up to 99 images will be saved (e.g., tiling01.png, tiling02.png, ...).
%   solver          - Integer specifying the solver used:
%
%         1 = CPLEX
%         2 = GUROBI
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
%   John Burkardt, Marcus Garvie (edited)

  if solver == 1
      x = cplex_solution_read(sol_file);
  elseif solver == 2
      x = gurobi_solution_read(sol_file);
  else
      error('Unknown solver code. Use 1 for CPLEX or 2 for GUROBI.');
  end

  polyomino_monohedral_tiling_plot(r_shape, p_shapes, x, image_file, '');

end