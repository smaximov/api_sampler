module Api
  module V1
    class BasicController < Api::ApiController
      def kthnxbye
        render json: { reply: 'kthnxbye' }
      end

      def echo_get
        render json: { reply: request.query_parameters }
      end
    end
  end
end
