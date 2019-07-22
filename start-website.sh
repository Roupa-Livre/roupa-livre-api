#!/bin/bash

bundle check || bundle install

puma -C config/puma.rb