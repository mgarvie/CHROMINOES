function tf = isomorphic(A, B)
% ISOMORPHIC Checks if two matrices A and B are equivalent up to rotations and flips.
%
% This function returns true if A and B are isomorphic under any combination of 
% 0, 90, 180, or 270 degree rotations and horizontal flips. Otherwise, it returns false.
%
% Inputs:
%   A, B - Binary matrices to compare for isomorphism.
%
% Output:
%   tf - Logical value indicating whether A and B are isomorphic.
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

  tf = false;
  if isequal(A, B)
    tf = true;
  elseif isequal(A, rot90(B))
    tf = true;
  elseif isequal(A, rot90(B, 2))
    tf = true;
  elseif isequal(A, rot90(B, 3))
    tf = true;
  elseif isequal(A, fliplr(B))
    tf = true;
  elseif isequal(A, rot90(fliplr(B)))
    tf = true;
  elseif isequal(A, rot90(fliplr(B), 2))
    tf = true;
  elseif isequal(A, rot90(fliplr(B), 3))
    tf = true;
  end

end