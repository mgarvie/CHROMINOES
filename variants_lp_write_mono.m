function variants_lp_write_mono(filename, label, a, b, d)
% VARIANTS_LP_WRITE_MONO Writes an LP file for the chromino splitting problem.
%
% Creates the LP file for a tiling problem using a single free polyomino
% exactly d times, yielding colouring equations.
%
% Inputs:
%   filename - String, output filename (e.g., 'test.lp').
%   label       - String, problem title (e.g., '\ test'). Include initial backslash.
%   a             - Integer matrix (m x n), coefficients.
%   b             - Integer vector (m x 1), right-hand side values.
%   d             - Integer, number of copies of the polyomino used.
%
% Licensing:
%   This code is covered by the GNU General Public License (GPL).
%   See the LICENSE file for details.
%   (SPDX-License-Identifier: GPL-3.0-or-later)
%
% Modified:
%   26 March 2025
%
% Authors:
%   John Burkardt, Marcus Garvie (edited)

  [m, n] = size(a);

  output = fopen(filename, 'wt');

  if (output < 0)
    fprintf(1, '\n');
    fprintf(1, 'polyomino_lp_write - Error!\n');
    fprintf(1, '  Could not open the output file.\n');
    error('polyomino_lp_write - Error!');
  end

  fprintf(output, '%s \n', label);
  fprintf(output, '\n');

  fprintf(output, 'Maximize\n');
  fprintf(output, '  obj:  \n');

  fprintf(output, 'Subject to\n');
  line_length = 0;

  for i = 1 : m

    first = true;

    for j = 1 : n

      if (a(i, j) ~= 0)

        if (a(i, j) < 0)
          byte_num = fprintf(output, ' -');
          line_length = line_length + byte_num;
        elseif (~first)
          byte_num = fprintf(output, ' +');
          line_length = line_length + byte_num;
        end

        if (abs(a(i, j)) == 1)
          byte_num = fprintf(output, ' x%d', j);
          line_length = line_length + byte_num;
        else
          byte_num = fprintf(output, ' %d x%d', abs(a(i, j)), j);
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

  fprintf(output, 'Bounds\n');

  for j = 1 : n
    fprintf(output, ' 0 <= x%d <= %d\n', j, d(1));
  end

  fprintf(output, 'General\n');
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