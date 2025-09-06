{
  composerEnv,
  fetchurl,
  fetchgit ? null,
  fetchhg ? null,
  fetchsvn ? null,
  noDev ? false,
}:

let
  packages = {
    "brick/math" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "brick-math-ca57d18f028f84f777b2168cd1911b0dee2343ae";
        src = fetchurl {
          url = "https://api.github.com/repos/brick/math/zipball/ca57d18f028f84f777b2168cd1911b0dee2343ae";
          sha256 = "1nr1grrb9g5g3ihx94yk0amp8zx8prkkvg2934ygfc3rrv03cq9w";
        };
      };
    };
    "dflydev/dot-access-data" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dflydev-dot-access-data-0992cc19268b259a39e86f296da5f0677841f42c";
        src = fetchurl {
          url = "https://api.github.com/repos/dflydev/dflydev-dot-access-data/zipball/0992cc19268b259a39e86f296da5f0677841f42c";
          sha256 = "0qdf1gbfkj7vjqhn7m99s1gpjkj2crqrqh1wzpdzyz27izgjgsyw";
        };
      };
    };
    "doctrine/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-cache-331b4d5dbaeab3827976273e9356b3b453c300ce";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/cache/zipball/331b4d5dbaeab3827976273e9356b3b453c300ce";
          sha256 = "1ksr3460a5dpqgq5kgy2l7kdz7fairpvmip8nwaz9y833r5hnnyz";
        };
      };
    };
    "doctrine/dbal" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-dbal-719663b15983278227669c8595151586a2ff3327";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/dbal/zipball/719663b15983278227669c8595151586a2ff3327";
          sha256 = "1aihj4jflg5k0zjhwhkcmlg0pa6r9a72js7fzhrkxmg6hmzkh2qc";
        };
      };
    };
    "doctrine/deprecations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-deprecations-9504165960a1f83cc1480e2be1dd0a0478561314";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/deprecations/zipball/9504165960a1f83cc1480e2be1dd0a0478561314";
          sha256 = "04kpbzk5iw86imspkg7dgs54xx877k9b5q0dfg2h119mlfkvxil6";
        };
      };
    };
    "doctrine/event-manager" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-event-manager-41370af6a30faa9dc0368c4a6814d596e81aba7f";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/event-manager/zipball/41370af6a30faa9dc0368c4a6814d596e81aba7f";
          sha256 = "0pn2aiwl4fvv6fcwar9alng2yrqy8bzc58n4bkp6y2jnpw5gp4m8";
        };
      };
    };
    "doctrine/inflector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-inflector-8b7ff3e4b7de6b2c84da85637b59fd2880ecaa89";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/inflector/zipball/8b7ff3e4b7de6b2c84da85637b59fd2880ecaa89";
          sha256 = "1l83jbj4k59m1agi041gzx1rxix1wzxw9mvnivmg1hqr158149n7";
        };
      };
    };
    "doctrine/lexer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-lexer-c268e882d4dbdd85e36e4ad69e02dc284f89d229";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/lexer/zipball/c268e882d4dbdd85e36e4ad69e02dc284f89d229";
          sha256 = "12g069nljl3alyk15884nd1jc4mxk87isqsmfj7x6j2vxvk9qchs";
        };
      };
    };
    "dragonmantank/cron-expression" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dragonmantank-cron-expression-be85b3f05b46c39bbc0d95f6c071ddff669510fa";
        src = fetchurl {
          url = "https://api.github.com/repos/dragonmantank/cron-expression/zipball/be85b3f05b46c39bbc0d95f6c071ddff669510fa";
          sha256 = "09k5cj8bay6jkphjl5ngfx7qb17dxnlvpf6918a9ms8am731s2a6";
        };
      };
    };
    "egulias/email-validator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "egulias-email-validator-0dbf5d78455d4d6a41d186da50adc1122ec066f4";
        src = fetchurl {
          url = "https://api.github.com/repos/egulias/EmailValidator/zipball/0dbf5d78455d4d6a41d186da50adc1122ec066f4";
          sha256 = "00kwb8rhk1fq3a1i152xniipk3y907q1v5r3szqbkq5rz82dwbck";
        };
      };
    };
    "fideloper/proxy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fideloper-proxy-c073b2bd04d1c90e04dc1b787662b558dd65ade0";
        src = fetchurl {
          url = "https://api.github.com/repos/fideloper/TrustedProxy/zipball/c073b2bd04d1c90e04dc1b787662b558dd65ade0";
          sha256 = "05jzgjj4fy5p1smqj41b5qxj42zn0mnczvsaacni4fmq174mz4gy";
        };
      };
    };
    "firefly-iii/api-support-classes" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "firefly-iii-api-support-classes-0346a2af48ab0565926cbb82f75059e126426e58";
        src = fetchurl {
          url = "https://api.github.com/repos/JC5/api-support-classes/zipball/0346a2af48ab0565926cbb82f75059e126426e58";
          sha256 = "07zlzgybgv3rs454ngqm5fc483fk4ikb5by28drqx1irxha6gljc";
        };
      };
    };
    "fruitcake/laravel-cors" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fruitcake-laravel-cors-7c036ec08972d8d5d9db637e772af6887828faf5";
        src = fetchurl {
          url = "https://api.github.com/repos/fruitcake/laravel-cors/zipball/7c036ec08972d8d5d9db637e772af6887828faf5";
          sha256 = "1hb18l8yh8imz50dd438wnljl4jfk10yh25jl53vi0bxmylbf900";
        };
      };
    };
    "fruitcake/php-cors" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fruitcake-php-cors-58571acbaa5f9f462c9c77e911700ac66f446d4e";
        src = fetchurl {
          url = "https://api.github.com/repos/fruitcake/php-cors/zipball/58571acbaa5f9f462c9c77e911700ac66f446d4e";
          sha256 = "18xm69q4dk9zqfwgp938y2byhlyy9lr5x5qln4k2mg8cq8xr2sm1";
        };
      };
    };
    "graham-campbell/result-type" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "graham-campbell-result-type-0690bde05318336c7221785f2a932467f98b64ca";
        src = fetchurl {
          url = "https://api.github.com/repos/GrahamCampbell/Result-Type/zipball/0690bde05318336c7221785f2a932467f98b64ca";
          sha256 = "0a6kj3vxmhr1wh2kggmrl6y41hkg19jc0iq8qw095lf11mr4bd83";
        };
      };
    };
    "guzzlehttp/guzzle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-guzzle-ac1ec1cd9b5624694c3a40be801d94137afb12b4";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/guzzle/zipball/ac1ec1cd9b5624694c3a40be801d94137afb12b4";
          sha256 = "0bpgi47jc2d1ca0h62ahg9bpkh355azncwgnzcb2vsaldcm4g27s";
        };
      };
    };
    "guzzlehttp/promises" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-promises-fe752aedc9fd8fcca3fe7ad05d419d32998a06da";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/promises/zipball/fe752aedc9fd8fcca3fe7ad05d419d32998a06da";
          sha256 = "09ivi77y49bpc2sy3xhvgq22rfh2fhv921mn8402dv0a8bdprf56";
        };
      };
    };
    "guzzlehttp/psr7" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-psr7-c94a94f120803a18554c1805ef2e539f8285f9a2";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/psr7/zipball/c94a94f120803a18554c1805ef2e539f8285f9a2";
          sha256 = "05q47cx2dvqxxi5kan0d3q956lqrf3rnan5qbwc36hk4pb5n1sqs";
        };
      };
    };
    "laravel/framework" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-framework-148ae59b7da6c3db6736374d357c5aaef9506fb7";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/framework/zipball/148ae59b7da6c3db6736374d357c5aaef9506fb7";
          sha256 = "0wimkdmj9mryvmydkv0qbwsf0cz5lap9r9xd59pajma9x7bkiwyj";
        };
      };
    };
    "laravel/serializable-closure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-serializable-closure-9e4b005daa20b0c161f3845040046dc9ddc1d74e";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/serializable-closure/zipball/9e4b005daa20b0c161f3845040046dc9ddc1d74e";
          sha256 = "1arjkh7rxjnifcccqrdyby308fg3vlp5mfz5bhhk9cs9q1xhrhna";
        };
      };
    };
    "laravel/tinker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-tinker-dff39b661e827dae6e092412f976658df82dbac5";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/tinker/zipball/dff39b661e827dae6e092412f976658df82dbac5";
          sha256 = "0az4n99pfrhrnr7diwi656f8y9qbynxzdw25md29ji8bw0isbc6d";
        };
      };
    };
    "league/commonmark" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-commonmark-32a49eb2b38fe5e5c417ab748a45d0beaab97955";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/commonmark/zipball/32a49eb2b38fe5e5c417ab748a45d0beaab97955";
          sha256 = "0f58yq6liaqh0bh5iga03nz38iy9j25rvg0b7i1zw807gf9swkdj";
        };
      };
    };
    "league/config" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-config-a9d39eeeb6cc49d10a6e6c36f22c4c1f4a767f3e";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/config/zipball/a9d39eeeb6cc49d10a6e6c36f22c4c1f4a767f3e";
          sha256 = "0mwqf6pdapgbxcry328kl9974awjmnv491c6ryirw74lqkapw2bn";
        };
      };
    };
    "league/csv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-csv-9d2e0265c5d90f5dd601bc65ff717e05cec19b47";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/csv/zipball/9d2e0265c5d90f5dd601bc65ff717e05cec19b47";
          sha256 = "0mcngirl2r8aw7hgbwaq3hrkkib4xwvhngijdhrkdzg4hj6ii3ap";
        };
      };
    };
    "league/flysystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-094defdb4a7001845300334e7c1ee2335925ef99";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem/zipball/094defdb4a7001845300334e7c1ee2335925ef99";
          sha256 = "0dn71b1pwikbwz1cmmz9k1fc8k1fsmah3gy8sqxbz7czhqn5qiva";
        };
      };
    };
    "league/mime-type-detection" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-mime-type-detection-ff6248ea87a9f116e78edd6002e39e5128a0d4dd";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/mime-type-detection/zipball/ff6248ea87a9f116e78edd6002e39e5128a0d4dd";
          sha256 = "1a63nvqd6cz3vck3y8vjswn6c3cfwh13p0cn0ci5pqdf0bgjvvfz";
        };
      };
    };
    "monolog/monolog" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "monolog-monolog-4192345e260f1d51b365536199744b987e160edc";
        src = fetchurl {
          url = "https://api.github.com/repos/Seldaek/monolog/zipball/4192345e260f1d51b365536199744b987e160edc";
          sha256 = "1w4fqwcymjc2p4wac9m0hhyym8i61y324ckb4v4ggnm2agjzl1yr";
        };
      };
    };
    "nesbot/carbon" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nesbot-carbon-4a54375c21eea4811dbd1149fe6b246517554e78";
        src = fetchurl {
          url = "https://api.github.com/repos/briannesbitt/Carbon/zipball/4a54375c21eea4811dbd1149fe6b246517554e78";
          sha256 = "00l918jykwyi8pjn7x08m29x3wrwh92sq495acyp9dkiby7k59y1";
        };
      };
    };
    "nette/schema" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nette-schema-9a39cef03a5b34c7de64f551538cbba05c2be5df";
        src = fetchurl {
          url = "https://api.github.com/repos/nette/schema/zipball/9a39cef03a5b34c7de64f551538cbba05c2be5df";
          sha256 = "1kr5lai6r1l6w85ck64b1cq9cp0r2kwa10i1xcmlc7q0xlrxwhp2";
        };
      };
    };
    "nette/utils" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nette-utils-0af4e3de4df9f1543534beab255ccf459e7a2c99";
        src = fetchurl {
          url = "https://api.github.com/repos/nette/utils/zipball/0af4e3de4df9f1543534beab255ccf459e7a2c99";
          sha256 = "0pmcgx3h3bl02sdqvhb9ap548ldxnhl3051imqss2yd64fkxf5fj";
        };
      };
    };
    "nikic/php-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nikic-php-parser-210577fe3cf7badcc5814d99455df46564f3c077";
        src = fetchurl {
          url = "https://api.github.com/repos/nikic/PHP-Parser/zipball/210577fe3cf7badcc5814d99455df46564f3c077";
          sha256 = "191ijb7bybqnl1jayx6bipqh91dc9acg9zsbh89fk4h1ff87b1qp";
        };
      };
    };
    "opis/closure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "opis-closure-3d81e4309d2a927abbe66df935f4bb60082805ad";
        src = fetchurl {
          url = "https://api.github.com/repos/opis/closure/zipball/3d81e4309d2a927abbe66df935f4bb60082805ad";
          sha256 = "0hqs6rdkkcggswrgjlispkby2yg4hwn63bl2ma62lnmpfbpwn0sd";
        };
      };
    };
    "phpoption/phpoption" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpoption-phpoption-eab7a0df01fe2344d172bff4cd6dbd3f8b84ad15";
        src = fetchurl {
          url = "https://api.github.com/repos/schmittjoh/php-option/zipball/eab7a0df01fe2344d172bff4cd6dbd3f8b84ad15";
          sha256 = "1lk50y8jj2mzbwc2mxfm2xdasxf4axya72nv8wfc1vyz9y5ys3li";
        };
      };
    };
    "psr/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-cache-aa5030cfa5405eccfdcb1083ce040c2cb8d253bf";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/cache/zipball/aa5030cfa5405eccfdcb1083ce040c2cb8d253bf";
          sha256 = "07rnyjwb445sfj30v5ny3gfsgc1m7j7cyvwjgs2cm9slns1k1ml8";
        };
      };
    };
    "psr/container" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-container-513e0666f7216c7459170d56df27dfcefe1689ea";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/container/zipball/513e0666f7216c7459170d56df27dfcefe1689ea";
          sha256 = "00yvj3b5ls2l1d0sk38g065raw837rw65dx1sicggjnkr85vmfzz";
        };
      };
    };
    "psr/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-event-dispatcher-dbefd12671e8a14ec7f180cab83036ed26714bb0";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/event-dispatcher/zipball/dbefd12671e8a14ec7f180cab83036ed26714bb0";
          sha256 = "05nicsd9lwl467bsv4sn44fjnnvqvzj1xqw2mmz9bac9zm66fsjd";
        };
      };
    };
    "psr/http-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-client-2dfb5f6c5eff0e91e20e913f8c5452ed95b86621";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-client/zipball/2dfb5f6c5eff0e91e20e913f8c5452ed95b86621";
          sha256 = "0cmkifa3ji1r8kn3y1rwg81rh8g2crvnhbv2am6d688dzsbw967v";
        };
      };
    };
    "psr/http-factory" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-factory-12ac7fcd07e5b077433f5f2bee95b3a771bf61be";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-factory/zipball/12ac7fcd07e5b077433f5f2bee95b3a771bf61be";
          sha256 = "0inbnqpc5bfhbbda9dwazsrw9xscfnc8rdx82q1qm3r446mc1vds";
        };
      };
    };
    "psr/http-message" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-message-f6561bf28d520154e4b0ec72be95418abe6d9363";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-message/zipball/f6561bf28d520154e4b0ec72be95418abe6d9363";
          sha256 = "195dd67hva9bmr52iadr4kyp2gw2f5l51lplfiay2pv6l9y4cf45";
        };
      };
    };
    "psr/log" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-log-ef29f6d262798707a9edd554e2b82517ef3a9376";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/log/zipball/ef29f6d262798707a9edd554e2b82517ef3a9376";
          sha256 = "02z3lixbb248li6y060afd2mdz6w5chfwxgsnwkff89205xafzg1";
        };
      };
    };
    "psr/simple-cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-simple-cache-408d5eafb83c57f6365a3ca330ff23aa4a5fa39b";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/simple-cache/zipball/408d5eafb83c57f6365a3ca330ff23aa4a5fa39b";
          sha256 = "1djgzclkamjxi9jy4m9ggfzgq1vqxaga2ip7l3cj88p7rwkzjxgw";
        };
      };
    };
    "psy/psysh" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psy-psysh-7f7da640d68b9c9fec819caae7c744a213df6514";
        src = fetchurl {
          url = "https://api.github.com/repos/bobthecow/psysh/zipball/7f7da640d68b9c9fec819caae7c744a213df6514";
          sha256 = "18pswm73lnsx3hjpnc6ld694jkf1n9g00a114a27k5ns0wwkag52";
        };
      };
    };
    "ralouphie/getallheaders" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ralouphie-getallheaders-120b605dfeb996808c31b6477290a714d356e822";
        src = fetchurl {
          url = "https://api.github.com/repos/ralouphie/getallheaders/zipball/120b605dfeb996808c31b6477290a714d356e822";
          sha256 = "1bv7ndkkankrqlr2b4kw7qp3fl0dxi6bp26bnim6dnlhavd6a0gg";
        };
      };
    };
    "ramsey/collection" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ramsey-collection-cccc74ee5e328031b15640b51056ee8d3bb66c0a";
        src = fetchurl {
          url = "https://api.github.com/repos/ramsey/collection/zipball/cccc74ee5e328031b15640b51056ee8d3bb66c0a";
          sha256 = "1i2ga25aj80cci3di58qm17l588lzgank8wqhdbq0dcb3cg6cgr6";
        };
      };
    };
    "ramsey/uuid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ramsey-uuid-8505afd4fea63b81a85d3b7b53ac3cb8dc347c28";
        src = fetchurl {
          url = "https://api.github.com/repos/ramsey/uuid/zipball/8505afd4fea63b81a85d3b7b53ac3cb8dc347c28";
          sha256 = "06a5bccdx61va3wc3f5smxh04mvs0xi2skrqcjh4anwmlxchnl76";
        };
      };
    };
    "rcrowe/twigbridge" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "rcrowe-twigbridge-f4968efb99537cc1b37c5bf20280614aadc31825";
        src = fetchurl {
          url = "https://api.github.com/repos/rcrowe/TwigBridge/zipball/f4968efb99537cc1b37c5bf20280614aadc31825";
          sha256 = "0kxaw5jmyjq5n5lvhg5a4j5wdvlnp0r3hcs34299mgpx7na9b5cd";
        };
      };
    };
    "spatie/enum" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "spatie-enum-f1a0f464ba909491a53e60a955ce84ad7cd93a2c";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/enum/zipball/f1a0f464ba909491a53e60a955ce84ad7cd93a2c";
          sha256 = "1501zvm71gnni3jwcrc9zn9zqwandar5mv540695r93py7h2dmlj";
        };
      };
    };
    "swiftmailer/swiftmailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "swiftmailer-swiftmailer-8a5d5072dca8f48460fce2f4131fcc495eec654c";
        src = fetchurl {
          url = "https://api.github.com/repos/swiftmailer/swiftmailer/zipball/8a5d5072dca8f48460fce2f4131fcc495eec654c";
          sha256 = "1p9m4fw9y9md9a7msbmnc0hpdrky8dwrllnyg1qf1cdyp9d70x1d";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-ffe3aed36c4d60da2cf1b0a1cee6b8f2e5fa881b";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/ffe3aed36c4d60da2cf1b0a1cee6b8f2e5fa881b";
          sha256 = "1q3wf6p8chvhdmfjpjm4q4xl4762p660psn14br419f7km9lwnxq";
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-css-selector-1955d595c12c111629cc814d3f2a2ff13580508a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/css-selector/zipball/1955d595c12c111629cc814d3f2a2ff13580508a";
          sha256 = "0l0z3v8c77aambj2rxa9pbcipcqqvlmmmm8cpnbhi3hg80z00wvg";
        };
      };
    };
    "symfony/deprecation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-deprecation-contracts-26954b3d62a6c5fd0ea8a2a00c0353a14978d05c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/deprecation-contracts/zipball/26954b3d62a6c5fd0ea8a2a00c0353a14978d05c";
          sha256 = "1wlaj9ngbyjmgr92gjyf7lsmjfswyh8vpbzq5rdzaxjb6bcsj3dp";
        };
      };
    };
    "symfony/error-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-error-handler-c1fcde614dfe99d62a83b796a53b8bad358b266a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/error-handler/zipball/c1fcde614dfe99d62a83b796a53b8bad358b266a";
          sha256 = "0b4c7n2yy26swjzbsj0n03qjsb5qi6w09v0nl0s70fjrs9fvb0qb";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-6472ea2dd415e925b90ca82be64b8bc6157f3934";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher/zipball/6472ea2dd415e925b90ca82be64b8bc6157f3934";
          sha256 = "1s7dkz4hw3lcqbfh88ws8l8471dc1f4zk159iv6gkdwgyxdbqcyv";
        };
      };
    };
    "symfony/event-dispatcher-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-contracts-7bc61cc2db649b4637d331240c5346dcc7708051";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher-contracts/zipball/7bc61cc2db649b4637d331240c5346dcc7708051";
          sha256 = "1crx2j4g5jn904fwk7919ar9zpyfd5bvgm80lmyg15kinsjm3w4i";
        };
      };
    };
    "symfony/finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-finder-9b630f3427f3ebe7cd346c277a1408b00249dad9";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/finder/zipball/9b630f3427f3ebe7cd346c277a1408b00249dad9";
          sha256 = "0b2rdx4080jav1ixqxrl4mabn91amf81xsj533b067vdfq4rcfv4";
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-foundation-ff2818d1c3d49860bcae1f2cbb5eb00fcd3bf9e2";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-foundation/zipball/ff2818d1c3d49860bcae1f2cbb5eb00fcd3bf9e2";
          sha256 = "1f9q79rmyxmh7bh55pggi3wkpqza8ya5l5qpynpvxn284rxzfdsh";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-cf7e61106abfc19b305ca0aedc41724ced89a02a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-kernel/zipball/cf7e61106abfc19b305ca0aedc41724ced89a02a";
          sha256 = "1z1wh7rqf8s9cwpmf540f5q5fbf1ya0iawlvhl60rlqxh9f74ykc";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-af49bc163ec3272f677bde3bc44c0d766c1fd662";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mime/zipball/af49bc163ec3272f677bde3bc44c0d766c1fd662";
          sha256 = "058is0f9b3v3vgk5p30a75g9pj9v76mrlglpv3p3kbazp1klw22q";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-30885182c981ab175d4d034db0f6f469898070ab";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-ctype/zipball/30885182c981ab175d4d034db0f6f469898070ab";
          sha256 = "0dfh24f8g048vbj88vx0lvw48nq5dsamy5kva72ab1h7vw9hvpwb";
        };
      };
    };
    "symfony/polyfill-iconv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-iconv-f1aed619e28cb077fc83fac8c4c0383578356e40";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-iconv/zipball/f1aed619e28cb077fc83fac8c4c0383578356e40";
          sha256 = "0fjx1a0kvkj0677nc6h49phqlk0hsgkzbs401lmhj6b6cdc7hvzp";
        };
      };
    };
    "symfony/polyfill-intl-grapheme" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-grapheme-81b86b50cf841a64252b439e738e97f4a34e2783";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-grapheme/zipball/81b86b50cf841a64252b439e738e97f4a34e2783";
          sha256 = "1dxymfi577yridk6dn8v2z1hyrpaxr8sp4g6dxxy913ilf6igx7r";
        };
      };
    };
    "symfony/polyfill-intl-idn" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-idn-749045c69efb97c70d25d7463abba812e91f3a44";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-idn/zipball/749045c69efb97c70d25d7463abba812e91f3a44";
          sha256 = "0ni1zlnp5xpxyzbax7v3mn20x35i69nsmch2sx322cs6dwb0ggbn";
        };
      };
    };
    "symfony/polyfill-intl-normalizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-normalizer-8590a5f561694770bdcd3f9b5c69dde6945028e8";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/8590a5f561694770bdcd3f9b5c69dde6945028e8";
          sha256 = "1c60xin00q0d2gbyaiglxppn5hqwki616v5chzwyhlhf6aplwsh3";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-0abb51d2f102e00a4eefcf46ba7fec406d245825";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-mbstring/zipball/0abb51d2f102e00a4eefcf46ba7fec406d245825";
          sha256 = "1z17f7465fn778ak68mzz5kg2ql1n6ghgqh3827n9mcipwbp4k58";
        };
      };
    };
    "symfony/polyfill-php72" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php72-9a142215a36a3888e30d0a9eeea9766764e96976";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php72/zipball/9a142215a36a3888e30d0a9eeea9766764e96976";
          sha256 = "06ipbcvrxjzgvraf2z9fwgy0bzvzjvs5z1j67grg1gb15x3d428b";
        };
      };
    };
    "symfony/polyfill-php73" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php73-cc5db0e22b3cb4111010e48785a97f670b350ca5";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php73/zipball/cc5db0e22b3cb4111010e48785a97f670b350ca5";
          sha256 = "04z6fah8rn5b01w78j0vqa0jys4mvji66z4ql6wk1r1bf6j0048y";
        };
      };
    };
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-4407588e0d3f1f52efb65fbe92babe41f37fe50c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php80/zipball/4407588e0d3f1f52efb65fbe92babe41f37fe50c";
          sha256 = "187whknxl9rs0ddkjph6zmla5kh3k7w6hnvgfc44zig17jxsjdff";
        };
      };
    };
    "symfony/polyfill-php81" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php81-5de4ba2d41b15f9bd0e19b2ab9674135813ec98f";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php81/zipball/5de4ba2d41b15f9bd0e19b2ab9674135813ec98f";
          sha256 = "0igxnmib8vkjp9x81j66hl4pf8i0nj86k4hdh8gzcymq01si0mxm";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-597f3fff8e3e91836bb0bd38f5718b56ddbde2f3";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/process/zipball/597f3fff8e3e91836bb0bd38f5718b56ddbde2f3";
          sha256 = "1vv2xwk3cvr144yxjj6k4afhkv50v2b957lscncs6m3rvi2zs1nk";
        };
      };
    };
    "symfony/routing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-routing-e07817bb6244ea33ef5ad31abc4a9288bef3f2f7";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/routing/zipball/e07817bb6244ea33ef5ad31abc4a9288bef3f2f7";
          sha256 = "1lk7dbcxvfwmyx65hm0v78ma79f67jnq2xnzg6k0wz52161rk6cl";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-24d9dc654b83e91aa59f9d167b131bc3b5bea24c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/service-contracts/zipball/24d9dc654b83e91aa59f9d167b131bc3b5bea24c";
          sha256 = "1flrnq7dw7rg8b901fbi7gv6k25hqbhffpd15w751fmzsrpzaphl";
        };
      };
    };
    "symfony/string" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-string-ac0aa5c2282e0de624c175b68d13f2c8f2e2649d";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/ac0aa5c2282e0de624c175b68d13f2c8f2e2649d";
          sha256 = "1j6xx0byn8bjmadf83r2hljk37i4z66x1gq7kpdfcrdg57dhz0ds";
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-3d38cf8f8834148c4457681d539bc204de701501";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation/zipball/3d38cf8f8834148c4457681d539bc204de701501";
          sha256 = "0m7mqid0rrqhkfb9zifg03r6ijsbmaqid0x0saa94wpqha9bnims";
        };
      };
    };
    "symfony/translation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-contracts-c4183fc3ef0f0510893cbeedc7718fb5cafc9ac9";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation-contracts/zipball/c4183fc3ef0f0510893cbeedc7718fb5cafc9ac9";
          sha256 = "0j97rf4mpfdgm7ysxdlx9g4c40drblzfp3ycbym4pxkaf3plk7zy";
        };
      };
    };
    "symfony/var-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-dumper-cdcadd343d31ad16fc5e006b0de81ea307435053";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-dumper/zipball/cdcadd343d31ad16fc5e006b0de81ea307435053";
          sha256 = "074xgg7z22kxlprahd272gb7krkh9k1rw548s6c3igmk6yylzs9n";
        };
      };
    };
    "tijsverkoyen/css-to-inline-styles" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tijsverkoyen-css-to-inline-styles-da444caae6aca7a19c0c140f68c6182e337d5b1c";
        src = fetchurl {
          url = "https://api.github.com/repos/tijsverkoyen/CssToInlineStyles/zipball/da444caae6aca7a19c0c140f68c6182e337d5b1c";
          sha256 = "13lzhf1kswg626b8zd23z4pa7sg679si368wcg6pklqvijnn0any";
        };
      };
    };
    "twig/twig" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "twig-twig-8442df056c51b706793adf80a9fd363406dd3674";
        src = fetchurl {
          url = "https://api.github.com/repos/twigphp/Twig/zipball/8442df056c51b706793adf80a9fd363406dd3674";
          sha256 = "163vz03p0vblkrg6jxlfhywhndd5y9bbwj64rbb0z6zsj76a8ayg";
        };
      };
    };
    "vlucas/phpdotenv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "vlucas-phpdotenv-264dce589e7ce37a7ba99cb901eed8249fbec92f";
        src = fetchurl {
          url = "https://api.github.com/repos/vlucas/phpdotenv/zipball/264dce589e7ce37a7ba99cb901eed8249fbec92f";
          sha256 = "0z2q376k3rww8qb9jdywm3fj386pqmcx7rg6msd3zdrjxfbqcqnl";
        };
      };
    };
    "voku/portable-ascii" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "voku-portable-ascii-87337c91b9dfacee02452244ee14ab3c43bc485a";
        src = fetchurl {
          url = "https://api.github.com/repos/voku/portable-ascii/zipball/87337c91b9dfacee02452244ee14ab3c43bc485a";
          sha256 = "1j2xpbv7xiwxwb6gfc3h6imc6xcbyb2jw3h8wgfnpvjl5yfbi4xb";
        };
      };
    };
    "webmozart/assert" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "webmozart-assert-6964c76c7804814a842473e0c8fd15bab0f18e25";
        src = fetchurl {
          url = "https://api.github.com/repos/webmozarts/assert/zipball/6964c76c7804814a842473e0c8fd15bab0f18e25";
          sha256 = "17xqhb2wkwr7cgbl4xdjf7g1vkal17y79rpp6xjpf1xgl5vypc64";
        };
      };
    };
  };
  devPackages = { };
in
composerEnv.buildPackage {
  inherit packages devPackages noDev;
  name = "firefly-iii";
  src = ./.;
  executable = false;
  symlinkDependencies = false;
  meta = {
    homepage = "https://github.com/firefly-iii/universal-importer";
    license = "AGPL-3.0-or-later";
  };
}
