{ lib, stdenv, callPackage, fetchurl
, jdk, cmake, zlib, python3
, dotnet-sdk_5
, autoPatchelfHook
, libdbusmenu
, vmopts ? null
}:

with lib;

let
  mkJetBrainsProduct = callPackage ./common.nix { inherit vmopts; };
  # Sorted alphabetically

  buildClion = { name, version, src, license, description, wmClass, ... }:
    (mkJetBrainsProduct {
      inherit name version src wmClass jdk;
      product = "CLion";
      meta = with lib; {
        homepage = "https://www.jetbrains.com/clion/";
        inherit description license;
        longDescription = ''
          Enhancing productivity for every C and C++
          developer on Linux, macOS and Windows.
        '';
        maintainers = with maintainers; [ edwtjo mic92 ];
        platforms = platforms.linux;
      };
    }).overrideAttrs (attrs: {
      nativeBuildInputs = (attrs.nativeBuildInputs or []) ++ optionals (stdenv.isLinux) [
        autoPatchelfHook
      ];
      buildInputs = (attrs.buildInputs or []) ++ optionals (stdenv.isLinux) [
        python3
        stdenv.cc.cc
        libdbusmenu
      ];
      dontAutoPatchelf = true;
      postFixup = (attrs.postFixup or "") + optionalString (stdenv.isLinux) ''
        (
          cd $out/clion-${version}
          # bundled cmake does not find libc
          rm -rf bin/cmake/linux
          ln -s ${cmake} bin/cmake/linux
          autoPatchelf $PWD/bin
          wrapProgram $out/bin/clion \
            --set CL_JDK "${jdk}"
        )
      '';
    });

  buildJetBrainsClient = { name, version, src, license, description, wmClass, ... }:
    (mkJetBrainsProduct {
      inherit name version src wmClass jdk;
      product = "JetbrainsClient";
      execFileName = "jetbrains_client";
      extraLdPath = [ zlib ];
      meta = with lib; {
        homepage = "https://www.jetbrains.com/code-with-me/";
        inherit description license;
        longDescription = ''
          IDE for Java SE, Groovy & Scala development Powerful
          environment for building Google Android apps Integration
          with JUnit, TestNG, popular SCMs, Ant & Maven. Also known
          as IntelliJ.
        '';
        maintainers = with maintainers; [ em0lar ];
        platforms = [ "x86_64-darwin" "i686-darwin" "i686-linux" "x86_64-linux" ];
      };
    });

  buildDataGrip = { name, version, src, license, description, wmClass, ... }:
    (mkJetBrainsProduct {
      inherit name version src wmClass jdk;
      product = "DataGrip";
      meta = with lib; {
        homepage = "https://www.jetbrains.com/datagrip/";
        inherit description license;
        longDescription = ''
          DataGrip is a new IDE from JetBrains built for database admins.
          It allows you to quickly migrate and refactor relational databases,
          construct efficient, statically checked SQL queries and much more.
        '';
        maintainers = with maintainers; [ ];
        platforms = platforms.linux;
      };
    });

  buildGoland = { name, version, src, license, description, wmClass, ... }:
    (mkJetBrainsProduct {
      inherit name version src wmClass jdk;
      product = "Goland";
      meta = with lib; {
        homepage = "https://www.jetbrains.com/go/";
        inherit description license;
        longDescription = ''
          Goland is the codename for a new commercial IDE by JetBrains
          aimed at providing an ergonomic environment for Go development.
          The new IDE extends the IntelliJ platform with the coding assistance
          and tool integrations specific for the Go language
        '';
        maintainers = [ maintainers.miltador ];
        platforms = platforms.linux;
      };
    }).overrideAttrs (attrs: {
      postFixup = (attrs.postFixup or "") + ''
        interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
        patchelf --set-interpreter $interp $out/goland*/plugins/go/lib/dlv/linux/dlv
        chmod +x $out/goland*/plugins/go/lib/dlv/linux/dlv
      '';
    });

  buildIdea = { name, version, src, license, description, wmClass, ... }:
    (mkJetBrainsProduct {
      inherit name version src wmClass jdk;
      product = "IDEA";
      extraLdPath = [ zlib ];
      meta = with lib; {
        homepage = "https://www.jetbrains.com/idea/";
        inherit description license;
        longDescription = ''
          IDE for Java SE, Groovy & Scala development Powerful
          environment for building Google Android apps Integration
          with JUnit, TestNG, popular SCMs, Ant & Maven. Also known
          as IntelliJ.
        '';
        maintainers = with maintainers; [ edwtjo gytis-ivaskevicius ];
        platforms = [ "x86_64-darwin" "i686-darwin" "i686-linux" "x86_64-linux" ];
      };
    });

  buildMps = { name, version, src, license, description, wmClass, ... }:
    (mkJetBrainsProduct rec {
      inherit name version src wmClass jdk;
      product = "MPS";
      meta = with lib; {
        homepage = "https://www.jetbrains.com/mps/";
        inherit license description;
        longDescription = ''
          A metaprogramming system which uses projectional editing
          which allows users to overcome the limits of language
          parsers, and build DSL editors, such as ones with tables and
          diagrams.
        '';
        maintainers = with maintainers; [ rasendubi ];
        platforms = platforms.linux;
      };
    });

  buildPhpStorm = { name, version, src, license, description, wmClass, ... }:
    (mkJetBrainsProduct {
      inherit name version src wmClass jdk;
      product = "PhpStorm";
      meta = with lib; {
        homepage = "https://www.jetbrains.com/phpstorm/";
        inherit description license;
        longDescription = ''
          PhpStorm provides an editor for PHP, HTML and JavaScript
          with on-the-fly code analysis, error prevention and
          automated refactorings for PHP and JavaScript code.
        '';
        maintainers = with maintainers; [ schristo ma27 ];
        platforms = platforms.linux;
      };
    });

  buildPycharm = { name, version, src, license, description, wmClass, ... }:
    (mkJetBrainsProduct {
      inherit name version src wmClass jdk;
      product = "PyCharm";
      meta = with lib; {
        homepage = "https://www.jetbrains.com/pycharm/";
        inherit description license;
        longDescription = ''
          Python IDE with complete set of tools for productive
          development with Python programming language. In addition, the
          IDE provides high-class capabilities for professional Web
          development with Django framework and Google App Engine. It
          has powerful coding assistance, navigation, a lot of
          refactoring features, tight integration with various Version
          Control Systems, Unit testing, powerful all-singing
          all-dancing Debugger and entire customization. PyCharm is
          developer driven IDE. It was developed with the aim of
          providing you almost everything you need for your comfortable
          and productive development!
        '';
        maintainers = with maintainers; [ ];
        platforms = platforms.linux;
      };
    }).override {
      propagatedUserEnvPkgs = [ python3 ];
    };

  buildRider = { name, version, src, license, description, wmClass, ... }:
    (mkJetBrainsProduct {
      inherit name version src wmClass jdk;
      product = "Rider";
      meta = with lib; {
        homepage = "https://www.jetbrains.com/rider/";
        inherit description license;
        longDescription = ''
          JetBrains Rider is a new .NET IDE based on the IntelliJ
          platform and ReSharper. Rider supports .NET Core,
          .NET Framework and Mono based projects. This lets you
          develop a wide array of applications including .NET desktop
          apps, services and libraries, Unity games, ASP.NET and
          ASP.NET Core web applications.
        '';
        maintainers = [ maintainers.miltador ];
        platforms = platforms.linux;
      };
    }).overrideAttrs (attrs: {
      postPatch = lib.optionalString (!stdenv.isDarwin) (attrs.postPatch + ''
        rm -rf lib/ReSharperHost/linux-x64/dotnet
        mkdir -p lib/ReSharperHost/linux-x64/dotnet/
        ln -s ${dotnet-sdk_5}/bin/dotnet lib/ReSharperHost/linux-x64/dotnet/dotnet
      '');
    });

  buildRubyMine = { name, version, src, license, description, wmClass, ... }:
    (mkJetBrainsProduct {
      inherit name version src wmClass jdk;
      product = "RubyMine";
      meta = with lib; {
        homepage = "https://www.jetbrains.com/ruby/";
        inherit description license;
        longDescription = description;
        maintainers = with maintainers; [ edwtjo ];
        platforms = platforms.linux;
      };
    });

  buildWebStorm = { name, version, src, license, description, wmClass, ... }:
    (mkJetBrainsProduct {
      inherit name version src wmClass jdk;
      product = "WebStorm";
      meta = with lib; {
        homepage = "https://www.jetbrains.com/webstorm/";
        inherit description license;
        longDescription = ''
          WebStorm provides an editor for HTML, JavaScript (incl. Node.js),
          and CSS with on-the-fly code analysis, error prevention and
          automated refactorings for JavaScript code.
        '';
        maintainers = with maintainers; [ abaldeau ];
        platforms = platforms.linux;
      };
    }).overrideAttrs (attrs: {
      postPatch = (attrs.postPatch or "") + optionalString (stdenv.isLinux) ''
        # Webstorm tries to use bundled jre if available.
        # Lets prevent this for the moment
        rm -r jbr
      '';
    });
in

{
  # Sorted alphabetically

  clion = buildClion rec {
    name = "clion-${version}";
    version = "2021.3"; /* updated by script */
    description  = "C/C++ IDE. New. Intelligent. Cross-platform";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/cpp/CLion-${version}.tar.gz";
      sha256 = "0rvq0k99c4kniw2k0a8m2hq27v9nvn7qg6yg9dwxlmadsrx6as29"; /* updated by script */
    };
    wmClass = "jetbrains-clion";
    update-channel = "CLion RELEASE"; # channel's id as in http://www.jetbrains.com/updates/updates.xml
  };

  jetbrains-client = buildJetBrainsClient rec {
    name = "jetbrains-client-${version}";
    version = "213.5744.223";
    description = "TODO";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/code-with-me/JetBrainsClient-${version}-no-jbr.tar.gz";
      sha256 = "sha256-6ppgihzMaLZUDASkzxb5ZPW7w97/KN9V8zfUXQYW1eo=";
    };
    wmClass = "jetbrains-codewithme-guest";
  };

  datagrip = buildDataGrip rec {
    name = "datagrip-${version}";
    version = "2021.3.1"; /* updated by script */
    description = "Your Swiss Army Knife for Databases and SQL";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/datagrip/${name}.tar.gz";
      sha256 = "18drbddcjbbv6q6j95wy7ila8d7imi0gh5nnf0lhj4gkkxhszmii"; /* updated by script */
    };
    wmClass = "jetbrains-datagrip";
    update-channel = "DataGrip RELEASE";
  };

  goland = buildGoland rec {
    name = "goland-${version}";
    version = "2021.3"; /* updated by script */
    description = "Up and Coming Go IDE";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/go/${name}.tar.gz";
      sha256 = "0bdsvfsx0vhmvlqvy9phw6yz98la8qw2avm4p0yl9j8y9zplbhl0"; /* updated by script */
    };
    wmClass = "jetbrains-goland";
    update-channel = "GoLand RELEASE";
  };

  idea-community = buildIdea rec {
    name = "idea-community-${version}";
    version = "2021.3"; /* updated by script */
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    license = lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "0xrhgqbsyd2plzkkmy00bwsa8dk4ijszmhmbyn6c9ygl01zhji6y"; /* updated by script */
    };
    wmClass = "jetbrains-idea-ce";
    update-channel = "IntelliJ IDEA RELEASE";
  };

  idea-ultimate = buildIdea rec {
    name = "idea-ultimate-${version}";
    version = "2021.3"; /* updated by script */
    description = "Integrated Development Environment (IDE) by Jetbrains, requires paid license";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIU-${version}-no-jbr.tar.gz";
      sha256 = "0riwww75aizprb01c1sccprbr00ky5wgy5cxxjxqgm8v72rfnihb"; /* updated by script */
    };
    wmClass = "jetbrains-idea";
    update-channel = "IntelliJ IDEA RELEASE";
  };

  mps = buildMps rec {
    name = "mps-${version}";
    version = "2021.2.3"; /* updated by script */
    versionMajorMinor = "2021.2"; /* updated by script */
    description = "Create your own domain-specific language";
    license = lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/mps/${versionMajorMinor}/MPS-${version}.tar.gz";
      sha256 = "1j33b48ki1xw7xb1hr8k2jz7d78h0qcr1b5gql7i40d7szq0iy10"; /* updated by script */
    };
    wmClass = "jetbrains-mps";
    update-channel = "MPS RELEASE";
  };

  phpstorm = buildPhpStorm rec {
    name = "phpstorm-${version}";
    version = "2021.3"; /* updated by script */
    description = "Professional IDE for Web and PHP developers";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webide/PhpStorm-${version}.tar.gz";
      sha256 = "1h3ld3swvvx8hicm5lpf65mr7asiqy59hvqnigz71hbjgqnsb8g0"; /* updated by script */
    };
    wmClass = "jetbrains-phpstorm";
    update-channel = "PhpStorm RELEASE";
  };

  pycharm-community = buildPycharm rec {
    name = "pycharm-community-${version}";
    version = "2021.3"; /* updated by script */
    description = "PyCharm Community Edition";
    license = lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "0iypqilil6x9k1gi6bfjzccw7wp601grd9639yk50crg45wnzga4"; /* updated by script */
    };
    wmClass = "jetbrains-pycharm-ce";
    update-channel = "PyCharm RELEASE";
  };

  pycharm-professional = buildPycharm rec {
    name = "pycharm-professional-${version}";
    version = "2021.3"; /* updated by script */
    description = "PyCharm Professional Edition";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/python/${name}.tar.gz";
      sha256 = "0z6dnigx616939azyngjy5r4gayazplkgq480k80ppmkw636yhl1"; /* updated by script */
    };
    wmClass = "jetbrains-pycharm";
    update-channel = "PyCharm RELEASE";
  };

  rider = buildRider rec {
    name = "rider-${version}";
    version = "2021.3"; /* updated by script */
    description = "A cross-platform .NET IDE based on the IntelliJ platform and ReSharper";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
      sha256 = "0m1y770dsl8fyrvbmp1b56rka1jhanlxzdbp8pa0jx9fxjr9anmi"; /* updated by script */
    };
    wmClass = "jetbrains-rider";
    update-channel = "Rider RELEASE";
  };

  ruby-mine = buildRubyMine rec {
    name = "ruby-mine-${version}";
    version = "2021.3"; /* updated by script */
    description = "The Most Intelligent Ruby and Rails IDE";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/ruby/RubyMine-${version}.tar.gz";
      sha256 = "1vmybxnwyv7wiv3clm857yvzlws0bcza01wx8jm0dbnrzq38dz4d"; /* updated by script */
    };
    wmClass = "jetbrains-rubymine";
    update-channel = "RubyMine RELEASE";
  };

  webstorm = buildWebStorm rec {
    name = "webstorm-${version}";
    version = "2021.3"; /* updated by script */
    description = "Professional IDE for Web and JavaScript development";
    license = lib.licenses.unfree;
    src = fetchurl {
      url = "https://download.jetbrains.com/webstorm/WebStorm-${version}.tar.gz";
      sha256 = "1llz97r95xrf7yixgbfipg153qikkxziwwhv9dvvi29v7pi1k4ys"; /* updated by script */
    };
    wmClass = "jetbrains-webstorm";
    update-channel = "WebStorm RELEASE";
  };

}