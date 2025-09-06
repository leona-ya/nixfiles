{ config, ... }:
{
  l.sops.secrets."profiles/desktop/openvpn_uni_cert".owner = "root";
  l.sops.secrets."profiles/desktop/openvpn_uni_key".owner = "root";
  l.sops.secrets."profiles/desktop/openvpn_uni_auth".owner = "root";
  services.openvpn.servers."uni-info" = {
    config = ''
            client
            dev tun
            proto udp
            remote bifrost.bit.uni-bonn.de 7073
            resolv-retry infinite
            nobind

            # Downgrade privileges after initialization (non-Windows only)
            # The user specified here should exist! If not, create it or
            # replace it with the most unprivileged account on your
            # linux distribution of choice.
            #user nobody
            #group nobody

            persist-key
            persist-tun
            remote-cert-tls server
            cipher AES-256-CBC
            auth SHA512

            # Set log file verbosity.
            verb 5

            <ca>
      -----BEGIN CERTIFICATE-----
      MIIF4DCCA8igAwIBAgIJAKt/iHfqA7Z6MA0GCSqGSIb3DQEBDQUAMH0xCzAJBgNV
      BAYTAkRFMQwwCgYDVQQIDANOUlcxDTALBgNVBAcMBEJvbm4xEjAQBgNVBAoMCWIt
      aXQgQm9ubjE9MDsGA1UECww0U3lzdGVtZ3J1cHBlIGItaXQvZW1haWxBZGRyZXNz
      PXNnYml0QGJpdC51bmktYm9ubi5kZTAeFw0xNTA5MjExMzIxNDJaFw0zNTA5MTYx
      MzIxNDJaMH0xCzAJBgNVBAYTAkRFMQwwCgYDVQQIDANOUlcxDTALBgNVBAcMBEJv
      bm4xEjAQBgNVBAoMCWItaXQgQm9ubjE9MDsGA1UECww0U3lzdGVtZ3J1cHBlIGIt
      aXQvZW1haWxBZGRyZXNzPXNnYml0QGJpdC51bmktYm9ubi5kZTCCAiIwDQYJKoZI
      hvcNAQEBBQADggIPADCCAgoCggIBAKnPfanRoQEbnbKJbxc3HQgk52q3x5gNiNL3
      xHHs8EqSvFTTVad/FK248xkbsQD0aepkYPemDIcahmdgQk86OKswq0FHcH9g9FZj
      kD+wi9ZGm4mK7sIHdKrXnbb37H2H+98Assh77KmCG4tYqdbpmPgk7eZI8qOfyCWM
      6YLcdqQw125Ymn5VohXFZHE9TSe1Pw5Xu9r2jxiuuop9cGJ5Epu9UzkQkqMflSE/
      McI1DPUMHbqHZxVYhJjQtB/sQ9g6r2c5C8g1FcKh8pp5Iuldk21VcwBVqEUVJCe+
      qThlsf6eCRAMIyZdSIScaKIabeenTJ3PUB7OSuEUA4UjsNzSWzieKfM3QgTqi5rj
      fPkQ7S0rW1ImVuX7/1+56EiHXjRn75j4AaVsZMxcIsqFucp8dEE6cn80Q9HOTwhy
      8uPmYENogUdmK4yUI/85mx/Jlq+iDQ6E5pD4gPizqsu9MuYIFLUcFN8DaCuddE94
      u7zkG3gCgFGBUHHP6Uvjdvr9EOKzqdtLSTBzV1j1TMruggWu5b9yHSwok6oL7m6Z
      Z/jigqIGSco+Dl7ZkGxB1Q/fpOlBVlPLYy7S6KcjikRqP9JK2XpX5IeYVK6acFbg
      1cAgxCTD67ll7t5jOZC5cSiCDdrJlysiDojrbx3KMBPS0wOK+gqDebEl05lH2Jb/
      9fT4/vVDAgMBAAGjYzBhMB0GA1UdDgQWBBSoUh/7fzfvxg6XDrtVm5tAWly63jAf
      BgNVHSMEGDAWgBSoUh/7fzfvxg6XDrtVm5tAWly63jAPBgNVHRMBAf8EBTADAQH/
      MA4GA1UdDwEB/wQEAwIBhjANBgkqhkiG9w0BAQ0FAAOCAgEACFtu8xDQKK2zZj00
      Z8sAMc9GpKXFl+IFoZv6n1F14u7e7SfpfDaSS6O93FLtJg9sL6gsZrMvg61oxb5A
      vDDOMkRe2OfythR6wm3ulHtpWK5LThwEk/NzaDMpFjBbUvNI3uFDzRd5HIeK4iQy
      Ff98V89DJ1X9XiHSYZ/2rxWuYU2mDMt3p42CtohMRZmFUsa1kwork7nX+frLgSp6
      zm/QZNLaEjJWdKIoRHJIAlLn3lBNgn9JLaGJ0WmusTlfkuQ2i12CTQZfOXbR/nlA
      GnsjBInIRaQrnSo63YGDsAgvdhTOzG5RK8vdW8RpTzADFkdzFXtGVay4w7qXiogk
      vr3rOjfIlIhguC+tzS/OPA/QgzxCffaJX0PT2er/e62xODJR+ZmmJ8YHJtJLgIA1
      hAV39ongGUG7W/mElQ/olU1CdpYFsJF1gnw0D5svPaOJg7OdgDaVOZePG9Il75ff
      L/ZxdRoUfaFpp263zQPCYCt07qOF5wJ7UOcJNPpe8BFj6Z+/wiTY4J7HCQwPHvC6
      30XH7J/wSb3DT20VsBo9abfcVWCCUA+PfPQK9D1nbqz3uMOxlUP3KEI/bIeOBnb4
      kGXWOPCoLJ5nRM74HvMgQTg5Tl08utP0P1RPZ62sIK86nJ+MELeklf45VGgknXbB
      BKXIltqm7VHp+BQ0nggAs1l90nI=
      -----END CERTIFICATE-----
      -----BEGIN CERTIFICATE-----
      MIIF6jCCA9KgAwIBAgICEAAwDQYJKoZIhvcNAQENBQAwfTELMAkGA1UEBhMCREUx
      DDAKBgNVBAgMA05SVzENMAsGA1UEBwwEQm9ubjESMBAGA1UECgwJYi1pdCBCb25u
      MT0wOwYDVQQLDDRTeXN0ZW1ncnVwcGUgYi1pdC9lbWFpbEFkZHJlc3M9c2diaXRA
      Yml0LnVuaS1ib25uLmRlMB4XDTE1MDkyMTEzMjE0OVoXDTM1MDkxNTEzMjE0OVow
      gYoxCzAJBgNVBAYTAkRFMQwwCgYDVQQIDANOUlcxEjAQBgNVBAoMCWItaXQgQm9u
      bjE9MDsGA1UECww0U3lzdGVtZ3J1cHBlIGItaXQvZW1haWxBZGRyZXNzPXNnYml0
      QGJpdC51bmktYm9ubi5kZTEaMBgGA1UEAwwRaW50ZXJtZWRpYXRlIENBIDEwggIi
      MA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDtyUqIZCIQWMo7FODSAm1qMXBb
      5F7xFxr8I5FKU2C02NWaxx01qE/l6kw698kFz5eMgPDWG7n5DJt1ersoNJcYiBuA
      kXVjud3naPnE8QA92/8yVv2RsHhzVNnDJpxpv0QxsMBDAngYtNzURDDafx85VrTJ
      IyRfIC4xEkz5olEQmx4DyZJj9lDCOp0QjHcpVdXaVn3Gi35Sq8ovvTkk38mTAHMX
      HahwkwnWQ2avKGwz5lcsdmbQvCz39MhGIaWLd/vBIbYbSK9JkWeR7fMDOXksTHwV
      8qFk9PPPoHOCW8J9hlgY+wjGNe0KNX1NzJUrqmuF4gV9ckLxS41tvyxhQSHu1w8f
      6WjjLD9xNJorpaRUM2xCRuknx3xICiwVQI3C8wkA2M9yYtDNObUjdcQCqQF4FE7x
      9G5nL3v4Mv4NRF2C96Ri8c6yWZYWshDnfenAlP3CKmLOXm8kSoF1lHYWr+t4fUCL
      bJj+dLP/CBUCuirBMEL9SKAQuPVcoF7iz1U8FNaZ9ad28Gz78QSrH4X8TED8HIPw
      MRwY8NOjXTfOKvogArryEFC7ylBEF34QmA5xfgnJYdJVvCHDTH6z1oY32Lv5An4b
      hDU/Ty3I9rWHStmRdRRA25/agy8R8jDKhBipLx1bYPbhR4sjcAyRLPw7SdIGf3O/
      aV/vXrYFPeEsUL9fCwIDAQABo2YwZDAdBgNVHQ4EFgQUR8MctF8gvQZg8OihmyS3
      Hz5uev0wHwYDVR0jBBgwFoAUqFIf+38378YOlw67VZubQFpcut4wEgYDVR0TAQH/
      BAgwBgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYwDQYJKoZIhvcNAQENBQADggIBAGHw
      C2ZMN2ndZq8O4OJANq6fXQEunPoXr+uBlawvBFykt/AXPasBUrXOptBrgadXsNz5
      fNpIzNH2JPpM1bhV3ATIdJIwnxJNa7ebB/xZJFqhFZIWpg9WzkKYdtfh/IwgH+Cj
      4m2q0zsUamzNOPVTeXlLhbafx9iWqeAykCoBVsl3dZnvwzDITqbjjCOgUTBTDEJ6
      TtyPOAvTU7Bc/aA9h+L/I4U06ThCa4YO6hgzt4fvHlJD292Ow8/krO975+pJkep+
      T93xhARDL5mBRmU9OzrorajDhVY2Y95xOmf8RLyNgHH6pNlpcuAbJSqd/fMb3pMA
      d39TyQedpHOSNT5/FIc4lPDdNexXr0X1/qVuVa2NDmG1r2GKOkFcLFIMCVL70oA9
      ivBGjSpFbCl0fNugkEcpSDix1QoJ4b/i94JEMz30vZ8igW73GhskeHGof1ajBApd
      Go1/WQ+6vupQQY2k70LsoS+YwMzokX9cOyywiHRzz2rxmmivNzULGqw+3HRVmLjT
      VeDVtUYyOThGRHTUWuC0O0hISHYp2lKK2uGSgeWHDNILn0kWnxcZtxUBLwOXz+yZ
      BxzA0AdxV53ovP9O/vXtKHt6h35oFiTbRsBJLA0N8UhJGCS2g1lyKRuxjvlRa0kj
      CvsdhYGF94XmfiHi23iGMT075MqkRpD2yo+m1+wh
      -----END CERTIFICATE-----
      </ca>
          cert ${config.sops.secrets."profiles/desktop/openvpn_uni_cert".path}
          key ${config.sops.secrets."profiles/desktop/openvpn_uni_key".path}
          auth-user-pass ${config.sops.secrets."profiles/desktop/openvpn_uni_auth".path}
    '';
    autoStart = false;
  };
}
