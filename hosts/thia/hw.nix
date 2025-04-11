{ ... }: {
  hardware.fancontrol = {
    enable = true;
    config = ''
      INTERVAL=10
      DEVPATH=hwmon5=devices/platform/nct6775.656
      DEVNAME=hwmon5=nct6793
      FCTEMPS=hwmon5/pwm1=hwmon5/temp7_input
      FCFANS= hwmon5/pwm1=hwmon5/fan1_input
      MINTEMP=hwmon5/pwm1=30
      MAXTEMP=hwmon5/pwm1=70
      MINSTART=30 hwmon5/pwm1=56
      MINSTOP=30 hwmon5/pwm1=16
      MAXPWM=hwmon5/pwm1=150
    '';
  };
  boot.kernelModules = [ "nct6775" ];
}
