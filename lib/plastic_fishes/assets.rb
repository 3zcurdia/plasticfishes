# frozen_string_literal: true

module PlasticFishes
  # Assets logic to read assets filanmes and filepaths
  module Assets
    module_function

    def filenames
      file_paths.map do |path|
        sanitize_filepath(path)
      end
    end

    def file_paths
      Dir[File.join(__dir__, "../../public/*.png")]
    end

    def sanitize_filepath(path)
      path.split('/').last.sub('.png', '')
    end
  end
end
