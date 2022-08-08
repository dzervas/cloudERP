variable "tags" {
  type = map(string)
  default = {
    app         = "clouderp"
    environment = "testing"
    client      = "me"
  }
}
