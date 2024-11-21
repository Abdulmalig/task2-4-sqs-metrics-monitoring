variable "lambda_function_name" {
  default = "image-processor-lambda-abdulmaliks"
}

variable "s3_bucket" {
  default = "pgr301-couch-explorers"
}

variable "sqs_queue_name" {
  default = "image-processing-queue-abdulmaliks"
}


variable "notification_email" {
  description = "Email address to receive notifications"
  type        = string
  default    = "abab018@student.kristiania.no"
}