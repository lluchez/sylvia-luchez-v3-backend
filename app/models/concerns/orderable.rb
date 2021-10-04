# needs a `order` attribute
# allows to override the behavior of `generic_default_order_value` by defining `default_order_value`
module Orderable
  extend ActiveSupport::Concern

  included do |_base|
    before_save do |record|
      record.set_order_default_value if order.blank? || order.zero?
    end

    def generic_default_order_value
      self.class.maximum(:order)
    end

    def set_order_default_value
      fn = :default_order_value
      fn = :generic_default_order_value unless respond_to?(fn)
      self.order = (send(fn) || 0) + 1
    end
  end
end
