FROM alpine:3.6
LABEL maintainer="neutron37@protonmail.com"

# Ensure the latest packages.
RUN apk --no-cache update && apk --no-cache upgrade

# Build prerequisites will be removed later in build.
RUN apk --no-cache --virtual .build-deps add build-base \
    ca-certificates \
    libffi-dev \
    openssl-dev \
    python3-dev

# Required packages.
RUN apk --no-cache add bash \
    python3 \
    openntpd \
    tzdata

# Fix-up Python
WORKDIR /usr/bin
RUN python3 -m ensurepip
RUN rm -r /usr/lib/python*/ensurepip
RUN pip3 install --upgrade pip setuptools
RUN if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi
RUN  ln -s idle3 idle \
  && ln -s pydoc3 pydoc \
  && ln -s python3 python \
  && ln -s python3-config python-config
ENV LANG C.UTF-8

# Install ansible from source artifact.
COPY artifacts/ansible /ansible
RUN pip install -r /ansible/requirements.txt

# Cleanup.
WORKDIR /
RUN apk del .build-deps
RUN rm -r /root/.cache

# Create entrypoint
COPY artifacts/dansible /dansible
ENTRYPOINT ["dansible"]

# Copy over environment-specific, generated files.
COPY artifacts/ansible_content /ansible_content