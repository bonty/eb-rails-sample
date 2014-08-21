#!/bin/bash
docker run -i -t --rm \
    -v /app/rails_app:/app \
    rails_app:latest \
    bash -c "cd /app && eval '$1'"
