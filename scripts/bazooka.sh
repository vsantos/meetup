#!/bin/bash

function usage(){
    cat <<EOF
usage:
    ${0} "\${ENDPOINT}" "\${NUMBER_OF_REQUESTS}"

ENDPOINT:
    - health (200)
    - consul (200)
    - create (201)
    - unauthorized (401)
    - forbidden (403)
    - notfound (404)
    - error (500)

EOF
}

if [[ "${1}" == '' ]] || [[ "${2}" == '' ]]; then
    usage
    exit 1
fi

RESPONSE_MOCKER_PROTO="https"
RESPONSE_MOCKER_HOST='meetup-responsemocker.pismo.cloud'
RESPONSE_MOCKER_PORT='443'
RESPONSE_MOCKER_ENDPOINT="${1}"
RESPONSE_MOCKER_NUMBER_OF_REQUESTS="${2}"

for i in $(seq 1 "${RESPONSE_MOCKER_NUMBER_OF_REQUESTS}"); do
    curl \
        "${RESPONSE_MOCKER_PROTO}"://"${RESPONSE_MOCKER_HOST}":${RESPONSE_MOCKER_PORT}/mock/${RESPONSE_MOCKER_ENDPOINT}
    echo -e ""
done