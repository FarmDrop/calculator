# frozen_string_literal: true

module Calculator
  module Repositories
    class DeliverySlot
      def initialize(db: Constants.db)
        @table = db[:delivery_slots]
      end

      def upsert(delivery_slot)
        delivery_slot.transform_keys!(&:to_sym)
        result = @table
                 .insert_conflict(
                   target: :id,
                   update: delivery_slot.reject { |k, _v| k == :id }
                 ).insert(delivery_slot)
        result
      end

      def delete(delivery_slot_ids)
        @table
          .where(id: delivery_slot_ids)
          .delete
      end

      def open_delivery_slot
        open_delivery_slots.first
      end

      def open_delivery_slots
        @table
          .where { Sequel[state: 'open'] }
          .order_by(:id)
          .to_a
      end

      def find_by_id(id)
        @table
          .where(id: id)
          .first
      end
    end
  end
end
