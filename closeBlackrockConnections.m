function closeBlackrockConnections(onlineNSP)
%CLOSEBLACKROCKCONNECTIONS Closes the UDP connection between computer and
%Blackrock Neurotech NSPs
%
% CODE PURPOSE
% Close the USP connection between the computer running the current MATLAB
% session and the some number of Blackrock Neurotech NSPs. Note that UDP
% connections have to be closed in the reverse order from which they were
% initiated.
%
% SYNTAX
% closeBlackrockConnections(address)
%
% INPUT
% onlineNSP - an integer array representing the indices of the NSPs which
%           successfully established a connection to the computer/MATLAB
%           session
%
% Author: Joshua Adkinson

for i = flip(onlineNSP)
        cbmex('close','instance',i-1)
end

end