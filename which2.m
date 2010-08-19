function paths = which2(varargin)
% Hack: Octave does not support which(..., '-a;;')
if ischar(varargin{end}) && strcmp(varargin{end}, '-all')
   paths = which(varargin{:});
   if iscell(path)
       break
   end
   paths = {};
   while 1,
     path = which(varargin{1:end-1});
     if isempty(path)
        break
     end
     paths{end+1} = path;
     [a b c] = fileparts(path);
     rmpath(a);
   end
   for i = 1:length(paths)
     [a b c] = fileparts(paths{i});
     addpath(a);
   end
else
   paths = which(varargin{:});
end
