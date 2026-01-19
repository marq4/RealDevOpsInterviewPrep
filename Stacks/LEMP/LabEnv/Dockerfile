FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean

EXPOSE 80

# Simple shell form:
CMD service apache2 start && tail -f /dev/null
