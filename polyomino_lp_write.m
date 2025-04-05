function polyomino_lp_write(filename, label, m, n, a, b)
% POLYOMINO_LP_WRITE Writes an LP file for the polyomino problem.
%
% This function generates an LP-format file representing the polyomino problem.
% Line breaks are added to ensure compatibility with software packages imposing
% limits on maximum line length (typically 80 characters).
%
% Inputs:
%   filename - String, the output filename.
%   label       - String, the problem title.
%   m            - Integer, number of equations.
%   n             - Integer, number of variables.
%   a             - Integer matrix (m x n), the coefficients.
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

  % Open the file.
  output = fopen(filename, 'wt');

  if (output < 0)
    fprintf(1, '\n');
    fprintf(1, 'POLYOMINO_LP_WRITE - Error!\n');
    fprintf(1, '  Could not open the output file.\n');
    error('POLYOMINO_LP_WRITE - Error!');
  end

  fprintf(output, '%s\n', label);
  fprintf(output, '\n');

  fprintf(output, 'Maximize\n');
  fprintf(output, '  Obj:  \n');

  fprintf(output, 'Subject to\n');
  line_length = 0;

  for i = 1 : m

    first = true;

    for j = 1 : n

      if (a(i,j) ~= 0)

        if (a(i,j) < 0)
          byte_num = fprintf(output, ' -');
          line_length = line_length + byte_num;
        elseif (~first)
          byte_num = fprintf(output, ' +');
          line_length = line_length + byte_num;
        end

        if (abs(a(i,j)) == 1)
          byte_num = fprintf(output, ' x%d', j);
          line_length = line_length + byte_num;
        else
          byte_num = fprintf(output, ' %d x%d', abs(a(i,j)), j);
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

  % Close the file.
  fclose(output);

end