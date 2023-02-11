resource "aws_iam_user" "user" {
  name = "${var.env_ci}-user"
}

resource "aws_iam_role" "role" {
  name = "${var.env_ci}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": { "AWS": "arn:aws:iam::${var.account_id}:root" },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_group" "group" {
  name = "${var.env_ci}-group"
}

resource "aws_iam_policy" "policy" {
  name        = "${var.env_ci}-policy"
  description = "A test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Resource": "arn:aws:iam::${var.account_id}:role/prod-ci-role"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "${var.env_ci}-attachment"
  # users      = [aws_iam_user.user.name]
  roles      = [aws_iam_role.role.name]
  groups     = [aws_iam_group.group.name]
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_group_membership" "group-member" {
  name = "${var.env_ci}-group-membership"

  users = [
    aws_iam_user.user.name
  ]

  group = aws_iam_group.group.name
}