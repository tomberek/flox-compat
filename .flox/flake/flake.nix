{
  outputs = { self }: let
    in
    {
    devShells = builtins.mapAttrs (system: pkgs: {
      default = 
       let
         getEnvSh = import ./get-env.sh.nix;
       arg = {
         name = "devshell";
         builder = "${builtins.fetchClosure {
           fromStore = "https://cache.nixos.org";
           fromPath = self.urls.toplevel.x86_64-linux.bash.out or (throw "No bash found, install one into the toplevel");
           inputAddressed = true;
         }}/bin/bash";
         inherit system;
         outputs = [ "out" ];
         stdenv = ./stdenv;
         packages = [ pkgs.default ];

         # can append more context eg: argContext = builtins.getContext (toString derivationArg.args);
         args = [(builtins.appendContext getEnvSh {})];

         shellHook = ''
             echo shellHook startup

             . <(nix eval --impure --expr 'let __div=x: y: y x; in ${../env}/manifest.toml / __readFile / builtins.fromTOML
                  / (x: x.vars or {}) / __mapAttrs (k: v: "export k=\"''${v}\"" ) / __attrValues / __concatStringsSep "\n"' --raw)

             . <(nix eval --impure --expr 'let __div=x: y: y x; in ${../env}/manifest.toml / __readFile / builtins.fromTOML
                  / (x: x.hook.on-activate or "")' --raw)

             # Find the parent shell
             pid=$PPID
             while [ "$pid" -ne 0 ]; do
                 new_shell=$(ps -p $pid -o comm= 2>/dev/null)
                 case "$new_shell" in
                     bash|zsh|fish|sh|ksh|csh|tcsh) break ;;
                     *) : ;;
                 esac
                 pid=$(ps -p $pid -o ppid= 2>/dev/null | tr -d '[:space:]')
                 [ -z "$pid" ] && break
             done
             "$new_shell"
             echo exiting shellHook
         '';
        };
       in derivation arg;
    }) self.packages;
    packages = builtins.mapAttrs (system: pkgs: {
        default = builtins.derivation {
          name = "env";
          inherit system;
          builder = "builtin:buildenv";
          derivations = map (x: [
            "true"
            self.priorities."${builtins.unsafeDiscardStringContext (toString x)}"
            1
            x
          ]) (builtins.attrValues pkgs);
          manifest = "/dummy";
        };
    }) self.raw_packages;
        raw_packages.aarch64-darwin.bash-dev = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/1hbx0k930mf4pkb994x5dfgs7lcnsqq0-bash-interactive-5.2p37-dev";
            inputAddressed = true;
          };
        priorities."/nix/store/1hbx0k930mf4pkb994x5dfgs7lcnsqq0-bash-interactive-5.2p37-dev" = 5;
        urls."toplevel"."aarch64-darwin"."bash"."dev" = "/nix/store/1hbx0k930mf4pkb994x5dfgs7lcnsqq0-bash-interactive-5.2p37-dev";
        raw_packages.aarch64-darwin.bash-doc = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/gyxhzxgh07pvqni8hbsls1bgzj1a2f8l-bash-interactive-5.2p37-doc";
            inputAddressed = true;
          };
        priorities."/nix/store/gyxhzxgh07pvqni8hbsls1bgzj1a2f8l-bash-interactive-5.2p37-doc" = 5;
        urls."toplevel"."aarch64-darwin"."bash"."doc" = "/nix/store/gyxhzxgh07pvqni8hbsls1bgzj1a2f8l-bash-interactive-5.2p37-doc";
        raw_packages.aarch64-darwin.bash-info = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/m9ccdl3xgmk3dzz1lrvbw79sjq0dxdbh-bash-interactive-5.2p37-info";
            inputAddressed = true;
          };
        priorities."/nix/store/m9ccdl3xgmk3dzz1lrvbw79sjq0dxdbh-bash-interactive-5.2p37-info" = 5;
        urls."toplevel"."aarch64-darwin"."bash"."info" = "/nix/store/m9ccdl3xgmk3dzz1lrvbw79sjq0dxdbh-bash-interactive-5.2p37-info";
        raw_packages.aarch64-darwin.bash-man = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/q9gsfxm6w9awwahz0sj408bx5i22xzr5-bash-interactive-5.2p37-man";
            inputAddressed = true;
          };
        priorities."/nix/store/q9gsfxm6w9awwahz0sj408bx5i22xzr5-bash-interactive-5.2p37-man" = 5;
        urls."toplevel"."aarch64-darwin"."bash"."man" = "/nix/store/q9gsfxm6w9awwahz0sj408bx5i22xzr5-bash-interactive-5.2p37-man";
        raw_packages.aarch64-darwin.bash-out = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/gh2gn7xbqnahi44yd01xkv2vy172bg1v-bash-interactive-5.2p37";
            inputAddressed = true;
          };
        priorities."/nix/store/gh2gn7xbqnahi44yd01xkv2vy172bg1v-bash-interactive-5.2p37" = 5;
        urls."toplevel"."aarch64-darwin"."bash"."out" = "/nix/store/gh2gn7xbqnahi44yd01xkv2vy172bg1v-bash-interactive-5.2p37";
        raw_packages.aarch64-linux.bash-debug = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/26zf7pim4zpwfjb95r8cchm7h93cz7mr-bash-interactive-5.2p37-debug";
            inputAddressed = true;
          };
        priorities."/nix/store/26zf7pim4zpwfjb95r8cchm7h93cz7mr-bash-interactive-5.2p37-debug" = 5;
        urls."toplevel"."aarch64-linux"."bash"."debug" = "/nix/store/26zf7pim4zpwfjb95r8cchm7h93cz7mr-bash-interactive-5.2p37-debug";
        raw_packages.aarch64-linux.bash-dev = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/1vg484z3g5sv0lnmnag2ag4mj6fgsm4x-bash-interactive-5.2p37-dev";
            inputAddressed = true;
          };
        priorities."/nix/store/1vg484z3g5sv0lnmnag2ag4mj6fgsm4x-bash-interactive-5.2p37-dev" = 5;
        urls."toplevel"."aarch64-linux"."bash"."dev" = "/nix/store/1vg484z3g5sv0lnmnag2ag4mj6fgsm4x-bash-interactive-5.2p37-dev";
        raw_packages.aarch64-linux.bash-doc = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/lnh49s60fcbncc18z5n9gvxaw64fjpcc-bash-interactive-5.2p37-doc";
            inputAddressed = true;
          };
        priorities."/nix/store/lnh49s60fcbncc18z5n9gvxaw64fjpcc-bash-interactive-5.2p37-doc" = 5;
        urls."toplevel"."aarch64-linux"."bash"."doc" = "/nix/store/lnh49s60fcbncc18z5n9gvxaw64fjpcc-bash-interactive-5.2p37-doc";
        raw_packages.aarch64-linux.bash-info = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/f6ay4qmjndhsvqb82wr6vgckzfbri8xy-bash-interactive-5.2p37-info";
            inputAddressed = true;
          };
        priorities."/nix/store/f6ay4qmjndhsvqb82wr6vgckzfbri8xy-bash-interactive-5.2p37-info" = 5;
        urls."toplevel"."aarch64-linux"."bash"."info" = "/nix/store/f6ay4qmjndhsvqb82wr6vgckzfbri8xy-bash-interactive-5.2p37-info";
        raw_packages.aarch64-linux.bash-man = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/1mnhsigz5wnb5dq0v38nbfngfp83nxwa-bash-interactive-5.2p37-man";
            inputAddressed = true;
          };
        priorities."/nix/store/1mnhsigz5wnb5dq0v38nbfngfp83nxwa-bash-interactive-5.2p37-man" = 5;
        urls."toplevel"."aarch64-linux"."bash"."man" = "/nix/store/1mnhsigz5wnb5dq0v38nbfngfp83nxwa-bash-interactive-5.2p37-man";
        raw_packages.aarch64-linux.bash-out = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/86spmd2gg2v0v7zviqxh6y4jrs0zb37i-bash-interactive-5.2p37";
            inputAddressed = true;
          };
        priorities."/nix/store/86spmd2gg2v0v7zviqxh6y4jrs0zb37i-bash-interactive-5.2p37" = 5;
        urls."toplevel"."aarch64-linux"."bash"."out" = "/nix/store/86spmd2gg2v0v7zviqxh6y4jrs0zb37i-bash-interactive-5.2p37";
        raw_packages.x86_64-darwin.bash-dev = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/241gc427lrqrnybd8j23wpc4sz28g12r-bash-interactive-5.2p37-dev";
            inputAddressed = true;
          };
        priorities."/nix/store/241gc427lrqrnybd8j23wpc4sz28g12r-bash-interactive-5.2p37-dev" = 5;
        urls."toplevel"."x86_64-darwin"."bash"."dev" = "/nix/store/241gc427lrqrnybd8j23wpc4sz28g12r-bash-interactive-5.2p37-dev";
        raw_packages.x86_64-darwin.bash-doc = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/r6rpyfnqzzjw01q9khczbnhynf45ixjq-bash-interactive-5.2p37-doc";
            inputAddressed = true;
          };
        priorities."/nix/store/r6rpyfnqzzjw01q9khczbnhynf45ixjq-bash-interactive-5.2p37-doc" = 5;
        urls."toplevel"."x86_64-darwin"."bash"."doc" = "/nix/store/r6rpyfnqzzjw01q9khczbnhynf45ixjq-bash-interactive-5.2p37-doc";
        raw_packages.x86_64-darwin.bash-info = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/m9g7v85kixxb6qaxys8v8hg14g68nwm3-bash-interactive-5.2p37-info";
            inputAddressed = true;
          };
        priorities."/nix/store/m9g7v85kixxb6qaxys8v8hg14g68nwm3-bash-interactive-5.2p37-info" = 5;
        urls."toplevel"."x86_64-darwin"."bash"."info" = "/nix/store/m9g7v85kixxb6qaxys8v8hg14g68nwm3-bash-interactive-5.2p37-info";
        raw_packages.x86_64-darwin.bash-man = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/pf0h950fa13szp0giihc2gd8vpwm91mi-bash-interactive-5.2p37-man";
            inputAddressed = true;
          };
        priorities."/nix/store/pf0h950fa13szp0giihc2gd8vpwm91mi-bash-interactive-5.2p37-man" = 5;
        urls."toplevel"."x86_64-darwin"."bash"."man" = "/nix/store/pf0h950fa13szp0giihc2gd8vpwm91mi-bash-interactive-5.2p37-man";
        raw_packages.x86_64-darwin.bash-out = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/wlkvcypggzncs98lnrl2ivywkiqqgjnw-bash-interactive-5.2p37";
            inputAddressed = true;
          };
        priorities."/nix/store/wlkvcypggzncs98lnrl2ivywkiqqgjnw-bash-interactive-5.2p37" = 5;
        urls."toplevel"."x86_64-darwin"."bash"."out" = "/nix/store/wlkvcypggzncs98lnrl2ivywkiqqgjnw-bash-interactive-5.2p37";
        raw_packages.x86_64-linux.bash-debug = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/92023r59a9v1nkgrqv9mayddd3233p45-bash-interactive-5.2p37-debug";
            inputAddressed = true;
          };
        priorities."/nix/store/92023r59a9v1nkgrqv9mayddd3233p45-bash-interactive-5.2p37-debug" = 5;
        urls."toplevel"."x86_64-linux"."bash"."debug" = "/nix/store/92023r59a9v1nkgrqv9mayddd3233p45-bash-interactive-5.2p37-debug";
        raw_packages.x86_64-linux.bash-dev = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/9nrh5ga5dgz3f957w33iqzsfw2gkk5hq-bash-interactive-5.2p37-dev";
            inputAddressed = true;
          };
        priorities."/nix/store/9nrh5ga5dgz3f957w33iqzsfw2gkk5hq-bash-interactive-5.2p37-dev" = 5;
        urls."toplevel"."x86_64-linux"."bash"."dev" = "/nix/store/9nrh5ga5dgz3f957w33iqzsfw2gkk5hq-bash-interactive-5.2p37-dev";
        raw_packages.x86_64-linux.bash-doc = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/1qbrlv6ll2sdrac04zpvb6hjvg30307y-bash-interactive-5.2p37-doc";
            inputAddressed = true;
          };
        priorities."/nix/store/1qbrlv6ll2sdrac04zpvb6hjvg30307y-bash-interactive-5.2p37-doc" = 5;
        urls."toplevel"."x86_64-linux"."bash"."doc" = "/nix/store/1qbrlv6ll2sdrac04zpvb6hjvg30307y-bash-interactive-5.2p37-doc";
        raw_packages.x86_64-linux.bash-info = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/4rw0flfjd0xlis2yik8hz8izilsnxf1h-bash-interactive-5.2p37-info";
            inputAddressed = true;
          };
        priorities."/nix/store/4rw0flfjd0xlis2yik8hz8izilsnxf1h-bash-interactive-5.2p37-info" = 5;
        urls."toplevel"."x86_64-linux"."bash"."info" = "/nix/store/4rw0flfjd0xlis2yik8hz8izilsnxf1h-bash-interactive-5.2p37-info";
        raw_packages.x86_64-linux.bash-man = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/1z2p0d1sjd9gnfl049l61sy2qdd61dvb-bash-interactive-5.2p37-man";
            inputAddressed = true;
          };
        priorities."/nix/store/1z2p0d1sjd9gnfl049l61sy2qdd61dvb-bash-interactive-5.2p37-man" = 5;
        urls."toplevel"."x86_64-linux"."bash"."man" = "/nix/store/1z2p0d1sjd9gnfl049l61sy2qdd61dvb-bash-interactive-5.2p37-man";
        raw_packages.x86_64-linux.bash-out = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/m3hnxdlz6v6650ggqz29nsqbvzvdvnsy-bash-interactive-5.2p37";
            inputAddressed = true;
          };
        priorities."/nix/store/m3hnxdlz6v6650ggqz29nsqbvzvdvnsy-bash-interactive-5.2p37" = 5;
        urls."toplevel"."x86_64-linux"."bash"."out" = "/nix/store/m3hnxdlz6v6650ggqz29nsqbvzvdvnsy-bash-interactive-5.2p37";
        raw_packages.aarch64-darwin.cowsay-man = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/b85anb1vpvb1j8ab6an3gfcqvrpi9kaz-cowsay-3.8.4-man";
            inputAddressed = true;
          };
        priorities."/nix/store/b85anb1vpvb1j8ab6an3gfcqvrpi9kaz-cowsay-3.8.4-man" = 5;
        urls."toplevel"."aarch64-darwin"."cowsay"."man" = "/nix/store/b85anb1vpvb1j8ab6an3gfcqvrpi9kaz-cowsay-3.8.4-man";
        raw_packages.aarch64-darwin.cowsay-out = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/38jwjk31qwkgvw71mgsmnq456z7a3czs-cowsay-3.8.4";
            inputAddressed = true;
          };
        priorities."/nix/store/38jwjk31qwkgvw71mgsmnq456z7a3czs-cowsay-3.8.4" = 5;
        urls."toplevel"."aarch64-darwin"."cowsay"."out" = "/nix/store/38jwjk31qwkgvw71mgsmnq456z7a3czs-cowsay-3.8.4";
        raw_packages.aarch64-linux.cowsay-man = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/82ykdqlpzcjhq9hp73fj68giq5h7lwvk-cowsay-3.8.4-man";
            inputAddressed = true;
          };
        priorities."/nix/store/82ykdqlpzcjhq9hp73fj68giq5h7lwvk-cowsay-3.8.4-man" = 5;
        urls."toplevel"."aarch64-linux"."cowsay"."man" = "/nix/store/82ykdqlpzcjhq9hp73fj68giq5h7lwvk-cowsay-3.8.4-man";
        raw_packages.aarch64-linux.cowsay-out = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/m9m4p9svjqna6msx42mhd0nrpwkn73hy-cowsay-3.8.4";
            inputAddressed = true;
          };
        priorities."/nix/store/m9m4p9svjqna6msx42mhd0nrpwkn73hy-cowsay-3.8.4" = 5;
        urls."toplevel"."aarch64-linux"."cowsay"."out" = "/nix/store/m9m4p9svjqna6msx42mhd0nrpwkn73hy-cowsay-3.8.4";
        raw_packages.x86_64-darwin.cowsay-man = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/ni4ab7gqg298f5a0g7fxn42x828p6zr2-cowsay-3.8.4-man";
            inputAddressed = true;
          };
        priorities."/nix/store/ni4ab7gqg298f5a0g7fxn42x828p6zr2-cowsay-3.8.4-man" = 5;
        urls."toplevel"."x86_64-darwin"."cowsay"."man" = "/nix/store/ni4ab7gqg298f5a0g7fxn42x828p6zr2-cowsay-3.8.4-man";
        raw_packages.x86_64-darwin.cowsay-out = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/5fv49m4p94q4ydav52zxx55r3n1yhxn4-cowsay-3.8.4";
            inputAddressed = true;
          };
        priorities."/nix/store/5fv49m4p94q4ydav52zxx55r3n1yhxn4-cowsay-3.8.4" = 5;
        urls."toplevel"."x86_64-darwin"."cowsay"."out" = "/nix/store/5fv49m4p94q4ydav52zxx55r3n1yhxn4-cowsay-3.8.4";
        raw_packages.x86_64-linux.cowsay-man = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/vi00a1s1xhl6p034d6nkkmy8zvanxbi2-cowsay-3.8.4-man";
            inputAddressed = true;
          };
        priorities."/nix/store/vi00a1s1xhl6p034d6nkkmy8zvanxbi2-cowsay-3.8.4-man" = 5;
        urls."toplevel"."x86_64-linux"."cowsay"."man" = "/nix/store/vi00a1s1xhl6p034d6nkkmy8zvanxbi2-cowsay-3.8.4-man";
        raw_packages.x86_64-linux.cowsay-out = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/xkk1gr9bw2dbdjna8391rj1zl1l3dmhq-cowsay-3.8.4";
            inputAddressed = true;
          };
        priorities."/nix/store/xkk1gr9bw2dbdjna8391rj1zl1l3dmhq-cowsay-3.8.4" = 5;
        urls."toplevel"."x86_64-linux"."cowsay"."out" = "/nix/store/xkk1gr9bw2dbdjna8391rj1zl1l3dmhq-cowsay-3.8.4";
        raw_packages.aarch64-darwin.hello-out = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/rx1fzrw5bzj2cys6xk5av1v5c6ibh3cr-hello-2.12.1";
            inputAddressed = true;
          };
        priorities."/nix/store/rx1fzrw5bzj2cys6xk5av1v5c6ibh3cr-hello-2.12.1" = 5;
        urls."toplevel"."aarch64-darwin"."hello"."out" = "/nix/store/rx1fzrw5bzj2cys6xk5av1v5c6ibh3cr-hello-2.12.1";
        raw_packages.aarch64-linux.hello-out = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/76plgdn1gbaxh0br5xbc6c7pmc3j6rmk-hello-2.12.1";
            inputAddressed = true;
          };
        priorities."/nix/store/76plgdn1gbaxh0br5xbc6c7pmc3j6rmk-hello-2.12.1" = 5;
        urls."toplevel"."aarch64-linux"."hello"."out" = "/nix/store/76plgdn1gbaxh0br5xbc6c7pmc3j6rmk-hello-2.12.1";
        raw_packages.x86_64-darwin.hello-out = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/pmvrzc5w8wv71j1d2m74qfnjg81py437-hello-2.12.1";
            inputAddressed = true;
          };
        priorities."/nix/store/pmvrzc5w8wv71j1d2m74qfnjg81py437-hello-2.12.1" = 5;
        urls."toplevel"."x86_64-darwin"."hello"."out" = "/nix/store/pmvrzc5w8wv71j1d2m74qfnjg81py437-hello-2.12.1";
        raw_packages.x86_64-linux.hello-out = builtins.fetchClosure {
            fromStore = "https://cache.nixos.org";
            fromPath = "/nix/store/9bwryidal9q3g91cjm6xschfn4ikd82q-hello-2.12.1";
            inputAddressed = true;
          };
        priorities."/nix/store/9bwryidal9q3g91cjm6xschfn4ikd82q-hello-2.12.1" = 5;
        urls."toplevel"."x86_64-linux"."hello"."out" = "/nix/store/9bwryidal9q3g91cjm6xschfn4ikd82q-hello-2.12.1";
  };
}
