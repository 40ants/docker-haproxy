FROM haproxy:1.8.20

# RUN apk upgrade --update					&&  \
#     apk add bash ca-certificates rsyslog git gcc                &&  \
#     # here's the catch: by creating a soft-link that 
#     # links /var/log/haproxy.log to /dev/stdout whatever 
#     # rsyslogd writes to the file will endup being
#     # propagated to the standard output of the container
#     ln -sf /dev/stdout /var/log/system.log

RUN apt-get update					&&  \
    apt-get --yes install rsyslog git gcc make          &&  \
    # here's the catch: by creating a soft-link that 
    # links /var/log/haproxy.log to /dev/stdout whatever 
    # rsyslogd writes to the file will endup being
    # propagated to the standard output of the container
    ln -sf /dev/stdout /var/log/system.log && \
    #
    # Now install s6 supervisor
    #
    mkdir -p /tmp/s6 && cd /tmp/s6 && \
    git clone https://github.com/skarnet/skalibs && \
    cd skalibs && ./configure && make install && cd /tmp/s6 && \
    git clone https://github.com/skarnet/execline && \
    cd execline && ./configure && make install && cd /tmp/s6 && \
    git clone https://github.com/skarnet/s6 && \
    cd s6 && ./configure && make install && \
    cd / && rm -fr /tmp/s6 && \
    #
    # And do cleanup
    #
    apt-get remove --yes git gcc make && \
    apt-get autoremove --yes



# Include our configurations (`./etc` contains the files that we'd
# need to have in the `/etc` of the container).
COPY ./etc/ /etc/

# Include our custom entrypoint that will the the job of lifting
# rsyslog alongside haproxy.
COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 80

# Set our custom entrypoint as the image's default entrypoint
# ENTRYPOINT [ "/entrypoint.sh" ]
ENTRYPOINT ["s6-svscan", "/etc/s6"]

# Make haproxy use the default configuration file
# CMD [ "-f", "/etc/haproxy.cfg" ]
