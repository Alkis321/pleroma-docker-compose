#!/bin/bash

export $(grep -v '^#' .env | xargs)
envsubst < docker-compose.yml | docker stack deploy -c - dutchman