ARG ELASTIC_VER=6.8.10
ARG SUDACHI_PLUGIN_VER=2.0.2

FROM docker.elastic.co/elasticsearch/elasticsearch:${ELASTIC_VER}

ARG ELASTIC_VER
ARG SUDACHI_PLUGIN_VER

RUN wget https://github.com/WorksApplications/Sudachi/releases/download/v0.1.0/sudachi-0.1.0-dictionary-full.zip && \
    unzip -o -d config/sudachi -j  'sudachi-0.1.0-dictionary-full.zip'  && \
    rm -f sudachi-0.1.0-dictionary-full.zip && \
    bin/elasticsearch-plugin install https://github.com/WorksApplications/elasticsearch-sudachi/releases/download/v${ELASTIC_VER}-${SUDACHI_PLUGIN_VER}/analysis-sudachi-${ELASTIC_VER}-${SUDACHI_PLUGIN_VER}.zip && \
    bin/elasticsearch-plugin install analysis-icu
