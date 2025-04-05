function x = gurobi_solution_read(filename)
% GUROBI_SOLUTION_READ reads solution vectors from a GUROBI file.
%
%  Discussion:
%
%    Each line of the file has the form "x## value", where the name starts
%    with 'x' followed by a numeric index, and the value is typically 0 or 1.
%
%    The function reads this data and returns a solution vector x.
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
%  Input:
%    filename - string, the name of the input file.
%
%  Output:
%    x        - integer vector, the extracted solution.
%

  fprintf(1, '\n');
  fprintf(1, 'GUROBI_SOLUTION_READ:\n');
  fprintf(1, '  Extract information from GUROBI file "%s".\n', filename);

  % Determine number of lines in the file
  line_num = file_line_count(filename);
  fprintf(1, '  The file contains %d lines of information.\n', line_num);

  % Preallocate x
  x = zeros(line_num, 1);

  % Open input file
  input_unit = fopen(filename);

  nz = 0;
  i_max = 0;

  for line_index = 1 : line_num
    line_text = fgetl(input_unit);

    [w1, line_text] = s_word_extract_first(line_text);

    % Skip lines not starting with 'x'
    if (w1(1) ~= 'x')
      continue
    end

    i = str2num(w1(2:end));
    i_max = max(i_max, i);

    [w2, ~] = s_word_extract_first(line_text);
    value = str2num(w2);

    if (value ~= 0)
      nz = nz + 1;
    end

    x(i) = value;
  end

  fclose(input_unit);

  % Force nonnegative integer values
  x = abs(x);
  x = round(x);

  % Report number of nonzeros
  fprintf(1, '\n');
  fprintf(1, '  The file contains %d nonzero values.\n', nz);

  % Resize vector if necessary
  if (i_max ~= line_num)
    x = x(1:i_max);
    fprintf(1, '  X array size adjusted to %d\n', i_max);
  end

  return
end