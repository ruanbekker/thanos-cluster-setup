FROM busybox
#ADD https://github.com/thanos-io/thanos/releases/download/v0.15.0/thanos-0.15.0.linux-amd64.tar.gz /tmp/thanos.tar.gz
#RUN tar -xf /tmp/thanos.tar.gz && mv /tmp/thanos-0.15.0.linux-amd64/thanos /bin/thanos && chmod +x /bin/thanos
ADD thanos /bin/thanos
RUN chmod +x /bin/thanos
ENV THANOS_SIDECAR_ENDPOINT1 localhost
ENV THANOS_SIDECAR_ENDPOINT2 localhost
ENV THANOS_STORE_GW_ENDPOINT localhost
ENTRYPOINT [ "/bin/thanos" ]
CMD        [ "query", \
             "--http-address=0.0.0.0:29090", \
             "--query.replica-label=replica", \
             "--store=prometheus-a.localdns.xyz:10901", \
             "--store=prometheus-b.localdns.xyz:10901", \
             "--store=thanos-store-api.localdns.xyz:10901", \
             "--store=thanos-receive.localdns.xyz:10901" ]
