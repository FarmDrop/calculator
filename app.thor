# frozen_string_literal: true

# Main entry point
class App < Thor
  map 'server' => :start_server
  map 'console' => :console

  desc 'start_server', 'Start the application server'
  def start_server
    load
    require 'agoo'

    Agoo::Log.configure(dir: '', console: true, classic: true, colorize: true,
                        states: {
                          INFO: true, DEBUG: true,
                          connect: true, request: true,
                          response: true, eval: true, push: false
                        })
    Agoo::Server.init(9393, '.', graphql: '/graphql')
    Agoo::Server.start
  end

  desc 'console', 'Start a pry console with all files loaded'
  def console
    load
    require 'pry'

    Pry.start
  end

  private

  desc 'load', 'Load required files'
  def load
    lib_path = File.expand_path('lib', __dir__)
    $LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

    require 'calculator'
  end
end
