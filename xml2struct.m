function s = xml2struct(file)
% XML2STRUCT Converts an XML file into a MATLAB structure.
%
% Given an XML file, this function parses its contents into a nested
% MATLAB structure with fields corresponding to elements, attributes, and text.
%
% Inputs:
%   file - String, path to the XML file to be read.
%
% Outputs:
%   s    - Struct containing parsed XML data.
%
% Notes:
%   Characters in tag and attribute names are replaced:
%     '-' becomes '_dash_'
%     ':' becomes '_colon_'
%     '.' becomes '_dot_'
%
% Licensing:
%   This code is covered by the GNU General Public License (GPL).
%   See the LICENSE file for details.
%   (SPDX-License-Identifier: GPL-3.0-or-later)
%
% Modified:
%   26 March 2025
%
% Original Authors:
%   W. Falkena, ASTI, TUDelft, 2010
%   A. Wanner, 2011
%   I. Smirnov, 2012
%   X. Mo, University of Wisconsin, 2012

  if nargin < 1
    clc;
    help xml2struct
    return
  end

  if isa(file, 'org.apache.xerces.dom.DeferredDocumentImpl') || ...
     isa(file, 'org.apache.xerces.dom.DeferredElementImpl')
    xDoc = file;
  else
    if exist(file, 'file') == 0
      if isempty(strfind(file, '.xml'))
        file = [file '.xml'];
      end
      if exist(file, 'file') == 0
        error(['The file ' file ' could not be found']);
      end
    end
    xDoc = xmlread(file);
  end

  s = parseChildNodes(xDoc);

end

function [children, ptext, textflag] = parseChildNodes(theNode)
  children = struct;
  ptext = struct; textflag = 'Text';

  if hasChildNodes(theNode)
    childNodes = getChildNodes(theNode);
    numChildNodes = getLength(childNodes);

    for count = 1:numChildNodes
      theChild = item(childNodes, count-1);
      [text, name, attr, childs, textflag] = getNodeData(theChild);

      if ~strcmp(name, '#text') && ~strcmp(name, '#comment') && ~strcmp(name, '#cdata_dash_section')
        if isfield(children, name)
          if ~iscell(children.(name))
            children.(name) = {children.(name)};
          end
          index = length(children.(name)) + 1;
          children.(name){index} = childs;
          if ~isempty(fieldnames(text))
            children.(name){index} = text;
          end
          if ~isempty(attr)
            children.(name){index}.Attributes = attr;
          end
        else
          children.(name) = childs;
          if ~isempty(text) && ~isempty(fieldnames(text))
            children.(name) = text;
          end
          if ~isempty(attr)
            children.(name).Attributes = attr;
          end
        end
      else
        ptextflag = 'Text';
        if strcmp(name, '#cdata_dash_section')
          ptextflag = 'CDATA';
        elseif strcmp(name, '#comment')
          ptextflag = 'Comment';
        end
        if ~isempty(regexprep(text.(textflag), '[\s]*', ''))
          if ~isfield(ptext, ptextflag) || isempty(ptext.(ptextflag))
            ptext.(ptextflag) = text.(textflag);
          else
            ptext.(ptextflag) = [ptext.(ptextflag) text.(textflag)];
          end
        end
      end
    end
  end
end

function [text, name, attr, childs, textflag] = getNodeData(theNode)
  name = toCharArray(getNodeName(theNode))';
  name = strrep(name, '-', '_dash_');
  name = strrep(name, ':', '_colon_');
  name = strrep(name, '.', '_dot_');

  attr = parseAttributes(theNode);
  if isempty(fieldnames(attr))
    attr = [];
  end

  [childs, text, textflag] = parseChildNodes(theNode);

  if isempty(fieldnames(childs)) && isempty(fieldnames(text))
    text.(textflag) = toCharArray(getTextContent(theNode))';
  end
end

function attributes = parseAttributes(theNode)
  attributes = struct;
  if hasAttributes(theNode)
    theAttributes = getAttributes(theNode);
    numAttributes = getLength(theAttributes);
    for count = 1:numAttributes
      str = toCharArray(toString(item(theAttributes, count-1)))';
      k = strfind(str, '=');
      attr_name = str(1:k(1)-1);
      attr_name = strrep(attr_name, '-', '_dash_');
      attr_name = strrep(attr_name, ':', '_colon_');
      attr_name = strrep(attr_name, '.', '_dot_');
      attributes.(attr_name) = str(k(1)+2:end-1);
    end
  end
end