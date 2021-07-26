#!/bin/bash
# vim: noet :

set -eu

# Script Directory
SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.."; pwd)"

# Change Directory
cd "${ROOT_DIR}"

# Global JSON
declare -a GLOBAL_JSON=()
if [ -d "nodes/all" ]; then
	while read -d $'\0' file; do
		GLOBAL_JSON+=("-j ${file}")
	done < <(find "nodes/all/" -mindepth 1 -maxdepth 1 -type f -name '*.json' -print0)
fi
declare -ar GLOBAL_JSON

# Global YAML
declare -a GLOBAL_YAML=()
if [ -d "nodes/all" ]; then
	while read -d $'\0' file; do
		GLOBAL_YAML+=("-y ${file}")
	done < <(find "nodes/all/" -mindepth 1 -maxdepth 1 -type f -name '*.yaml' -o  -type f -name '*.yml' -print0)
fi
declare -ar GLOBAL_YAML

# Domain JSON
declare -a DOMAIN_JSON=()
if [ -n "$(dnsdomainname)" ] && [ -d "nodes/domains/$(dnsdomainname)" ]; then
	while read -d $'\0' file; do
		DOMAIN_JSON+=("-j ${file}")
	done < <(find "nodes/domains/$(dnsdomainname)/" -mindepth 1 -maxdepth 1 -type f -name '*.json' -print0)
fi
declare -ar DOMAIN_JSON

# Domain YAML
declare -a DOMAIN_YAML=()
if [ -n "$(dnsdomainname)" ] && [ -d "nodes/domains/$(dnsdomainname)" ]; then
	while read -d $'\0' file; do
		DOMAIN_YAML+=("-y ${file}")
	done < <(find "nodes/domains/$(dnsdomainname)/" -mindepth 1 -maxdepth 1 -type f -name '*.yaml' -o  -type f -name '*.yml' -print0)
fi
declare -ar DOMAIN_YAML

# HOST JSON
declare -a HOST_JSON=()
if [ -n "$(dnsdomainname)" ] && [ -d "nodes/hosts/$(hostname)" ]; then
	while read -d $'\0' file; do
		HOST_JSON+=("-j ${file}")
	done < <(find "nodes/hosts/$(hostname)/" -mindepth 1 -maxdepth 1 -type f -name '*.json' -print0)
fi
declare -ar HOST_JSON

# HOST YAML
declare -a HOST_YAML=()
if [ -n "$(dnsdomainname)" ] && [ -d "nodes/hosts/$(hostname)" ]; then
	while read -d $'\0' file; do
		HOST_YAML+=("-y ${file}")
	done < <(find "nodes/hosts/$(hostname)/" -mindepth 1 -maxdepth 1 -type f -name '*.yaml' -o  -type f -name '*.yml' -print0)
fi
declare -ar HOST_YAML

# FQDN JSON
declare -a FQDN_JSON=()
if [ -n "$(dnsdomainname)" ] && [ -d "nodes/fqdns/$(dnsdomainname)/$(hostname)" ]; then
	while read -d $'\0' file; do
		FQDN_JSON+=("-j ${file}")
	done < <(find "nodes/fqdns/$(dnsdomainname)/$(hostname)/" -mindepth 1 -maxdepth 1 -type f -name '*.json' -print0)
fi
declare -ar FQDN_JSON

# FQDN YAML
declare -a FQDN_YAML=()
if [ -n "$(dnsdomainname)" ] && [ -d "nodes/fqdns/$(dnsdomainname)/$(hostname)" ]; then
	while read -d $'\0' file; do
		FQDN_YAML+=("-y ${file}")
	done < <(find "nodes/fqdns/$(dnsdomainname)/$(hostname)/" -mindepth 1 -maxdepth 1 -type f -name '*.yaml' -o  -type f -name '*.yml' -print0)
fi
declare -ar FQDN_YAML

# Inventories
declare -ar INVENTORIES=(
"${GLOBAL_JSON[@]}"
"${GLOBAL_YAML[@]}"
"${DOMAIN_JSON[@]}"
"${DOMAIN_YAML[@]}"
"${HOST_JSON[@]}"
"${HOST_YAML[@]}"
"${FQDN_JSON[@]}"
"${FQDN_YAML[@]}"
)

echo "${INVENTORIES[@]}"
