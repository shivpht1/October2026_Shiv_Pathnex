
FROM ubuntu:22.04

# Create the application directories
RUN mkdir -p /opt/pathnex/files /opt/pathnex/extracted

# COPY copies a regular file from the build context
COPY pathnex-file.txt /opt/pathnex/files/

# ADD can automatically extract a local tar archive
ADD pathnex.tar.gz /opt/pathnex/extracted/

# Display the copied and extracted files
CMD ["ls", "-R", "/opt/pathnex"]
