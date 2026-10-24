resource "aws_lambda_permission" "allow_s3" {

  statement_id = "AllowS3Invoke"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.image_resizer.function_name

  principal = "s3.amazonaws.com"

  source_arn = aws_s3_bucket.source.arn
}


resource "aws_s3_bucket_notification" "source_notification" {

  bucket = aws_s3_bucket.source.id

  lambda_function {

    lambda_function_arn = aws_lambda_function.image_resizer.arn
    
    events = [
      "s3:ObjectCreated:*"
    ]

    filter_prefix = ""

    filter_suffix = ""
  }

  depends_on = [
    aws_lambda_permission.allow_s3
  ]
}