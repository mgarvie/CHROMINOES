function x = cplex_solution_read(filename)
% CPLEX_SOLUTION_READ Reads a CPLEX solution file.
%
% The structure of the CPLEX solution file varies depending on whether
% CPLEX found a single solution or multiple solutions.
%
% Inputs:
%   filename - String, name of the solution file to be read (XML format).
%
% Outputs:
%   x - Numeric array (n x sol_num), containing solution vector(s).
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
%   John Burkardt

  data = xml2struct(filename);

  if isfield(data, 'CPLEXSolutions')
      x = cplex_solution_multiple_read(data);
  else
      x = cplex_solution_single_read(data);
  end

  % Clean up numerical noise and round to nearest integer
  x = abs(x);
  x = round(x);

end