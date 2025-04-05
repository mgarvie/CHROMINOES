function variants = colour_C_variants(poly, C)
% COLOUR_C_VARIANTS Creates matrices for a coloured region or polyomino.
%
% Given a binary matrix POLY representing a region or polyomino, this function 
% generates a stack of C matrices corresponding to the C checkerboard colourings 
% using modular arithmetic. Each output matrix assigns values from the set 
% {0, 1, 2, ..., C}, where 0 represents a hole and other integers represent colours.
%
% Only the fixed orientation of the input polyomino is used.
%
% Inputs:
%   poly - Binary matrix representing the shape to be coloured.
%   C     - Number of colours (must be between 2 and 6 inclusive).
%
% Output:
%   variants - 3D array of size (rows, cols, C) with each "page" giving a distinct colouring.
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

  [rows, cols] = size(poly);
  variants = zeros(rows, cols, C);

% Loop over each element of the binary input matrix POLY. For each non-zero
% entry (i,j), assign values to the third-dimension pages of VARIANTS using
% a shifted modular function. This generates C distinct colourings (checkerboard-style),
% each stored on a separate page of the 3D array VARIANTS.

  for j = 1:cols
    for i = 1:rows
      if poly(i, j) == 1
        for page = 1:C
          variants(i, j, page) = mod(i + j + page - 1, C) + 1;
        end
      end
    end
  end

end