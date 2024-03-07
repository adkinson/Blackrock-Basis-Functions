function isrec = checkBlackrockRecordings(onlineNSP)
%CHECKBLACKROCKRECORDINGS Checks whether recordings are currently being
%collected on the Blackrock Neurotech NSPs/Central Software Suites
%currently connected to the MATLAB session
%
% CODE PURPOSE
% Determines whether the Blackrock Neurotech NSPs and their respective
% Central Software Suites which already have UDP connections to the current
% MATLAB session (see OPENBLACKROCKCONNECTIONS) are currently
% recording/collecting data.
%
% NOTE
% This function can serve a number of technical purposes:
% (1) The main purpose: are the NSPs currently recording?
% (2) Sometimes Central may initiate a recording but fail to generate the
%   files necessary for data to be collected resulting in the remaining
%   generated files being corrupted/empty. Fortunately, even if the Central
%   GUI shows a recording is occuring visually, checking with this function
%   will return a FALSE state, allowing the user to mitigate any data
%   collection failures.
% (3) Running CHECKBLACKROCKRECORDINGS without a connection to the NSPs
%   will result in an error notifying the the UDP interface is closed
%
% SYNTAX
% isrec = checkBlackrockRecordings(onlineNSP)
%
% INPUT
% onlineNSP - an integer array representing the indices of the NSPs which
%           successfully established a connection to the computer/MATLAB
%           session
%
% OUTPUT
% isrec - an boolean array representing the recording state of the
%           connected NSPs, 1 representing that recordings are taking place 
%           place and 0 otherwise.
%
% Author: Joshua Adkinson

isrec = false(size(onlineNSP));
for i = onlineNSP
    isrec(i) = cbmex('fileconfig','instance',i-1);
end

end