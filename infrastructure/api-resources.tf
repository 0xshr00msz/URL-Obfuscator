# API Gateway Resources and Methods

# URLs Resource
resource "aws_api_gateway_resource" "urls" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "urls"
}

# Encode Resource
resource "aws_api_gateway_resource" "encode" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "encode"
}

# Store Resource
resource "aws_api_gateway_resource" "store" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "store"
}

# Methods
resource "aws_api_gateway_method" "get_urls" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.urls.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_encode" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.encode.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_store" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.store.id
  http_method   = "POST"
  authorization = "NONE"
}

# Integrations
resource "aws_api_gateway_integration" "get_urls" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.urls.id
  http_method             = aws_api_gateway_method.get_urls.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:dynamodb:action/Scan"
  credentials             = aws_iam_role.api_gateway_dynamodb.arn

  request_templates = {
    "application/json" = file("${path.module}/../backend/api_gateway_templates/scan_request.vtl")
  }
}

resource "aws_api_gateway_integration" "post_encode" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.encode.id
  http_method             = aws_api_gateway_method.post_encode.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.encode_url.invoke_arn
}

resource "aws_api_gateway_integration" "post_store" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.store.id
  http_method             = aws_api_gateway_method.post_store.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:dynamodb:action/PutItem"
  credentials             = aws_iam_role.api_gateway_dynamodb.arn

  request_templates = {
    "application/json" = file("${path.module}/../backend/api_gateway_templates/put_item_request.vtl")
  }
}

# Integration Responses
resource "aws_api_gateway_integration_response" "get_urls" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.urls.id
  http_method = aws_api_gateway_method.get_urls.http_method
  status_code = "200"

  response_templates = {
    "application/json" = file("${path.module}/../backend/api_gateway_templates/scan_response.vtl")
  }
}

resource "aws_api_gateway_integration_response" "post_store" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.store.id
  http_method = aws_api_gateway_method.post_store.http_method
  status_code = "200"

  response_templates = {
    "application/json" = file("${path.module}/../backend/api_gateway_templates/put_item_response.vtl")
  }
}

# Method Responses
resource "aws_api_gateway_method_response" "get_urls_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.urls.id
  http_method = aws_api_gateway_method.get_urls.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "post_encode_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.encode.id
  http_method = aws_api_gateway_method.post_encode.http_method
  status_code = "200"
}

resource "aws_api_gateway_method_response" "post_store_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.store.id
  http_method = aws_api_gateway_method.post_store.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
