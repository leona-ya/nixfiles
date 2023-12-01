{ pkgs, ... }:

{
  home-manager.users.leona = {
    programs.wofi = {
      enable = true;
      style = ''
        window {
          margin: 0px;
          background-color: #2D2A2E;
        }

        #input {
          margin: 2.5px;
          border: none;
          color: #a0e300;
          background-color: #3F3A40;
        }

        #inner-box {
          margin: 2.5px;
          border: none;
          background-color: #2D2A2E;
        }

        #outer-box {
          margin: 2.5px;
          border: none;
          background-color: #2D2A2E;
        }

        #scroll {
          margin: 0px;
          border: none;
        }

        #text {
          margin: 2.5px;
          border: none;
          color: #FCFCFA;
        } 

        #entry:selected {
          background-color: #3F3A40;
        }
      '';
    };
  };
}
