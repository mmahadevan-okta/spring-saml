#!/bin/bash
if [[ "$#" -eq 1 ]] && [[ -f $1 ]]; then
	# Load OKTAORG and API_TOKEN from the configuration file
	source "$1"

	org=${OKTAORG}
	api_token=${API_TOKEN}

	SAML_SP_IP_ADDRESS=`docker-machine ip default`
#	echo docker-machine ip: $SAML_SP_IP_ADDRESS

	containerHost="http://$SAML_SP_IP_ADDRESS:8080/spring-security-saml2-sample/saml"
	audienceRestriction="$containerHost/metadata"
	postBackURL="$containerHost/SSO"
	recipient=$postBackURL
	destination=$postBackURL
	label=$(date +%Y%m%d%S)

curl -sS -X POST \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
-d '{
  "name": "template_saml_2_0",
  "label": "Spring SAML App '$label'",
  "signOnMode": "SAML_2_0",
  "settings": {
    "app": {
      "audienceRestriction": "'$audienceRestriction'",
      "forceAuthn": false,
      "postBackURL": "'$postBackURL'",
      "authnContextClassRef": "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport",
      "requestCompressed": "COMPRESSED",
      "recipient": "'$recipient'",
      "signAssertion": "SIGNED",
      "destination": "'$destination'",
      "signResponse": "SIGNED",
      "nameIDFormat": "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress",
      "groupName": null,
      "groupFilter": null,
      "defaultRelayState": null,
      "configuredIssuer": null,
      "attributeStatements": null
    }
  }
}' "https://${org}.okta.com/api/v1/apps"

else
  echo "Usage $0 <okta_organization.conf>"
  exit 1
fi


