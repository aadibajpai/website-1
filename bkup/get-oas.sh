#!/bin/bash
#
# Copyright (c) My Tiki, Inc.
# MIT license. See LICENSE file in root directory.
#
# Used during continuous integration github workflow to get the rendered
# aws OAS3 documentation from API Gateway.

mkdir ./infrastructure/files
aws apigateway get-export \
    --rest-api-id $1 \
    --stage-name $2 \
    --export-type oas30 \
    --region $3 \
    ./infrastructure/files/oas-rendered.json
