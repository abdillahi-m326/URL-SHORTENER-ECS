resource "aws_codedeploy_app" "codedeploy_app" {
  name             = "appexample-dev-codedeploy-us-east-1"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name               = aws_codedeploy_app.codedeploy_app.name
  deployment_group_name  = "example-group"
  service_role_arn       = aws_iam_role.codedeploy_role.arn
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
  autoscaling_groups     = [aws_autoscaling_group.autoscaling_group.name]
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
