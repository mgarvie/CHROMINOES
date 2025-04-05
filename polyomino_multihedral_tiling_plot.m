function polyomino_multihedral_tiling_plot(r_shape, p_num, p_shapes, d, x, filename, label)
% POLYOMINO_MULTIHEDRAL_TILING_PLOT plots multihedral polyomino tilings.
%
% Licensing:
%   This code is covered by the GNU General Public License (GPL).
%   See the LICENSE file for details.
%   (SPDX-License-Identifier: GPL-3.0-or-later)
%
% Modified:
%   27 March 2025
%
% Author:
%   John Burkardt
%
% Inputs:
%   r_shape     - integer matrix, the region to be tiled.
%   p_num       - integer, the number of polyomino types.
%   p_shapes  - integer 3D array, top-left tight representations of each polyomino.
%   d                - integer vector, number of copies of each polyomino used.
%   x                - binary matrix (x_m × x_n), each column is a tiling solution vector.
%   filename    - string, output image filename (e.g., 'plot01.png').
%   label          - string, label shown on the plot.
%
% Notes:
%   - The solution vector x must match the encoding produced by
%     polyomino_multihedral_matrix.
%   - The variable color_choice (set below) controls coloring behavior:
%     1: all polyominoes same color
%     2: each placed polyomino gets a unique color
%     3: each variant gets a unique color
%     4: each polyomino *type* gets a unique color, shared across variants

  % File extension parsing
  [~, ~, ext] = fileparts(filename);
  ext = ext(2:end);
  if strcmp(ext, 'jpg')
    ext = 'jpeg';
  end

  color_choice = 4;
  filename2 = filename;

  [a, ~, parent] = polyomino_multihedral_matrix(r_shape, p_num, p_shapes, d);
  [a_m, a_n] = size(a);
  [r_m, r_n] = size(r_shape);
  r_num = sum(r_shape(:));
  r_index = polyomino_index(r_shape);
  [x_m, x_n] = size(x);

  for x_index = 1:x_n
    xc = zeros(x_m, 1);
    xi = zeros(x_m, 1);

    nz = 0;

    for i = 1:x_m
      if x(i,x_index) == 0
        color = 0;
      else
        nz = nz + 1;
        switch color_choice
          case 1
            color = 1;
          case 2
            color = nz;
          case 3
            color = i;
          case 4
            color = parent(i);
        end
        xc(i) = color;
        xi(i) = nz;
      end
    end

    axc = a(1:r_num,:) * xc;
    axi = a(1:r_num,:) * xi;

    r_color = zeros(r_m, r_n);
    r_label = zeros(r_m, r_n);
    for i = 1:r_m
      for j = 1:r_n
        idx = r_index(i,j);
        if idx ~= 0
          r_color(i,j) = axc(idx);
          r_label(i,j) = axi(idx);
        end
      end
    end

    % Plotting
    clf;
    hold on;
    r_color = flip(r_color);
    r_label = flip(r_label);
    imagesc(r_color);

    lw = 0.04;
    for i = 1:r_m
      for j = 1:r_n
        if r_label(i,j) == 0
          continue;
        end
        % Define tile boundaries
        if i == 1 || r_label(i-1,j) ~= r_label(i,j)
          fill([j-0.5 j+0.5 j+0.5 j-0.5], ...
               [i-0.5-lw i-0.5-lw i-0.5+lw i-0.5+lw], 'k');
        end
        if i == r_m || r_label(i+1,j) ~= r_label(i,j)
          fill([j-0.5 j+0.5 j+0.5 j-0.5], ...
               [i+0.5-lw i+0.5-lw i+0.5+lw i+0.5+lw], 'k');
        end
        if j == 1 || r_label(i,j-1) ~= r_label(i,j)
          fill([j-0.5-lw j-0.5+lw j-0.5+lw j-0.5-lw], ...
               [i-0.5 i-0.5 i+0.5 i+0.5], 'k');
        end
        if j == r_n || r_label(i,j+1) ~= r_label(i,j)
          fill([j+0.5-lw j+0.5+lw j+0.5+lw j+0.5-lw], ...
               [i-0.5 i-0.5 i+0.5 i+0.5], 'k');
        end
      end
    end

    hold off;

    % Set colormap and axis
    switch color_choice
      case 1
        color_num = 2;
      case 2
        color_num = nz + 1;
      case 3
        color_num = x_m + 1;
      case 4
        color_num = p_num + 1;
    end

    caxis([0, color_num - 1]);

    if false
      colormap(gray(color_num));
      cmap = colormap();
      cmap(1,:) = [1 1 1];
      colormap(cmap);
      brighten(0.4);
    else
      colormap(jet(color_num));
      cmap = colormap();
      cmap(1,:) = [1 1 1];
      colormap(cmap);
    end

    title({label; filename2});
    axis equal;
    axis off;

    if ~isempty(ext)
      if strcmp(ext, 'fig')
        savefig(filename2);
      else
        print(['-d' ext], '-r600', filename2);
      end
      fprintf('  Saved plot as "%s"\n', filename2);
    end

    filename2 = filename_inc(filename2);
  end

  return
end