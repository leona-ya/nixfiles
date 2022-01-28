{ ... }: {
  services.gitlab-runner = {
    concurrent = 3;
    gracefulTimeout = "5min";
    services = {
      em0lar-default = {
        # File should contain at least these two variables:
        # `CI_SERVER_URL`
        # `REGISTRATION_TOKEN`
        registrationConfigFile = "/run/secrets/gitlab-runner-registration";
        dockerImage = "debian:stable";
        tagList = [ "private" "everything" ];
      };
    };
  };
}
