function onlineNSP = openBlackrockConnections(address)
%OPENBLACKROCKCONNECTIONS Opens UDP connection between computer and
%Blackrock Neurotech NSPs
%
% CODE PURPOSE
% Establish a connection between the computer running the current MATLAB
% session and the some number of Blackrock Neurotech NSPs. The number of
% NSPs to connect to is determined by the number of IP addresses provided.
%
% SYNTAX
% onlineNSP = openBlackrockConnections(address)
%
% INPUT
% address - the IP address(es) of the network interface cards (NIC)
%           connecting from the current computer to the NSPs (or local
%           network connected to the NSPs). For a single NSP, input can be
%           a string/char of the IP address (ex. '192.168.137.1') or a cell
%           array of strings/chars for multiple NSPs
%           (ex. {'192.168.137.1','192.168.137.177'}).
%
% OUTPUT
% onlineNSP - an integer array representing the indices of the NSPs which
%           successfully established a connection to the computer/MATLAB
%           session
%
% Author: Joshua Adkinson

if ~iscell(address)
    cellstr(address)
end

potentialNSP = false(size(address));
for i=1:length(address)
    try
        cbmex('open','central-addr',address{i},'instance',i-1)
    catch
        continue
    end
    disp(['NSP',int2str(i),' Active'])
    potentialNSP(i) = true;
end
onlineNSP = find(potentialNSP);

end