
# AWS COVID Data Pipeline

This project is an example of setting up an AWS-based data pipeline for processing and analyzing COVID-19 related data. The pipeline involves data ingestion, storage, transformation, and loading into Amazon Redshift for further analysis.

## Prerequisites

Before running this project, make sure you have the following prerequisites:

- AWS Account: You need an AWS account with appropriate access rights.
- Terraform: This project uses Terraform to provision AWS resources. Make sure you have Terraform installed.
- Python: The project contains Python scripts to interact with AWS services.
- AWS Redshift: You should have an AWS Redshift cluster set up, or you can configure one as part of this project.

## Configuration

1. Configure AWS Provider:

   Modify the `provider` block in the `main.tf` file to specify your AWS region and access credentials.

2. Create S3 Buckets:

   Create S3 buckets for various purposes, such as staging, storing metadata, and data storage. Modify the `aws_s3_bucket` and `aws_s3_bucket_ownership_controls` resources in `main.tf` to define your bucket names and ownership controls.

3. AWS Glue Crawlers:

   Set up AWS Glue Crawlers to discover and catalog your data sources. Configure the crawler resources in `main.tf` by specifying the paths to your data in S3.

4. AWS Redshift Cluster:

   Define your Redshift cluster settings in `main.tf`, including the type of cluster, database name, and security group. Make sure to specify the VPC settings as well.

5. Athena Configuration:

   Modify the Python script's `AWS_ACCESS_KEY` and `AWS_SECRET_KEY` variables to specify your AWS access credentials. You should also specify the `S3_STAGING` location for query results.

## Usage

1. Initialize Terraform:

   Run `terraform init -var-file="credentials.tfvars"` in the project directory to initialize Terraform.

2. Deploy Resources:

   Use `terraform apply -var-file="credentials.tfvars"` to create the AWS resources as defined in your Terraform configuration.

3. Data Ingestion:

   After creating resources, use Python scripts to run Athena queries and ingest data into your Redshift database.

4. Analyze Data:

   You can now analyze the COVID-19 data in your Redshift cluster.


## Acknowledgments

This project was created as a demonstration of a data pipeline using AWS services. Feel free to adapt and modify it for your specific use case.

## Author

- Atilla Teixeira Reis

---

