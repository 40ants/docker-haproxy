Haproxy Docker Image With Correct Logging
=========================================

This image includes `haproxy`_ + `rsyslog`_, correctly supervised by `s6`_.

Usage
-----

Test how it does work::

  docker run --rm -ti --name test-haproxy -p 1080:80 40ants/haproxy:1.8.20

Then open in browser http://localhost:1080/


Prepare for production
----------------------

Replace example haproxy config /etc/haproxy.cfg with your own, and ensure you have these
options::

  global
      log /dev/log local0

This will tell Haproxy to write log to rsyslog's socket. Rsyslog is configured to redirect
all messages to container's stdout.

S6 is supervise both processes and handles system signals, making container to shutdown gracefully
when you hit ``Ctrl-C`` or ``docker stop my-proxy``.

Used resources
--------------

This images is used some ideas from these posts:

* https://ops.tips/gists/haproxy-docker-container-logs/
* http://www.gilesorr.com/blog/haproxy-static-content.html


.. _s6: https://skarnet.org/software/s6/
.. _haproxy: http://www.haproxy.org
.. _rsyslog: https://www.rsyslog.com
