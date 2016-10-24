# frozen_string_literal: true

module ConfigureHelper
  def configure(&block)
    before { ApiSampler.configure(&block) }
  end
end
