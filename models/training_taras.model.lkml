connection: "snowlooker"

# include all the views
include: "/views/**/*.view"

datagroup: training_taras_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: training_taras_default_datagroup

explore: order_items {
  always_filter: {
    filters: [order_items.status: "Completed", users.country: "USA"]
  }
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: users {}

explore: inventory_items {}
