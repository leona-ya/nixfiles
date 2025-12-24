{ writers, nix-diff, lib, ... }: writers.writePython3Bin "nix-eval-and-diff" { doCheck = false; } ''
  import subprocess
  import random
  import string
  import json
  from pathlib import Path
  import argparse

  parser = argparse.ArgumentParser(prog="nix-eval-and-diff")
  parser.add_argument("hostname")
  args = parser.parse_args()

  def eval_(hostname: str, cwd: Path):
      drvs = json.loads(
          subprocess.check_output(
              [
                  "nix",
                  "path-info",
                  "--derivation",
                  f".#nixosConfigurations.{hostname}.config.system.build.toplevel",
                  "--json",
              ],
              cwd=cwd,
              text=True,
              stderr=subprocess.DEVNULL,
          )
      )
      # Nix and Lix behave differently here:
      # Nix returns a dict of drvs, Lix a list of dicts
      if isinstance(drvs, list):
        return drvs[0]["path"]
      elif isinstance(drvs, dict):
        return list(drvs.keys())[0]

  base_path = Path(
      subprocess.check_output(["git", "rev-parse", "--show-toplevel"], text=True).strip()
  )
  random_string = "".join(random.choices(string.ascii_letters + string.digits, k=6))
  worktree_path = base_path / f".worktree/eval-and-diff-{random_string}"
  subprocess.run(
      ["git", "worktree", "add", worktree_path, "origin/main"],
      cwd=base_path,
      check=True,
      stdout=subprocess.DEVNULL,
      stderr=subprocess.DEVNULL,
  )
  main_drv = eval_(args.hostname, worktree_path)
  subprocess.run(
      ["git", "worktree", "remove", worktree_path],
      cwd=base_path,
      check=True,
      stdout=subprocess.DEVNULL,
  )
  new_drv = eval_(args.hostname, base_path)

  print(
      subprocess.check_output(
          ["${lib.getExe nix-diff}", "--color", "always", main_drv, new_drv],
          text=True,
      )
  )
''
