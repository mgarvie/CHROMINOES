function list = variomino_embed_list(r, p, number)
% VARIOMINO_EMBED_LIST Lists embeddings of a chromino into a region.
%
% Given a region r and a chromino p, each represented by matrices whose entries 
% are integers between 1 and v (for occupied squares) or 0 (empty), this function 
% finds all embeddings of p into r. An embedding is an offset (mi,nj) such that 
% for every nonzero entry in p, the corresponding entry in r matches exactly.
%
% Inputs:
%   r            - Integer matrix (mr x nr), representing the region chromino R.
%   p           - Integer matrix (mp x np), representing the chromino P.
%   number - Integer, total number of embeddings.
%
% Outputs:
%   list - Integer matrix (k x 2), where k is the number of embeddings found.
%          Each row contains offsets [mi, nj] indicating an embedding of variomino P into region R.
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

  [mr, nr] = size(r);
  [mp, np] = size(p);

  list = zeros(number, 2);

  pvec = reshape(p, mp * np, 1);
  p_nonzero_index = find(pvec ~= 0);

  k = 0;
  for mi = 0 : mr - mp
    for nj = 0 : nr - np
      rvec = reshape(r(1+mi:mp+mi, 1+nj:np+nj), mp * np, 1);
      if (all(rvec(p_nonzero_index) == pvec(p_nonzero_index)))
        k = k + 1;
        list(k, 1:2) = [mi, nj];
      end
    end
  end

end