#!/bin/bash
docker service rm IBGateway-Service && \

docker service create \
            --name IBGateway-Service \
            --network iConnect \
            --dns 8.8.8.8 \
            --dns 8.8.4.4 \
            --reserve-memory=2GB \
            --replicas 1 \
            --secret iStrategy-IBKR-TWS_USERID \
            --secret iStrategy-IBKR-TWS_PASSWORD \
            --env-file /home/ubuntu/project/ib-gateway-docker/.env \
            -e TZ=America/Chicago \
            --mount type=bind,source=/opt/iTradeBot/configuration/jts.ini,target=/root/Jts/jts.ini \
            --publish published=4001,target=4001,mode=host \
            --publish published=4002,target=4002,mode=host \
            --publish published=5900,target=5900,mode=host \
            715153891427.dkr.ecr.us-east-2.amazonaws.com/ib_gateway-image:stable