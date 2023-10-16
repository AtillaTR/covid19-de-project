# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_s3_bucket" "bucket" {
    bucket = var.s3_bucket_name
   
}

resource "aws_s3_bucket" "athena_metadata_bucket" {
    bucket = var.s3_bucket_name_athena
   
}

resource "aws_s3_bucket" "staging_bucket" {
    bucket = var.s3_bucket_name_staging
   
}



resource "aws_s3_bucket_ownership_controls" "rule" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_object" "create_base_folder" {
    bucket = aws_s3_bucket.bucket.id
    key = "${var.s3_base_folder}/"
}

resource "aws_s3_object" "ingest_files_csv" {
  for_each = fileset(var.local_directory, "**/*.csv")

  bucket = aws_s3_bucket.bucket.id
  key    = "${var.s3_base_folder}/${each.key}"
  source = "${var.local_directory}/${each.key}"
  etag   = filemd5("${var.local_directory}/${each.key}")
  content_type = "text/csv"
}

resource "aws_s3_object" "ingest_files_json" {
  for_each = fileset(var.local_directory, "**/*.geojson")

  bucket = aws_s3_bucket.bucket.id
  key    = "${var.s3_base_folder}/${each.key}"
  source = "${var.local_directory}/${each.key}"
  etag   = filemd5("${var.local_directory}/${each.key}")
  content_type = "text/json"
}



resource "aws_glue_crawler" "enigma_jhud_crawler" {
  depends_on = [aws_s3_bucket.bucket]

    name = "enigma_jhud_crawler"
    role = var.glue_role
    database_name = var.glue_database_name

    s3_target {
        path = "s3://${aws_s3_bucket.bucket.id}/covid_data/enigma-jhud/" 
    }

    configuration = <<EOF
{
    "Version": 1.0,
    "CrawlerOutput": {
        "Partitions": { "AddOrUpdateBehavior": "InheritFromTable" },
        "Tables": { "AddOrUpdateBehavior": "MergeNewColumns" }
    }
}
EOF
}

resource "aws_glue_crawler" "nytimes_data_in_usa_country_crawler" {
  depends_on = [aws_s3_bucket.bucket]

    table_prefix = "nytimes_data_in_usa_"
    name = "nytimes_data_in_usa_country_crawler"
    role = var.glue_role
    database_name = var.glue_database_name

    s3_target {
        path = "s3://${aws_s3_bucket.bucket.id}/covid_data/enigma-nytimes-data-in-usa/csv/us_county" 
    }

    configuration = <<EOF
{
    "Version": 1.0,
    "CrawlerOutput": {
        "Partitions": { "AddOrUpdateBehavior": "InheritFromTable" },
        "Tables": { "AddOrUpdateBehavior": "MergeNewColumns" }
    }
}
EOF
}

resource "aws_glue_crawler" "nytimes_data_in_usa_states_crawler" {
  depends_on = [aws_s3_bucket.bucket]

    table_prefix = "nytimes_data_in_usa_"
    name = "nytimes_data_in_usa_states_crawler"
    role = var.glue_role
    database_name = var.glue_database_name

    s3_target {
        path = "s3://${aws_s3_bucket.bucket.id}/covid_data/enigma-nytimes-data-in-usa/csv/us_states" 
    }

    configuration = <<EOF
{
    "Version": 1.0,
    "CrawlerOutput": {
        "Partitions": { "AddOrUpdateBehavior": "InheritFromTable" },
        "Tables": { "AddOrUpdateBehavior": "MergeNewColumns" }
    }
}
EOF
}

resource "aws_glue_crawler" "rearc_covid_19_testing_us_states_crawler" {
  depends_on = [aws_s3_bucket.bucket]

    table_prefix = "rearc_covid_19_testing_us_states_"
    name = "rearc_covid_19_testing_us_states_crawler"
    role = var.glue_role
    database_name = var.glue_database_name

    s3_target {
        path = "s3://${aws_s3_bucket.bucket.id}/covid_data/rearc-covid-19-testing-data/csv/states_daily" 
    }

    configuration = <<EOF
{
    "Version": 1.0,
    "CrawlerOutput": {
        "Partitions": { "AddOrUpdateBehavior": "InheritFromTable" },
        "Tables": { "AddOrUpdateBehavior": "MergeNewColumns" }
    }
}
EOF
}

resource "aws_glue_crawler" "rearc_covid_19_testing_us_daily_crawler" {
  depends_on = [aws_s3_bucket.bucket]

    table_prefix = "rearc_covid_19_testing_"
    name = "rearc_covid_19_testing_us_daily_crawler"
    role = var.glue_role
    database_name = var.glue_database_name

    s3_target {
        path = "s3://${aws_s3_bucket.bucket.id}/covid_data/rearc-covid-19-testing-data/csv/us_daily" 
    }

    configuration = <<EOF
{
    "Version": 1.0,
    "CrawlerOutput": {
        "Partitions": { "AddOrUpdateBehavior": "InheritFromTable" },
        "Tables": { "AddOrUpdateBehavior": "MergeNewColumns" }
    }
}
EOF
}

resource "aws_glue_crawler" "rearc_covid_19_testing_us_total_latest_crawler" {
  depends_on = [aws_s3_bucket.bucket]

    table_prefix = "rearc_covid_19_testing_"
    name = "rearc_covid_19_testing_us_total_latest_crawler"
    role = var.glue_role
    database_name = var.glue_database_name

    s3_target {
        path = "s3://${aws_s3_bucket.bucket.id}/covid_data/rearc-covid-19-testing-data/csv/us-total-latest" 
    }

    configuration = <<EOF
{
    "Version": 1.0,
    "CrawlerOutput": {
        "Partitions": { "AddOrUpdateBehavior": "InheritFromTable" },
        "Tables": { "AddOrUpdateBehavior": "MergeNewColumns" }
    }
}
EOF
}

resource "aws_glue_crawler" "rearc_usa_hospital_beds_crawler" {
  depends_on = [aws_s3_bucket.bucket]

    name = "rearc_usa_hospital_beds_crawler"
    role = var.glue_role
    database_name = var.glue_database_name

    s3_target {
        path = "s3://${aws_s3_bucket.bucket.id}/covid_data/rearc-usa-hospital-beds" 
    }

    configuration = <<EOF
{
    "Version": 1.0,
    "CrawlerOutput": {
        "Partitions": { "AddOrUpdateBehavior": "InheritFromTable" },
        "Tables": { "AddOrUpdateBehavior": "MergeNewColumns" }
    }
}
EOF
}

resource "aws_glue_crawler" "static_datasets_country_code_crawler" {
  depends_on = [aws_s3_bucket.bucket]

    table_prefix = "static_datasets_"
    name = "static_datasets_country_code_crawler"
    role = var.glue_role
    database_name = var.glue_database_name

    s3_target {
        path = "s3://${aws_s3_bucket.bucket.id}/covid_data/static-datasets/csv/countrycode" 
    }

    configuration = <<EOF
{
    "Version": 1.0,
    "CrawlerOutput": {
        "Partitions": { "AddOrUpdateBehavior": "InheritFromTable" },
        "Tables": { "AddOrUpdateBehavior": "MergeNewColumns" }
    }
}
EOF
}

resource "aws_glue_crawler" "static_datasets_country_population_crawler" {
  depends_on = [aws_s3_bucket.bucket]

    table_prefix = "static_datasets_"
    name = "static_datasets_country_population_crawler"
    role = var.glue_role
    database_name = var.glue_database_name

    s3_target {
        path = "s3://${aws_s3_bucket.bucket.id}/covid_data/static-datasets/csv/CountyPopulation" 
    }

    configuration = <<EOF
{
    "Version": 1.0,
    "CrawlerOutput": {
        "Partitions": { "AddOrUpdateBehavior": "InheritFromTable" },
        "Tables": { "AddOrUpdateBehavior": "MergeNewColumns" }
    }
}
EOF
}

resource "aws_glue_crawler" "static_datasets_state_abv_crawler" {
  depends_on = [aws_s3_bucket.bucket]

    table_prefix = "static_datasets_"
    name = "static_datasets_state_abv_crawler"
    role = var.glue_role
    database_name = var.glue_database_name

    s3_target {
        path = "s3://${aws_s3_bucket.bucket.id}/covid_data/static-datasets/csv/state-abv" 
    }

    configuration = <<EOF
{
    "Version": 1.0,
    "CrawlerOutput": {
        "Partitions": { "AddOrUpdateBehavior": "InheritFromTable" },
        "Tables": { "AddOrUpdateBehavior": "MergeNewColumns" }
    }
}
EOF
}
resource "aws_vpc" "covid_vpc" {
  cidr_block = "10.0.0.0/16" # Substitua pelo bloco CIDR desejado
  tags = {
    Name = "covid_vpc"
  }
}

# Crie uma subnet pública
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.covid_vpc.id
  cidr_block        = "10.0.1.0/24" # Substitua pelo bloco CIDR desejado
  availability_zone = "us-east-1a" # Substitua pela zona de disponibilidade desejada
  map_public_ip_on_launch = true
}

# Crie uma subnet privada
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.covid_vpc.id
  cidr_block        = "10.0.2.0/24" # Substitua pelo bloco CIDR desejado
  availability_zone = "us-east-1b" # Substitua pela zona de disponibilidade desejada
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.covid_vpc.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.covid_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.covid_vpc.id

}

resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_rt_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_security_group" "redshift_security_group" {
  name        = "redshift-security-group"
  description = "Security group for Redshift cluster"
  vpc_id      = aws_vpc.covid_vpc.id
}

resource "aws_security_group_rule" "redshift_ingress" {
  type        = "ingress"
  from_port   = 5439 # Porta padrão do Redshift
  to_port     = 5439
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # Permite conexões de qualquer endereço IP. Recomenda-se limitar isso à faixa IP desejada.

  security_group_id = aws_security_group.redshift_security_group.id
}

resource "aws_redshift_subnet_group" "covid_subnet_group" {
  name       = "covid-subnet-group"
  description = "Redshift subnet group for COVID cluster"
  subnet_ids = [aws_subnet.public_subnet.id]
}

resource "aws_redshift_cluster" "covid_cluster" {
  cluster_identifier         = "de-covid-cluster"
  node_type                  = "dc2.large" # Substitua pelo tipo de nó desejado
  cluster_type               = "single-node"
  skip_final_snapshot        = true
  cluster_subnet_group_name  = aws_redshift_subnet_group.covid_subnet_group.name
  vpc_security_group_ids      = [aws_security_group.redshift_security_group.id]
  database_name              = "dev"
  master_username            = "awsuser"      # Substitua pelo nome de usuário desejado
  master_password            = "Passw0rd123!" # Substitua pela senha desejada
}

