function [p_shapes, r_shape, p_num, d] = LPmake_chrom_example3_C3()
% LPMAKE_CHROM_EXAMPLE3_C3 Constructs an LP system for tiling a checkerboard-coloured 
% 40-by-40 region using chromatic variants of five polyominoes, based on a precomputed 
% solution vector with three colours.
%
% Outputs:
%   p_shapes - 3D binary array of selected polyominoes.
%   r_shape    - Binary matrix representing the coloured region to tile.
%   p_num      - Number of distinct chromino variants used (# nonzero entries in solution).
%   d               - Vector specifying the number of copies of each chromino variant.
%
% Instructions:
%   Before running this script, you must save a particular solution vector `x` 
%   (obtained from solving the LP file COLOUR_EXAMPLE3_C3 generated by 
%   LPMAKE_COLOUR_EXAMPLE3_C3) into a file named 'x.mat' in the current directory.
%   Use the following MATLAB command:
%
%     save('x.mat', 'x');
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
%   Marcus Garvie

  % Number of colours
  C = 3;

  % Define the C-coloured checkerboard target region
  One = ones(40, 40);
  variants = colour_C_variants(One, C);
  r_shape = variants(:, :, C-1);  % Ensure a 1 in position (1,1)

  % Load precomputed solution vector (must be saved as x.mat)
  data = load('x.mat');
  soln = data.x;
  displayVectorComponents(soln);
  len = length(soln);

  % Extract number of copies of each chromino used
  d = soln(soln ~= 0).';

  % Count number of distinct chromino variants used 
  p_num = length(d);

  % Initialize array to store used chromino shapes
  p_shapes = zeros(40, 40, p_num);

  % Generate all chromino variants for each polyomino
  P1 = [1; 1];                        % 2×1 domino
  chrom1 = FindAllChrom(P1, C);
  num_chrom1 = size(chrom1, 3);

  P2 = [1 1; 1 1];                   % 2×2 square
  chrom2 = FindAllChrom(P2, C);
  num_chrom2 = size(chrom2, 3);

  P3 = [1 0; 1 1; 1 0];              % L-shaped triomino
  chrom3 = FindAllChrom(P3, C);
  num_chrom3 = size(chrom3, 3);

  P4 = [0 1 0; 0 1 1; 1 1 0];        % compact 3×3 shape
  chrom4 = FindAllChrom(P4, C);
  num_chrom4 = size(chrom4, 3);

  P5 = [0 1 0 1 0 1 0;
        1 1 1 1 1 1 1;
        0 1 0 1 1 1 0;
        0 0 0 0 1 1 1;
        0 0 0 0 0 1 0];              % large 5×7 shape
  chrom5 = FindAllChrom(P5, C);
  num_chrom5 = size(chrom5, 3);

  % Pack all chrominoes into a large array
  chrom_all = zeros(40, 40, len);
  count = 0;
  for page = 1:num_chrom1
    count = count + 1;
    chrom_all(1:2, 1, count) = chrom1(:, :, page);
  end
  for page = 1:num_chrom2
    count = count + 1;
    chrom_all(1:2, 1:2, count) = chrom2(:, :, page);
  end
  for page = 1:num_chrom3
    count = count + 1;
    chrom_all(1:3, 1:2, count) = chrom3(:, :, page);
  end
  for page = 1:num_chrom4
    count = count + 1;
    chrom_all(1:3, 1:3, count) = chrom4(:, :, page);
  end
  for page = 1:num_chrom5
    count = count + 1;
    chrom_all(1:5, 1:7, count) = chrom5(:, :, page);
  end

  % Select and store only the chrominoes used in the solution
  count = 0;
  for i = 1:len
    if soln(i) ~= 0
      count = count + 1;
      p_shapes(:, :, count) = chrom_all(:, :, i);
    end
  end

  % Construct the constraint matrix for the chromino tiling problem
  [A, b, ~] = variomino_matrix(r_shape, p_num, p_shapes, d);
  [m, n] = size(A);

  % Display matrix dimensions
  fprintf('\n');
  fprintf('Number of constraints (rows): %d\n', m);
  fprintf('Number of variables (columns): %d\n', n);

  % Write the linear program to file
  filename = 'chrom_example3_C3.lp';
  label = '\ LP file chrom_example3_C3';
  variomino_lp_write(filename, label, A, b);

  % Notify user of file creation
  fprintf('\n');
  fprintf('LPmake_chrom_example3_C3 created the LP file "%s"\n', filename);

end