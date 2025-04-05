function filename = filename_inc(filename)
% FILENAME_INC increments the numeric part of a filename string.
%
%  Discussion:
%
%    It is assumed that the digits in the name, whether scattered or
%    connected, represent a number that is to be increased by 1 on
%    each call. If this number is all 9's on input, the output number
%    is all 0's. Non-numeric characters of the name are unaffected.
%
%    If the name is empty, then the routine stops.
%
%    If the name contains no digits, the empty string is returned.
%
%  Example:
%
%      Input            Output
%      -----            ------
%      'a7to11.txt'     'a7to12.txt'  (typical case, last digit incremented)
%      'a7to99.txt'     'a8to00.txt'  (carry propagation)
%      'a9to99.txt'     'a0to00.txt'  (wrap around)
%      'cat.txt'        ' '           (no digits in input name)
%      ' '              STOP!         (error)
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
%    filename - string, the string to be incremented.
%
%  Output:
%    filename - string, the incremented string.
%

  lens = length(filename);

  if (lens <= 0)
    fprintf(1, '\n');
    fprintf(1, 'FILENAME_INC - Fatal error!\n');
    fprintf(1, '  The input filename is empty.\n');
    error('FILENAME_INC - Fatal error!');
  end

  change = 0;

  for i = lens : -1 : 1

    c = filename(i);

    if ('0' <= c && c <= '8')
      c = c + 1;
      filename(i) = c;
      return

    elseif (c == '9')
      change = change + 1;
      filename(i) = '0';
    end

  end

  if (change == 0)
    filename = ' ';
  end

  return
end