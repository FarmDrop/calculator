# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :delivery_slots do
      Integer :id, primary_key: true
      delivery_slot_state :state
    end
  end
end
