file(REMOVE_RECURSE
  "libuci_.a"
  "libuci_.pdb"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/uci_.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
