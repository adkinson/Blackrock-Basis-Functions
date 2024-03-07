function stopBlackrockRecordings(savefile,onlineNSP,camRec,closeConnections)
%STOPBLACKROCKRECORDINGS Terminates data acquisition of Blackrock NSPs and
%other peripherals in the BSLMC EMU
%
% CODE PURPOSE
% Terminates the recording of data through the Blackrock Neurotech NSPs
% plus any other desired peripheral devices.
%
% SYNTAX
% stopBlackrockRecordings(onlineNSP,camRec,closeConnections)
%
% INPUT
% onlineNSP - an integer array representing the indices of the NSPs which
%           successfully established a connection to the computer/MATLAB
%           session
% camRec - a boolean indicating whether peripheral cameras are to be
%           recorded
% closeConnections - a boolean to determie whether to close the UDP
%           connections between the current MATLAB session and the
%           Blackrock Neurotech NSPs
%
% Author: Joshua Adkinson

%% Stopping Recording
try
    % Stop NSPs
    for i = flip(onlineNSP)
        if camRec && i==1
            cbmex('digitalout',2,'disable','instance',i-1)
            pause(0.05)
            cameraControl('stop',savefile)
        end
        cbmex('fileconfig','','',0,'instance',i-1,'option','none')
    end
    % Close cbmex connection
    if closeConnections
        closeBlackrockConnections(onlineNSP)
    end
catch ME
    msgbox({'An error occurred while starting Blackrock recordings.','Please manually stop BlackRock recordings.',['Error: ',ME.message]},'Error: Recording Stop','warn')
    rethrow(ME)
end

end