module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 6.0"

  function_name = "my-lambda1"
  description   = "My awesome lambda function"

  handler = "index.lambda_handler"
  runtime = "python3.12"

  source_path = "${path.root}/lambda_function"

  publish     = true
  timeout     = 10
  memory_size = 128

  tags = {
    Name  = "my-lambda1"
    Owner = "ganesh"
  }
}