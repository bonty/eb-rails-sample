#!/bin/sh
cd /app
exec /sbin/setuser app bundle exec unicorn -c config/unicorn.rb
