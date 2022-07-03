{ pkgs, lib, config, ... }: {
  services.nginx.virtualHosts = {
    "autoconfig.em0lar.dev" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "autoconfig.maroni.me"
        "autoconfig.bechilli.de"
      ];
      locations = {
        "= /mail/config-v1.1.xml" = {
          root = pkgs.writeTextDir "mail/config-v1.1.xml" ''
            <?xml version="1.0" encoding="UTF-8"?>

            <clientConfig version="1.1">
             <emailProvider id="em0lar.dev">
               <domain>em0lar.dev</domain>
               <displayName>em0lar.dev Mail</displayName>
               <displayShortName>em0lar</displayShortName>
               <incomingServer type="imap">
                 <hostname>mail.em0lar.dev</hostname>
                 <port>993</port>
                 <socketType>SSL</socketType>
                 <authentication>password-cleartext</authentication>
                 <username>%EMAILADDRESS%</username>
               </incomingServer>
               <outgoingServer type="smtp">
                 <hostname>mail.em0lar.dev</hostname>
                 <port>465</port>
                 <socketType>SSL</socketType>
                 <authentication>password-cleartext</authentication>
                 <username>%EMAILADDRESS%</username>
               </outgoingServer>
             </emailProvider>
            </clientConfig>
            '';
        };
      };
    };
  };
}
