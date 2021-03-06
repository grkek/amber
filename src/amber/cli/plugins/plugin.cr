require "teeplate"
require "liquid"
require "base64"

require "random/secure"
require "../helpers/helpers"

require "../recipes/file_entries"
require "./fetcher"
require "./installer"

module Amber::Plugins
  class Plugin
    Log = ::Log.for(self)
    getter name : String
    getter directory : String

    def self.can_generate?(name : String)
      template = Fetcher.new(name).fetch
      !(template.nil?)
    end

    def initialize(name : String, directory : String)
      @name = name

      @directory = File.join(directory)
      unless Dir.exists?(@directory)
        Dir.mkdir_p(@directory)
      end
    end

    def generate(action : String, options = nil)
      case action
      when "install"
        log_message "Adding plugin #{name}"
        Installer.new(name).render(directory, list: true, color: true)
      else
        Log.error { "Invalid plugin command".colorize(:light_red) }
      end
    end

    def log_message(msg)
      Log.info { msg.colorize(:light_cyan) }
    end
  end
end
