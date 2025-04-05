function [v_num, v, v_p] = polyomino_multihedral_variants(mp, np, p_num, p, d)
% POLYOMINO_MULTIHEDRAL_VARIANTS Generates polyomino variants by rotation 
% and reflection.
%
% Given an array of polyominoes, this function generates all unique variants
% obtainable by rotating and reflecting each polyomino. Only polyominoes
% indicated by positive entries in D are processed.
%
% Inputs:
%   mp, np - Integers specifying the number of rows and columns for the 
%                 polyomino representation.
%   p_num - Number of polyominoes.
%   p          - Binary matrix array (mp x np x p_num), each slice p(:,:,k) is 
%                 "top-left tight," containing at least one '1' in the first row 
%                 and first column.
%   d          - Integer vector (p_num x 1), specifying how many copies of each 
%                 polyomino are allowed. If d(i) <= 0, no variants are generated.
%
% Outputs:
%   v_num  - Integer, number of unique variants generated.
%   v           - Binary matrix array (mp x np x v_num), storing all variants.
%   v_p       - Integer vector (v_num x 1), where v_p(i) indicates the index of 
%                  the original polyomino from which variant v(:,:,i) was derived.
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

  v_num = 0;
  v = [];
  v_p = [];

  for l = 1 : p_num

    if (1 <= d(l))

      [ mq, nq, q ] = polyomino_condense ( mp, np, p(1:mp,1:np,l) );
      
      for reflect = 0 : 1
        for rotate = 0 : 4

          [ms, ns, s] = polyomino_transform(mq, nq, q, rotate, reflect);

          if (ms <= mp && ns <= np)

            t = zeros(mp, np);
            t(1:ms, 1:ns) = s;

            different = true;
            for k = 1 : v_num
              if (t(1:mp, 1:np) == v(1:mp, 1:np, k))
                different = false;
                break;
              end
            end

            if (different)
              v_num = v_num + 1;
              v(1:mp, 1:np, v_num) = t(1:mp, 1:np);
              v_p(v_num) = l;
            end

          end

        end
      end

    end

  end

end