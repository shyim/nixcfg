{ ... }: {
  sops.secrets.grafanaToken = {
    restartUnits = [ "alloy.service" ];
    mode = "0444";
  };

  services.alloy.enable = true;

  services.mtr-exporter = {
    enable = true;
    port = 9466;
    jobs = [
      {
        name = "geforce-now";
        address = "np-frk-02.cloudmatchbeta.nvidiagrid.net";
      }
      {
        name = "heise";
        address = "heise.de";
      }
    ];
  };

  environment.etc."alloy/config.alloy".text = ''
    prometheus.remote_write "metrics_hosted_prometheus" {
       endpoint {
          name = "hosted-prometheus"
          url  = "https://prometheus-prod-01-eu-west-0.grafana.net/api/prom/push"

          basic_auth {
            username = "362070"
            password_file = "/run/secrets/grafanaToken"
          }
       }
    }

    prometheus.scrape "speedtest_probe" {
      targets = [{
        __address__ = "127.0.0.1:9469",
      }]
      metrics_path = "/probe"
      scrape_interval = "5m"
      scrape_timeout = "90s"
      params = { script = [ "speedtest" ], }

      forward_to = [prometheus.remote_write.metrics_hosted_prometheus.receiver]
    }

    prometheus.scrape "speedtest_metrics" {
      targets = [{
        __address__ = "127.0.0.1:9469",
      }]
      metrics_path = "/metrics"

      forward_to = [prometheus.remote_write.metrics_hosted_prometheus.receiver]
    }

    prometheus.scrape "mtr" {
      targets = [{
        __address__ = "127.0.0.1:9466",
      }]
      metrics_path = "/metrics"

      forward_to = [prometheus.remote_write.metrics_hosted_prometheus.receiver]
    }

    prometheus.exporter.blackbox "blackbox" {
        config = "{ modules: { http_2xx: { prober: http, timeout: 5s }, icmp: { prober: icmp, timeout: 5s } } }"

        target {
            name    = "heise"
            address = "https://www.heise.de"
            module  = "http_2xx"
        }

        target {
            name    = "google"
            address = "8.8.8.8"
            module  = "icmp"
        }

        target {
            name    = "cloudflare"
            address = "1.1.1.1"
            module  = "icmp"
        }

        target {
            name    = "cloudflare-duesseldorf"
            address = "172.69.109.2"
            module  = "icmp"
        }

        target {
            name    = "quad9"
            address = "9.9.9.9"
            module  = "icmp"
        }

        target {
            name    = "heise"
            address = "heise.de"
        }
    }

    prometheus.scrape "blackbox" {
      targets    = prometheus.exporter.blackbox.blackbox.targets
      forward_to = [prometheus.remote_write.metrics_hosted_prometheus.receiver]
    }
  '';

  virtualisation.oci-containers.containers.speedtest-cli = {
    image = "billimek/prometheus-speedtest-exporter:latest";
    ports = [ "127.0.0.1:9469:9469" ];
  };
}
