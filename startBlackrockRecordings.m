function [camRec] = startBlackrockRecordings(savefile,onlineNSP,camRec,comment)
%STARTBLACKROCKRECORDINGS Initiates data acquisition of Blackrock NSPs and
%other peripherals in the BSLMC EMU
%
% CODE PURPOSE
% Initiate the recording of data through the Blackrock Neurotech NSPs plus
% any other desired peripheral devices connected to the NSPs with the
% intention of synchronizing that data to said NSPs. This code also
% attemptes to ensure that all Blackrock recordings were properly initiated
% and will generate 'reattempt' recordings if the recording initially
% failed. Note only one reattempt is possible before the function throws an
% error.
%
% SYNTAX
% [camRec] = startBlackrockRecordings(savefile,onlineNSP,camRec,comment)
%
% INPUT
% savefile - a string/char array of the desired filename to be used for any
%           recordings collected from the utilization of this function.
%           File extensions and file paths are stripped from the provided
%           savefile input
% onlineNSP - an integer array representing the indices of the NSPs which
%           successfully established a connection to the computer/MATLAB
%           session
% camRec - a boolean indicating whether peripheral cameras are to be
%           recorded
% comment - a char array written to the Blackrock recording files. Useful
%           for providing notes and added information to the Blackrock
%           header files. Note that 'comment' is limited to 256 characters.
%
% OUTPUT
% camRec - a boolean indicating whether peripheral cameras are currently
%           recording
%
% Author: Joshua Adkinson
%
% NOTE: This function uses some functions that can be found in the
% following GitHub repository: https://github.com/adkinson/MATLAB_Utilities

%% Default Inputs
[filepath,saveFilename] = fileparts(savefile);
if isempty(filepath)
    filepath = 'C:\Users\User\Desktop\DATA';
end
savefile = fullfile(filepath,saveFilename);

if nargin<4
    comment = '';
end
timerNSP = uint64(zeros(size(onlineNSP)));
recordingCheckMax = 2; % How long (in seconds) to wait before declaring the recording failed to start.


%% Time Check for Video
if camRec
    camRec = cameraTimeCheck();
end


%% Blackrock Filename Suffix Check
if numel(onlineNSP)==1
    suffix = {[]};
else
    suffix = strcat(repmat({'_NSP-'},numel(onlineNSP),1),cellstr(num2str(onlineNSP(:))));
end


%% Starting Acquisitions
try
    % Start Cameras
    if camRec
        cameraControl('start',saveFilename)
    end
    % Start NSPs
    for i = onlineNSP(:).'
        cbmex('fileconfig',[savefile,suffix{i}],comment,1,'instance',i-1)
        timerNSP(i) = tic;
    end
    % Check NSP Recordings Started
    %NEW
    pause(0.05)
    rec = false;
    while ~rec && toc(timerNSP(numel(timerNSP)))<recordingCheckMax
        isrec = checkBlackrockRecordings(onlineNSP);
        rec = all(isrec);
    end
    if ~rec
        fprintf('One of the File Storage Apps failed to initialize a recording.\nAffected File: %s\nReattempting initiation and resetting timers...\n',savefile)
        for i = onlineNSP(:).'
            cbmex('fileconfig',[savefile,suffix{i},'_reattempt'],'',1,'instance',i-1,'option','none')
        end
    end
    
    % Send Starting Comment
    for i = onlineNSP(:).'
        cbmex('comment', 255, 0,['NSP',int2str(i),' Recording Started'],'instance',i-1);
    end

    %OLD
%     for i = onlineNSP
%         isrec = false;
%         while ~isrec && toc(timerNSP(i))<recordingCheckMax
%             isrec = cbmex('fileconfig','instance',i-1);
%         end
%         recStartTime = toc(timerNSP(i));
%         if ~isrec
%             error('CBMEX:NoRecording',['No recording detected on NSP',int2str(i),'.'])
%         end
%         fprintf('Recording on NSP%d officially started %d seconds after cbmex(''fileconfig'').\n',i,recStartTime);
%         cbmex('comment', 255, 0,['NSP',int2str(i),' Recording Started'],'instance',i-1);
%     end

    % Initiate Camera FrameStart Triggering Signal from NSP
    if camRec && any(onlineNSP==1)
        cbmex('digitalout',2,'timed','frequency','input',30,'value',50,'instance',onlineNSP(onlineNSP==1)-1)
    end
catch ME
    msgbox({'An error occurred while starting Blackrock recordings: ',ME.message},'Error: Recording Start','warn');
    if ~strcmp(ME.identifier,'CBMEX:NoRecording')
        stopBlackrockRecordings(savefile,onlineNSP,true,false)
    end
    rethrow(ME)
end

end