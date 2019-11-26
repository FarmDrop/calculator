# frozen_string_literal: true
require 'bundler/setup'

require 'dotenv'
Dotenv.load

require 'calculator/initializers/constants'

require 'calculator/repositories/delivery_slot'
require 'calculator/repositories/delivery_cost'
