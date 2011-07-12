function qpHandle = connect(machine)
%make the connection:
% here should provide:
% URL: string
% user: username string
% password: user's password string

URL = sprintf('10.10.%d.101/qpapi', machine);
user = 'zwang';
if machine == 11
  password = 'EovrzuPa4C';
else
  password = 'zwang2011'
end

qpHandle = qpapiConnect(URL, user, password);
