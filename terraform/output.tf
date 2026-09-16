output "source_bucket_name" {
  description = "S3 bucket for uploading original images"
  value       = aws_s3_bucket.source.bucket
}

output "output_bucket_name" {
  description = "S3 bucket containing resized images"
  value       = aws_s3_bucket.output.bucket
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.image_resizer.function_name
}

output "lambda_role_arn" {
  description = "Lambda IAM role ARN"
  value       = aws_iam_role.lambda_role.arn
}