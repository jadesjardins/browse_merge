% eegplugin_Import() - Import menu.
function eegplugin_browsemerge(fig,try_strings,catch_strings)

% start up
addpath(genpath(fileparts(which('eegplugin_browsemerge.m'))));


%--------------------------------------------------------------------------
% Get File menu handle...
%--------------------------------------------------------------------------
filemenu=findobj(fig,'Label','File');

% Create "pop_browsemerge" callback cmd.
%------------------------------------------------
cmd='[ALLEEG,EEG]=pop_browsemerge(ALLEEG);';
finalcmdBM=[cmd];

% Add submenus to the "Batch" submenu.
%-------------------------------------
uimenu(filemenu,'label','merge files from browser','callback',finalcmdBM,'separator','on');

