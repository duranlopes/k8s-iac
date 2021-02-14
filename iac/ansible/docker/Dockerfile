FROM alpine:3.9
#ENV PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/ansible/.local/bin:/ansible/.gem/ruby/2.5.0/bin'
RUN apk update && apk upgrade && \
  apk add bash git python3 openssh-client openssl \
  py3-paramiko py3-psutil py3-pluggy py3-bcrypt py3-pynacl \
  py3-cryptography py3-cffi py3-docutils py3-rsa py3-click py3-dateutil \
  py3-urllib3 py3-markupsafe py3-pygit2 py3-future py-futures py3-requests \
  py3-ptyprocess py3-mccabe py3-pyflakes py3-chardet py3-certifi \
  py3-atomicwrites py3-attrs py3-py py-openssl \
  libstdc++ g++ make

RUN pip3 install pip --upgrade && \
  pip3 install ansible==2.10.0 pyvmomi==7.0 

RUN  adduser -h /ansible -s /bin/bash -D ansible

USER ansible
WORKDIR /app 
ENV ANSIBLE_STDOUT_CALLBACK='debug'
ADD . /app

