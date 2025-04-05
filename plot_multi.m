function plot_multi(r_shape, p_num, p_shapes, d, sol_file, image_file, solver)
% PLOT_MULTI plots multihedral tilings after optimization.
%
%  Licensing:
%
%    This code is covered by the GNU General Public License (GPL).
%    See the LICENSE file for details.
%    (SPDX-License-Identifier: GPL-3.0-or-later)
%
%  Modified:
%
%    27 March 2025
%
%  Author:
%
%    John Burkardt
%
%  Input:
%    r_shape    - integer matrix, the region to be tiled.
%    p_num      - integer, the number of polyomino types.
%    p_shapes   - integer array, shape data for each polyomino.
%    d          - integer vector (1,p_num), number of copies of each polyomino.
%    sol_file   - string, path to solution file (produced by optimizer).
%    image_file - string, output filename for plots (e.g., 'plot01.png').
%    solver     - integer: 1 for CPLEX, 2 for GUROBI.
%
%  Note:
%    Run the appropriate LPmake file, solve the LP externally, then use
%    this function to visualize the result.
%

  % Read solution vector from optimizer output
  if solver == 1
    x = cplex_solution_read(sol_file);    % CPLEX
  elseif solver == 2
    x = gurobi_solution_read(sol_file);   % GUROBI
  else
    error('Unsupported solver. Use 1 for CPLEX or 2 for GUROBI.');
  end

  % Plot and save solution(s)
  polyomino_multihedral_tiling_plot(r_shape, p_num, p_shapes, d, ...
    x, image_file, '');

  return
end