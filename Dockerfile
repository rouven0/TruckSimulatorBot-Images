# syntax=docker/dockerfile:1

FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY app/ .

CMD gunicorn server:app -b 0.0.0.0:9001 --error-logfile -
