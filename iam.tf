resource "aws_iam_role" "ecs_execution" {
    name = "ecs-execution"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_policy_attachment" "ecs_execution_policy" {

  name       = "ecs-execution-policy"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

  roles = [aws_iam_role.ecs_execution.name]
}