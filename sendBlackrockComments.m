function sendBlackrockComments(comment,onlineNSP,commentColor)
%SENDBLACKROCKCOMMENTS Wrapper function sending comments to potentially
%multiple NSPs
%
% CODE PURPOSE
% Send a comment created by the user to a specified number of NSP devices
% based on the 'onlineNSP' variable
%
% SYNTAX
% sendBlackrockComments(comment,onlineNSP)
%
% INPUT
% comment - a string/char array to be sent to all NSP devices. Note that
%           comments longer than 92 characters are truncated
% onlineNSP - an integer array representing the indices of the NSPs which
%           successfully established a connection to the computer/MATLAB
%           session
%
% Author: Joshua Adkinson
if nargin<3
    commentColor = 16777215; %red
end
if length(comment)>92
    warning('Input comment exceeds 92 character limit. Comment will be truncated on the recording.');
end
for i = onlineNSP(:).'
    cbmex('comment', commentColor, 0, comment,'instance',i-1)
end

end