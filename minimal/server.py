import os
import socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)  

IP_ADDRESS  = os.getenv("IP_ADDRESS", '0.0.0.0')
PORT        = os.getenv("PORT", 25565)

sock.bind((IP_ADDRESS, PORT))

while True:
	payload, client_address = sock.recvfrom(4096)
	print(payload)