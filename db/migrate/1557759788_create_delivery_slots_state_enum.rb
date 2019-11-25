# frozen_string_literal: true

Sequel.migration do
  change do
    create_enum(:delivery_slot_state, %w[open closing closed])
  end
end
