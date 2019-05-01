FROM haproxy:1.8.20

RUN apt-get update					&&  \
    apt-get --yes install rsyslog git gcc make          &&  \
    #
    # Here's the catch: by creating a soft-link that 
    # links /var/log/system.log to /dev/stdout whatever 
    # rsyslogd writes to the file will endup being
    # propagated to the standard output of the container
    #
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

EXPOSE 80

ENTRYPOINT ["s6-svscan", "/etc/s6"]