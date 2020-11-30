FROM ubuntu:latest
# docker run -it --net=host phasip/openldap
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /
RUN apt-get update && apt-get install -y git build-essential libltdl-dev groff-base file
RUN git clone https://github.com/openldap/openldap.git
ENV CC=gcc
ENV CFLAGS='-Og -g'
RUN cd /openldap \
    && ./configure \
    && make depend \
    && make \
    && make install

COPY initial_config /usr/local/etc/openldap/slapd.conf
RUN cat /usr/local/etc/openldap/slapd.conf
RUN ls -la /usr/local/etc/openldap/slapd.conf
COPY initial_data /initial_data
RUN mkdir /usr/local/var/openldap-data
RUN slapadd -l /initial_data
ENV PATH="$PATH:/usr/local/libexec/"
ENTRYPOINT ["/usr/local/libexec/slapd","-h","ldap://:1389/","-d","256"]
