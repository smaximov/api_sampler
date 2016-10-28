# frozen_string_literal: true

module ApiSampler
  # Mark the columns of an ActiveRecord model as sortable.
  #
  # @example Basic usage
  #   class User < ActiveRecord::Base
  #     include Sortable
  #
  #     sortable :first_name, :last_name
  #     sortable :created_at
  #   end
  #
  # @example Specify default sorting column
  #   class Product < ActiveRecord::Base
  #     include Sortable
  #
  #     sortable_default :name
  #   end
  #
  # @example Specify default sorting column along with sorting direction
  #   class Car < ActiveRecord::Base
  #     include Sortable
  #
  #     sortable_default column: :color, direction: :desc
  #   end
  module Sortable
    extend ActiveSupport::Concern

    SORTING_DIRECTION = %w(asc desc).freeze
    SORTING_DEFAULTS = { 'sort' => 'id', 'dir' => 'asc' }.freeze

    class_methods do            # rubocop:disable Metrics/BlockLength
      # Set default sorting column and/or sorting direction.
      def sortable_default(column: nil, direction: nil, validate: true)
        column ||= SORTING_DEFAULTS['sort']
        direction ||= SORTING_DEFAULTS['dir']

        column = column.to_s
        direction = direction.to_s.downcase

        validate_column(column, validate)
        validate_direction(direction)

        @sortable_defaults = { 'sort' => column, 'dir' => direction }
      end

      def sortable_defaults
        (@sortable_defaults ||= SORTING_DEFAULTS).dup
      end

      # @return [<Symbol>]
      #   the list of column which can be used as sorting keys.
      def sortable_columns
        @sortable_columns ||= []
      end

      # Mark particular columns of the model as sortable.
      def sortable(*columns, validate: true)
        columns.each { |column| validate_column(column, validate) }
        sortable_columns.concat(columns.map(&:to_s))
      end

      # Return an object which can generate an ORDER BY clause.
      #
      # @param params [ActionController::Parameters] request parameters.
      # @return [ApiSampler::Sortable::Sorter]
      def sort_with(params)
        Sorter.new(self, params)
      end

      private

      def validate_column(column, validate)
        return unless validate

        raise ArgumentError, "Unknown column #{column.inspect}" unless
          has_attribute?(column)
      end

      def validate_direction(dir)
        raise ArgumentError, "Invalid sorting direction #{dir.inspect}" unless
          SORTING_DIRECTION.include?(dir)
      end
    end

    class Sorter
      attr_reader :sort, :dir, :sortable, :params, :defaults

      def initialize(sortable, params)
        @sortable = sortable
        @params = params
        @defaults = sortable.sortable_defaults

        @sort = whitelisted_param(sortable.sortable_columns, 'sort')
        @dir = if sortable.sortable_columns.include?(params['sort'])
                 whitelisted_param(Sortable::SORTING_DIRECTION, 'dir')
               else
                 defaults['dir'] # standalone :dir doesn't make sense
               end
      end

      # Generate the condition for ORDER_BY clause.
      def order
        "#{sort} #{dir}"
      end

      # Return parameters for URL generation.
      def sort_by(column)
        column = column.to_s

        direction = next_dir(column)
        column = direction && column

        { 'sort' => column, 'dir' => direction }
      end

      def dir_class(column)
        return nil unless sort == column.to_s

        case params['dir']
        when 'asc' then 'sorted ascending'
        when 'desc' then 'sorted descending'
        end
      end

      private

      def whitelisted_param(whitelist, name)
        param = params[name]
        default = defaults[name]

        whitelist.include?(param) ? param : default
      end

      def next_dir(column)
        return 'asc' unless sort == column.to_s

        case params['dir']
        when 'asc' then 'desc'
        when 'desc' then nil
        else 'asc'
        end
      end
    end
  end
end
