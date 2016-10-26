# frozen_string_literal: true

require 'api_sampler/matched_route'

module ApiSampler
  # Finds a matching route for the request, if any.
  class RouteResolver
    def initialize(router)
      @router = router
    end

    # Find a route matching `request`, if any.
    #
    # If a block is given and the matching route is found,
    # yields the matched route.
    #
    # @yield [route] the matched route, if any.
    # @yieldparam route [MatchedRoute]
    #   the route matching `request`.
    #
    # @return [MatchedRoute, nil]
    #   the route matching `request`, if any.
    def resolve(request)
      route = find_route(request)
      yield route if route.present? && block_given?
      route
    end

    private

    def find_route(request)
      @router.recognize(request) do |route, parameters|
        return MatchedRoute.new(route, parameters)
      end

      nil
    end
  end
end
