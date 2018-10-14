FROM python:3-alpine3.8

WORKDIR /app

ENV FLASK_APP response_mocker.py

COPY requirements.txt /app
COPY response_mocker.py /app

RUN apk add --update \
    curl && \
    rm -rf /var/cache/apk/*

RUN pip3 install -r requirements.txt

ENTRYPOINT ["python3", "response_mocker.py"]
