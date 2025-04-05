<b>Repository:</b>

<em>CHROMINOES</em> is a collection of computer programs in MATLAB which uses integer linear programming (ILP) techniques 
and a generalized checkerboard colouring method to tile regions of the plane with sets of polyominoes. Note that the codes here generalize the 2-colour tiling approach at the 'Pariominoes' respository linked below. The programs are designed to be used with a high-performance MILP solver, either CPLEX or Gurobi. Users can also solve tiling problems 
without the use of colouring techniques if they want.

<b>Usage:</b>

To use use these programs you need to do the following three steps:

<ol type="i">
  <li>Construct the linear system in <code>MATLAB</code> and export the corresponding LP file to <code>CPLEX</code> or <code>Gurobi</code>.</li>
  <li>Solve the LP file using <code>CPLEX</code> or <code>Gurobi</code>, and export the solution file back to <code>MATLAB</code>.</li>
  <li>Extract and process the solution file in <code>MATLAB</code> for visualization.</li>
</ol>

<p>
  The repository contains <code>LP make files</code> for generating the ILP files and scripts for reproducing and plotting results from Section 5 in the reference given below, and are easily adapted to solve other problems. In the uncoloured case, <code>PLOT_MONO</code> and <code>PLOT_MULTI</code> generate monohedral and multihedral tiling plots, respectively. For coloured tilings, <code>PLOT_VARIOMINO</code>, optionally used in combination with <code>MAGNIFIED_COMBINED_BEST</code>, produces plots and zoomed-in views of solution regions. <code>FINDALLCHROMPLOT</code> plots all chromino variants for a given polyomino and number of colours. Each <code>MATLAB</code> file includes usage instructions in its initial comment section.
</p>

<b>References:</b>

<p>
  Garvie, M. R., & Burkardt, J. (2025). <i>A Generalized Colouring Method for a Parallelizable Integer Linear Programming Approach to Polyomino Tiling</i>. Preprint submitted to <i>Theoretical Computer Science</i>, April 4, 2025. <br>
  <em>Departments of Mathematics & Statistics, University of Guelph, ON, Canada; and Mathematics, University of Pittsburgh, PA, USA.</em>
</p>

<p><b>Related Repositories:</b></p>
<ul>
  <li><a href="https://github.com/jvburkardt/polyominoes" target="_blank">polyominoes</a> – ILP methods for tiling problems</li>
  <li><a href="https://github.com/jvburkardt/pariominoes" target="_blank">pariominoes</a> – Parallel computing approaches for polyomino tiling using ILP and a 2-colour approach</li>
</ul>

<b>License:</b>

<p>
  All programs in this repository are covered by the <strong>GNU General Public License (GPL)</strong>. 
  For details, please refer to the <code>LICENSE</code> file included in the repository. 
  <br>
  <em>SPDX-License-Identifier: GPL-3.0-or-later</em>
</p>

<p>
  All queries should be addressed to Marcus R. Garvie (<a href="mailto:mgarvie@uoguelph.ca">mgarvie@uoguelph.ca</a>).
</p>








