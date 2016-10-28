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

    private

    attr_reader :sorter
  end
end
