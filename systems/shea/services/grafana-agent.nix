{ config
, pkgs
, ...
}: {
  services.grafana-agent = {
    enable = true;

    settings = {
      integrations = {
        agent.enabled = true;
        agent.scrape_integration = true;
        node_exporter.enabled = true;
        replace_instance_label = true;
      };

      logs = {
        configs = [
          {
            clients = [
              {
                basic_auth = {
                  password_file = "/etc/grafana-agent-logs";
                  username = "180005";
                };
                url = "https://logs-prod-eu-west-0.grafana.net/api/prom/push";
              }
            ];
            name = "default";
            positions = {
              filename = "/var/lib/grafana-agent/loki_positions.yaml";
            };
            scrape_configs = [
              {
                job_name = "journal";
                journal = {
                  labels = {
                    job = "systemd-journal";
                  };
                  max_age = "12h";
                };
                relabel_configs = [
                  {
                    source_labels = [
                      "__journal__systemd_unit"
                    ];
                    target_label = "unit";
                  }
                ];
              }
              {
                job_name = "caddy-access-logs";
                static_configs = [
                  {
                    labels = {
                      __path__ = "/var/log/caddy/*.log";
                    };
                  }
                ];
              }
            ];
          }
        ];
      };
      metrics = {
        global = {
          remote_write = [
            {
              basic_auth = {
                password_file = "/etc/grafana-agent-metrics";
                username = "362070";
              };
              url = "https://prometheus-prod-01-eu-west-0.grafana.net/api/prom/push";
            }
          ];
        };
        configs = [
          {
            name = "default";
            scrape_configs = [
              {
                job_name = "caddy";
                static_configs = [
                  {
                    targets = [ "localhost:2019" ];
                  }
                ];
              }
            ];
          }
        ];
      };
    };
  };
}
