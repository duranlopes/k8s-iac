#!/bin/bash
for i in {1..10000}; do
  curl http://192.168.124.134:30000/docs
  sleep $1
done
