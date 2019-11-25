# frozen_string_literal: true

module Calculator
  module Repositories
    class DeliveryCost
      def initialize(db: Constants.db)
        @table = db[:delivery_costs]
      end

      def upsert(delivery_cost)
        delivery_cost.transform_keys!(&:to_sym)
        result = @table
                 .insert_conflict(
                   target: :id,
                   update: delivery_cost.reject { |k, _v| k == :id }
                 ).insert(delivery_cost)
        result
      end

      def delete(id)
        @table
          .where(id: id)
          .delete
      end

      def find_by_delivery_slot_id(delivery_slot_id)
        @table
          .where(delivery_slot_id: delivery_slot_id)
          .all
      end
    end
  end
end
