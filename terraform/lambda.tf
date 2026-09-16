data "archive_file" "lambda_zip" {

  type = "zip"

  source_file = "${path.module}/../lambda/lambda_function.py"

  output_path = "${path.module}/lambda_function.zip"
}
resource "aws_lambda_layer_version" "pillow" {

  filename = "${path.module}/../layers/pillow-layer.zip"

  layer_name = "${var.project_name}-pillow"

  compatible_runtimes = [
    "python3.12"
  ]
}
resource "aws_lambda_function" "image_resizer" {

  function_name = "${var.project_name}-lambda"

  role = aws_iam_role.lambda_role.arn

  runtime = "python3.12"

  handler = "lambda_function.lambda_handler"

  filename = data.archive_file.lambda_zip.output_path

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  timeout = 30

  memory_size = 512

  layers = [
    aws_lambda_layer_version.pillow.arn
  ]

environment {
  variables = {
    OUTPUT_BUCKET = aws_s3_bucket.output.bucket
  }
}
}