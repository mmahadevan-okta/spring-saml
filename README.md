# Introduction

This Docker build installs the spring-security-saml application in a tomcat image. Once the configuration files are updated with the Okta organization and API token, various scripts can be executed to create the SAML app within Okta and the spring-security-saml module configured as a Service Provider.

# Pre-requistes
- Docker is installed and ready to go. If not, Visit https://www.docker.com/

# Instructions
- Make a copy of the example.conf file. Like this: `cp example.conf yourorg.conf`
- Update yourorg.conf with appropriate OKTAORG and [API_TOKEN](http://developer.okta.com/docs/api/getting_started/getting_a_token.html) variables
- IMPORTANT: Ensure `docker-machine ip default` returns a valid and correct IP Address.
- Run `./create-saml-app-in-okta.sh yourorg.conf` to create a SAML application in your Okta org
-- Note the value of the 'id' field returned. Verify other values as well.
-- If you have `jq`, try `./create-saml-app.sh | jq '.id'`
-- This `id` value is your application_id
-- Run `./get-metadata.sh <application_id> > idp.xml`. This will create the `idp.xml` file that will be used to configure spring-security-saml module.
- Log in to your Okta org as an Administrator
- Verify the settings for this newly created application and assign it to a user
- Run `docker build -t spring-security-saml .`
- Run `docker run --rm -p 8080:8080 spring-security-saml`
- Log in as this user and Test IdP initiated SSO flow first (this is important as spring-security-sample sets metadata based on this)
- Feel free to test the SP init flow by accessing the sample

# Sample SAML App Settings
| Key | Value  |
| -------- | -------- |
|Single Sign On URL|http://192.168.99.100:8080/spring-security-saml2-sample/saml/SSO|
|Recipient URL|http://192.168.99.100:8080/spring-security-saml2-sample/saml/SSO|
|Destination URL|http://192.168.99.100:8080/spring-security-saml2-sample/saml/SSO|
|Audience Restriction|http://192.168.99.100:8080/spring-security-saml2-sample/saml/metadata|
|Default Relay State||
|Name ID Format|Unspecified|
|Response|Signed|
|Assertion Signature|Signed|
|Signature Algorithm|RSA_SHA256|
|Digest Algorithm|SHA256|
|Assertion Encryption|Unencrypted|
|SAML Single Logout|Disabled|
|authnContextClassRef|PasswordProtectedTransport|
|Honor Force Authentication|Yes|
|SAML Issuer ID|http://www.okta.com/${org.externalKey}|
