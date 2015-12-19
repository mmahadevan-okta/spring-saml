#!/bin/bash


if [[ "$#" -eq 2 ]] && [[ -f $1 ]]; then
# Load OKTAORG and API_TOKEN from the configuration file
source "$1"

org=${OKTAORG}
api_token=${API_TOKEN}
aid=${2:=0oincoorect_app_id_AZq0x7}

curl -sS -X GET \
	-H "Accept: application/xml" \
	-H "Content-Type: application/json" \
	-H "Authorization: SSWS ${api_token}" \
	-d '{
}' "https://${org}.okta.com/api/v1/apps/$aid/sso/saml/metadata"

else
# Exit if 2 arguments are not passed
  echo "Usage $0 <okta_organization.conf> <application_id>"}
  exit 1
fi

