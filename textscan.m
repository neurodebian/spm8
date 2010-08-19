function varargout = textscan(varargin)

if strcmp(varargin{end-1}, 'delimiter')
  if ischar(varargin{1})
    s = varargin{1};
  else
    s = fread(varargin{1}, Inf);
  end
  out = {};
  i = 1;
  while 1,
    ind = strfind(s, varargin{end});
    if isempty(ind)
       out{i,1} = s;
       break
    end
    sub = s(1:ind(1)-1);
    s = s(ind(1)+1:end);
    out{i,1} = sub;
    i = i + 1;
  end
  varargout{1} = {out};
else
  if ischar(varargin{1})
      varargout = sscanf(varargin{:});
  else
      filename = readlink(['/proc/self/fd/' num2str(varargin{1})]);
      [a b c d] = textread(filename, varargin{2:end});
      varargout{1} = {a, b, c, d};
  end
end
