#!/bin/bash

if [ -f .env ]; then
    echo "Loading environment variables from .env file..."
else
    echo "Error: .env file not found. Please create a .env file with the necessary environment variables."
    exit 1
fi

source .env

# previous checks