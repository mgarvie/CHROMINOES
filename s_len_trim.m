function len = s_len_trim(s)
% S_LEN_TRIM returns the length of a character string to the last nonblank.
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
%    s  - string, the string to be measured.
%
%  Output:
%    len  - integer, the length of the string up to the last nonblank.
%

  len = length(s);

  while (len > 0)
    if (s(len) ~= ' ')
      return
    end
    len = len - 1;
  end

  return
end