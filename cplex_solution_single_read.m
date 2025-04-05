function x = cplex_solution_single_read(data)
% CPLEX_SOLUTION_SINGLE_READ Reads a CPLEX single solution structure.
%
% Parses a single-solution CPLEX XML structure into a MATLAB column vector.
%
% Inputs:
%   data - Struct, parsed CPLEX solution XML data.
%
% Outputs:
%   x    - Column vector (n x 1), the extracted solution vector.
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

  sol_num = 1;

  % Initialize x with a single entry (to be expanded as needed)
  x = zeros(1, 1);

  % Number of variables with explicit values
  value_num = length(data.CPLEXSolution.variables.variable);

  for value_index = 1 : value_num
    name = data.CPLEXSolution.variables.variable{value_index}.Attributes.name;
    var_index = str2double(name(2:end));

    value = str2double(data.CPLEXSolution.variables.variable{value_index}.Attributes.value);

    x(var_index, 1) = value;
  end

end