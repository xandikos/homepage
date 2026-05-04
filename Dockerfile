FROM python:3-slim AS builder
RUN pip install --no-cache-dir mkdocs mkdocs-material
ADD . /code
RUN apt-get update && apt-get install -y --no-install-recommends make man2html && \
    rm -rf /var/lib/apt/lists/*
RUN make -C /code html

FROM nginx:alpine
COPY --from=builder /code/site /usr/share/nginx/html
EXPOSE 80
