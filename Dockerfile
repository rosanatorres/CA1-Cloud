FROM alpine:3.13.2 AS builder

# Install all dependencies required for compiling busybox
RUN apk add gcc musl-dev make perl

# Download busybox sources
RUN wget https://busybox.net/downloads/busybox-1.35.0.tar.bz2 \
  && tar xf busybox-1.35.0.tar.bz2 \
  && mv /busybox-1.35.0 /busybox

# Create a new user to secure running commands
RUN adduser -D static


#Get the content of WebDev CA1 from GitHub
RUN wget https://github.com/rosanatorres/DevCA1/archive/main.tar.gz \
  && tar xf main.tar.gz \
  && rm main.tar.gz \
  && mv /DevCA1-main /home/static

# Change working directory
WORKDIR /busybox

# Install a custom version of BusyBox
COPY .config .
RUN make && make install

# Switch to the scratch image
FROM scratch

EXPOSE 8080

# Copy user and BusyBox
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /busybox/_install/bin/busybox /

# Copy the content of WebDev CA1 to the scratch image
COPY --from=builder /home/static /home/static

# Switch to our non-root user and their work directory
USER static

WORKDIR /home/static/DevCA1-main

# Uploads a blank default httpd.conf
# This is only needed in order to set the `-c` argument in this base file
# and save the developer the need to override the CMD line in case they ever
# want to use a httpd.conf

# httpd.conf
COPY httpd.conf .

# When a container is constructed, issue commands are executed.
CMD ["/busybox", "httpd", "-f", "-v", "-p", "8080", "-c", "httpd.conf"]
