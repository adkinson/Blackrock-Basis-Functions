function closeConnections = checkBlackrockConnection(onlineNSP,address)
%CHECKBLACKROCKCONNECTION Check the UDP connection between computer and Blackrock Neurotech NSPs
%
% CODE PURPOSE
% Check the connection between the computer running the current MATLAB
% session and the some number of Blackrock Neurotech NSPs. The number of
% NSPs to connect to is determined by the number of IP addresses provided.
%
% SYNTAX
% closeConnections = checkBlackrockConnection(address)
%
% INPUT
% onlineNSP - an integer array representing the indices of the NSPs which
%           successfully established a connection to the computer/MATLAB
%           session
% address - the IP address(es) of the network interface cards (NIC)
%           connecting from the current computer to the NSPs (or local
%           network connected to the NSPs). For a single NSP, input can be
%           a string/char of the IP address (ex. '192.168.137.1') or a cell
%           array of strings/chars for multiple NSPs (ex.
%           {'192.168.137.1','192.168.137.177'})
%
% OUTPUT
% closeConnections - a boolean to notify whether the connection of the NSPs
%           to the current MATLAB session needs to be closed and reopened.
%
% Author: Joshua Adkinson

closeConnections = false;
for i = onlineNSP(:).'
    try
        isrec = cbmex('fileconfig','instance',i-1);
        if ~isrec
            error('CBMEX:NoRecording',['No recording detected on NSP',int2str(i),'.'])
        end
    catch ME
        switch ME.identifier
            case 'CBMEX:NoRecording'
                fprintf('\n%s\n',ME.message)
            otherwise
                fprintf('Connection to NSP%d needs to be restarted.',i)
                try
                    cbmex('open','central-addr',address{i},'instance',i-1);
                catch ME2
                    fprintf('Reconnection to NSP%d unsuccessful. Stop recording manually!!!',i)
                    rethrow(ME2)
                end
                fprintf('Reconnection to NSP%d successful.',i)
                closeConnections = true;
        end
    end
end
end