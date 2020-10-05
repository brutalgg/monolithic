FROM brutalgg/generic

LABEL maintainer="LanCache.Net Team <team@lancache.net>"

ENV GENERICCACHE_VERSION=2 \
    CACHE_MODE=monolithic \
    CACHE_MEM_SIZE=500m \
    CACHE_DISK_SIZE=1000000m \
    CACHE_MAX_AGE=3560d \
    CACHE_SLICE_SIZE=1m \
    UPSTREAM_DNS="8.8.8.8 8.8.4.4" \
    BEAT_TIME=1h \
    LOGFILE_RETENTION=3560 \
    CACHE_DOMAINS_REPO="https://github.com/uklans/cache-domains.git" \
    CACHE_DOMAINS_BRANCH=master \
    NGINX_WORKER_PROCESSES=auto

COPY overlay/ /

RUN \
# Update and get dependencies
  apt-get update && \
  apt-get install -y \
  jq \
  git \
  && \
# Cleanup
  apt-get -y autoremove && \
  apt-get -y clean && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /tmp/* && \
  rm -rf var/tmp/* && \
# Create directories
  mkdir -m 755 -p /data/cachedomains	;\
	mkdir -m 755 -p /tmp/nginx				  ;

RUN git clone --depth=1 --no-single-branch https://github.com/uklans/cache-domains/ /data/cache-domains

VOLUME ["/data/logs", "/data/cache", "/data/cachedomains", "/var/www"]

EXPOSE 80
WORKDIR /scripts
