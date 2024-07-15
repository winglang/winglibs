for testfile in tests/*.test.w; do
  wing test "$testfile"
done
