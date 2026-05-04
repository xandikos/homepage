FROM debian:sid-slim
ADD . /code
RUN apt -y update && apt -y install make man2html python3-pip && \
    python3 -m pip install --break-system-packages mkdocs mkdocs-material && \
    cd /code && make html && \
    apt -y purge python3-pip && apt -y autoremove
RUN apt -y install node-static
EXPOSE 8080
CMD node /usr/bin/node-static -a 0.0.0.0 /code/site
