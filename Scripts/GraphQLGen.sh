## Calls the Apollo script to run the code generation tool which:
##   1) Checks that the proper code gen tool is installed (and attempts to update if not)
##   2) downloads the latest schema
##   3) takes our GraphQL queries and the schema to generate a Swift API file

set -eu
set -o pipefail

## The Apollo script is designed to work in a Xcode build phase. The environment var CONFIGURATION is
## required to fool the script into thinking that it is being run in a build phase.
export CONFIGURATION="Dummy config to fool Apollo script into thinking that it is called from Xcode."

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd)"
APOLLO_SCRIPTS_PATH="$PROJECT_ROOT/Pods/Apollo/Scripts"
API_TARGET_PATH="$PROJECT_ROOT/Recap/"
RESOURCES_PATH="$PROJECT_ROOT/Recap/"
LOCAL_SCHEMA="$RESOURCES_PATH/schema.json"
GENERATED_FILE="$API_TARGET_PATH/API.swift"

## Get the latest schema
#$APOLLO_SCRIPTS_PATH/check-and-run-apollo-codegen.sh introspect-schema $REMOTE_SCHEMA --output $LOCAL_SCHEMA --method GET

## Generate the Swift API
$APOLLO_SCRIPTS_PATH/check-and-run-apollo-codegen.sh generate $RESOURCES_PATH/*.graphql --schema $LOCAL_SCHEMA --output $GENERATED_FILE
