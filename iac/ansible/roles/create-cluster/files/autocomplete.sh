#!/bin/bash

kubectl completion bash > /etc/bash_completion.d/kubectl

source <(kubectl completion bash)