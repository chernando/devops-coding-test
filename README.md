# DevOps Challenge

## Prerequisites

Before you can run the DevOps Challenge application, ensure that you have the following prerequisites installed:

- [Java Development Kit (JDK) 11](https://openjdk.java.net/projects/jdk/11/)
- [Docker](https://www.docker.com/get-started)

## Installation

To install the DevOps Challenge application, follow these steps:

1. Clone this repository to your local machine:

   ```shell
   git clone https://github.com/chernando/devops-coding-test.git
   ```

2. Change into the project directory:

   ```shell
   cd devops-coding-test
   ```

3. Build the application:

   ```shell
   ./scripts/build.sh
   ```

## Usage

To run the DevOps Challenge application locally, execute the following command:

```shell
./scripts/run.sh
```

Once the application is running, you can access it by navigating to [http://localhost:8443](http://localhost:8443) in your web browser.

## Development & Deployment

1. Ensure you have bumped the version in `pom.xml`:

   ```xml
	 <groupId>com.example</groupId>
	 <artifactId>demo</artifactId>
	 <version>0.0.1-SNAPSHOT</version>
	 <name>demo</name>
	 <description>Demo project for Spring Boot</description>
   ```

2. Create a Pull Request.

3. GitHub Actions will eventually publishes the image to our private Container Registry.
   
   - You can check the progress in the `Actions` tab. 

4. Use XXX to deploy this version into the correct ECS/EKS environment.

### Manually publishing image to ECR

1. Log in to Amazon ECR:

    For security reasons, you have to renew your credentials every 12 hours.

    ```shell
    # Set $REGION & $ACCOUNT
    
    aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT.dkr.ecr.$REGION.amazonaws.com
    ```
    
    > 💡 Alternatively, you can use https://github.com/awslabs/amazon-ecr-credential-helper


2. Tag the image:

    Match your local image with our Container Registry:

    ```shell
  
    # Set $PROJECT & $VERSION

    docker tag $PROJECT:$VERSION $ACCOUNT.dkr.ecr.$REGION.amazonaws.com/$PROJECT:$VERSION
    ```

3. Push:

    ```shell
    docker push $ACCOUNT.dkr.ecr.$REGION.amazonaws.com/$PROJECT:$VERSION
    ```
