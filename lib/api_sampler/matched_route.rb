# frozen_string_literal: true

module ApiSampler
  # A route which matched the request, along with its path parameters.
  # @!attribute [r] pattern
  #   @return [String] the route pattern.
  #
  # @!attribute [rw] route
  #   @return [ActionDispath::Journey::Route] the matched route.
  #
  # @!attribute [rw] parameters
  #   @return [{ Symbol => String }] the path parameters of {#route}.
  MatchedRoute = Struct.new('MatchedRoute', :route, :parameters) do
    def pattern
      route.path.spec.to_s
    end
  end
end
