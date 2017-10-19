% pop_ImportERPsFormat() - Import ERPscore Format average files.
%
% Usage:
%   >>  OUTEEG = pop_ExportOpenFormat( INEEG, EpochPts, OffsetPts );
%
% Inputs:
%   INEEG       - input EEG continuous dataset
%   EpochPts    - NPts per epoch.
%   OffsetPts   - NPts to offset beginning of each epoch.
%    
% Outputs:
%   OUTEEG  - output dataset
%
% See also:
%   SEGMANTATION, EEGLAB 

% Copyright (C) <2006>  <James Desjardins>
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

function [ALLEEG,EEG]=pop_browsemerge(ALLEEG,varargin)

try
    options = varargin;
    for index = 1:length(options)
        if iscell(options{index}) & ~iscell(options{index}{1}), options{index} = { options{index} }; end;
    end;
    if ~isempty( varargin ); g=struct(options{:});
    else g= []; end;
catch
    disp('pop_browsemerge() error: calling convention {''key'', value, ... } error'); return;
end;


try g.infname; catch; g.infname={};end
try g.infpath; catch; g.infpath=cd;end
try g.outfname; catch; g.outfname='';end
try g.outfpath; catch; g.outfpath=cd;end
try g.manual; catch; g.manual='on';end
try g.useloaded; catch; g.useloaded='off';end

if ischar(g.infname);
    infname=cellstr(g.infname);
else
    infname=g.infname;
end
infpath=g.infpath;
outfname=g.outfname;
outfpath=g.outfpath;
useloaded=g.useloaded;

n_ALLEEG=length(ALLEEG);
if n_ALLEEG>0;
    for i=1:n_ALLEEG;
        loadedsets{i}=ALLEEG(i).filename;
    end
end
% pop up window
% -------------
if nargin < 5 || strcmp(g.manual,'on')
    
    results=inputgui( ...
        'geom', ...
        {...
        {8 10 [0 0] [3 1]} ... %1
        {8 10 [0.7 2] [3.3 1]} ... %2
        {8 10 [0.22 3] [1 1]} ... %3
        {8 10 [0.7 3] [3.3 1]} ... %4
        {8 10 [0.32 4] [1 1]} ... %5
        {8 10 [0.7 4] [3.3 8]} ... %6
        {8 10 [4.7 2] [3.3 1]} ... %7
        {8 10 [4.22 3] [1 1]} ... %8
        {8 10 [4.7 3] [3.3 1]} ... %9
        {8 10 [4.32 4] [1 1]} ... %10
        {8 10 [4.7 4] [3.3 1]} ... %11
        {8 10 [4.7 6] [3.3 1]} ... %12
        {8 10 [4.7 7] [3.3 3]} ... %13
        
        }, ...
        'uilist', ...
        {...
        {'Style', 'text', 'string', 'Select the files and destination:', 'FontWeight', 'bold'} ... %1
        {'Style', 'pushbutton', 'string', 'browse for input set files', ...
        'callback', ...
        ['[HistFName, HistFPath] = uigetfile(''*.set'',''input dataset files:'',''' g.infpath ''',''multiselect'',''on'');', ...
        'if isnumeric(HistFName);return;end;', ...
        'set(findobj(gcbf,''tag'',''edt_hfp''),''string'',HistFPath);', ...
        'set(findobj(gcbf,''tag'',''edt_hfn''),''string'',HistFName);']} ... %2
        {'Style', 'text', 'string', 'path:'} ... %3
        {'Style', 'edit', 'tag','edt_hfp', 'string', g.infpath} ... %4
        {'Style', 'text', 'string', 'file:'} ... %5
        {'Style', 'edit', 'max', 500, 'tag', 'edt_hfn','string',g.infname} ... %6
        {'Style', 'pushbutton','string','browse for output path', ...
        'callback', ...
        ['[BatchFPath] = uigetdir(cd,''output path:'');', ...
        'set(findobj(gcbf,''tag'',''edt_dfp''),''string'',BatchFPath);']} ... %7
        {'Style', 'text', 'string', 'path:'} ... %8
        {'Style', 'edit', 'tag','edt_dfp','string',g.outfpath} ... %9
        {'Style', 'text', 'string', 'file:'} ... %10
        {'Style', 'edit','tag', 'lst_dfn','string',g.outfname} ... %11
        {'Style','checkbox','string','Include currently loaded set files?','Value',1} ... %12
        {'Style','edit','max', 500,'string',loadedsets} ... %13
        }, ...
        'title', 'Dataset file merging GUI -- pop_browsemerge()' ...
        );
    
    if isempty(results);return;end
    
    infpath=    results{1};
    infname=    results{2};
    outfpath=   results{3};
    outfname=   results{4};
    useloaded=  results{5};
    
end;



mrg_ALLEEG=pop_loadset('filename',infname,'filepath',infpath);

n_mrg_ALLEEG=length(mrg_ALLEEG);

if n_ALLEEG>0 && useloaded;
    for i=1:n_ALLEEG;
        mrg_ALLEEG(n_mrg_ALLEEG+i)=ALLEEG(i);
    end
end

disp(['Merging ', num2str(length(mrg_ALLEEG)), ' files...']);

EEG = pop_mergeset(mrg_ALLEEG, 1:length(mrg_ALLEEG), 1);

ALLEEG=mrg_ALLEEG;

pop_saveset( EEG, 'filename',outfname,'filepath',outfpath);


