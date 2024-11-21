resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role-arkelioo"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_s3_sqs_policy" {
  name        = "lambda_s3_sqs_policy-arkelioo"
  description = "IAM policy for Lambda access to S3 and SQS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::${var.s3_bucket}/*",
          "arn:aws:s3:::${var.s3_bucket}"
        ]
      },
      {
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Effect   = "Allow"
        Resource = aws_sqs_queue.image_processing_queue.arn
      },
      {
        Action = "logs:*"
        Effect = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_s3_sqs_policy.arn
}

resource "aws_sqs_queue" "image_processing_queue" {
  name = var.sqs_queue_name
}

resource "aws_lambda_function" "image_processor" {
  filename         = "lambda_sqs.zip"
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "lambda_sqs.lambda_handler"
  runtime          = "python3.9"
  timeout          = 30
  source_code_hash = filebase64sha256("lambda_sqs.zip")
  environment {
    variables = {
      S3_BUCKET = var.s3_bucket
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_event_source" {
  event_source_arn = aws_sqs_queue.image_processing_queue.arn
  function_name    = aws_lambda_function.image_processor.arn
  batch_size       = 10
  enabled          = true
}
