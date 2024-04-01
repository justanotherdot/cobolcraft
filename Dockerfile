FROM debian:bookworm-slim

# Install dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y tini gcc g++ make gnucobol && rm -rf /var/lib/apt/lists/*

# Copy source files
COPY Makefile .
COPY server.cob .
COPY CBL_GC_SOCKET ./CBL_GC_SOCKET

# Build
RUN make

# Include runtime dependencies
ENV COB_PRE_LOAD=CBL_GC_SOCKET:CBL_GC_SOCKET/CBL_GC_SOCKET.so

# Run the server within Tini (to handle signals properly)
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["./server"]
