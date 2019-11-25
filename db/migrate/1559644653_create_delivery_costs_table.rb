# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :delivery_costs do
      Integer :id, primary_key: true
      Integer :cost_pence, null: false
      Integer :minimum_spend_pence, null: false
      String :label
    end

    alter_table(:delivery_costs) do
      add_foreign_key :delivery_slot_id, :delivery_slots, null: false, on_delete: :cascade
    end
  end
end
