function [mn_num, mn_v, nm_num, nm_v] = polyomino_variants(m, n, p)
% POLYOMINO_VARIANTS Finds distinct orientations of a polyomino.
%
% This function generates all distinct orientations of a given polyomino by
% rotating and reflecting it. The orientations are grouped by dimensions.
%
% Inputs:
%   m, n  - Integers specifying the number of rows and columns in polyomino P.
%   p       - Binary matrix (m x n), representing the polyomino. The matrix must 
%              be "tight," having at least one '1' in rows 1 and m, and columns 1 and n.
%
% Outputs:
%   mn_num - Integer, number of distinct variants with dimensions (m x n).
%   mn_v      - Binary matrix array (m x n x mn_num), the (m x n) variants.
%   nm_num - Integer, number of distinct variants with dimensions (n x m).
%                    (Zero if m = n.)
%   nm_v      - Binary matrix array (n x m x nm_num), the (n x m) variants.
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

  mn_num = 0;
  mn_v = [];

  nm_num = 0;
  nm_v = [];

  if (m == n)

    for reflect = 0 : 1
      for rotate = 0 : 4

        [mq, nq, q] = polyomino_transform(m, n, p, rotate, reflect);

        different = true;
        for k = 1 : mn_num
          if (polyomino_equal(mq, nq, q, m, n, mn_v(:, :, k)))
            different = false;
            break;
          end
        end

        if (different)
          mn_num = mn_num + 1;
          mn_v(1:m, 1:n, mn_num) = q(1:m, 1:n);
        end

      end
    end

  else

    for reflect = 0 : 1
      for rotate = 0 : 4

        [mq, nq, q] = polyomino_transform(m, n, p, rotate, reflect);

        if (mq == m)

          different = true;
          for k = 1 : mn_num
            if (polyomino_equal(mq, nq, q, m, n, mn_v(:, :, k)))
              different = false;
              break;
            end
          end

          if (different)
            mn_num = mn_num + 1;
            mn_v(1:mq, 1:nq, mn_num) = q(1:mq, 1:nq);
          end

        else

          different = true;
          for k = 1 : nm_num
            if (polyomino_equal(mq, nq, q, n, m, nm_v(:, :, k)))
              different = false;
              break;
            end
          end

          if (different)
            nm_num = nm_num + 1;
            nm_v(1:mq, 1:nq, nm_num) = q(1:mq, 1:nq);
          end
        end

      end
    end
  end

end