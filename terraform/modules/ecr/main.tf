data "aws_ecr_repository" "url_shortener_app" {
  name = "url_shortener_app"
}

resource "aws_ecr_lifecycle_policy" "ecr_policies" {
  repository = aws_ecr_repository.url_shortener_app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep only 10 prod images"
        selection = {
          countType     = "imageCountMoreThan"
          countNumber   = 10
          tagStatus     = "tagged"
          tagPrefixList = ["prod"]
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep last 20 dev/latest images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["dev-", "latest"]
          countType     = "imageCountMoreThan"
          countNumber   = 20
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 3
        description  = "Delete untagged images older than 7 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }
        action = {
          type = "expire"
        }
      }
    ]
  })

}
