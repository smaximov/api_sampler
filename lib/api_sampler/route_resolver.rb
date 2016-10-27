# frozen_string_literal: true

require 'api_sampler/matched_route'

module ApiSampler
  # Finds a matching route for the request, if any.
  class RouteResolver
    # @param request [ActionDispatch::Request, Rack::Request]
    #   the current request.
    #
    #   If `request` has other type than {ActionDispatch::Request},
    #   you must additionaly specify a router.
    # @param router [ActionDispatch::Journey::Router]
    #   an optional router.
    #
    #   You can omit this parameter if `request` has type
    #   {ActionDispatch::Request}.
    def initialize(request, router: nil)
      @request = request
      @router = router || request.routes.router
    end

    # Find a route matching the request, if any.
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
    def resolve
      route = find_route
      yield route if route.present? && block_given?
      route
    end

    private

    def find_route
      @router.recognize(@request) do |route, parameters|
        remove_blacklisted_parameters(parameters)
        return MatchedRoute.new(route, parameters)
      end

      nil
    end

    def remove_blacklisted_parameters(parameters)
      ApiSampler.config.path_params_blacklist.each do |param|
        parameters.delete(param)
      end
    end
  end
end
