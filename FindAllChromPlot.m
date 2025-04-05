function chrom = FindAllChromPlot(mat, C)
% FINDALLCHROMPLOT Generates and plots all chrominoes using C colours
% for a given binary polyomino matrix.
%
% This function creates all distinct chromino variants using rotations and flips 
% of the input binary matrix MAT, colours them using modular colouring with C colours,
% removes duplicates up to isometry, prints colour-frequency counts, and visualizes
% the results in a multi-subplot figure.
%
% Element   RGB triplet      Colour
%    0              [1 1 1]           White
%    1              [0 0 0]           Black
%    2              [0.7 0.7 0.7]  Gray
%    3              [1 0 0]           Red
%    4              [0 1 0]           Green
%    5              [1 1 0]           Yellow
%    6              [0 0 1]           Blue
%    7              [1 0 1]           Magenta
%
% Inputs:
%   mat - Binary matrix representing the polyomino shape.
%   C    - Number of colours (2 to 6 inclusive).
%
% Output:
%   chrom - 3D array of all unique chromino variants.
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

  [rows, cols] = size(mat);

  % Generate all 8 possible orientations (rotations and flips)
  orients = cell(1, 8);
  orients{1} = mat;
  for i = 2:4
    orients{i} = rot90(orients{i - 1});
  end
  orients{5} = fliplr(mat);
  for i = 6:8
    orients{i} = rot90(orients{i - 1});
  end

  % Apply modular colouring to each orientation
  variants1 = colour_C_variants(orients{1}, C);
  variants2 = colour_C_variants(orients{2}, C);
  variants3 = colour_C_variants(orients{3}, C);
  variants4 = colour_C_variants(orients{4}, C);
  variants5 = colour_C_variants(orients{5}, C);
  variants6 = colour_C_variants(orients{6}, C);
  variants7 = colour_C_variants(orients{7}, C);
  variants8 = colour_C_variants(orients{8}, C);

  % Initialize transformed variants
  for page = 1:C
    var1(:, :, page) = zeros(rows, cols);
    var2(:, :, page) = zeros(rows, cols);
    var3(:, :, page) = zeros(rows, cols);
    var4(:, :, page) = zeros(rows, cols);
    var5(:, :, page) = zeros(rows, cols);
    var6(:, :, page) = zeros(rows, cols);
    var7(:, :, page) = zeros(rows, cols);
    var8(:, :, page) = zeros(rows, cols);
  end

  % Undo transformations to align all variants with the original orientation
  var1 = variants1;
  for j = 1:C
    var2(:, :, j) = rot90(variants2(:, :, j), -1);
    var3(:, :, j) = rot90(variants3(:, :, j), -2);
    var4(:, :, j) = rot90(variants4(:, :, j), -3);
    var5(:, :, j) = fliplr(variants5(:, :, j));
    var6(:, :, j) = fliplr(rot90(variants6(:, :, j), -1));
    var7(:, :, j) = fliplr(rot90(variants7(:, :, j), -2));
    var8(:, :, j) = fliplr(rot90(variants8(:, :, j), -3));
  end

  % Combine all colourings into a single 3D array
  variants = cat(3, var1, var2, var3, var4, var5, var6, var7, var8);

  % Convert to cell array to remove duplicates up to isometry
  for page = 1:8*C
    var_cell{page} = variants(:, :, page);
  end
  unique_mats = unique_iso(var_cell);
  left = numel(unique_mats);

  % Reconstruct chrom array from unique cell array
  for page = 1:left
    chrom(:, :, page) = unique_mats{page};
  end

  % Display colour counts for each chromino variant
  for page = 1:left
    fprintf('Variant %d \n', page);
    for colour = 1:C
      num = nnz(chrom(:, :, page) == colour);
      fprintf('# squares of colour %d = %d \n', colour, num);
    end
    fprintf('\n');
  end

  % Define RGB colour map
  index = cat(3, [1 1 1], [0 0 0], [0.7 0.7 0.7], ...
                 [1 0 0], [0 1 0], [1 1 0], [0 0 1], [1 0 1]);

  % Plot all chromino variants
  sqSize = ceil(sqrt(left));
  for page = 1:left
    array = chrom(:, :, page);
    unq = unique(array);
    ind = unq + 1;

    % Build colormap
    cmap = [];
    for i = 1:length(ind)
      cmap = [cmap; index(:, :, ind(i))];
    end

    % Scale values for image display
    [~, ~, arrayscaled] = unique(array);
    arrayscaled = reshape(arrayscaled, size(array));

    % Plot each variant
    subplot(sqSize, sqSize, page);
    hAxes = gca;
    imagesc(hAxes, arrayscaled);
    colormap(hAxes, cmap);
    set(gcf, 'color', 'w');
    title(sprintf('chromino #%d', page));
    axis equal tight off;
  end

end