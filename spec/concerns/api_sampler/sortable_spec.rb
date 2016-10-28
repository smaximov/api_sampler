# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApiSampler::Sortable do
  def mock_sortable(has_attribute: true, &block)
    klass = Class.new do
      @_has_attribute = has_attribute

      def self.has_attribute?(_)
        @_has_attribute
      end

      include ApiSampler::Sortable
    end

    klass.instance_eval(&block) unless block.nil?
    klass
  end

  describe 'default values' do
    let(:klass) { mock_sortable }

    it 'sorts using "id asc" by default' do
      expect(klass.sortable_defaults['sort']).to eq('id')
      expect(klass.sortable_defaults['dir']).to eq('asc')
    end

    it 'has no sortable columns' do
      expect(klass.sortable_columns).to be_empty
    end
  end

  describe '.sortable' do
    let(:klass) do
      mock_sortable do
        sortable :foo, :bar
      end
    end

    it 'stringifies .sortable_columns' do
      expect(klass.sortable_columns).to contain_exactly('foo', 'bar')
    end

    context 'with an unknown column' do
      it do
        expect {
          mock_sortable has_attribute: false do
            sortable :unknown
          end
        }.to raise_error(ArgumentError, /unknown column/i)
      end

      context 'and validate: valse' do
        it do
          expect {
            mock_sortable has_attribute: false do
              sortable :unknown, validate: false
            end
          }.not_to raise_error
        end
      end
    end
  end

  describe '.sortable_default' do
    it 'stringifies column name' do
      klass = mock_sortable { sortable_default column: :foo }
      expect(klass.sortable_defaults['sort']).to eq('foo')
    end

    it 'stringifies sorting direction' do
      klass = mock_sortable { sortable_default direction: :desc }
      expect(klass.sortable_defaults['dir']).to eq('desc')
    end

    context 'with invalid sorting direction' do
      it do
        expect {
          mock_sortable do
            sortable_default column: :foo, direction: 'invalid'
          end
        }.to raise_error(ArgumentError, /invalid sorting direction/i)
      end
    end

    context 'when sorting direction is not provided' do
      let(:klass) do
        mock_sortable do
          sortable_default column: :id
        end
      end

      it 'assumes :asc' do
        expect(klass.sortable_defaults['dir']).to eq('asc')
      end
    end

    context 'when sorting column is not provided' do
      let(:klass) do
        mock_sortable do
          sortable_default direction: :asc
        end
      end

      it 'assumes :id' do
        expect(klass.sortable_defaults['sort']).to eq('id')
      end
    end

    context 'with an unknown column' do
      it do
        expect {
          mock_sortable has_attribute: false do
            sortable_default column: :unknown
          end
        }.to raise_error(ArgumentError, /unknown column/i)
      end

      context 'and validate: valse' do
        it do
          expect {
            mock_sortable has_attribute: false do
              sortable_default column: :unknown, validate: false
            end
          }.not_to raise_error
        end
      end
    end
  end

  describe '.sort_with' do
    let!(:invalid) { '; drop table users' }
    let(:klass) do
      mock_sortable do
        sortable :path
        sortable_default column: :created_at, direction: :desc
      end
    end
    let(:params) { mock_params }
    subject(:sorter) { klass.sort_with(params) }

    def mock_params(opts = {})
      ActionController::Parameters.new(opts)
    end

    context '#order' do
      context 'both :sort and :dir missing' do
        it { expect(sorter.order).to eq('created_at desc') }
      end

      context ':sort missing, :dir valid' do
        let(:params) { mock_params(dir: 'asc') }

        it { expect(sorter.order).to eq('created_at desc') }
      end

      context ':sort missing, :dir invalid' do
        let(:params) { mock_params(dir: invalid) }

        it { expect(sorter.order).to eq('created_at desc') }
      end

      context ':sort valid, :dir missing' do
        let(:params) { mock_params(sort: 'path') }

        it { expect(sorter.order).to eq('path desc') }
      end

      context 'both :sort and :dir valid' do
        let(:params) { mock_params(sort: 'path', dir: 'asc') }

        it { expect(sorter.order).to eq('path asc') }
      end

      context ':sort valid, :dir invalid' do
        let(:params) { mock_params(sort: 'path', dir: invalid) }

        it { expect(sorter.order).to eq('path desc') }
      end

      context ':sort invalid, :dir missing' do
        let(:params) { mock_params(sort: invalid) }

        it { expect(sorter.order).to eq('created_at desc') }
      end

      context ':sort invalid, :dir valid' do
        let(:params) { mock_params(sort: invalid, dir: 'asc') }

        it { expect(sorter.order).to eq('created_at desc') }
      end

      context 'both :sort and :dir invalid' do
        let(:params) { mock_params(sort: invalid, dir: invalid) }

        it { expect(sorter.order).to eq('created_at desc') }
      end
    end

    context '#sort_by' do
      context 'when not matching current sort column' do
        let(:params) { mock_params(sort: 'path') }

        it 'is asc by default' do
          expect(sorter.sort_by(:id)).to eq('sort' => 'id', 'dir' => 'asc')
        end
      end

      context 'when matching current sort column' do
        context 'and dir is asc' do
          let(:params) { mock_params(sort: 'path', dir: 'asc') }

          it 'is desc' do
            expect(sorter.sort_by(:path)).to eq('sort' => 'path',
                                                'dir' => 'desc')
          end
        end
      end

      context 'when matching current sort column' do
        context 'and dir is desc' do
          let(:params) { mock_params(sort: 'path', dir: 'desc') }

          it 'is nil' do
            expect(sorter.sort_by(:path)).to eq('sort' => nil, 'dir' => nil)
          end
        end
      end
    end
  end
end
