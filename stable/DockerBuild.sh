#!/bin/bash

docker build -t ib_gateway-image:stable .

docker run -d   --name InteractiveBroker.Gateway \
                --network iConnect \
                --ip 10.0.1.10 \
                --restart always \
                --env-file .env \
                -p 4001:4001 \
                -p 4002:4002 \
                -p 5900:5900 \
                715153891427.dkr.ecr.us-east-2.amazonaws.com/ib_gateway-image:stable

# ###########################################################################
# The following is using docker service
#
#   Use following command to create secrets:
#   =========================================================================
#   printf "***********" | docker secret create iStrategy-IBKR-TWS_USERID -
#   printf "***********" | docker secret create iStrategy-IBKR-TWS_PASSWORD -
#   =========================================================================
#
# ###########################################################################
docker service rm IBGateway-Service     # remove existing services
docker service create \
            --name IBGateway-Service \
            --network iConnect \
            --reserve-memory=2GB \
            --replicas 1 \
            --secret iStrategy-IBKR-TWS_USERID \
            --secret iStrategy-IBKR-TWS_PASSWORD \
            --env-file .env \
            --publish published=4001,target=4001,mode=host \
            --publish published=4002,target=4002,mode=host \
            --publish published=5900,target=5900,mode=host \
            715153891427.dkr.ecr.us-east-2.amazonaws.com/ib_gateway-image:stable