connection: "snowlooker"

# include all the views
include: "/views/**/*.view"

datagroup: training_taras_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: training_taras_default_datagroup

explore: order_items {}
