function unique_mats = unique_iso(var_cell)
% UNIQUE_ISO Removes isomorphic matrices from a cell array.
%
% Given a cell array of matrices, removes any duplicates that are isomorphic
% to each other (one can be transformed into another by rotations or reflections).
%
% Inputs:
%   var_cell  - Cell array containing matrices to be checked.
%
% Outputs:
%   unique_mats - Cell array containing matrices with isomorphic duplicates removed.
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

  num = numel(var_cell);
  unique_mats = var_cell;

  for i = 1 : num
      for j = i + 1 : num
          A = var_cell{i};
          B = var_cell{j};
          tf = isomorphic(A, B);
          if tf
              unique_mats{i} = [];
          end
      end
  end

  empties = find(cellfun(@isempty, unique_mats));
  unique_mats(empties) = [];

end