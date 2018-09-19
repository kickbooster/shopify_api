# frozen_string_literal: true

module ShopifyAPI
  class Checkout < Base
    self.primary_key = :token
    headers['X-Shopify-Checkout-Version'] = '2016-09-06'

    def complete
      post(:complete)
    end

    def ready?
      return false unless persisted?

      reload
      status_code = ShopifyAPI::Base.connection.response.code.to_i
      [200, 201].include?(status_code) ? true : false
    end

    def payments
      Payment.find(:all, params: { checkout_id: id })
    end

    def shipping_rates
      ShippingRate.find(:all, params: { checkout_id: id })
    end
  end
end
