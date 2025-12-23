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
  main_eval = json.loads(
      subprocess.check_output(
          [
              "nix",
              "path-info",
              "--derivation",
              f".#nixosConfigurations.{args.hostname}.config.system.build.toplevel",
              "--json",
          ],
          cwd=worktree_path,
          text=True,
          stderr=subprocess.DEVNULL,
      )
  )
  main_drv = main_eval[0]["path"]
  subprocess.run(
      ["git", "worktree", "remove", worktree_path],
      cwd=base_path,
      check=True,
      stdout=subprocess.DEVNULL,
  )
  new_eval = json.loads(
      subprocess.check_output(
          [
              "nix",
              "path-info",
              "--derivation",
              f".#nixosConfigurations.{args.hostname}.config.system.build.toplevel",
              "--json",
          ],
          cwd=base_path,
          text=True,
          stderr=subprocess.DEVNULL,
      )
  )
  new_drv = new_eval[0]["path"]

  print(
      subprocess.check_output(
          ["${lib.getExe nix-diff}", "--color", "always", main_drv, new_drv],
          text=True,
      )
  )
''
