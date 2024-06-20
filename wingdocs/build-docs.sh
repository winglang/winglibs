#!/bin/bash -x
if [ -z "${DOCS_SOURCE}" ]; then
  echo "Missing DOCS_SOURCE"
  exit 1
fi

if [ -z "${WING_DIRNAME}" ]; then
  echo "Missing WING_DIRNAME"
  exit 1
fi

if [ -z "${STAGING_DIR}" ]; then
  echo "Missing STAGING_DIR"
  exit 1
fi


echo STAGING_DIR=$STAGING_DIR
echo WING_DIRNAME=$WING_DIRNAME
echo DOCS_SOURCE=$DOCS_SOURCE

mkdir -p "${STAGING_DIR}"

cd "${STAGING_DIR}"

rsync -av "$WING_DIRNAME/base-template/" .

echo "Copying docs... $DOCS_SOURCE => $PWD/$docs_target"
docs_target="versioned_docs/version-latest/"
mkdir -p "$docs_target"
rsync -av "$DOCS_SOURCE" "$docs_target"

echo "Installing dependencies..."
npm install

echo "Building..."
npm run build
