{
  description = "Flake Templates for Develop Environment";

  outputs = { self }:
  let
    inherit (builtins) filter map foldl' readDir attrNames concatMap elem;

    unionFor = ks: f: foldl' (a: b: a // b) {} (map f ks);
    subDirsAll = (path: let d = readDir path; in filter (k: d.${k} == "directory") (attrNames d));
    dirContainsFile = dir: filename: elem filename (attrNames (readDir dir));
    findSubDirsContains = root: filename:
    concatMap (dir:
      let p = "${root}/${dir}";
      in (if dirContainsFile p filename then [dir] else []) ++ map (s: "${dir}/${s}") (findSubDirsContains p filename)
    ) (subDirsAll root);
  in
  {
    templates = unionFor (findSubDirsContains ./. "flake.nix") (dir: {
      "${builtins.replaceStrings ["/"] ["-"] dir}" = {
        path = "./" + dir;
        description = dir;
      };
    });
  };
}
