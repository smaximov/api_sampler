module Api
  module V1
    class BasicController < Api::ApiController
      def kthnxbye
        render json: { reply: 'kthnxbye' }
      end
    end
  end
end
