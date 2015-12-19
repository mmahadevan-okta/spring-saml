#!/bin/bash

if [[ "$#" -eq 2 ]] && [[ -f $1 ]]; then
# Load OKTAORG and API_TOKEN from the configuration file
source "$1"

org=${OKTAORG}
api_token=${API_TOKEN}
aid=$2

curl -sS -X POST \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-H "Authorization: SSWS ${api_token}" \
	"https://${org}.okta.com/api/v1/apps/$aid/lifecycle/deactivate"

curl -sS -X DELETE \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-H "Authorization: SSWS ${api_token}" \
	"https://${org}.okta.com/api/v1/apps/$aid"

else
# Exit if 2 arguments are not passed
  echo "Usage $0 <okta_organization.conf> <application_id>"}
  exit 1
fi

