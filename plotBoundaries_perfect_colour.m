function plotBoundaries_perfect_colour(M,lineWidth)
% PLOTBOUNDARIES_PERFECT_COLOUR draws chromino boundaries in a tiling solution 
% perfectly without 'notched' or 'crossed' corners. The tiles are coloured differently
% if they represent distinct free polyominoes (up to rotation/reflection).
%
% Discussion:
% The input M is a 2D integer matrix representing a tiling solution. Each nonzero entry 
% corresponds to a unit square that belongs to a tile, and all entries with the same 
% positive integer represent squares belonging to the same polyomino. Zeros indicate 
% empty grid cells.
%
% This version detects which tiles correspond to the same free polyomino (i.e., same
% shape under rotation/reflection) and assigns a unique colour to each distinct shape.
% The pastel colour palette is designed to visually match the style used in 
% POLYOMINO_MULTIHEDRAL_TILING_PLOT with color_choice = 4.
%
% Inputs:
%   M             - a 2D integer matrix representing a tiling solution,
%                     where integers are >= 1 for squares of the chromino, and zero for holes
%   lineWidth - the width of lines used to draw the boundaries of the tiles
%
% Licensing:
%   This code is covered by the GNU General Public License (GPL).
%   See the LICENSE file for details.
%   (SPDX-License-Identifier: GPL-3.0-or-later)
%
% Modified: April 1, 2025
%
% Author:
%   Marcus Garvie
%
%  Note:
%    Some technical issues were resolved with the aid of ChatGPT 4o

% Get grid size and unique tile IDs
[n, m] = size(M);
tile_ids = unique(M(M > 0));

% Classify tile shapes up to rotation and reflection
tile_shapes = containers.Map('KeyType','double','ValueType','any');
shape_to_color_idx = containers.Map();
shape_id_counter = 0;

% Loop over each tile ID and identify its canonical (symmetry-invariant) shape
for id = tile_ids'
    % Extract coordinates of squares in this tile
    [r, c] = find(M == id);
    coords = [c, r];
    coords = coords - min(coords, [], 1);

    % Generate all 8 symmetry variants (rotations + reflections)
    variants = cell(8,1);
    k = 1;
    for reflect = [false, true]
        for rot = 0:3
            A = coords;
            if reflect
                A(:,1) = -A(:,1);
            end
            theta = rot * pi/2;
            R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
            A = round(A * R');
            A = A - min(A, [], 1);
            variants{k} = sortrows(A);
            k = k + 1;
        end
    end

    % Select canonical form (lex smallest of all variants)
    canonical = variants{1};
    for j = 2:8
        if lex_compare(variants{j}, canonical) < 0
            canonical = variants{j};
        end
    end

    % Assign a unique ID to this canonical shape
    key = mat2str(canonical);
    if ~isKey(shape_to_color_idx, key)
        shape_id_counter = shape_id_counter + 1;
        shape_to_color_idx(key) = shape_id_counter;
    end
    tile_shapes(id) = shape_to_color_idx(key);
end

% Generate pastel version of JET colormap with one colour per shape
base_colors = jet(shape_id_counter + 1);
base_colors(1,:) = [];  % remove colour for background (index 0)
blend_factor = 0.2;     % blend with white for pastel effect
color_map = base_colors + blend_factor * (1 - base_colors);

% Set up figure and axes
figure;
hold on;
axis equal;
set(gca, 'YDir', 'reverse');  % Make (1,1) appear top-left
set(gcf, 'Color', 'w');
axis off;

% Define edge directions and associated line segments
dirs = [0 -1; 1 0; 0 1; -1 0];  % [dx, dy] for each direction (clockwise)
edges = {
    [0 0; 1 0],  % top edge
    [1 0; 1 1],  % right edge
    [1 1; 0 1],  % bottom edge
    [0 1; 0 0]   % left edge
};

% Loop through each tile and draw its boundary
for id = tile_ids'
    edgeSet = containers.Map;

    % Identify boundary edges of the current tile
    for row = 1:n
        for col = 1:m
            if M(row, col) == id
                for d = 1:4
                    dr = dirs(d,2);
                    dc = dirs(d,1);
                    rr = row + dr;
                    cc = col + dc;

                    % Add edge if neighbouring square is different or out of bounds
                    if rr < 1 || rr > n || cc < 1 || cc > m || M(rr, cc) ~= id
                        base = [col-1, row-1];
                        e = edges{d} + base;
                        key = sprintf('%.3f,%.3f;%.3f,%.3f', e(1,1), e(1,2), e(2,1), e(2,2));
                        edgeSet(key) = e;
                    end
                end
            end
        end
    end

    % Assemble the boundary edges into a closed polygon
    E = values(edgeSet);
    segments = cat(3, E{:});
    V = segments(:,:,1);
    used = false(size(segments,3),1);
    used(1) = true;
    poly = V(1,:);
    curr = V(2,:);

    % Walk through edges to construct ordered boundary
    while true
        poly(end+1,:) = curr;
        found = false;
        for i = 1:size(segments,3)
            if used(i), continue; end
            v1 = segments(:,:,i);
            if all(abs(v1(1,:) - curr) < 1e-6)
                curr = v1(2,:);
                used(i) = true;
                found = true;
                break;
            elseif all(abs(v1(2,:) - curr) < 1e-6)
                curr = v1(1,:);
                used(i) = true;
                found = true;
                break;
            end
        end
        if ~found || all(abs(curr - poly(1,:)) < 1e-6)
            break;
        end
    end

    % Assign pastel colour based on shape ID
    color_idx = tile_shapes(id);
    face_col = color_map(mod(color_idx-1, size(color_map,1)) + 1, :);

    % Draw the polygon with PATCH (clean boundaries, no artifacts)
    patch('XData', poly(:,1), 'YData', poly(:,2), ...
          'FaceColor', face_col, 'EdgeColor', 'k', 'LineWidth', lineWidth);
end

end

% Lexicographic comparison function for shape canonicalization
function out = lex_compare(A, B)
    for i = 1:min(size(A,1), size(B,1))
        d = A(i,:) - B(i,:);
        if any(d ~= 0)
            out = sign(d(find(d,1)));
            return;
        end
    end
    out = sign(size(A,1) - size(B,1));
end