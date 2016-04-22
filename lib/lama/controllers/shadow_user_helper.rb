module Lama
  module Controllers
    module ShadowUserHelper
      extend ActiveSupport::Concern

      included do
        if respond_to?(:helper_method)
          helper_method :shadow_signed_in?, :current_shadow_user
        end
      end

      # Is user signed in as shadow
      def shadow_signed_in?
        session[:shadow_user_id].present?
      end

      # Sign in shadow user
      def shadow_sign_in(user)
        if user_signed_in?
          raise I18n.t 'lama.shadow_user.user_already_signed_in'
        end
        if !user.shadow || user.new_record?
          raise I18n.t 'lama.shadow_user.cannot_sign_in'
        end
        transfer_cart_to_user(user)
        session[:shadow_user_id] = user.id
      end

      # Get current shadow user if exists
      def current_shadow_user
        @current_shadow_user ||= User.find(session[:shadow_user_id]) if session[:shadow_user_id]
      end

      private

      def transfer_cart_to_user(user)
        cart.each do |user_product|
          user_product.update_attributes user_id: user.id
        end
        session[:cart] = []
      end
    end
  end
end
