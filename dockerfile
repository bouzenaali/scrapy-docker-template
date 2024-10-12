FROM python:3.11

WORKDIR /app

COPY . /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    gcc \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    locales \
    python3-venv && \
    rm -rf /var/lib/apt/lists/*

# Set locale to handle dates in French properly (optional)
RUN echo "fr_FR.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=fr_FR.UTF-8

# Set locale environment variables
ENV LANG=fr_FR.UTF-8
ENV LC_ALL=fr_FR.UTF-8

# Create a virtual environment for the Python project
RUN python3 -m venv /app/venv

# Activate the virtual environment and install Python dependencies
RUN /app/venv/bin/pip install --upgrade pip
RUN /app/venv/bin/pip install -r requirements.txt

# Make sure the virtual environment is activated in every RUN command
SHELL ["/bin/bash", "-c"]

# Expose a volume so you can easily access output data (e.g., scraped files)
VOLUME ["/app/data"]

# run your Scrapy spider
CMD ["/bin/bash", "-c", "source /app/venv/bin/activate && cd /app/schedule && scrapy crawl example -o /app/data/output.csv"]