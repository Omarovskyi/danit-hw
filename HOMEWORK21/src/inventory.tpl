[webservers]
%{ for ip in instance_ips ~}
${ip}
%{ endfor ~}