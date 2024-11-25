In Task 2, I automated the process of building and publishing a Docker image to Docker Hub using a GitHub Actions workflow. The workflow triggers on every push to the main branch, ensuring the latest version of the Java SQS client is always available. It retrieves the code, logs into Docker Hub (using GitHub Secrets), builds the image, and pushes it with two tags: latest for general use and a Git commit SHA for traceability. A multi-stage Dockerfile was used to minimize the image size, combining Maven for the build phase and a lightweight eclipse-temurin:17-jre-alpine image for runtime. This setup ensures efficiency and simplicity for the team without requiring local Java installations.

In Task 4, I implemented monitoring for the SQS queue by configuring a CloudWatch alarm to track the ApproximateAgeOfOldestMessage metric. The alarm is triggered if a message remains in the queue for more than 5 minutes, indicating a delay in processing. An SNS topic is used to send email notifications when the alarm is triggered or resolved, with the recipient email specified as a Terraform variable for flexibility. Terraform was also used to define the CloudWatch alarm and SNS integration, ensuring reproducibility across environments.

Together, these tasks optimize the development workflow and application monitoring. Task 2 enhances deployment automation, while Task 4 ensures potential delays in message processing are detected and addressed proactively, improving the user experience. Both solutions are parameterized and scalable, making them adaptable to different setups. The combination of CI/CD automation and real-time monitoring aligns with DevOps best practices for reliability and efficiency.
