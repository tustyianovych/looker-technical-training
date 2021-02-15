connection: "snowlooker"

# include all the views
include: "/views/**/*.view"

datagroup: training_taras_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}


datagroup: training_taras_users_explore_default_datagroup  {
  sql_trigger: select CURRENT_DATE ;;
  max_cache_age: "24 hours"
}

datagroup: training_taras_order_items_explore_default_datagroup  {
  sql_trigger: select max(created_at) from order_items ;;
  max_cache_age: "4 hours"
}


explore: order_items {
  persist_with: training_taras_order_items_explore_default_datagroup
  sql_always_where: ${returned_date} IS NULL AND ${status} = 'Complete' ;;
  sql_always_having: ${total_sales} > 200 AND ${count} > 5 ;;
  conditionally_filter: {
    filters: [
      order_items.created_date: "2 years"
      ]
      unless: [users.id]

  }
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: users {
  persist_with: training_taras_users_explore_default_datagroup
  always_filter: {
    filters: [
      users.created_date: "90 days"
    ]
  }
}

explore: inventory_items {}
