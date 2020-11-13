import socket
def goget(page):
	s = socket.socket()
	s.connect((page, 80))
	s.send('GET / HTTP/1.0\r\nHost: '+page+'\r\nUser-Agent: danisawesome/0.1\r\n\r\n')
	r = s.recv(1024)
	print(r)
goget('dandart.co.uk')
print('Really reminds you of simpler days.')
print('''How about some nice Bach?''')

