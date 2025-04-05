function variomino_lp_write(filename, label, A, b)
% VARIOMINO_LP_WRITE Writes an LP file for generalized coloured tiling problem.
%
% Given a coefficient matrix and right-hand side vector representing a coloured 
% tiling problem, this function creates a corresponding LP-format file.
%
% Inputs:
%   filename - String, the output filename (e.g., 'problem.lp').
%   label       - String, the problem title (e.g., '\ test').
%   A             - Integer matrix (m x n), the coefficients.
%   b             - Integer vector (m x 1), the right-hand sides.
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

  [m, n] = size(A);

  output = fopen(filename, 'wt');

  if (output < 0)
    fprintf(1, '\n');
    fprintf(1, 'variomino_lp_write(): Error!\n');
    fprintf(1, '  Could not open the output file "%s".\n', filename);
    error('variomino_lp_write(): Error!');
  end

  fprintf(output, '%s\n', label);
  fprintf(output, '\n');

  fprintf(output, 'Maximize\n');
  fprintf(output, '  Obj: \n');

  fprintf(output, 'Subject to\n');
  line_length = 0;

  for i = 1 : m

    first = true;

    for j = 1 : n

      if (A(i, j) ~= 0)

        if (A(i, j) < 0)
          byte_num = fprintf(output, ' -');
          line_length = line_length + byte_num;
        elseif (~first)
          byte_num = fprintf(output, ' +');
          line_length = line_length + byte_num;
        end

        if (abs(A(i, j)) == 1)
          byte_num = fprintf(output, ' x%d', j);
          line_length = line_length + byte_num;
        else
          byte_num = fprintf(output, ' %d x%d', abs(A(i, j)), j);
          line_length = line_length + byte_num;
        end

        if (70 <= line_length)
          fprintf(output, '\n');
          fprintf(output, '  ');
          line_length = 2;
        end

        first = false;

      end
    end
    fprintf(output, ' = %d\n', b(i));
    line_length = 0;
  end

  fprintf(output, 'Binary\n');
  line_length = fprintf(output, ' ');

  for j = 1 : n
    byte_num = fprintf(output, ' x%d', j);
    line_length = line_length + byte_num;
    if (73 <= line_length && j < n)
      fprintf(output, '\n');
      fprintf(output, '  ');
      line_length = 2;
    end
  end
  fprintf(output, '\n');

  fprintf(output, 'End\n');

  fclose(output);

end