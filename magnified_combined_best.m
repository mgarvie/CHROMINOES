function magnified_combined_best(figFile, pngFile, matFile, mad_factor, radius, resolution)
% MAGNIFIED_COMBINED_BEST renders a high-resolution image and overlays a magnifier tool.
%
%  Discussion:
% The function `magnified_combined_best` enhances visualization of scientific data by 
% providing a three-stage process: (1) converting a MATLAB FIG file to a high-resolution 
% PNG image with optimized rendering settings, (2) transforming this image into a MAT file 
% for efficient data handling, and (3) displaying the result with an interactive magnification 
% tool that allows detailed exploration of specific regions. This facilitates both 
% broad overview and fine-detail examination of complex visualizations in a single workflow.
%
%    This function carries out the following three steps:
%    1. Converts a .fig file to a high-resolution .png image.
%    2. Converts the .png image into a .mat file for later use.
%    3. Launches an interactive magnifier window for exploring image detail.
%
%  Licensing:
%    This code is covered by the GNU General Public License (GPL).
%    See the LICENSE file for details.
%    (SPDX-License-Identifier: GPL-3.0-or-later)
%
%  Modified:
%    29 March 2025
%
%  Author:
%    Marcus Garvie, 
%
%  Note:
%    Some technical issues were resolved with the aid of ChatGPT 4o and Claude 3.7 Sonnet
%
%  Input:
%    string figFile: the .fig file to convert and magnify.
%    string pngFile: output .png image filename.
%    string matFile: output .mat image filename (contains RGB image data).
%    real mad_factor: magnification factor for the zoomed view.
%    real radius: physical magnifier radius (in inches).
%    real resolution: resolution (in DPI) used for rendering.
%
%  Example usage:
%    magnified_combined_best('test.fig', 'test.png', 'test.mat', 8, 2.0, 900)

  % Convert radius from inches to pixels
  radius = radius * resolution;

  % Load default MATLAB sound
  load gong.mat;

  % Step 1: Save high-resolution PNG image
  saveHighResBinarizedImage(figFile, pngFile, resolution);

  % Step 2: Convert PNG image to MAT file
  convertImageToMat(pngFile, matFile);

  % Step 3: Launch magnifier tool
  magnifier_alt(matFile, mad_factor, radius, resolution, y, Fs);

end

function saveHighResBinarizedImage(figFile, pngFile, resolution)
  % Open the figure file with default settings
  fig = openfig(figFile, 'invisible');
  
  % Enhanced figure configuration for better quality
  set(fig, 'PaperPositionMode', 'auto');
  set(fig, 'Color', 'white');  % Ensure consistent background
  set(fig, 'InvertHardcopy', 'off');  % Preserve figure colors exactly
  
  % Try to use exportgraphics (better quality) if available (MATLAB R2020a+)
  if exist('exportgraphics', 'file')
    try
      % First attempt with painters (good for vector content)
      set(fig, 'Renderer', 'painters');
      drawnow;
      exportgraphics(fig, pngFile, 'Resolution', resolution, 'BackgroundColor', 'white', 'ContentType', 'image');
      fprintf('  High-resolution image saved to %s using exportgraphics/painters\n', pngFile);
    catch
      try
        % If painters fails, try opengl (better for complex graphics)
        set(fig, 'Renderer', 'opengl');
        drawnow;
        exportgraphics(fig, pngFile, 'Resolution', resolution, 'BackgroundColor', 'white', 'ContentType', 'image');
        fprintf('  High-resolution image saved to %s using exportgraphics/opengl\n', pngFile);
      catch
        % Fall back to print function if exportgraphics fails
        set(fig, 'Renderer', 'opengl');
        drawnow;
        print(fig, pngFile, '-dpng', ['-r' num2str(resolution)]);
        fprintf('  High-resolution image saved to %s using print (fallback)\n', pngFile);
      end
    end
  else
    % Fall back to original method if exportgraphics not available
    try
      % First attempt with painters
      set(fig, 'Renderer', 'painters');
      drawnow;
      print(fig, pngFile, '-dpng', ['-r' num2str(resolution)]);
    catch
      % If painters fails, try opengl
      set(fig, 'Renderer', 'opengl');
      drawnow;
      print(fig, pngFile, '-dpng', ['-r' num2str(resolution)]);
    end
    fprintf('  High-resolution image saved to %s\n', pngFile);
  end
  
  close(fig);
end

function convertImageToMat(imageFile, matFile)
  img_rgb = imread(imageFile);
  save(matFile, 'img_rgb');
  fprintf('  Image data saved to %s\n', matFile);
end

function magnifier_alt(img_file, mad_factor, radius, resolution, y, Fs)

  FPS = 20;

  if endsWith(img_file, '.mat')
    data = load(img_file);
    if isfield(data, 'img_rgb')
      img_rgb = data.img_rgb;
    else
      error('The .mat file does not contain variable ''img_rgb''.');
    end
  else
    error('The provided file is not a .mat file.');
  end

  img_rgb = double(img_rgb) ./ 255;
  size_img = size(img_rgb);

  if length(size_img) < 2
    error('The image data is not valid.');
  end

  MagPower = mad_factor;
  MagRadius = radius;
  BorderThickness = 64;
  PreMagRadius = round(MagRadius ./ MagPower);

  close all;

  % Enable graphics smoothing with caution
  try
    set(0, 'DefaultFigureGraphicsSmoothing', 'on');
  catch
    % If not supported in this MATLAB version, continue without it
  end

  MainAxesSize = [size_img(2), size_img(1)];
  MainFigureHdl = figure('Name', 'Magnifier Demo v0.01', ...
    'NumberTitle', 'off', ...
    'Units', 'pixels', ...
    'Position', [300, 50, MainAxesSize], ...
    'MenuBar', 'figure', ...
    'Color', 'white', ... % Explicitly set figure background to white
    'Renderer', 'opengl', ...
    'WindowButtonMotionFcn', @stl_magnifier_WindowButtonMotionFcn, ...
    'WindowButtonDownFcn', {@saveMagnifiedImage, y, Fs, resolution});

  MainAxesHdl = axes('Parent', MainFigureHdl, ...
    'Units', 'normalized', ...
    'Position', [0 0 1 1], ...
    'XLim', [1, MainAxesSize(1)], ...
    'YLim', [1, MainAxesSize(2)], ...
    'YDir', 'normal', ...
    'NextPlot', 'add', ...
    'Visible', 'on');

  imshow(img_rgb);
  mag_img_hdl = imshow([], 'Parent', MainAxesHdl);

  extendedRadius = MagRadius + BorderThickness;
  [x, y] = meshgrid(-extendedRadius:extendedRadius);
  dist = sqrt(x.^2 + y.^2);

  mask_img = double(dist <= extendedRadius);
  border_mask = double(dist <= extendedRadius & dist >= MagRadius);
  final_mask = mask_img - border_mask;
  final_mask(final_mask < 0) = 0;

  set(mag_img_hdl, 'AlphaData', final_mask);

  conversionFactor = 72 / resolution;
  border_hdl = rectangle('Position', [1 1 1 1], ...
    'EdgeColor', 'k', ...     % change 'k' to 'b' if you want border of circle to be blue
    'LineWidth', BorderThickness * conversionFactor, ...
    'Curvature', [1 1], ...
    'Visible', 'off', ...
    'Parent', MainAxesHdl);

  alreadyDrawn = 0;
  start_time = tic;

  function stl_magnifier_WindowButtonMotionFcn(~, ~)
    cur_time = toc(start_time);
    curFrameNo = floor(cur_time * FPS);
    if alreadyDrawn < curFrameNo
      mag_pos = get(MainAxesHdl, 'CurrentPoint');
      mag_pos = mag_pos(1, 1:2);

      mag_x = mag_pos(1) + [-PreMagRadius, PreMagRadius];
      mag_y = mag_pos(2) + [-PreMagRadius, PreMagRadius];
      mag_x_cropped = min(max(mag_x, 1), size_img(2));
      mag_y_cropped = min(max(mag_y, 1), size_img(1));
      x_range = round(mag_x_cropped(1):mag_x_cropped(2));
      y_range = round(mag_y_cropped(1):mag_y_cropped(2));
      if isempty(x_range) || isempty(y_range), return; end

      mag_img_part = img_rgb(y_range, x_range, :);
      % Try bicubic first, fall back to other methods if issues occur
      try
        mag_img_part_resized = imresize(mag_img_part, ...
          [2 * extendedRadius + 1, 2 * extendedRadius + 1], 'bicubic');
      catch
        % Fall back to simpler interpolation if bicubic fails
        mag_img_part_resized = imresize(mag_img_part, ...
          [2 * extendedRadius + 1, 2 * extendedRadius + 1], 'bilinear');
      end

      set(mag_img_hdl, ...
        'CData', mag_img_part_resized, ...
        'XData', mag_pos(1) + [-extendedRadius, extendedRadius], ...
        'YData', mag_pos(2) + [-extendedRadius, extendedRadius]);

      set(border_hdl, 'Position', ...
        [mag_pos(1) - MagRadius, mag_pos(2) - MagRadius, ...
         2 * MagRadius, 2 * MagRadius], ...
        'Visible', 'on');

      drawnow;
      alreadyDrawn = curFrameNo;
    end
  end

  function saveMagnifiedImage(~, ~, y, Fs, resolution)
    sound(y, Fs);
    
    % Try using exportgraphics first for better quality
    if exist('exportgraphics', 'file')
      try
        exportgraphics(MainAxesHdl, 'magnified_image.png', 'Resolution', resolution, 'BackgroundColor', 'white');
        fprintf('  Magnified image saved as magnified_image.png using exportgraphics\n');
        return;
      catch
        fprintf('  Warning: exportgraphics failed, trying alternate methods\n');
      end
    end
    
    % First try saving with simple print method
    try
      print(MainFigureHdl, 'magnified_image.png', '-dpng', ['-r' num2str(resolution)]);
      fprintf('  Magnified image saved as magnified_image.png\n');
    catch
      fprintf('  Warning: Simple print method failed, trying alternate method\n');
      try
        % If print fails, try getframe method
        frame = getframe(MainAxesHdl);
        imwrite(frame.cdata, 'magnified_image.png');
        fprintf('  Magnified image saved as magnified_image.png using getframe\n');
      catch
        fprintf('  Warning: All image saving methods failed.\n');
      end
    end    
  end

end