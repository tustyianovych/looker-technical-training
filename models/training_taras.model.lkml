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
  always_filter: {
    filters: {
      field: order_items.created_date
      value: "last 30 days"
    }
  }

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: users {
  persist_with: training_taras_users_explore_default_datagroup
  conditionally_filter: {
    filters: {
      field: users.created_date
      value: "last 90 days"
    }
    unless: [users.id, users.state]
  }
}

explore: user_facts {
  description: "Explore is based on a derived table with users' facts."
  join: users {
    fields: [users.id, users.state]
    sql_on: ${users.id} = ${user_facts.user_id} ;;
    relationship: one_to_one
  }
}


explore: inventory_items {}
