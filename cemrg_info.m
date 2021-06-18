function cemrg_info(msg, condition2print)
% CEMRG INFO. Function for output to console based. Use jointly with
% sprintf. A breakline (\n) character is always concatenated to the message.
% 
% USAGE: cemrg_info("Hello, splitvent!", condition2print);
% 
% confition2print = true (default), 
% if condition2print == false, then nothing gets shown in console.
% 

if nargin < 2
    condition2print = true;
end

if condition2print == true
    fprintf([msg '\n']);
end

