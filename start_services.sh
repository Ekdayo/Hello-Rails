#!/bin/bash

# Start Prometheus Exporter
bundle exec prometheus_exporter &

# Start Rails server
bundle exec rails server -b 0.0.0.0 -p 3040

