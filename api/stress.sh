#!/bin/bash
for i in {1..10000}; do
  curl http://simplecrud.com/docs
  sleep $1
done
