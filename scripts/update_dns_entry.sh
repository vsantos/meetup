#!/bin/bash

function usage(){
    cat <<EOF
usage:
    ${0} "\${NEW_DNS_ENTRY}"

EOF
}

if [[ "${1}" == '' ]]; then
    usage
    exit 1
fi

RECORD_ZONE_ID='Z10H85URZYI2OK'
RECORD_DOMAIN='pismolabs.io'
RECORD_TTL='30'
RECORD_NAME="meetup-responsemocker.${RECORD_DOMAIN}"
RECORD_VALUE="${1}"
RECORD_UPDATE_ENTRY_STDERR_FILE='/tmp/.route53_stderr'
RECORD_STATUS_FILE='/tmp/.record_set_status'

if [[ -f "${RECORD_STATUS_FILE}" ]]; then rm "${RECORD_STATUS_FILE}"; fi

CHANGE_ID=$(aws route53 change-resource-record-sets \
            --profile dev \
            --hosted-zone-id ${RECORD_ZONE_ID} \
            --output json \
            --change-batch '{"Changes": [{"Action": "UPSERT", "ResourceRecordSet": {"Name": "'${RECORD_NAME}'", "Type": "CNAME", "TTL": '${RECORD_TTL}', "ResourceRecords": [{"Value": "'${RECORD_VALUE}'"}] } } ] }' 2>"${RECORD_UPDATE_ENTRY_STDERR_FILE}" \
            | jq -r '.ChangeInfo.Id' \
            | cut -d'/' -f3)

if [ ! -z "${CHANGE_ID}" ]; then
    echo 'PENDING' > "${RECORD_STATUS_FILE}"
    echo "[INFO]: Record change submitted! Change ID: ${CHANGE_ID}"
    until [ "$(cat ${RECORD_STATUS_FILE})" = "INSYNC" ]; do
        echo "[INFO]: Waiting for Route53 DNS to be in sync for '${RECORD_NAME}' ..."
        aws route53 get-change --output json --id "${CHANGE_ID}" | jq -r '.ChangeInfo.Status' > "${RECORD_STATUS_FILE}"
        sleep 5
    done
    echo "[INFO]: Record change updated, you can test it running: 'nslookup ${RECORD_NAME}'"
    rm "${RECORD_STATUS_FILE}"
else
    echo "[ERROR]: Something went wrong then updating DNS entry, please check the stderr file '${RECORD_UPDATE_ENTRY_STDERR_FILE}'"
fi
