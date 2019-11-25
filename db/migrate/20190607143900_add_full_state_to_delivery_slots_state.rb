# frozen_string_literal: true

Sequel.migration do
  no_transaction
  change do
    add_enum_value(:delivery_slot_state, 'full')
  end
end
