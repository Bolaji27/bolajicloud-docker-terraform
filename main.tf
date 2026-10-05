resource "aws_ecs_cluster" "website" {
  name = "website"

}

resource "aws_ecs_task_definition" "httpd" {

  family                   = "httpd"

  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  cpu = "256"

  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name  = "httpd"

      image = "669076482055.dkr.ecr.eu-west-2.amazonaws.com/bolajidocker-app:1.1"

      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = "/ecs/httpd"
          awslogs-region        = "eu-west-2"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "ecs" {
  name = "/ecs/httpd"
}

resource "aws_ecs_service" "httpd" {

  name = "httpd"

  cluster = aws_ecs_cluster.website.id

  task_definition = aws_ecs_task_definition.httpd.arn

  launch_type = "FARGATE"

  desired_count = 1

  network_configuration {

    subnets = var.subnet_ids

    security_groups = [aws_security_group.ecs.id]

    assign_public_ip = true
  }

  load_balancer {

    target_group_arn = aws_lb_target_group.httpd.arn

    container_name = "httpd"

    container_port = 80
  }

  depends_on = [
    aws_lb_listener.http
  ]
}
