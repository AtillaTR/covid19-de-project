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
  for_each = fileset(var.local_directory, "**/*.json")

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
        path = "s3://${aws_s3_bucket.bucket.id}/covid_data/enigma-nytimes-data-in-usa/csv/us_country" 
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

    table_prefix = "rearc_covid_19_testing_us_states"
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

    table_prefix = "rearc_usa_hospital_beds_"
    name = "rearc_usa_hospital_beds_crawler"
    role = var.glue_role
    database_name = var.glue_database_name

    s3_target {
        path = "s3://${aws_s3_bucket.bucket.id}/covid_data/rearc-covid-19-testing-data" 
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
