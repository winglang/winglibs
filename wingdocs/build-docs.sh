#!/bin/sh
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

cp -r "${WING_DIRNAME}/base-template/" .

DOCS_TARGET="versioned_docs/version-latest"
mkdir -p "${DOCS_TARGET}"
echo "Staging docs: ${DOCS_SOURCE} => ${DOCS_TARGET}"
cp -r "${DOCS_SOURCE}/" "${DOCS_TARGET}"

npm install
npm run build
