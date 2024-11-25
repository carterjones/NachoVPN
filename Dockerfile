FROM python:3.12-slim-bookworm
WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libffi-dev \
    libssl-dev \
    osslsigncode \
    msitools \
    mingw-w64 \
    gcc-mingw-w64 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY setup.py .
COPY manifest.in .
COPY requirements.txt .
COPY src/ src/

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir certbot
RUN pip install --no-cache-dir .

EXPOSE 80
EXPOSE 443

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/bin/bash", "-c", "./entrypoint.sh"]