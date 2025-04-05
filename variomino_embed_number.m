function number = variomino_embed_number(r, p)
% VARIOMINO_EMBED_NUMBER Counts embeddings of a chromino into a region.
%
% Given a region r and a chromino p, each represented by matrices whose entries
% are integers between 1 and v (occupied squares) or 0 (empty), this function 
% counts how many distinct embeddings of p exist within r. An embedding is an 
% offset (mi,nj) such that, for every nonzero entry in p, the corresponding 
% entry in r matches exactly.
%
% Inputs:
%   r       - Integer matrix (mr x nr), representing the region chromino R.
%   p      - Integer matrix (mp x np), representing the chromino P.
%
% Outputs:
%   number - Integer, number of distinct embeddings of P into R.
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

  number = 0;

  [mr, nr] = size(r);
  [mp, np] = size(p);

  pvec = reshape(p, mp * np, 1);
  p_nonzero_index = find(pvec ~= 0);

  for mi = 0 : mr - mp
      for nj = 0 : nr - np
          rvec = reshape(r(1+mi:mp+mi, 1+nj:np+nj), mp * np, 1);
          if (all(rvec(p_nonzero_index) == pvec(p_nonzero_index)))
              number = number + 1;
          end
      end
  end

end