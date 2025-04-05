function polyomino_monohedral_tiling_plot(r, p, x, filename, label)
% POLYOMINO_MONOHEDRAL_TILING_PLOT Visualizes monohedral polyomino tilings.
%
% This function plots tilings of a given region using a single polyomino
% shape, allowing for rotations and reflections. It can visualize multiple
% tiling solutions and export the images to files.
%
% Inputs:
%   r        - Binary matrix representing the region to tile.
%   p        - Binary matrix representing the polyomino shape.
%   x        - Binary matrix (nvars x nsols), solution vectors.
%   filename - String, base name for image file(s) (e.g., 'tiling01.png').
%   label    - String, label for the image title.
%
% Licensing:
%   This code is covered by the GNU General Public License (GPL).
%   See the LICENSE file for details.
%   (SPDX-License-Identifier: GPL-3.0-or-later)
%
% Modified:
%   30 March 2025
%
% Author:
%   John Burkardt, Marcus Garvie (edited)

  % Plot options
  color_choice = 1;  % 1 = uniform color, 2 = unique visible colors, 3 = unique all
  
  % Process filename properly
  [path, name, ext] = fileparts(filename);
  
  % Handle the extension - ensure we have it without the dot
  if ~isempty(ext)
    ext = ext(2:end);  % remove '.'
    if strcmp(ext, 'jpg'), ext = 'jpeg'; end
  end
  
  % Make sure we have proper path construction
  if ~isempty(path)
    base_filename = fullfile(path, name);
  else
    base_filename = name;
  end

  [mp, np] = size(p);
  [mr, nr] = size(r);
  [mx, nx] = size(x);

  [mn_num, mn_v, nm_num, nm_v] = polyomino_monohedral_variants(mp, np, p);
  
  % Use base_filename2 without extension for logic below
  base_filename2 = base_filename;
  
  for x_index = 1 : nx
%
%  The array S is our representation of the tiling.
%  S starts as a zeroed out version of R.
%
    s1 = zeros ( mr, nr );
    s2 = zeros ( mr, nr );
%
%  Start the variable count at 0.
%
    var = 0;
    nz = 0;
%
%  Handle the variants which have shape (MP,NP) like P.
%  Store the actual representation of the variant in Q.
%
    for k = 1 : mn_num

      mq = mp;
      nq = np;
      q = mn_v(1:mq,1:nq,k);
%
%  Determine the number of ways, and the corresponding offsets, by which
%  Q can be placed on R.
%
      number = polyomino_embed_number ( mr, nr, r, mq, nq, q );

      list = polyomino_embed_list ( mr, nr, r, mq, nq, q, number );
%
%  For each placement VAR, check whether it is part of the solution.
%  If so, we can mark the corresponding entries of S with VAR.
%
      for l = 1 : number
        var = var + 1;
        if ( x(var,x_index) == 1 )
          nz = nz + 1;
          if ( color_choice == 1 )
            color = 1;
          elseif ( color_choice == 2 )
            color = nz;
          elseif ( color_choice == 3 )
            color = var;
          end
          ioff = list(l,1);
          joff = list(l,2);
          s1(1+ioff:mq+ioff,1+joff:nq+joff) = ...
            s1(1+ioff:mq+ioff,1+joff:nq+joff) + color * q(1:mq,1:nq);
          s2(1+ioff:mq+ioff,1+joff:nq+joff) = ...
            s2(1+ioff:mq+ioff,1+joff:nq+joff) + nz * q(1:mq,1:nq);
        end
      end

    end
%
%  Similar procedure for the variants of P that have shape (N,M).
%
    for k = 1 : nm_num

      mq = np;
      nq = mp;
      q = nm_v(1:mq,1:nq,k);

      number = polyomino_embed_number ( mr, nr, r, mq, nq, q );
 
      list = polyomino_embed_list ( mr, nr, r, mq, nq, q, number );

      for l = 1 : number
        var = var + 1;
        if ( x(var,x_index) == 1 )
          nz = nz + 1;
          if ( color_choice == 1 )
            color = 1;
          elseif ( color_choice == 2 )
            color = nz;
          elseif ( color_choice == 3 )
            color = var;
          end
          ioff = list(l,1);
          joff = list(l,2);
          s1(1+ioff:mq+ioff,1+joff:nq+joff) = ...
            s1(1+ioff:mq+ioff,1+joff:nq+joff) + color * q(1:mq,1:nq);
          s2(1+ioff:mq+ioff,1+joff:nq+joff) = ...
            s2(1+ioff:mq+ioff,1+joff:nq+joff) + nz * q(1:mq,1:nq);
        end
      end

    end
%
%  Clear figure.
%  Prepare for overlaying multiple graphics commands.
%
    clf
    hold on
%
%  Before calling imagesc, we want to flip each column.
%
    s1 = flip ( s1 );
    s2 = flip ( s2 );
%
%  Display the solution as a matrix.
%
    imagesc ( s1 );

    lw = 0.04;

    for i = 1 : mr
      for j = 1 : nr

        if ( s2(i,j) ~= 0 ) 
%
%  Horizontal separator above.
%
          if ( i == 1 )
            xl = [j - 0.5 - lw, j + 0.5 + lw, j + 0.5 + lw, j - 0.5 - lw ];
            yl = [i - 0.5 - lw, i - 0.5 - lw, i - 0.5 + lw, i - 0.5 + lw ];
            fill ( xl, yl, 'k' );
          elseif ( s2(i-1,j) == 0 )
            xl = [j - 0.5,      j + 0.5,      j + 0.5,      j - 0.5      ];
            yl = [i - 0.5 - lw, i - 0.5 - lw, i - 0.5 + lw, i - 0.5 + lw ];
            fill ( xl, yl, 'k' );
          elseif ( s2(i-1,j) ~= s2(i,j) )
            xl = [j - 0.5, j + 0.5, j + 0.5,      j - 0.5      ];
            yl = [i - 0.5, i - 0.5, i - 0.5 + lw, i - 0.5 + lw ];
            fill ( xl, yl, 'k' );
          end
%
%  Horizontal separator below.
%
          if ( i == mr )
            xl = [j - 0.5,      j + 0.5,      j + 0.5,      j - 0.5      ];
            yl = [i + 0.5 + lw, i + 0.5 + lw, i + 0.5 - lw, i + 0.5 - lw ];
            fill ( xl, yl, 'k' );
          elseif ( s2(i+1,j) == 0 )
            xl = [j - 0.5,      j + 0.5,      j + 0.5,      j - 0.5      ];
            yl = [i + 0.5 + lw, i + 0.5 + lw, i + 0.5 - lw, i + 0.5 - lw ];
            fill ( xl, yl, 'k' );
          elseif ( s2(i+1,j) ~= s2(i,j) )
            xl = [j - 0.5, j + 0.5, j + 0.5,      j - 0.5      ];
            yl = [i + 0.5, i + 0.5, i + 0.5 - lw, i + 0.5 - lw ];
            fill ( xl, yl, 'k' );
          end
%
%  Vertical separator to left.
%
          if ( j == 1 )
            xl = [ j - 0.5 - lw, j - 0.5 + lw, j - 0.5 + lw, j - 0.5 - lw ];
            yl = [ i - 0.5 - lw, i - 0.5 - lw, i + 0.5 + lw, i + 0.5 + lw ];
            fill ( xl, yl, 'k' );
          elseif ( s2(i,j-1) == 0 )
            xl = [ j - 0.5 - lw, j - 0.5 + lw, j - 0.5 + lw, j - 0.5 - lw ];
            yl = [ i - 0.5 - lw, i - 0.5 - lw, i + 0.5 + lw, i + 0.5 + lw ];
            fill ( xl, yl, 'k' );
          elseif ( s2(i,j-1) ~= s2(i,j) )
            xl = [ j - 0.5,      j - 0.5 + lw, j - 0.5 + lw, j - 0.5      ];
            yl = [ i - 0.5 - lw, i - 0.5 - lw, i + 0.5 + lw, i + 0.5 + lw ];
            fill ( xl, yl, 'k' );
          end
%
%  Vertical separator to right.
%
          if ( j == nr )
            xl = [ j + 0.5 - lw, j + 0.5 + lw, j + 0.5 + lw, j + 0.5 - lw ];
            yl = [ i - 0.5 - lw, i - 0.5 - lw, i + 0.5 + lw, i + 0.5 + lw ];
            fill ( xl, yl, 'k' );
          elseif ( s2(i,j+1) == 0 )
            xl = [ j + 0.5 - lw, j + 0.5 + lw, j + 0.5 + lw, j + 0.5 - lw ];
            yl = [ i - 0.5 - lw, i - 0.5 - lw, i + 0.5 + lw, i + 0.5 + lw ];
            fill ( xl, yl, 'k' );
          elseif ( s2(i,j+1) ~= s2(i,j) )
            xl = [ j + 0.5 - lw, j + 0.5,      j + 0.5,      j + 0.5 - lw ];
            yl = [ i - 0.5 - lw, i - 0.5 - lw, i + 0.5 + lw, i + 0.5 + lw ];
            fill ( xl, yl, 'k' );
          end

        end
      end
    end

    hold off
%
%  Coloring option 1:
%  0 = white for blank space.
%  1 = light blue for all polyominoes.
%
    if ( color_choice == 1 )

      color_num = 2;
      caxis ( [ 0, 1 ] );
%
%  Coloring option 2:
%  Allow a color for each nonzero variable, plus 0=white.
%
    elseif ( color_choice == 2 )
      color_num = nz + 1;
      caxis ( [ 0, nz ] );
%
%  Coloring option 3:
%  Allow a color for each variable, plus 0=white.
%
    elseif ( color_choice == 3 )
      var_num = var;
      color_num = var_num + 1;
      caxis ( [ 0, var_num ] );
    end

    colormap ( jet ( color_num ) );
    cmap = colormap ( );
    cmap(1,1:3) = [ 1, 1, 1 ];
    colormap ( cmap );

%
%  Use the same scale for X and Y directions.
%
    axis ( 'equal' )
%
%  Don't display the graph axes.
%
    axis ( 'off' )
%
%  Save a version of the plot.
%  Handle different file saving scenarios explicitly
%
    if ( isempty ( ext ) )
      % If no extension is provided, save as fig by default
      fig_filename = [base_filename2, '.fig'];
      savefig(fig_filename);
      fprintf(1, '  Saved plot as "%s"\n', fig_filename);
    elseif ( strcmp(ext, 'fig') )
      % If .fig extension is provided
      fig_filename = [base_filename2, '.', ext];
      savefig(fig_filename);
      fprintf(1, '  Saved plot as "%s"\n', fig_filename);
    else
      % For other image formats
      img_filename = [base_filename2, '.', ext];
      device = ['-d', ext];
      print(device, '-r600', img_filename);
      
      % Also save a .fig file in addition to the requested format
      fig_filename = [base_filename2, '.fig'];
      savefig(fig_filename);
      fprintf(1, '  Saved plot as "%s"\n', img_filename);
      fprintf(1, '  Also saved as "%s"\n', fig_filename);
    end

    % pause ( 5 )

    % Update the base filename for the next iteration
    base_filename2 = filename_inc(base_filename2);

  end

  return
end