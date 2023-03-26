locals {
  lb=coalesce(
    var.load_balance == "Round Robin" ? "LB_ALGORITHM_ROUND_ROBIN" : "",
    var.load_balance == "Least Load" ? "LB_ALGORITHM_LEAST_LOAD" : ""
)
}