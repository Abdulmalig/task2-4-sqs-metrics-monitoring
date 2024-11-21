variable "lambda_function_name" {
  default = "image-processor-lambda-arkelioo"
}

variable "s3_bucket" {
  default = "pgr301-couch-explorers"
}

variable "sqs_queue_name" {
  default = "image-processing-queue-arkelioo"
}
