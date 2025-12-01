# Use a more recent Debian base so apt repos are available
FROM python:3.10-slim-bullseye

# Install needed system packages (no 'upgrade' to speed up & avoid issues)
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
      gcc \
      build-essential \
      libffi-dev \
      libssl-dev \
      ffmpeg \
      aria2 \
      mediainfo \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

# Use pip to install python deps; ensure requirements.txt contains pytube if needed
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000
ENV COOKIES_FILE_PATH="youtube_cookies.txt"

# Start both web and bot in the same container (minimal approach)
CMD bash -lc "PORT=${PORT:-8000}; echo running on $PORT; gunicorn --workers 3 --bind 0.0.0.0:${PORT} app:app & python3 main.py"
