#!/usr/bin/env python3
import os
import socketserver

class MyTCPHandler(socketserver.BaseRequestHandler):
    def handle(self):
        self.data = self.request.recv(1024).strip()

class ThreadedTCPServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
    pass

if __name__ == "__main__":
    HOST, PORT = os.environ.get('HEALTHCHECK_HOST', "0.0.0.0"), int(os.environ.get('HEALTHCHECK_PORT', 9999))

    with ThreadedTCPServer((HOST, PORT), MyTCPHandler) as server:
        server.serve_forever()