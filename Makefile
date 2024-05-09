SHELL := /bin/bash
MAKEFLAGS += --silent
ARGS = $(filter-out $@,$(MAKECMDGOALS))

.default: help

include .env
-include .env.local

include .build/.mk/*/*.mk
include .build/.mk/*.mk
