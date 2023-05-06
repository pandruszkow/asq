FROM python:3.11-slim-buster AS base

RUN set -ex
RUN apt-get update
# Must install terminfo, or else backspace won't work
RUN apt-get install libtinfo6
RUN pip install --no-cache-dir --upgrade pip
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM base as requirementstxt
WORKDIR /app
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

FROM requirementstxt AS app
COPY . /app/

CMD ["bash", "asq.sh"]
