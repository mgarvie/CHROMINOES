function [w, s] = s_word_extract_first(s)
% S_WORD_EXTRACT_FIRST extracts the first word from a string.
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
%    s  - string, the input string.
%
%  Output:
%    w  - string, the first word of the input string.
%    s  - string, the input string with the first word removed.
%

  w = ' ';
  s_len = s_len_trim(s);

  if (s_len < 1)
    return
  end

  % Find the first nonblank character.
  get1 = 0;
  while true
    get1 = get1 + 1;
    if (s_len < get1)
      return
    end
    if (s(get1) ~= ' ')
      break
    end
  end

  % Find the last contiguous nonblank character.
  get2 = get1;
  while true
    if (s_len <= get2)
      break
    end
    if (s(get2 + 1) == ' ')
      break
    end
    get2 = get2 + 1;
  end

  % Extract the word.
  w = s(get1:get2);

  % Shift the remaining string.
  s = s(get2 + 1:s_len);

  return
end