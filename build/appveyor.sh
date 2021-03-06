#!/bin/bash

# Build script run by Appveyor. Might eventually be less
# single-purpose, but let's get coverage going ASAP...

set -e

declare -r ROOT=$(realpath $(dirname $0)/..)
cd $ROOT

dotnet --info

dotnet build -c Release src/NodaTime.sln

# Run the tests under dotCover
build/coverage.sh

dotnet test -c Release src/NodaTime.Test --filter=TestCategory!=Slow
dotnet test -c Release src/NodaTime.Demo

dotnet build -c Release src/NodaTime.TzdbCompiler
dotnet test -c Release src/NodaTime.TzdbCompiler.Test
