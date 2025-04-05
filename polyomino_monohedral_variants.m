function [mn_num, mn_v, nm_num, nm_v] = polyomino_monohedral_variants(m, n, p)
% POLYOMINO_MONOHEDRAL_VARIANTS reports the distinct orientations of a polyomino.
%
%  Discussion:
%
%    Given a polyomino as a physical object, we can flip it over, and we
%    can turn it 90, 180 or 270 degrees. The transformed object may
%    actually have the same profile as the original, or it may differ.
%
%  Licensing:
%
%    This code is covered by the GNU General Public License (GPL).
%    See the LICENSE file for details.
%    (SPDX-License-Identifier: GPL-3.0-or-later)
%
%  Modified:
%
%    27 March 2025
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, integer m, n, the number of rows and columns in the representation
%    of the polyomino p.
%
%    Input, integer p(m,n), a matrix of 0's and 1's representing the 
%    polyomino. The matrix should be "tight", that is, there should be a
%    1 in row 1, and in column 1, and in row m, and in column n.
%
%    Output, integer mn_num, the number of variants with m rows and n columns,
%    which will be at least 1.
%
%    Output, integer mn_v(m,N,mn_num), the variants with m rows and n columns.
%
%    Output, integer nm_num, the number of variants with n rows and m columns,
%    which will be 0 if m = n.
%
%    Output, integer nm_v(n,m,nm_num), the variants with n rows and m columns.
%

  mn_num = 0;
  mn_v = [];

  nm_num = 0;
  nm_v = [];

  if ( m == n )

    for reflect = 0 : 1
      for rotate = 0 : 4

        [mq, nq, q] = polyomino_transform(m, n, p, rotate, reflect);

        different = true;
        for k = 1 : mn_num
          if ( polyomino_equal(mq, nq, q, m, n, mn_v(:,:,k)) )
            different = false;
            break;
          end
        end

        if ( different )
          mn_num = mn_num + 1;
          mn_v(1:m,1:n,mn_num) = q(1:m,1:n);
        end

      end
    end

  else

    for reflect = 0 : 1
      for rotate = 0 : 4

        [mq, nq, q] = polyomino_transform(m, n, p, rotate, reflect);

        if ( mq == m )

          different = true;
          for k = 1 : mn_num
            if ( polyomino_equal(mq, nq, q, m, n, mn_v(:,:,k)) )
              different = false;
              break;
            end
          end

          if ( different )
            mn_num = mn_num + 1;
            mn_v(1:mq,1:nq,mn_num) = q(1:mq,1:nq);
          end

        else

          different = true;
          for k = 1 : nm_num
            if ( polyomino_equal(mq, nq, q, n, m, nm_v(:,:,k)) )
              different = false;
              break;
            end
          end

          if ( different )
            nm_num = nm_num + 1;
            nm_v(1:mq,1:nq,nm_num) = q(1:mq,1:nq);
          end

        end

      end
    end

  end

  return
end