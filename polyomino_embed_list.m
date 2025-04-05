function list = polyomino_embed_list(mr, nr, r, mp, np, p, number)
% POLYOMINO_EMBED_LIST Lists the polyomino embeddings in a region.
%
% A region R and a polyomino P are represented as binary matrices, with
% entries of 1 indicating cells belonging to the shape, and entries of 0
% indicating empty space. Both matrices have no initial or final rows or
% columns consisting entirely of zeros.
%
% This function finds all embeddings of polyomino P within region R.
% An embedding is an offset (mi,nj) such that:
%
%     P(i,j) = R(i+mi, j+nj)
%
% for 1 <= i <= mp, 1 <= j <= np, and
% 0 <= mi <= mr - mp, 0 <= nj <= nr - np.
%
% Inputs:
%   mr         - Number of rows in region matrix R.
%   nr          - Number of columns in region matrix R.
%   r            - Binary matrix (mr x nr) representing region R.
%   mp        - Number of rows in polyomino matrix P.
%   np         - Number of columns in polyomino matrix P.
%   p           - Binary matrix (mp x np) representing polyomino P.
%   number - Integer specifying the number of embeddings.
%
% Output:
%   list   - Matrix (number x 2), each row gives offsets [mi, nj] of an embedding.
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

  list = zeros(number, 2);

  % Count the 1's in P.
  pr = sum(sum(p));

  % For each possible (mi,nj) offset, check for embeddings.
  k = 0;
  for mi = 0 : mr - mp
    for nj = 0 : nr - np
      srp = sum(sum(p(1:mp,1:np) .* r(1+mi:mp+mi,1+nj:np+nj)));
      if (srp == pr)
        k = k + 1;
        list(k,1:2) = [mi, nj];
      end
    end
  end

end