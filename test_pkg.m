function test_pkg (pkg_name)
  p = pkg ("list", pkg_name);
  pkg_dir = p{1}.dir;
  runtests (pkg_dir);
endfunction
