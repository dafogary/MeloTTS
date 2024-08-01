# Stage 1: Base image with NVIDIA support and CUDA
FROM nvidia/cuda:12.2.0-base AS base

# Install system dependencies for CUDA and PyTorch
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    build-essential \
    libsndfile1 \
    nano \
    procps \
    mecab \
    libmecab-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PyTorch and other Python dependencies
RUN pip3 install torch==1.9.0+cu111 torchvision==0.10.0+cu111 torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html

# Stage 2: Application setup
FROM python:3.9-slim

# Install procps to make ps command available
RUN apt-get update && apt-get install -y \
    build-essential \
    libsndfile1 \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy application files
COPY . /app

# Install Python dependencies
RUN pip3 install -e .

# Download additional resources
RUN python3 -m unidic download
RUN python3 melo/init_downloads.py

# Expose the port
EXPOSE 8888

# Set the default command
CMD ["python", "./melo/app.py", "--host", "0.0.0.0", "--port", "8888"]

