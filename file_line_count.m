function [line_num, blank_num, comment_num, data_num] = file_line_count(filename)
% FILE_LINE_COUNT counts the lines in a file.
%
%  Discussion:
%
%    Each input line is a "record".
%
%    The records are divided into three groups:
%      * blanks       - lines containing only whitespace,
%      * comments - lines beginning with '#',
%      * data           - all other lines.
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
%    line_num            - integer, the total number of lines.
%    blank_num         - integer, number of blank lines.
%    comment_num   - integer, number of comment lines.
%    data_num           - integer, number of data lines.
%

  input_unit = fopen(filename);

  if (input_unit < 0)
    fprintf(1, '\n');
    fprintf(1, 'FILE_LINE_COUNT - Error!\n');
    fprintf(1, '  Could not open the file "%s".\n', filename);
    error('FILE_LINE_COUNT - Error!');
  end

  blank_num = 0;
  comment_num = 0;
  data_num = 0;
  line_num = 0;

  while true
    line = fgetl(input_unit);
    if isequal(line, -1)
      break;
    end

    line_num = line_num + 1;
    line_length = s_len_trim(line);

    if (line_length <= 0)
      blank_num = blank_num + 1;
    elseif (line(1) == '#')
      comment_num = comment_num + 1;
    else
      data_num = data_num + 1;
    end
  end

  fclose(input_unit);

  return
end