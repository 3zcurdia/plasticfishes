# frozen_string_literal: true

require_relative "assets"

module PlasticFishes
  # A simulated database model
  class Fishes
    def initialize
      @list = Assets.filenames.to_h do |filename|
        [filename, builder(filename)]
      end.freeze
    end

    def all = list.values
    def find(id) = list[id]
    def include?(id) = list.key?(id)
    def random = list[random_key]
    def random_key = list.keys.sample

    private

    attr_reader :list

    def builder(key)
      {
        id: key,
        name: key.tr("-", " ").capitalize,
        uuid: SecureRandom.uuid,
        number: SecureRandom.hex(3).to_i(16),
        bigint: SecureRandom.hex(32).to_i(16),
        text: lipsum.sample(20).join(" ").capitalize,
        api_path: "/api/fishes/#{key}",
        web_path: "/fishes/#{key}",
        image_path: "/images/#{key}.png",
        created_at: Time.now.utc.iso8601
      }
    end

    def lipsum
      @lipsum ||= %w[lorem ipsum dolor sit amet consectetur adipisicing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua ut enim ad minim veniam quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur excepteur sint occaecat cupidatat non proident sunt in culpa qui officia deserunt mollit anim id est laborum]
    end
  end
end
