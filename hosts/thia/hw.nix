{ ... }:
{
  hardware.fancontrol = {
    enable = true;
    config = ''
      INTERVAL=10
      DEVPATH=hwmon3=devices/platform/nct6775.656
      DEVNAME=hwmon3=nct6793
      FCTEMPS=hwmon3/pwm1=hwmon3/temp7_input
      FCFANS= hwmon3/pwm1=hwmon3/fan1_input
      MINTEMP=hwmon3/pwm1=30
      MAXTEMP=hwmon3/pwm1=70
      MINSTART=30 hwmon3/pwm1=56
      MINSTOP=30 hwmon3/pwm1=16
      MAXPWM=hwmon3/pwm1=150
    '';
  };
  boot.kernelModules = [ "nct6775" ];
}
