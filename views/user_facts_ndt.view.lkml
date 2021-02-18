# If necessary, uncomment the line below to include explore_source.

# include: "training_taras.model.lkml"

view: user_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: user_id {}
      column: total_sales {}
      column: count {}
      bind_all_filters: yes
    }
  }
  dimension: user_id {
    type: number
  }
  dimension: total_sales {
    value_format: "usd"
    type: number
  }
  dimension: count {
    type: number
  }
}
