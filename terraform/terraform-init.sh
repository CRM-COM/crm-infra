#!/bin/bash

terraform init -backend-config=../environments/$1/env.tfvars