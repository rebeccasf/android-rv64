# Use Ubuntu as base image
FROM ubuntu:20.04

# Avoid timezone prompt during package configuration
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    git-core \
    gnupg \
    flex \
    bison \
    build-essential \
    zip \
    curl \
    zlib1g-dev \
    gcc-multilib \
    g++-multilib \
    libc6-dev-i386 \
    lib32ncurses5-dev \
    x11proto-core-dev \
    libx11-dev \
    lib32z-dev \
    ccache \
    libgl1-mesa-dev \
    libxml2-utils \
    xsltproc \
    unzip \
    fontconfig \
    python3 \
    python3-distutils \
    openjdk-8-jdk

# Create a symbolic link for Python
RUN ln -s /usr/bin/python3 /usr/bin/python

# Download the Repo tool and ensure it is executable
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo \
  && chmod a+x /usr/local/bin/repo

# Clean up APT when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setting up the working directory
RUN mkdir -p /aosp
WORKDIR /aosp

# Initialize the Repo
RUN repo init -u https://android.googlesource.com/platform/manifest

# Sync the Repo
RUN repo sync -j1

# Setup environment and build the code
CMD source build/envsetup.sh && lunch aosp_x86-eng && make -j$(nproc)

