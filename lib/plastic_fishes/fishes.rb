# frozen_string_literal: true

require_relative "assets"

module PlasticFishes
  # A simulated database model
  class Fishes
    def initialize
      @list = Assets.filenames.map do |filename|
        [filename, builder(filename)]
      end.to_h.freeze
    end

    def all
      list.values
    end

    def find(id)
      list[id]
    end

    def include?(id)
      list.key?(id)
    end

    def random
      list[random_key]
    end

    def random_key
      list.keys.sample
    end

    private

    attr_reader :list

    def builder(key)
      {
        id: key,
        name: key.tr("-", " ").capitalize,
        uuid: SecureRandom.uuid,
        number: SecureRandom.hex(3).to_i(16),
        bigint: SecureRandom.hex(32).to_i(16),
        text: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        api_path: "/api/fishes/#{key}",
        web_path: "/fishes/#{key}",
        image_path: "/#{key}.png",
        created_at: Time.now.utc.iso8601
      }
    end
  end
end
