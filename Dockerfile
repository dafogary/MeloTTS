# Use a CUDA-enabled base image with Python
FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

# Install system dependencies and Python
RUN apt update && apt install -y \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    build-essential \
    libsndfile1 \
    nano \
    mecab \
    libmecab-dev \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Install PyTorch and other Python dependencies
RUN pip3 install torch==1.9.0+cu111 torchvision==0.10.0+cu111 torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html

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
