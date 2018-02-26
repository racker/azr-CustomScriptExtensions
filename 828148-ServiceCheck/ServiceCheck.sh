#!/bin/bash
# Linux Service/Process Checker
# Checks service and processes and returns results in json format
# Author: Kevin Grigsby <kevin.grigsby@rackspace.com>

# GLOBAL CONSTANTS
_COMPUTER=$(hostname)
_RESID=${vmid}

# GLOBALS
MESSAGE="["
OPEN="{"

# FUNCTION TO BUILD JSON RETURN
append_message () {
   local _TYPE=${1}
     
   local _NAME=${2}
   local _STATE=${3}
   
   # Only set if we are returning a "Service" object
   if [[ ${_TYPE} == "Svc" ]]; then
      local _STARTTYPE=${4}
      local _DISPLAY=${5}
   fi
   
   # Json string builder, hopefully readable...
   MESSAGE+="${OPEN}"; OPEN=",{"
   MESSAGE+="\"Computer\":\"${_COMPUTER}\","
   if [[ -v _DISPLAY ]]; then MESSAGE+="\"${_TYPE}Display\":\"${_DISPLAY}\","; fi
   MESSAGE+="\"${_TYPE}Name\":\"${_NAME}\","
   MESSAGE+="\"${_TYPE}State\":\"${_STATE}\","
   if [[ -v _STARTTYPE ]]; then MESSAGE+="\"${_TYPE}StartType\":\"${_STARTTYPE}\","; fi
   MESSAGE+="\"ResourceId\":\"${_RESID}\""
   MESSAGE+="}"
}

# FUNCTION TO CHECK IF WE SUPPORT SERVICE
# Collapsing function, only supports systemd currently
service_check () {
   if command -v systemctl >/dev/null; then
      service_check () {
         return 0
      }; service_check ${@}
   else
      service_check () {
         return 1
      }; service_check ${@}
   fi
}

# MAIN FUNCTION
main () {
   # Step through CSV list of processes if exists
   if [[ -v ProcessName ]]; then
      for PROC in ${ProcessName//,/ }; do
         if pgrep -f ${PROC} >/dev/null 2>&1; then
            append_message Proc ${PROC} "Running"
         else
            append_message Proc ${PROC} "Not Found"
         fi
      done
   fi

   # Step through CSV list of services if exists
   if [[ -v ServiceName ]]; then
      for SVC in ${ServiceName//,/ }; do

         # Check if this system supports service checking
         if service_check; then
            export $(systemctl show -p Names,ActiveState,UnitFileState,LoadState ${SVC})
         
            # Sytemctl always returns values, check if this service is not found
            if [[ ${LoadState} == "not-found" ]]; then
               append_message Svc ${SVC} "Service Not Found" "Service Not Found" ${SVC}
            else
               append_message Svc ${SVC} "${ActiveState}" "${UnitFileState}" "${Names}"
               continue
            fi
         else
            append_message Svc ${SVC} "Service Not Found" "Service Not Found" ${SVC}
         fi
      done
   fi

   # Close out our JSON string
   MESSAGE+="]"

   # Return JSON
   echo ${MESSAGE}
}

# START
main
