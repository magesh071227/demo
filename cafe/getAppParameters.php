<?php

require 'aws.phar'; // AWSSDK

// Get region from environment variable or default to 'us-east-2'
$region = getenv('AWS_REGION') ?: 'us-east-2';

$secrets_client = new Aws\SecretsManager\SecretsManagerClient([
  'version' => 'latest',
  'region'  => $region,
]);

$showServerInfo = "";
$timeZone = "";
$currency = "";
$db_url = "";
$db_name = "";
$db_user = "";
$db_password = "";

try {
  $db_url = $secrets_client->getSecretValue([
    'SecretId' => '/cafe/dbUrl1'
  ]);
  $db_url = $db_url["SecretString"];

  $db_user = $secrets_client->getSecretValue([
    'SecretId' => '/cafe/dbUser1'
  ]);
  $db_user = $db_user["SecretString"];

  $db_password = $secrets_client->getSecretValue([
    'SecretId' => '/cafe/dbPassword1'
  ]);
  $db_password = $db_password["SecretString"];

  $db_name = $secrets_client->getSecretValue([
    'SecretId' => '/cafe/dbName1'
  ]);
  $db_name = $db_name["SecretString"];

  $currency = $secrets_client->getSecretValue([
    'SecretId' => '/cafe/currency1'
  ]);
  $currency = $currency["SecretString"];  

  $timezone = $secrets_client->getSecretValue([
    'SecretId' => '/cafe/timeZone1'
  ]);
  $timezone = $timezone["SecretString"];  

  $showServerInfo = $secrets_client->getSecretValue([
    'SecretId' => '/cafe/showServerInfo1'
  ]);
  $showServerInfo = $showServerInfo["SecretString"];  

}
catch (Exception $e) {
  $db_url = '';
  $db_name = '';
  $db_user = '';
  $db_password = '';
  $showServerInfo = '';
  $timeZone = '';
  $currency = '';
}
?>
