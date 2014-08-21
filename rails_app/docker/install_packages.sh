#!/bin/sh

# Add repositories
apt-get -y update

# Install packages
apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y install \
    build-essential \
    curl \
    wget \
    unzip \
    git-core \
    libcurl4-openssl-dev \
    libreadline-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    zlib1g-dev \
    autoconf \
    libc6-dev \
    ncurses-dev \
    automake \
    make \
    sqlite3 \
    libsqlite3-dev

# Install ruby
curl -O http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz
tar -zxvf ruby-2.1.2.tar.gz
cd ruby-2.1.2
./configure --disable-install-doc
make
make install
cd ..
rm -fr ruby-2.1.2 ruby-2.1.2.tar.gz
echo 'gem: --no-document' > /usr/local/etc/gemrc

# Install bundler
echo 'gem: --no-rdoc --no-ri' >> /.gemrc
gem install bundler

# Cleanup
apt-get clean
rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*
