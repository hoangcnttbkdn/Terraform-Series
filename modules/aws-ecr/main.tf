resource "aws_ecr_repository" "name" {
  for_each             = toset(length(local.image_names) > 0 ? local.image_names : [])
  name                 = "${local.name}-${each.value}"
  image_tag_mutability = var.image_tag_mutability

  dynamic "encryption_configuration" {
    for_each = var.encryption_configuration == null ? [] : [var.encryption_configuration]
    content {
      encryption_type = encryption_configuration.value.encryption_type
      kms_key         = encryption_configuration.value.kms_key
    }
  }

  image_scanning_configuration {
    scan_on_push = var.scan_images_on_push
  }

  # tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "name" {
  for_each   = toset(var.enable_lifecycle_policy ? local.image_names : [])
  repository = aws_ecr_repository.name[each.value].name

  policy = jsonencode({
    rules = concat(local.protected_tag_rules, local.untagged_image_rule, local.remove_old_image_rule)
  })
}

data "aws_iam_policy_document" "empty" {
  count = 0
}

data "aws_partition" "current" {}

data "aws_iam_policy_document" "resource_readonly_access" {
  count = 0
  statement {
    sid    = "ReadonlyAccess"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = var.principals_readonly_access
    }

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeImageScanFindings",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:ListTagsForResource",
    ]
  }

  dynamic "statement" {
    for_each = length(var.principals_lambda) > 0 ? [1] : []

    content {
      sid    = "LambdaECRImageCrossAccountRetrievalPolicy"
      effect = "Allow"
      actions = [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ]

      principals {
        type        = "Service"
        identifiers = ["lambda.amazonaws.com"]
      }

      condition {
        test     = "StringLike"
        values   = formatlist("arn:%s:lambda:*:%s:function:*", data.aws_partition.current.partition, var.principals_lambda)
        variable = "aws:sourceArn"
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.principals_lambda) > 0 ? [1] : []
    content {
      sid    = "CrossAccountPermission"
      effect = "Allow"

      principals {
        type = "AWS"

        identifiers = formatlist("arn:%s:iam::%s:root", data.aws_partition.current.partition, var.principals_lambda)
      }

      actions = [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ]
    }
  }

}

data "aws_iam_policy_document" "resource_full_access" {
  count = 0
  statement {
    sid    = "FullAccess"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = var.principals_full_access
    }

    actions = ["ecr:*"]
  }

  dynamic "statement" {
    for_each = length(var.principals_lambda) > 0 ? [1] : []

    content {
      sid    = "LambdaECRImageCrossAccountRetrievalPolicy"
      effect = "Allow"
      actions = [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ]

      principals {
        type        = "Service"
        identifiers = ["lambda.amazonaws.com"]
      }

      condition {
        test     = "StringLike"
        values   = formatlist("arn:%s:lambda:*:%s:function:*", data.aws_partition.current.partition, var.principals_lambda)
        variable = "aws:sourceArn"
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.principals_lambda) > 0 ? [1] : []
    content {
      sid    = "CrossAccountPermission"
      effect = "Allow"

      principals {
        type = "AWS"

        identifiers = formatlist("arn:%s:iam::%s:root", data.aws_partition.current.partition, var.principals_lambda)
      }

      actions = [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ]
    }
  }
}

data "aws_iam_policy_document" "resource" {
  count                     = 0
  source_policy_documents   = local.principals_readonly_access_non_empty ? [data.aws_iam_policy_document.resource_readonly_access[0].json] : [data.aws_iam_policy_document.empty[0].json]
  override_policy_documents = local.principals_full_access_non_empty ? [data.aws_iam_policy_document.resource_full_access[0].json] : [data.aws_iam_policy_document.empty[0].json]
}

resource "aws_ecr_repository_policy" "name" {
  for_each   = toset(local.ecr_need_policy ? local.image_names : [])
  repository = aws_ecr_repository.name[each.value].name
  policy     = join("", data.aws_iam_policy_document.resource.*.json)
}