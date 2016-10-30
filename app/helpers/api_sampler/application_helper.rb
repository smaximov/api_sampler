# frozen_string_literal: true
module ApiSampler
  module ApplicationHelper
    def sortable_column(name, column)
      link_to sorter.sort_by(column) do
        concat name
        concat ' '
        concat sorter.sort_dir(column)
      end
    end

    # @return [String, nil]
    #   the color assigned to the tag, if any.
    def tag_color(tag)
      ApiSampler.config.tag_color(tag)
    end

    private

    attr_reader :sorter
  end
end
